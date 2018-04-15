//
//  CKJPushManager.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/31.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKJPushManager.h"
#import "ChatMessageViewController.h"
#import "ClassDetailViewController.h"
#import "WebDetailViewController.h"
#import "PTConversationViewController.h"
#import "CKMyProductLibVC.h"
#import "CKMyProductLibVCOld.h"
#import "TopUpPayTypeViewController.h"
#import "TopUpViewController.h"
#import "CKCouponDetailViewController.h"


static NSString *appKey = JPush_appKey;
static NSString *channel = @"App Store";
static BOOL isProduction = YES;

@implementation CKJPushManager

+(instancetype)manager {
    static CKJPushManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CKJPushManager alloc] initPrivate];
    });
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        
    }
    return self;
}

-(void)registerJPushWithapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //融云消息推送
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
#pragma clang diagnostic pop
    // －－－－－－－－极光推送注册－－－－－－－－－
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        // iOS10 极光注册
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        
    }  else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)categories:nil];
    }
    //Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction];
    
    //打开极光推送日志
    [JPUSHService setDebugMode];
    //开启Crash日志收集
    [JPUSHService crashLogON];
    
    [CKCNotificationCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // 后台获取消息 跳转不同界面
    //  如果 App 状态为未运行，此函数将被调用，如果launchOptions包含UIApplicationLaunchOptionsRemoteNotificationKey表示用户点击apn 通知导致app被启动运行；如果不含有对应键值则表示 App 不是因点击apn而被启动，可能为直接点击icon被启动或其他。
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        // 程序未启动 是通过点击 通知apn消息打开app  此方法 被didReceiveRemoteNotification 替代 都会走
    }else{
        //[self getPushNotReadData];
    }
    // 清空icon 设置JPush服务器中存储的badge值 value 取值范围：[0,99999]
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

