//
//  CKCollegeHeaderView.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKCollegeHeaderView.h"
#import "SDCycleScrollView.h"

@interface CKCollegeHeaderView()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CKCollegeHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initComponents];
    }
    return self;
}

-(void)initComponents {
    
    self.backgroundColor = [UIColor whiteColor];
    
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185*SCREEN_WIDTH/375.0f)];
    _myScrollView.showsVerticalScrollIndicator = NO;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_myScrollView];
    
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185*SCREEN_WIDTH/375.0f) delegate:self placeholderImage:[UIImage imageNamed:@"waitbanner"]];
    
    self.cycleScrollView.backgroundColor = [UIColor whiteColor];
    self.cycleScrollView.currentPageDotColor = [UIColor redColor];
    self.cycleScrollView.pageDotColor = [UIColor lightGrayColor];
    self.cycleScrollView.imageURLStringsGroup = @[@"http://testofflineckysre.ckc8.com/ckc3/Uploads/201705/201705041722422029144.jpg",@"http://testofflineckysre.ckc8.com/ckc3/Uploads/201705/201705041722422029144.jpg",@"http://testofflineckysre.ckc8.com/ckc3/Uploads/201706/201706301853165863424.jpg"];
    [self.myScrollView addSubview:self.cycleScrollView];
    
    
    NSArray *titleArr = @[@"基础课程",@"销售技巧",@"学习天地",@"直播间"];
    NSArray *imageArr = @[@"fratures1",@"fratures3",@"fratures2",@"fratures2"];
    
    float leftx = (SCREEN_WIDTH-AdaptedWidth(40)*titleArr.count) / titleArr.count * 0.5;
    
    for (int i = 0; i < titleArr.count; i++){
        
        UIView *bgview = [UIView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(turnTo:)];
        [bgview addGestureRecognizer:tap];
        bgview.tag = 520 + i;
        [self addSubview:bgview];
        [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.myScrollView.mas_bottom);
            make.left.mas_equalTo(i*AdaptedWidth(SCREEN_WIDTH / 4.0f));
            make.width.mas_equalTo(AdaptedWidth(SCREEN_WIDTH / 4.0f));
            make.bottom.mas_equalTo(self);
        }];
        
        UIImageView *imageView = [UIImageView new];
        imageView.userInteractionEnabled = YES;
        [bgview addSubview:_imageView = imageView];
        [imageView setImage:[UIImage imageNamed:imageArr[i]]];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgview.mas_centerX);
            make.top.equalTo(self.myScrollView.mas_bottom).offset(AdaptedHeight(10));
            make.width.mas_equalTo(AdaptedWidth(40));
            make.height.mas_equalTo(AdaptedWidth(40));
        }];
        UILabel *titleLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
        [bgview addSubview:_titleLabel = titleLabel];
        titleLabel.text = titleArr[i];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(AdaptedHeight(5));
            make.centerX.mas_equalTo(self.imageView);
            make.width.mas_equalTo(AdaptedWidth(40) + 2 * leftx - AdaptedWidth(10));
            make.bottom.mas_offset(-AdaptedHeight(5));
        }];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerPushToDetail:)]) {
        [self.delegate bannerPushToDetail:index];
    }
}

-(void)turnTo:(UITapGestureRecognizer*)tap {
    
    UIView *v = [tap view];
    NSLog(@"%@", v);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(turnToDetailClassify:)]) {
        [self.delegate turnToDetailClassify:v.tag];
    }
}

@end
