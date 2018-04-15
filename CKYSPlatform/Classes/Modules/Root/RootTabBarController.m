//
//  RootTabBarController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/11/2.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "RootTabBarController.h"
#import "Mediator+CKMainPage.h"
#import "Mediator+CKColloge.h"
#import "Mediator+CKMessage.h"
#import "Mediator+CKOrder.h"
#import "Mediator+CKMine.h"
#import "LoginViewController.h"
#import "MinePersonalInfomationViewController.h"
#import "CKPayViewController.h"
#import "CommonMethod.h"

#import "DHomepageViewController.h"
#import "DMineViewController.h"
#import "CKOrderViewController.h"
#import "XWAlterVeiw.h"
#import "WXApi.h"
#import "CKChooseJoinGoodsVC.h"
#import "CKOrderinfoModel.h"

#import "CKMessageListViewController.h"
#import "CKConfrimRegistMsgViewController.h"
#import "FFWarnAlertView.h"

#define RootTabBarItemBadgeRadius 7.5f

@interface RootTabBarItem : UITabBarItem

@end

@implementation RootTabBarItem {
@private
    NSString *_rootTabBarBadgeValue;
    UILabel *_rootTabBarBadgeLabel;
}

-(NSString *)badgeValue {
    return _rootTabBarBadgeValue;
}

-(void)setBadgeValue:(NSString *)badgeValue {
    _rootTabBarBadgeValue = badgeValue;
    [self updateBadgeViewLayout];
}

-(void)updateBadgeViewLayout {
    
    NSString *viewKey = @"view";
    
    if(![CommonMethod isVariableWithClass:[UITabBarItem class] varName:viewKey]) {
        return;
    }
    
    UIView *view = [self valueForKey:viewKey];
    if(!view) {
        return;
    }
    
    if(!_rootTabBarBadgeLabel) {
        _rootTabBarBadgeLabel = [[UILabel alloc] init];
        _rootTabBarBadgeLabel.backgroundColor = [UIColor redColor];
        _rootTabBarBadgeLabel.textColor = [UIColor whiteColor];
        _rootTabBarBadgeLabel.textAlignment = NSTextAlignmentCenter;
        _rootTabBarBadgeLabel.font = [UIFont systemFontOfSize:9];
        _rootTabBarBadgeLabel.layer.masksToBounds = YES;
        _rootTabBarBadgeLabel.layer.cornerRadius = RootTabBarItemBadgeRadius;
        if(view.superview) {
            [view.superview addSubview:_rootTabBarBadgeLabel];
        }
    }
    
    BOOL isHiden = _rootTabBarBadgeValue ? NO : YES;
    _rootTabBarBadgeLabel.hidden = isHiden;
    
    if(!isHiden) {
        _rootTabBarBadgeLabel.text = _rootTabBarBadgeValue;
        CGFloat minX = CGRectGetMinX(view.frame) + CGRectGetWidth(view.frame) / 2 + self.imageInsets.left + RootTabBarItemBadgeRadius;
        CGRect frame = CGRectMake(minX, 4, RootTabBarItemBadgeRadius * 2, RootTabBarItemBadgeRadius * 2);
        _rootTabBarBadgeLabel.frame = frame;
    }
}

@end

@interface RootTabBarController ()<UITabBarControllerDelegate, XWAlterVeiwDelegate>

{
    NSString *_ckidString;
    NSString *_statusString;
    NSString *_tgidString;
    
}

@property (nonatomic, strong) XWAlterVeiw *alert;

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeComponent];
    
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