-(void)networkDidReceiveMessage:(NSNotification *)notification{
    NSLog(@"监听消息");
    NSDictionary * userInfo = [notification userInfo];
    
    NSString *pushType = [userInfo objectForKey:@"pushType"];
    if (!IsNilOrNull(pushType) && [pushType isEqualToString:@"serverPush"]) {
        return;
    }
    
    NSString *title = [userInfo objectForKey:@"title"];
    NSString *content = [userInfo objectForKey:@"content"]; //内容
    
    // 取得Extras字段内容
    NSDictionary *extrasDic = [userInfo objectForKey:@"extras"];
    NSString *type = [extrasDic objectForKey:@"type"];
    
    NSMutableArray *sortIDArr = [NSMutableArray array];
    NSString *typecode = [userInfo objectForKey:@"typecode"];
    if (!IsNilOrNull(typecode)) {
        [sortIDArr addObject:typecode];
        [KUserdefaults setObject:sortIDArr forKey:@"CollegeClassPushIdArr"];
    }
    
    NSString *imageUrl = [extrasDic objectForKey:@"imgurl"];
    NSString *detailUrl = [extrasDic objectForKey:@"url"];
    NSString *viewed = [extrasDic objectForKey:@"viewed"];
    
    //    NSString *imageUrl = [userInfo objectForKey:@"imgurl"];
    //    NSString *detailUrl = [userInfo objectForKey:@"url"];
    //    NSString *viewed = [userInfo objectForKey:@"viewed"];
    
    NSString *showAlert  = nil;
    if (IsNilOrNull(title)) {
        showAlert = [NSString stringWithFormat:@"%@",content];
    }else{
        showAlert = [NSString stringWithFormat:@"%@:%@",title,content];
    }
    
    UIViewController *currentVC = [UIViewController currentVC];
    UIApplication *application = [UIApplication sharedApplication];
    
    if(application.applicationState == UIApplicationStateActive){
        if ([currentVC isKindOfClass:[ChatMessageViewController class]] || [currentVC isKindOfClass:[PTConversationViewController class]]) {
            
        }else{
            if (![self.isToothVc isEqualToString:@"YES"]) {
                //如果要全部弹窗使用[[MessageAlert alloc] init]，最后一条[MessageAlert shareInstance];
                self.messageByPushAler = [MessageAlert shareInstance];
                self.messageByPushAler.isDealInBlock = YES;
                //新闻和课程消息推送
                if ([type isEqualToString:@"3"] || [type isEqualToString:@"4"]){
                    [self.messageByPushAler hiddenCancelBtn:NO];
                    
                    if(![currentVC isKindOfClass:[WebDetailViewController class]] && ![currentVC isKindOfClass:[ClassDetailViewController class]]){
                        
                        [self.messageByPushAler showAlert:content btnClick:^{
                            
                            NSLog(@"收到自定义消息");
                            if([type isEqualToString:@"3"]){//新闻
                                WebDetailViewController *newsDetail = [[WebDetailViewController alloc] init];
                                newsDetail.typeString = @"news";
                                newsDetail.detailUrl = detailUrl;
                                newsDetail.shareDescrip = content;
                                newsDetail.imgUrl = imageUrl;
                                newsDetail.shareTitle = title;
                                [[[UIViewController currentVC] navigationController] pushViewController:newsDetail animated:YES];
                                
                            }else if([type isEqualToString:@"4"]){
                                ClassDetailViewController *classDetail = [[ClassDetailViewController alloc] init];
                                classDetail.detailUrl = detailUrl;
                                classDetail.viewsString = viewed;
                                [[[UIViewController currentVC] navigationController] pushViewController:classDetail animated:YES];
                            }
                            
                        }];
                    }
                    
                }else if([type isEqualToString:@"10"] || [type isEqualToString:@"11"]){
                    if ([currentVC isKindOfClass:[CKMyProductLibVC class]] || [currentVC isKindOfClass:[CKMyProductLibVCOld class]] || [currentVC isKindOfClass:[TopUpPayTypeViewController class]] ||
                        [currentVC isKindOfClass:[TopUpViewController class]] || [currentVC isKindOfClass:[CKCouponDetailViewController class]]) {
                        
                    }else{
                        [self.messageByPushAler hiddenCancelBtn:NO];
                        [self.messageByPushAler showAlert:content btnClick:^{
                            //抵用券消息
                            [self enterProductLib];
                        }];
                    }
                }else if([type isEqualToString:@"0"] || [type isEqualToString:@"1"] || [type isEqualToString:@"2"] || [type isEqualToString:@"5"] || [type isEqualToString:@"6"] || [type isEqualToString:@"7"]){ // 开店消息（0）订单消息（2）系统（1）平台通知（5）产品库（6）芸豆库（7）直接展示
                    [self.messageByPushAler hiddenCancelBtn:YES];
                    [self.messageByPushAler showAlert:showAlert btnClick:^{
                        
                    }];
                }
                
            }
        }
        
    }else{
        NSLog(@"收到后台消息");
//        [self jpshApnsMessage:userInfo];
    }
    
}

/**
 说明用户点击通知, 进入了程序(程序还在运行中, 程序并没有被关掉) 本地消息
 */
-(void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification{
    
    //跳转对应的vc
//    RootTabViewController *rootVC = [[RootTabViewController alloc] init];
    RootTabBarController *rootVC = [[RootTabBarController alloc] init];
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    window.rootViewController = rootVC;
    rootVC.selectedIndex = 2;
}
/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
/**
 * 推送处理3
 */
#pragma mark 注册deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   
    NSLog(@"\n[JPush获取Token]---[%@]",deviceToken);
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    // 设置别名
    
    NSString *ckidStr = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *tgidString = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    if (IsNilOrNull(tgidString)){
        tgidString = @"0";
    }
    //推广人登录 注册极光push 格式tgid_ckid  创客注册极光push：ckid
    
    NSSet *setTags = [NSSet setWithObject:@"ckapp"];
    if(![tgidString isEqualToString:@"0"]){
        NSString *tgidJpush = [NSString stringWithFormat:@"%@_%@",tgidString,ckidStr];
        //推广人登录
        [JPUSHService setTags:setTags alias:tgidJpush fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"\n[推广人登录成功后设置别名]---[%@]",iAlias);
        }];
    }else{
        if(ckidStr && ckidStr.length > 0){  //避免ckid为空值进行设置
            [JPUSHService setTags:setTags alias:ckidStr fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"\n[JPush设置别名]---[%@]",iAlias);
            }];
        }
    }
    //查看registId
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
    }];
    
}

