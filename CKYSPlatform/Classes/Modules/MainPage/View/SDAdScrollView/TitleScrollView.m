//
//  SDAdScrollView.m
//  SDAdScrollView
//
//  Created by DHsong on 16/4/20.
//  Copyright © 2016年 DHsong. All rights reserved.
//

#import "TitleScrollView.h"
#import "NSTimer+Addition.h"

@interface TitleScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UILabel *currentLable;
@property (nonatomic, strong) UILabel *leftLable;
@property (nonatomic, strong) UILabel *rightLable;
@end


@implementation TitleScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        _animationDuration = 3.0f;
        _currentLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(13))];
        [self.scrollView addSubview:_currentLable];

        _leftLable =  [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(13))];
        [self.scrollView addSubview:_leftLable];
 
        
        _rightLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(13))];
        [self.scrollView addSubview:_rightLable];
                
        _timer = [NSTimer scheduledTimerWithTimeInterval:_animationDuration target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
       [_timer pauseTimer];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onGesture:)];
        [self.scrollView addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _leftLable.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    _currentLable.frame = CGRectOffset(_leftLable.frame, CGRectGetWidth(_leftLable.frame), 0);
    
    _rightLable.frame = CGRectOffset(_currentLable.frame, CGRectGetWidth(_currentLable.frame), 0);
    
    _scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*3, 0);

    CGRect rect = CGRectMake(40, CGRectGetHeight(self.bounds)-10, CGRectGetWidth(self.bounds)-40*2, 10);
    _pageControl.frame = rect;
}

#pragma mark - Action

-(void)onTimer:(NSTimer*)timer
{
  [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*2, 0) animated:YES];
}
-(void)onGesture:(UITapGestureRecognizer*)tapGesture
{
    if (self.tapActionBlock) {
        self.tapActionBlock(self);
    }
}

#pragma mark - setter
-(void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    self.pageControl.numberOfPages = _titleArr.count;
    self.pageControl.currentPage = 0;
    _currentPage = 0;
    
    if (_titleArr.count <= 1) {
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), 0);
    }else{
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*3, 0);
        [_timer resumeTimerAfterTimeInterval:_animationDuration];
    }
    
    [self refreshTitleView];
}

//根据当前的index，重置当前显示的图片，并且使currentImageView永远保持在中间
-(void)refreshTitleView
{
    NSInteger index = _currentPage;
    if([self.titleArr count]){
      [self formatTitleView:_currentLable imageData:self.titleArr[index]];
    }
    if (self.titleArr.count > 1) {
        index = _currentPage-1<0?self.titleArr.count-1:_currentPage-1;
        [self formatTitleView:_leftLable imageData:self.titleArr[index]];
        
        index = _currentPage+1>=self.titleArr.count?0:_currentPage+1;
        [self formatTitleView:_rightLable imageData:self.titleArr[index]];
    }else{
        
        if([self.titleArr count]){
            [self formatTitleView:_leftLable imageData:self.titleArr[index]];
        }
    }
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
}

//根据数组中类型判断如何展示图片
-(void)formatTitleView:(UILabel*)titleLable imageData:(id)data
{
    if ([data isKindOfClass:[NSString class]]) {
        titleLable.text = data;
    }
}


-(void)refreshCurrentPage
{
    if (self.scrollView.contentOffset.x >= CGRectGetWidth(self.bounds)*1.5) {
        
        _currentPage ++;
        
        if (_currentPage > self.titleArr.count-1) {
            _currentPage = 0;
        }
    }else if (self.scrollView.contentOffset.x <= CGRectGetWidth(self.bounds)/2) {
        _currentPage--;
        
        if (_currentPage < 0) {
            _currentPage = self.titleArr.count-1;
        }
    }
}


#pragma mark - UI
-(UIPageControl*)pageControl
{
    if (!_pageControl) {
        CGRect rect = CGRectMake(40, CGRectGetHeight(self.bounds)-20, CGRectGetWidth(self.bounds)-40*2, 10);
        _pageControl = [[UIPageControl alloc]initWithFrame:rect];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor clearColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

-(UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*3, 0);
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始滚动时暂停定时器
    [self.timer pauseTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshCurrentPage];
    
    if (self.pageControl.currentPage != _currentPage) {
        self.pageControl.currentPage = _currentPage;
        [self refreshTitleView];
    }
    //滚动结束回复定时器
    [self.timer resumeTimerAfterTimeInterval:_animationDuration];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self refreshCurrentPage];
    
    if (self.pageControl.currentPage != _currentPage) {
        self.pageControl.currentPage = _currentPage;
        [self refreshTitleView];
    }
}

@end
