//
//  RootBaseViewController.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/15.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "RootBaseViewController.h"
#import "CKTrainsExamViewController.h"

@interface RootBaseViewController ()


@end

@implementation RootBaseViewController

- (AppDelegate *)appDelegate
{
    if (!_appDelegate) {
        _appDelegate = [AppDelegate shareAppDelegate];
    }
    return _appDelegate;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self chekNetworking];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBaseUI];
    
    [CKCNotificationCenter addObserver:self selector:@selector(stopHud) name:@"hudstop" object:nil];
    
    [CKCNotificationCenter addObserver:self selector:@selector(networkStatusDidChange) name:RequestManagerReachabilityDidChangeNotification object:nil];
}


#pragma mark - 停止等待框
-(void)stopHud{
    [self.viewDataLoading stopAnimation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.viewDataLoading stopAnimation];
    [self.view sendSubviewToBack:_netTip];
}

-(void)createBaseUI{
    

    // 增加风火轮
    self.viewDataLoading = [[CKC_CustomProgressView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 增加网络错误时提示
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.indicatorView = nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionBottomCenter;
    self.viewNetError.marginInsets = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
    
    //网络提示
    _netTip = [[UIView alloc] initWithFrame:CGRectMake(0, 20+NaviAddHeight, SCREEN_WIDTH, 44)];
    _netTip.backgroundColor = [UIColor colorWithHexString:@"#fffbe0"];
    [self.view addSubview:_netTip];
    [self.view sendSubviewToBack:_netTip];
    
    UIImageView *warnImgV = [UIImageView new];
    [_netTip addSubview:warnImgV];
    warnImgV.image = [UIImage imageNamed:@"netWarn"];
    [warnImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_netTip.mas_centerY);
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(13);
    }];
    
    UILabel *warnMsg = [UILabel new];
    warnMsg.text = NetWorkNotReachable;
    warnMsg.textColor = [UIColor colorWithHexString:@"#db291d"];
    warnMsg.font = MAIN_NAMETITLE_FONT;
    [_netTip addSubview:warnMsg];
    [warnMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(warnImgV.mas_centerY);
        make.left.equalTo(warnImgV.mas_right).offset(10);
    }];
    
}

//添加提示view
- (void)showNoticeView:(NSString*)title
{
    if (IsNilOrNull(title)){
        return;
    }
    if (self.viewNetError && !self.viewNetError.visible) {
        self.viewNetError.textLabel.text = title;
        [self.viewNetError showInView:[UIApplication sharedApplication].keyWindow];
        [self.viewNetError dismissAfterDelay:1.5f];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.childViewControllers.count==1) {
        return NO;
    }
    return YES;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    UIViewController *vc = self.presentingViewController;
    NSString *class = NSStringFromClass([vc class]);
    
    // 模态之前先判断是否存在之情的视图
    if ([class isEqualToString:NSStringFromClass([viewControllerToPresent class])]) {
        
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self dismissViewControllerAnimated:YES completion:completion];
        
    } else {
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}


-(void)chekNetworking {
    
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    switch (status) {
        case RequestReachabilityStatusReachableViaWiFi:
        case RequestReachabilityStatusReachableViaWWAN: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HasNetNotification" object:nil];
            [self.view sendSubviewToBack:_netTip];
        }
            break;
            
        default: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNetNotification" object:nil];
            [self.view bringSubviewToFront:_netTip];

        }
            break;
    }
}


-(void)networkStatusDidChange {
    
    
//    RootTabViewController *rootVc = (RootTabViewController *)self.appDelegate.window.rootViewController;
    RootTabBarController *rootVc = (RootTabBarController *)self.appDelegate.window.rootViewController;

    
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    switch (status) {
        case RequestReachabilityStatusReachableViaWiFi:
        case RequestReachabilityStatusReachableViaWWAN: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HasNetNotification" object:nil];
            [self.view sendSubviewToBack:_netTip];//将一个UIView层推送到背后
            [self requestRootData:rootVc.selectedIndex];
        }
            break;
        default: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNetNotification" object:nil];
            [self.view bringSubviewToFront:_netTip]; //将一个UIView显示在最前面
        }
            break;
    }
}

-(void)requestRootData:(NSInteger)selectedIndex {
    
    if (selectedIndex == 0) {
        //请求数据
        [CKCNotificationCenter postNotificationName:@"RequestHomePageData" object:nil];
    }else if (selectedIndex == 1) {
        //请求数据
        [CKCNotificationCenter postNotificationName:@"RequestCollegeData" object:nil];
    }else if (selectedIndex == 2) {
        //请求数据
        [CKCNotificationCenter postNotificationName:@"RequestMessageData" object:nil];
    }else if (selectedIndex == 3) {
        //请求数据
        [CKCNotificationCenter postNotificationName:@"RequestOrderData" object:nil];
    }else if (selectedIndex == 4) {
        //请求数据
        [CKCNotificationCenter postNotificationName:@"RequestMineData" object:nil];
    }
}

-(void)dealloc{
    [CKCNotificationCenter removeObserver:self name:@"hudstop" object:nil];
    [CKCNotificationCenter removeObserver:self name:RequestManagerReachabilityDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
