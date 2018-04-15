//
//  BaseViewController.m
//  ShoppingCentre
//
//  Created by 庞宏侠 on 16/7/12.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "FFWarnAlertView.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
- (AppDelegate *)appDelegate {
    if (!_appDelegate) {
        _appDelegate = [AppDelegate shareAppDelegate];
    }
    return _appDelegate;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [CKCNotificationCenter addObserver:self selector:@selector(stopHud) name:@"hudstop" object:nil];
    [self createBaseUI];
    
}

-(void)stopHud{
    [self.viewDataLoading stopAnimation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.viewDataLoading stopAnimation];
}

-(void)createBaseUI{
    self.view.backgroundColor = [UIColor tt_grayBgColor];
    
    // 增加风火轮
    self.viewDataLoading = [[CKC_CustomProgressView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 增加网络错误时提示
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.indicatorView = nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionBottomCenter;
    self.viewNetError.marginInsets = (UIEdgeInsets)
    {
        .top = 0.0f,
        .bottom = 60.0f,
        .left = 0.0f,
        .right = 0.0f,
    };
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
//    FFWarnAlertView *alert = [[FFWarnAlertView alloc] init];
//    alert.titleLable.text = @"活该单身20年";
//    [alert showFFWarnAlertView];
    
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


//- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
//{
//    UIViewController *vc = self.presentingViewController;
//    NSString *class = NSStringFromClass([vc class]);
//
//    // 模态之前先判断是否存在之情的视图
//    if ([class isEqualToString:NSStringFromClass([viewControllerToPresent class])]) {
//
//        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        [self dismissViewControllerAnimated:YES completion:completion];
//
//    } else {
//        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
//    }
//}
-(void)dealloc{
    
    
    [CKCNotificationCenter removeObserver:self name:@"hudstop" object:nil];
}

@end