#pragma mark - 收到推送消息 基于iOS 7 及以上的系统版本
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"didReceiveRemoteNotification");
    
    NSLog(@"app状态%zd",application.applicationState);
    
    NSString *pushType = [userInfo objectForKey:@"pushType"];
    if (!IsNilOrNull(pushType) && [pushType isEqualToString:@"serverPush"]) {
        return;
    }
    
    NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
    NSString *type = [userInfo objectForKey:@"type"];
    
    NSMutableArray *sortIDArr = [NSMutableArray array];
    NSString *typecode = [userInfo objectForKey:@"typecode"];
    if (!IsNilOrNull(typecode)) {
        [sortIDArr addObject:typecode];
        [KUserdefaults setObject:sortIDArr forKey:@"CollegeClassPushIdArr"];
    }
    
    NSString *content = [apsDict objectForKey:@"alert"];//内容
    UIViewController *currentVC = [UIViewController currentVC];
    
    // iOS 10 以下 Required
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // IOS 7 Support Required
    completionHandler(UIBackgroundFetchResultNewData);
    if (application.applicationState == UIApplicationStateActive){//在应用内时收到推送
        [self appForgrounMessage:userInfo];
        NSLog(@"app进入前台UIApplicationStateActive");
        
    }else if(application.applicationState == UIApplicationStateInactive){//从应用外 滑动推送信息
        NSLog(@"app由后台进入前台UIApplicationStateInactive");
        if (IsNilOrNull(type)){
            //激光后台消息
            if ([currentVC isKindOfClass:[ChatMessageViewController class]] || [currentVC isKindOfClass:[PTConversationViewController class]]) {
                
            }else{
                if (![self.isToothVc isEqualToString:@"YES"]) {
                    
                    self.messageByPushAler = [MessageAlert shareInstance];
                    self.messageByPushAler.isDealInBlock = YES;
                    AudioServicesPlaySystemSound(1007);
                    // 2. 极光推送的事件处理
                    [self.messageByPushAler hiddenCancelBtn:YES];
                    [self.messageByPushAler showAlert:content btnClick:^{
                        
                    }];
                    
                }
            }
        }else{
            
            NSLog(@"Inactive收到消息");
            [self jpshApnsMessage:userInfo];
        }
    }else if(application.applicationState == UIApplicationStateBackground){
        //处理点击图标
        NSLog(@"Background后台收到推送消息");
        [self appBecomActiveWith:userInfo];
    }
    
    
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma mark - iOS10 收到通知（本地和远端） UNUserNotificationCenterDelegate
// iOS 10 Support 添加处理APNs通知回调方法 这个方法 是App在应用内收到的推送
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"willPresentNotification:%@",userInfo);
        [JPUSHService handleRemoteNotification:userInfo];
        completionHandler(UNNotificationPresentationOptionBadge);
        [self appForgrounMessage:userInfo];
    } else {
        completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    
}
// iOS 10 Support 这个是应用外，活跃状态
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"withCompletionHandler消息内容:%@",userInfo);
        [self jpshApnsMessage:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];
    }else{
        
        
    }
    completionHandler();  // 系统要求执行这个方法
}