-(void)initializeComponent {
    
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    
    Mediator *mediator = [Mediator sharedInstance];
    // 首页
    UIViewController *home = [mediator ckMainPageViewController];
    home.tabBarItem = [[RootTabBarItem alloc] init];
    home.tabBarItem.image = [self imageOriginal:@"tab_home_nomal"];
    home.tabBarItem.selectedImage = [self imageOriginal:@"tab_home_selected"];
    [home.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    RootNavigationController *navHome = [[RootNavigationController alloc] initWithRootViewController:home];
    // 商学院
    UIViewController *business = [mediator ckCollegeViewController];
    business.tabBarItem = [[RootTabBarItem alloc] init];
    business.tabBarItem.image = [self imageOriginal:@"tab_class_nomal"];
    business.tabBarItem.selectedImage = [self imageOriginal:@"tab_class_selected"];
    [business.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    RootNavigationController *navbusiness = [[RootNavigationController alloc] initWithRootViewController:business];
    // 消息
    CKMessageListViewController *news = [[CKMessageListViewController alloc] init];
//    UIViewController *news = [mediator ckMessageViewController];
    news.tabBarItem = [[RootTabBarItem alloc] init];
    news.tabBarItem.image = [self imageOriginal:@"tab_message_nomal"];
    news.tabBarItem.selectedImage = [self imageOriginal:@"tab_message_selected"];
    [news.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    RootNavigationController *navNews = [[RootNavigationController alloc] initWithRootViewController:news];
    //订单
    UIViewController *order = [mediator ckOrderViewController];
    order.tabBarItem = [[RootTabBarItem alloc] init];
    order.tabBarItem.image = [self imageOriginal:@"tab_order_nomal"];
    order.tabBarItem.selectedImage = [self imageOriginal:@"tab_order_selected"];
    [order.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    RootNavigationController *navOrder = [[RootNavigationController alloc] initWithRootViewController:order];
    //我
    UIViewController *me = [mediator ckMineViewController];
    me.tabBarItem = [[RootTabBarItem alloc] init];
    me.tabBarItem.image = [self imageOriginal:@"tab_mine_nomal"];
    me.tabBarItem.selectedImage = [self imageOriginal:@"tab_mine_selected"];
    [me.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    RootNavigationController *navMe = [[RootNavigationController alloc] initWithRootViewController:me];
    
    self.delegate = self;
    [self setViewControllers:@[navHome, navbusiness, navNews,navOrder,navMe]];
    
}

-(UIImage*)imageOriginal:(NSString*)name {
    UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

#pragma mark - UITabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    _statusString = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KStatus]];
    if (IsNilOrNull(_statusString)) {
        _statusString = @"";
    }
    NSString *checkStatus = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KCheckStatus]];
    if (IsNilOrNull(checkStatus)) {
        checkStatus = @"";
    }
    
    if (viewController == [tabBarController.viewControllers objectAtIndex:1] || viewController == [tabBarController.viewControllers objectAtIndex:2] || viewController == [tabBarController.viewControllers objectAtIndex:3]){
        //  店铺状态（未支付：NOTPAY，未审核：NOTREVIEW，未完善个人资料：NOINFO，已开通：PAY，关闭：CLOSE）
        NSString *exitRegisterState = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:@"exitRegister"]];
        NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
        if (![homeLoginStatus isEqualToString:@"homelogin"]) { //未登录 是否是半登录的case
            NSString *unionid = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:Kunionid]];
            if (!IsNilOrNull(unionid)) {
                if (IsNilOrNull(_ckidString) && [exitRegisterState isEqualToString:@"1"]) {
                    if (viewController == [tabBarController.viewControllers objectAtIndex:1] || viewController == [tabBarController.viewControllers objectAtIndex:2]){
//                        CKConfrimRegistMsgViewController *regist = [[CKConfrimRegistMsgViewController alloc] init];
//                        RootNavigationController *navi = [[RootNavigationController alloc] initWithRootViewController:regist];
//                        [self presentViewController:navi animated:YES completion:^{
//
//                        }];
                        [self checkRegistStatus];
                        return NO;
                    }else{
                        return YES;
                    }
                }else{
                    if (viewController == [tabBarController.viewControllers objectAtIndex:3]){
                        return YES;
                    }else{
                        LoginViewController *login = [[LoginViewController alloc] init];
                        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                            
                        }];
                        return NO;
                    }
                }
            }else{
                LoginViewController *login = [[LoginViewController alloc] init];
                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                    
                }];
                return NO;
            }
        }else{//登录状态
            if (viewController == [tabBarController.viewControllers objectAtIndex:3]){
                return YES;
            }else{
                NSString *tgStr = [KUserdefaults objectForKey:KSales];
                NSString *tgidString = IsNilOrNull(tgStr) ? @"0" : tgStr;
                if (viewController == [tabBarController.viewControllers objectAtIndex:2]) {
                    if (![tgidString isEqualToString:@"0"]) {//推广人登录不能看消息
                        FFWarnAlertView *warn = [[FFWarnAlertView alloc] init];
                        warn.titleLable.text = @"暂无权限查看";
                        [warn showFFWarnAlertView];
                        return NO;
                    }
                }
                
                if(checkStatus && checkStatus.length > 0){
                    
                    //已登录 未支付  跳转支付页面
                    if ([checkStatus isEqualToString:@"NOTPAY"]) {  //未付款
                        [self checkRegistStatus];
                        return NO;
                    }else  if ([checkStatus isEqualToString:@"CLOSE"]){
                        //已登录并且 已经付款 资料完善 店铺关闭  NOINFO/NOTREVIEW
                        if ([_statusString isEqualToString:@"NOINFO"]) {
                            //跳转完善信息
                            [self showNoticeView:CKYSmsgshopstatusUpdatePersonalInfo];
                            MinePersonalInfomationViewController *mineInfo = [[MinePersonalInfomationViewController alloc] init];
                            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:mineInfo] animated:YES completion:^{}];
                            return NO;
                        }else{
                            //提示店铺审核中
                            [self showNoticeView:CKYSmsgshopstatusPending];
                            return NO;
                        }
                        
                    }else  if ([checkStatus isEqualToString:@"NOOPEN"]){//预售店待开通
                        if ([_statusString isEqualToString:@"NOINFO"]) { //未完善资料
                            //跳转完善信息
                            MinePersonalInfomationViewController *mineInfo = [[MinePersonalInfomationViewController alloc] init];
                            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:mineInfo] animated:YES completion:^{}];
                            return NO;
                        }else  if([_statusString isEqualToString:@"NOOPEN"]){//预售店待开通
                            [self showNoticeView:CKYSmsgshopstatusConnectCKOpen];
                            return NO;
                            
                        }else{
                            //提示店铺审核中
                            [self showNoticeView:CKYSmsgshopstatusPending];
                            return NO;
                        }
                        
                    }else if ([checkStatus isEqualToString:@"PAY"]){
                        //正常情况
                        
                        return YES;
                    }else{
                        [self removeDataAndLogOut];
                        LoginViewController *login = [[LoginViewController alloc] init];
                        [self  presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                            
                        }];
                        return NO;
                    }
                }else{
                    
                    //已登录 未支付  跳转支付页面
                    if ([_statusString isEqualToString:@"NOTPAY"]) {  //未付款
                        
                        [self checkRegistStatus];
                        return NO;
                    }else  if ([_statusString isEqualToString:@"NOINFO"]){
                        //已登录并且 已经付款 资料完善 店铺关闭  NOINFO/NOTREVIEW
                        [self showNoticeView:CKYSmsgshopstatusUpdatePersonalInfo];
                        MinePersonalInfomationViewController *mineInfo = [[MinePersonalInfomationViewController alloc] init];
                        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:mineInfo] animated:YES completion:^{}];
                        return NO;
                        
                    }else if ([_statusString isEqualToString:@"NOTREVIEW"]){
                        //跳转完善信息
                        [self showNoticeView:CKYSmsgshopstatusPending];
                        return NO;
                    }else  if([_statusString isEqualToString:@"NOOPEN"]){//预售店待开通
                        
                        [self showNoticeView:CKYSmsgshopstatusConnectCKOpen];
                        return NO;
                        
                    }else if ([_statusString isEqualToString:@"PAY"]){
                        //正常情况
                        
                        return YES;
                    }else if ([_statusString isEqualToString:@"CLOSE"]){  //店铺关闭
                        //正常情况
                        [self  showNoticeView:CKYSmsgshopstatusPending];
                        return NO;
                    }else{
                        [self removeDataAndLogOut];
                        LoginViewController *login = [[LoginViewController alloc] init];
                        [self  presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                            
                        }];
                        return NO;
                    }
                    
                }
                return NO;
            }
        }
    }else{ //点击首页和个人中心
        return YES;
    }
}
#pragma mark-特殊情况下删除创客
-(void)removeDataAndLogOut {
    [KUserdefaults setObject:@"" forKey:Kckid];
    [KUserdefaults setObject:@"" forKey:KSales];
    [KUserdefaults setObject:@"" forKey:KStatus];
    [KUserdefaults setObject:@"" forKey:KCheckStatus];
}

//添加提示view
- (void)showNoticeView:(NSString*)title{
    if (self.viewNetError && !self.viewNetError.visible) {
        self.viewNetError.textLabel.text = title;
        [self.viewNetError showInView:[UIApplication sharedApplication].keyWindow];
        [self.viewNetError dismissAfterDelay:1.5f];
    }
}

#pragma mark - 检查注册状态
-(void)checkRegistStatus {
    
    NSString *unionid = [KUserdefaults objectForKey:Kunionid];
    if (IsNilOrNull(unionid)) {
        
        if(![WXApi isWXAppInstalled]){//未安装微信的客户
            self.alert = [[XWAlterVeiw alloc] init];
            self.alert.delegate = self;
            self.alert.titleLable.text = @"请下载安装微信";
            [self.alert show];
            
        }else{
            self.selectedIndex = 0;
            //安装了微信的客户
            SendAuthReq *req =[[SendAuthReq alloc ] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"26789ww";
            [WXApi sendReq:req];
        }
    }else{
        self.selectedIndex = 0;
        [CKCNotificationCenter postNotificationName:WeiXinAuthSuccess object:nil];
    }
}


#pragma -mark Autorotate

-(BOOL)shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

#pragma -mark dealloc
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
