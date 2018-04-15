//
//  WelcomeViewController.m
//  yingzi_iOS
//
//  Created by cheng on 16/2/3.
//  Copyright © 2016年 lyw. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>
{
    NSInteger  _currentPage;
    NSString *_ckidString;
}
@property (nonatomic,strong) UIScrollView * scrollview;
//@property (nonatomic,strong) UIPageControl * pageControl;
@property (nonatomic,strong) UIButton * startBtn;//立即进入主页按钮
@property (nonatomic,strong) UIButton * jumpButton;
@end

@implementation WelcomeViewController
-(id)init{
    if (self = [super init]) {
       
    }
    return self;
}
-(void)wexinCancel:(NSNotification *)notice{
    NSString *code = [NSString stringWithFormat:@"%@",notice.object];
    if ([code isEqualToString:@"0"]) {
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }

}
-(void)dealloc{
    [CKCNotificationCenter removeObserver:self name:@"cancel" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.viewDataLoading stopAnimation];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [CKCNotificationCenter addObserver:self selector:@selector(wexinCancel:) name:@"cancel" object:nil];
    
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollview.delegate = self;
    _scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT);
    _scrollview.pagingEnabled=YES;
    _scrollview.showsVerticalScrollIndicator=NO;
    _scrollview.showsHorizontalScrollIndicator=NO;
    _scrollview.bounces = NO;
    [_scrollview setContentOffset:CGPointMake(0, 0)];
    [self.view addSubview:_scrollview];
    for (int i=0; i<3; i++) {
        UIImageView * welcomeImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        welcomeImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome%d.png",i+1]];
        [_scrollview addSubview:welcomeImg];
        if (i == 2) {
            [welcomeImg setUserInteractionEnabled:YES];
            _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _startBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            _startBtn.backgroundColor = [UIColor clearColor];
            [_startBtn addTarget:self action:@selector(EnterIndex) forControlEvents:UIControlEventTouchUpInside];
            [welcomeImg addSubview:_startBtn];
        }
    }
//    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-20,SCREEN_WIDTH, 10)];
//    _pageControl.hidesForSinglePage = YES;
//    _pageControl.numberOfPages = 3;
//    _pageControl.currentPage = 0;
//    [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventTouchUpInside];
//    _pageControl.backgroundColor=[UIColor clearColor];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0) {
//        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:38.0/255.0 green:196.0/255.0 blue:252.0/255.0 alpha:1];
//        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
//    }
//    [self.view addSubview: _pageControl];
    
    
    //点击跳过功能
//    _jumpButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 30, 60, 20)];
//    [_jumpButton setTitle:@"点击跳过" forState:UIControlStateNormal];
//    [_jumpButton setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:115.0/255.0 alpha:1] forState:UIControlStateNormal];
//    [_jumpButton setBackgroundColor:[UIColor colorWithRed:17.0/255.0 green:16.0/255.0 blue:37.0/255.0 alpha:0.6]];
//     _jumpButton.layer.cornerRadius = 3;
//    _jumpButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_jumpButton addTarget:self action:@selector(EnterIndex) forControlEvents:UIControlEventTouchUpInside];
//    [_scrollview addSubview:_jumpButton];
}

- (void)EnterIndex
{
    //获取用户登录状态，判断是否进入登录界面
//    RootTabViewController * rootTab = [[RootTabViewController alloc] init];
    RootTabBarController *rootTab = [[RootTabBarController alloc] init];
    rootTab.selectedIndex = 0;
    [self.navigationController pushViewController:rootTab animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentPage = _scrollview.contentOffset.x/_scrollview.frame.size.width;
//    _pageControl.currentPage = _currentPage;
}

- (void)pageControlClick:(UIPageControl *)pageControl{
    CGFloat offsetX = pageControl.currentPage*SCREEN_WIDTH;
    [_scrollview setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

@end