#pragma mark - 处理官方通知
-(void)processOfficialNotice:(NSDictionary*)userInfo {
    
    //如果消息是官方通知的消息，如果类型3、4、5那么官方通知的未读红点要显示，否则不显示。
    NSString *type = [userInfo objectForKey:@"type"];
    if ([type isEqualToString:@"3"] || [type isEqualToString:@"4"] || [type isEqualToString:@"5"]) {
        [KUserdefaults setObject:@"1" forKey:KOfficialNotReadNum];
    }
}
-(void)appForgrounMessage:(NSDictionary *)userInfo{
    NSLog(@"应用内收到的极光推送%@",userInfo);
    [self processOfficialNotice:userInfo];
    //处理应用内收到消息
    [self appBecomActiveWith:userInfo];
    
}
#pragma mark-处理应用内极光收到推送消息
-(void)appBecomActiveWith:(NSDictionary *)userInfo{
    NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
    NSString *type = [userInfo objectForKey:@"type"];
    
    NSMutableArray *sortIDArr = [NSMutableArray array];
    NSString *typecode = [userInfo objectForKey:@"typecode"];
    if (!IsNilOrNull(typecode)) {
        [sortIDArr addObject:typecode];
        [KUserdefaults setObject:sortIDArr forKey:@"CollegeClassPushIdArr"];
    }
    
    NSString *content = [apsDict objectForKey:@"alert"];//内容
    
    NSString *imageUrl = [userInfo objectForKey:@"imgurl"];
    NSString *detailUrl = [userInfo objectForKey:@"url"];
    NSString *viewed = [userInfo objectForKey:@"viewed"];
    NSString *title = [userInfo objectForKey:@"title"];
    
    NSString *showAlert  = nil;
    if (IsNilOrNull(title)){
        showAlert = [NSString stringWithFormat:@"%@",content];
    }else{
        showAlert = [NSString stringWithFormat:@"%@:%@",title,content];
    }
    UIViewController *currentVC = [UIViewController currentVC];
    //极光后台消息
    if ([currentVC isKindOfClass:[ChatMessageViewController class]] || [currentVC isKindOfClass:[PTConversationViewController class]]) {
        
    }else{
        if (![self.isToothVc isEqualToString:@"YES"]) {
            // 2. 事件处理弹出框
            self.messageByPushAler = [MessageAlert shareInstance];
            self.messageByPushAler.isDealInBlock = YES;
            if (IsNilOrNull(type)){ //极光后台推送的消息
                AudioServicesPlaySystemSound(1007);
                // 2. 极光推送的事件处理
                [self.messageByPushAler hiddenCancelBtn:YES];
                [self.messageByPushAler showAlert:content btnClick:^{
                    
                }];
                
            }else{
                //应用内收到消息 刷新消息列表数据
                [CKCNotificationCenter postNotificationName:@"refreshMessage" object:nil];
                AudioServicesPlaySystemSound(1007);
                //新闻和课程消息推送
                if ([type isEqualToString:@"3"] || [type isEqualToString:@"4"]){
                    [self.messageByPushAler hiddenCancelBtn:NO];
                    [self.messageByPushAler showAlert:content btnClick:^{
                        
                        if([type isEqualToString:@"3"]){//新闻
                            NSLog(@"前台活跃展示消息啦啦啦啦啦了");
                            
                            WebDetailViewController *newsDetail = [[WebDetailViewController alloc] init];
                            newsDetail.typeString = @"news";
                            newsDetail.detailUrl = detailUrl;
                            newsDetail.shareDescrip = content;
                            newsDetail.imgUrl = imageUrl;
                            newsDetail.shareTitle = title;
                            [[[UIViewController currentVC] navigationController] pushViewController:newsDetail animated:YES];
                            
                        }else if([type isEqualToString:@"4"]){
                            ClassDetailViewController *classDetail = [[ClassDetailViewController alloc] init];
                            classDetail.detailUrl = detailUrl;
                            classDetail.viewsString = viewed;
                            [[[UIViewController currentVC] navigationController] pushViewController:classDetail animated:YES];
                        }
                        
                    }];
                    
                }else if([type isEqualToString:@"10"] || [type isEqualToString:@"11"]){
                    if ([currentVC isKindOfClass:[CKMyProductLibVC class]] || [currentVC isKindOfClass:[CKMyProductLibVCOld class]] || [currentVC isKindOfClass:[TopUpPayTypeViewController class]] ||
                        [currentVC isKindOfClass:[TopUpViewController class]] || [currentVC isKindOfClass:[CKCouponDetailViewController class]]) {
                        
                    }else{
                        [self.messageByPushAler hiddenCancelBtn:NO];
                        [self.messageByPushAler showAlert:content btnClick:^{
                            //抵用券消息
                            [self enterProductLib];
                        }];
                    }
                }else if([type isEqualToString:@"0"] || [type isEqualToString:@"1"] || [type isEqualToString:@"2"] || [type isEqualToString:@"5"] || [type isEqualToString:@"6"] || [type isEqualToString:@"7"]){ // 开店消息（0）订单消息（2）系统（1）平台通知（5）产品库（6）芸豆库（7）直接展示   （10）充值券发放提醒  （11）充值券过期提醒
                    [self.messageByPushAler hiddenCancelBtn:YES];
                    [self.messageByPushAler showAlert:showAlert btnClick:^{
                        
                    }];
                }
                
            }
            
        }
    }
    
}

#pragma mark-处理应用外极光收到推送消息
-(void)jpshApnsMessage:(NSDictionary *)userInfo{
    
    [self processOfficialNotice:userInfo];
    
    NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
    NSString *type = [userInfo objectForKey:@"type"];
    NSString *content = [apsDict objectForKey:@"alert"];//内容
    
    NSString *imageUrl = [userInfo objectForKey:@"imgurl"];
    NSString *detailUrl = [userInfo objectForKey:@"url"];
    NSString *viewed = [userInfo objectForKey:@"viewed"];
    NSString *title = [userInfo objectForKey:@"title"];
    
    NSMutableArray *sortIDArr = [NSMutableArray array];
    NSString *typecode = [userInfo objectForKey:@"typecode"];
    if (!IsNilOrNull(typecode)) {
        [sortIDArr addObject:typecode];
        [KUserdefaults setObject:sortIDArr forKey:@"CollegeClassPushIdArr"];
    }
    
    NSString *showAlert  = nil;
    if (IsNilOrNull(title)) {
        showAlert = [NSString stringWithFormat:@"%@",content];
    }else{
        showAlert = [NSString stringWithFormat:@"%@:%@",title,content];
    }
    
    UIViewController *currentVC = [UIViewController currentVC];
    //极光后台消息
    if ([currentVC isKindOfClass:[ChatMessageViewController class]] || [currentVC isKindOfClass:[PTConversationViewController class]]) {
        
    }else{
        if (![self.isToothVc isEqualToString:@"YES"]) {
            
            self.messageByPushAler = [MessageAlert shareInstance];
            self.messageByPushAler.isDealInBlock = YES;
            if (IsNilOrNull(type)){
                AudioServicesPlaySystemSound(1007);
                // 2. 极光推送的事件处理
                [self.messageByPushAler hiddenCancelBtn:YES];
                [self.messageByPushAler showAlert:content btnClick:^{
                    
                }];
                
            }else{
                NSLog(@"应用外收消息1");
                if ([type isEqualToString:@"3"] || [type isEqualToString:@"4"]){
                    
                    if([type isEqualToString:@"3"]){//新闻
                        WebDetailViewController *newsDetail = [[WebDetailViewController alloc] init];
                        newsDetail.typeString = @"news";
                        newsDetail.detailUrl = detailUrl;
                        newsDetail.shareDescrip = content;
                        newsDetail.imgUrl = imageUrl;
                        newsDetail.shareTitle = title;
                        [[[UIViewController currentVC] navigationController] pushViewController:newsDetail animated:YES];
                        
                    }else if([type isEqualToString:@"4"]){
                        ClassDetailViewController *classDetail = [[ClassDetailViewController alloc] init];
                        classDetail.detailUrl = detailUrl;
                        classDetail.viewsString = viewed;
                        [[[UIViewController currentVC] navigationController] pushViewController:classDetail animated:YES];
                    }
                    
                }else if([type isEqualToString:@"10"] || [type isEqualToString:@"11"]){
                    if ([currentVC isKindOfClass:[CKMyProductLibVC class]] || [currentVC isKindOfClass:[CKMyProductLibVCOld class]] || [currentVC isKindOfClass:[TopUpPayTypeViewController class]] ||
                        [currentVC isKindOfClass:[TopUpViewController class]] || [currentVC isKindOfClass:[CKCouponDetailViewController class]]) {
                        
                    }else{
                        //抵用券消息
                        [self enterProductLib];
                    }
                }else if([type isEqualToString:@"0"] || [type isEqualToString:@"1"] || [type isEqualToString:@"2"] || [type isEqualToString:@"5"] || [type isEqualToString:@"6"] || [type isEqualToString:@"7"]){

                }
            }
        }
    }
}

#pragma mark - 根据接受的消息跳转到指定VC
- (void)jumpToPointVC:(NSDictionary *)userInfo
{
    NSLog(@"杀死进程收到消息");
    
    NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
    NSString *type = [userInfo objectForKey:@"type"];
    
    NSMutableArray *sortIDArr = [NSMutableArray array];
    NSString *typecode = [userInfo objectForKey:@"typecode"];
    if (!IsNilOrNull(typecode)) {
        [sortIDArr addObject:typecode];
        [KUserdefaults setObject:sortIDArr forKey:@"CollegeClassPushIdArr"];
    }
    
    NSString *content = [apsDict objectForKey:@"alert"];//内容
    
    NSString *imageUrl = [userInfo objectForKey:@"imgurl"];
    NSString *detailUrl = [userInfo objectForKey:@"url"];
    NSString *viewed = [userInfo objectForKey:@"viewed"];
    NSString *title = [userInfo objectForKey:@"title"];
    
    NSString *showAlert  = nil;
    if (IsNilOrNull(title)) {
        showAlert = [NSString stringWithFormat:@"%@",content];
    }else{
        showAlert = [NSString stringWithFormat:@"%@:%@",title,content];
    }
    
    UIViewController *currentVC = [UIViewController currentVC];
    
    //如果是聊天页面 不弹窗
    if ([currentVC isKindOfClass:[ChatMessageViewController class]] || [currentVC isKindOfClass:[PTConversationViewController class]]) {
        
    }else{
        if ( ![self.isToothVc isEqualToString:@"YES"]) {
            // 2. 事件处理
            //弹出框
            self.messageByPushAler = [MessageAlert shareInstance];
            self.messageByPushAler.isDealInBlock = YES;
            //type:0:系统通知；1:顾客进店提醒；2：顾客下单通知
            
            if(IsNilOrNull(type)){
                [self.messageByPushAler hiddenCancelBtn:YES];
                [self.messageByPushAler showAlert:content btnClick:^{
                    
                }];
            }else{
                if ([type isEqualToString:@"3"] || [type isEqualToString:@"4"]){
                    if([type isEqualToString:@"3"]){//新闻
                        WebDetailViewController *newsDetail = [[WebDetailViewController alloc] init];
                        newsDetail.typeString = @"news";
                        newsDetail.detailUrl = detailUrl;
                        newsDetail.shareDescrip = content;
                        newsDetail.imgUrl = imageUrl;
                        newsDetail.shareTitle = title;
                        [[currentVC navigationController] pushViewController:newsDetail animated:YES];
                    }else{
                        ClassDetailViewController *classDetail = [[ClassDetailViewController alloc] init];
                        classDetail.detailUrl = detailUrl;
                        classDetail.viewsString = viewed;
                        [[currentVC navigationController] pushViewController:classDetail animated:YES];
                    }
                    
                }else if([type isEqualToString:@"0"] || [type isEqualToString:@"1"] || [type isEqualToString:@"2"] || [type isEqualToString:@"5"] || [type isEqualToString:@"6"] || [type isEqualToString:@"7"]){

                    
                }else if([type isEqualToString:@"10"] || [type isEqualToString:@"11"]){
                    if ([currentVC isKindOfClass:[CKMyProductLibVC class]] || [currentVC isKindOfClass:[CKMyProductLibVCOld class]] || [currentVC isKindOfClass:[TopUpPayTypeViewController class]] ||
                        [currentVC isKindOfClass:[TopUpViewController class]] || [currentVC isKindOfClass:[CKCouponDetailViewController class]]) {
                        
                    }else{
                        //抵用券消息
                        [self enterProductLib];
                    }
                   
                }
            }
        }
    }
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    
}

#pragma mark - 进入产品库
- (void)enterProductLib {
    
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if([homeLoginStatus isEqualToString:@"homelogin"]){
        UIViewController *currentVC = [UIViewController currentVC];
        NSString *monthcalmode = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_monthcalmode"]];
        //1：新的  0：老的
        if ([monthcalmode isEqualToString:@"1"]) {
            CKMyProductLibVC *pLibVC = [[CKMyProductLibVC alloc] init];
            [[currentVC navigationController] pushViewController:pLibVC animated:YES];
        }else{
            CKMyProductLibVCOld *pLibVC = [[CKMyProductLibVCOld alloc] init];
            [[currentVC navigationController] pushViewController:pLibVC animated:YES];
        }
    }
}

#pragma mark-获取订单和系统未读消息数量
-(void)getPushNotReadData{
    NSString *ckidStr = KCKidstring;
    if (IsNilOrNull(ckidStr)){
        ckidStr = @"";
    }
    
    NSDictionary *custParams = @{@"ckid":ckidStr,@"type":@"user"};
    NSString *custNotReadUrl = [NSString stringWithFormat:@"%@%@",PostMessageAPI, getNotReadMsgNum];
    
    [HttpTool postWithUrl:custNotReadUrl params:custParams success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            return ;
        }
        NSString *userStr = [NSString stringWithFormat:@"%@",dict[@"notreadnum"]];
        if (IsNilOrNull(userStr) || [userStr isEqualToString:@"0"]) {
            userStr = @"0";
        }
        
        [KUserdefaults setObject:userStr forKey:KCustomerNotReadNum];
        [KUserdefaults synchronize];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    NSDictionary *sysParams = @{@"ckid":ckidStr,@"type":@"system"};
    NSString *sysNotReadUrl = [NSString stringWithFormat:@"%@%@",PostMessageAPI, getNotReadMsgNum];
    
    
    [HttpTool postWithUrl:sysNotReadUrl params:sysParams success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            return ;
        }
        NSString *userStr = [NSString stringWithFormat:@"%@",dict[@"notreadnum"]];
        if (IsNilOrNull(userStr) || [userStr isEqualToString:@"0"]) {
            userStr = @"0";
        }
        [KUserdefaults setObject:userStr forKey:KSystemNotReadNum];
        [KUserdefaults synchronize];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}

#pragma mark 实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

/**
 *  发生错误
 *
 *  @param notification 通知
 */
- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo                       = [notification userInfo];
    NSString *error                              = [userInfo objectForKey:@"error"];
    NSLog(@"%@", error);
}

#pragma mark 用户是否关闭了推送
- (BOOL)isAllowedNotification {
    //iOS8 check if user allow notification
    CGFloat iOS = [[[UIDevice currentDevice]systemVersion] doubleValue];
    
    if(iOS>=8) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    }
    return NO;
}

//进入后台清零是因为如果在前台收到了消息，进入后台再推送消息不从零开始增加
-(void)applicationDidEnterBackground:(UIApplication *)application {
    [JPUSHService resetBadge];
}

// 点击之后badge清零
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [JPUSHService resetBadge];
    [application setApplicationIconBadgeNumber:0];
    [[UNUserNotificationCenter alloc] removeAllPendingNotificationRequests];
}

@end

