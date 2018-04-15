//
//  AppDelegate.m
//  CKYSPlatform
//
//  Created by ckys on 16/6/28.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "AppDelegate.h"
#import "CKVersionCheckManager.h"
#import "IntelligentTooth.h"
#import "WXApi.h"//微信SDK头文件
#import <AlipaySDK/AlipaySDK.h>//支付宝头文件
#import "PushManager.h"
#import "CKUncaughtExceptionHandle.h"
#import "CKJPushManager.h"
#import "UPPaymentControl.h"
#import "CacheManager.h"
#import "JDPAuthSDK.h"
//#import <Bugly/Bugly.h>
//#import "LocalPushManager.h"

@interface AppDelegate()<WXApiDelegate, UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

/**
 AppDelegate 类中的代码不允许存在除初始化UI以外的代码 或者 自定义Property，只能有调用代码。（如 支付回调、分享回调、推送等请在其他类中完成，只在此处调用）
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    if ([self isFirstLoadCurrentVersion]) {
        [[CacheManager shareInstance] cleanUserDefaultCache];
        [[CacheManager shareInstance] cleanLoginStatusData];
    }
    
    [[DefaultValue shareInstance] defaultValue];
    
    [RequestManager manager];
    
    [self initKeyWindow];
    
    
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        //不会上下滚动,具体哪个页面如果需要自动调节，设置
//        tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;

    }
    
    
    [CKUncaughtExceptionHandle setDefaultHandler];
    // 发送崩溃日志
    [CKUncaughtExceptionHandle sendExceptionLog];
    //腾讯bugly上报（不用bugly，打包时候太慢，用极光的错误统计）
    //[Bugly startWithAppId:@"c98e637bc7"];
    
    [[JDPAuthSDK sharedJDPay] registServiceWithAppID:JDAPPID merchantID:JDMerchantID];
    
    [self updaloadCurrentVersion];
    //键盘处理
    [self configKeyboard];
    //分享
    [CKShareManager manager];
    //极光推送
    [[CKJPushManager manager] registerJPushWithapplication:application didFinishLaunchingWithOptions:launchOptions];

    //微信授权处理
    [self weixinAuthoize];
    //融云通讯处理
    [RCloudManager manager];
    //启动智齿客服
    [[IntelligentTooth shareInstance] wisdomToothWith:application];
    //数据库配置
    [CacheData shareInstance];
    //检查更新
    [[CKVersionCheckManager shareInstance] checkVersion];
    
    [[PushManager manager] registerUserNotification:application didFinishLaunchingWithOptions:launchOptions];
    //本地通知
//    [LocalPushManager openLocalNotification];
    
    return YES;
}

-(BOOL)isFirstLoadCurrentVersion {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *lastVersion = [KUserdefaults objectForKey:CKLastVersionKey];
    
    if (!lastVersion) {
        [KUserdefaults setObject:currentVersion forKey:CKLastVersionKey];
        return YES;
    }else if (![lastVersion isEqualToString:currentVersion]) {
        [KUserdefaults setObject:currentVersion forKey:CKLastVersionKey];
        return YES;
    }
    return NO;
}

#pragma mark - 上传当前版本号
-(void)updaloadCurrentVersion {
    
    NSString *uploadStatus = [KUserdefaults objectForKey:@"CKYSUploadVersionSucc"];
    if (IsNilOrNull(uploadStatus) || [uploadStatus isEqualToString:@"Failure"]) {
        NSString *ckidStr = KCKidstring;
        
        if (!IsNilOrNull(ckidStr)) {
            NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
            NSString *mobile = [KUserdefaults objectForKey:Kmobile];
            if (IsNilOrNull(mobile)) {
                mobile = @"";
            }
            NSString *uuid = DeviceId_UUID_Value;
            if (IsNilOrNull(uuid)){
                uuid = @"";
            }
            
            NSDictionary *appDic = [[NSBundle mainBundle] infoDictionary];
            NSString *version = [appDic objectForKey:@"CFBundleShortVersionString"];
            NSString *devicetype = [NSString stringWithFormat:@"ios%@", version];
            
            [parmas setValue:mobile forKey:@"mobile"];
            [parmas setValue:ckidStr forKey:@"ckid"];
            [parmas setValue:uuid forKey:@"deviceid"];
            [parmas setValue:devicetype forKey:@"devicetype"];
            
            NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AppConfirmVersion];
            [HttpTool postWithUrl:requestUrl params:parmas success:^(id json) {
                NSDictionary *dict = json;
                NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
                if (![code isEqualToString:@"200"]) {
                    [KUserdefaults setObject:@"Failure" forKey:@"CKYSUploadVersionSucc"];
                    return ;
                }
                [KUserdefaults removeObjectForKey:@"CKYSUploadVersionSucc"];
            } failure:^(NSError *error) {
                [KUserdefaults setObject:@"Failure" forKey:@"CKYSUploadVersionSucc"];
            }];
        }
    }
    
    //请求域名
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{DeviceId:uuid};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getSomePath_Url];
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if ([code isEqualToString:@"200"]) {
            //月结显示模式
            NSString *monthcalmode = [NSString stringWithFormat:@"%@", dict[@"monthcalmode"]];
            if (IsNilOrNull(monthcalmode)) {
                monthcalmode = @"";
            }
            [KUserdefaults setObject:monthcalmode forKey:@"CKYS_monthcalmode"];
            
            NSString *payalertmsg = [NSString stringWithFormat:@"%@", dict[@"payalertmsg"]];
            if (IsNilOrNull(payalertmsg)) {
                payalertmsg = @"";
            }
            [KUserdefaults setObject:payalertmsg forKey:@"payalertmsg"];
            
            NSString *ckappverinfo = [dict objectForKey:@"ckappverinfo"];
            if (!IsNilOrNull(ckappverinfo)) {
                [KUserdefaults setObject:ckappverinfo forKey:@"CKYS_updateInfo"];
            }
            //ckappcoupon  我的优惠券 显示开关  1：开启   其它： 关闭
            NSString *ckappcoupon = [dict objectForKey:@"ckappcoupon"];
            if (!IsNilOrNull(ckappcoupon)) {
                [KUserdefaults setObject:ckappcoupon forKey:@"CKYS_ckappcoupon"];
            }
            //ckappgift  考试显示开关：  1：开启   其它：关闭
            NSString *ckappgift = [dict objectForKey:@"ckappgift"];
            if (!IsNilOrNull(ckappgift)) {
                [KUserdefaults setObject:ckappgift forKey:@"CKYS_ckappgift"];
            }
            
            // ckappleader 我的管理者显示开关 ：显示开关 1：开启 其他：关闭
            NSString *ckappleader = [dict objectForKey:@"ckappleader"];
            if (!IsNilOrNull(ckappleader)) {
                [KUserdefaults setObject:ckappleader forKey:@"CKYS_ckappleader"];
            }
            
            [KUserdefaults synchronize];
            
            [self updateDomain:dict];
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 更新域名
-(void)updateDomain:(NSDictionary*)dict {
    
    NSString *baseImagestr = [NSString stringWithFormat:@"%@", [dict objectForKey:@"appregeturl"]];
    if (!IsNilOrNull(baseImagestr)) {
        if (![baseImagestr hasSuffix:@"/"]) {
            baseImagestr = [baseImagestr stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:baseImagestr forKey:@"domainImgRegetUrl"];
    }
    
    NSString *domainNameRes = [NSString stringWithFormat:@"%@", [dict objectForKey:@"appreupurl"]];
    if (!IsNilOrNull(domainNameRes)) {
        if (![domainNameRes hasSuffix:@"/"]) {
            domainNameRes = [domainNameRes stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNameRes forKey:@"domainNameRes"];
    }
    
    NSString *domainNamePay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"apppayurl"]];
    if (!IsNilOrNull(domainNamePay)) {
        if (![domainNamePay hasSuffix:@"/"]) {
            domainNamePay = [domainNamePay stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNamePay forKey:@"domainNamePay"];
    }
    
    NSString *domainSmsMessage = [NSString stringWithFormat:@"%@", [dict objectForKey:@"appmsgurl"]];
    if (!IsNilOrNull(domainSmsMessage)) {
        if (![domainSmsMessage hasSuffix:@"/"]) {
            domainSmsMessage = [domainSmsMessage stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainSmsMessage forKey:@"domainSmsMessage"];
    }
    
    NSString *domainNameUnionPay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"appunionpayurl"]];
    if (!IsNilOrNull(domainNameUnionPay)) {
        if (![domainNameUnionPay hasSuffix:@"/"]) {
            domainNameUnionPay = [domainNameUnionPay stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNameUnionPay forKey:@"domainNameUnionPay"];
    }
}

-(void)initKeyWindow {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    RootTabBarController *root = [[RootTabBarController alloc] init];
    self.window.rootViewController = root;
    [self.window makeKeyAndVisible];
#warning if has welcome page pls import #import "WelcomeViewController.h"
    //如果有欢迎页在下面添加方法
}

-(void)weixinAuthoize {
    [WXApi registerApp:kWXAPP_ID];
}

//授权后回调 WXApiDelegate
//如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
-(void)onResp:(BaseResp *)resp {
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    //微信授权回调处理
    if ([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            [CKCNotificationCenter postNotificationName:@"cancel" object:@(aresp.errCode)];
            [self getWeiCodefinishedWhth:resp];
            
        }
    }
    //    WXSuccess           = 0,    /**< 成功    */
    //    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
    //    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    //    WXErrCodeSentFail   = -3,   /**< 发送失败    */
    //    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
    //    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
    
    //微信支付回调 处理
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        [CKCNotificationCenter postNotificationName:WeiXinPay_CallBack object:@(response.errCode)];
    }
}
#pragma mark-通过第一步code获取Accesontoken
-(void)getWeiCodefinishedWhth:(BaseResp *)req
{
    if (req.errCode==0) {
        NSLog(@"用户同意");
        //到绑定手机号
        SendAuthResp *aresp=(SendAuthResp *)req;
        NSLog(@"state=====%@",aresp.state);
        [self getAccessTokenWithCode:aresp.code andStateStr:aresp.state];
    }else if (req.errCode==-4)
    {
        NSLog(@"用户拒绝");
        //[LCProgressHUD showInfoMsg:@"登录失败"];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        [CKCNotificationCenter postNotificationName:@"WeChatAuthFailureNoti" object:nil];

    }
    else if (req.errCode==-2)
    {
        NSLog(@"用户取消");
        //[LCProgressHUD showInfoMsg:@"登录失败"];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        
        [CKCNotificationCenter postNotificationName:@"WeChatAuthFailureNoti" object:nil];
    }
}

-(void)getAccessTokenWithCode:(NSString *)code andStateStr:(NSString *)stateStr {
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,code];
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"微信的返回%@",dict);
                if ([dict objectForKey:@"errcode"]){
                    //获取token错误
                }else{
                    NSLog(@"%@",dict);
                    NSLog(@"unionid===%@",dict[@"unionid"]);
                    NSLog(@"openid=====%@",dict[@"openid"]);
                    NSLog(@" RefreshToken===%@",dict[@"refresh_token"]);
                    
                    //openid
                    NSString *openid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"openid"]];
                    if (IsNilOrNull(openid)){
                        openid = @"";
                    }
                    [KUserdefaults setObject:openid forKey:KopenID];
                    
                    NSString *unionid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"unionid"]];
                    if (IsNilOrNull(unionid)){
                        unionid = @"";
                    }
                    [KUserdefaults setObject:unionid forKey:Kunionid];
                    
                    
                    //刷新的token
                    NSString *refresh_token = [NSString stringWithFormat:@"%@",dict[@"refresh_token"]];
                    if (IsNilOrNull(refresh_token)){
                        refresh_token = @"";
                    }
                    
                    //请求的token
                    NSString *access_token = [NSString stringWithFormat:@"%@",dict[@"access_token"]];
                    if (IsNilOrNull(access_token)){
                        access_token = @"";
                    }
                    
                    //token过期时间
                    NSString *expires_in = [NSString stringWithFormat:@"%@",dict[@"expires_in"]];
                    if (IsNilOrNull(expires_in)){
                        expires_in = @"";
                    }
                    //存储AccessToken OpenId RefreshToken以便下次直接登陆
                    //AccessToken有效期两小时，RefreshToken有效期三十天
                    NSDate *oldDate = [NSDate date];    //获取AccessToken RefreshToken的一致时间
                    NSLog(@" oldDate =======%@ ",oldDate);
                    [KUserdefaults setObject:oldDate forKey:KolderData];
                    [KUserdefaults setObject:refresh_token forKey:kWeiXinRefreshToken];
                    
                    [KUserdefaults setObject:access_token forKey:KAccsess_token];
                    
                    [KUserdefaults setObject:expires_in forKey:KExpires_in];
                    
                    [KUserdefaults synchronize];
                    [self getUserInfoWithAccessToken:access_token andOpenId:openid andStateStr:stateStr];
                }
            }
        });
    });
}



#pragma mark - 获取用户的信息
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId andStateStr:(NSString *)stateStr
{

    NSLog(@"openId%@",openId);
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", accessToken, openId];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0 ), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    NSString *refresh_token = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:kWeiXinRefreshToken]];
                    if (IsNilOrNull(refresh_token)){
                        refresh_token = @"";
                    }
                    //AccessToken失效
                    [self getAccessTokenWithRefreshToken:refresh_token];
                }else{
                    //获取需要的数据
                    NSLog(@"获取的用户信息%@",dict);
                    
                    [KUserdefaults setObject:dict[@"nickname"] forKey:KnickName];
                    [KUserdefaults setObject:dict[@"headimgurl"] forKey:kheamImageurl];
                    [KUserdefaults synchronize];
                    //  NSString *nowdaTa=  [self dateNow];
                    //发送给服务器的时间
                    //  NSString *shijianca=[KUserdefaults objectForKey:KtimeCha];
                    //   NSInteger time=[nowdaTa integerValue]+[shijianca integerValue];
                    //授权成功之后，给服务器发送openid和uniond 获取ckid openid uniond
                    //授权后跳转
                    [CKCNotificationCenter postNotificationName:WeiXinAuthSuccess object:nil];
                }
            }
        });
    });
}


//重新获取AccessToken
- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",kWXAPP_ID,refreshToken];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"])
                {
                    //授权过期
                }else
                {
                    //重新使用AccessToken获取信息
                    NSLog(@"重新使用AccessToken获取信息%@",dict);
                }
            }
        });
    });
}
/**application openURL options方法*/
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    NSString *urlStr = url.absoluteString;
    if ([urlStr containsString:@"oauth"]) {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([urlStr containsString:@"jdpauth"]) {
        return [[JDPAuthSDK sharedJDPay] handleOpenURL:url];
    }
    
    if (self.paymentType == 1) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if(self.paymentType == 2){
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [CKCNotificationCenter postNotificationName:Alipay_CallBack object:self userInfo:resultDic];
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }
        return YES;
    }else if(self.paymentType == 3){
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            [CKCNotificationCenter postNotificationName:UnionPay_CallBack object:code userInfo:data];
            
            if([code isEqualToString:@"success"]){
                NSLog(@"银联支付成功");
                
            }else if([code isEqualToString:@"fail"]) { //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成
                NSLog(@"银联支付失败");
            }else if([code isEqualToString:@"cancel"]) {
                NSLog(@"银联取消支付");
            }
        }];
        return YES;
    }
    return NO;
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSString *urlStr = url.absoluteString;
    if ([urlStr containsString:@"oauth"]) {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([urlStr containsString:@"jdpay"]) {
        return [[JDPAuthSDK sharedJDPay] handleOpenURL:url];
    }
    
    
    
    if (self.paymentType == 1) { //微信支付
        return [WXApi handleOpenURL:url delegate:self];
    }else if(self.paymentType == 2){
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [CKCNotificationCenter postNotificationName:Alipay_CallBack object:self userInfo:resultDic];
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }
        
        return YES;
    }else if(self.paymentType == 3){
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            [CKCNotificationCenter postNotificationName:UnionPay_CallBack object:code userInfo:data];
            
            if([code isEqualToString:@"success"]){
                NSLog(@"银联支付成功");
                
            }else if([code isEqualToString:@"fail"]) { //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成
                NSLog(@"银联支付失败");
            }else if([code isEqualToString:@"cancel"]) {
                NSLog(@"银联取消支付");
            }
        }];
        return YES;
    }
    return NO;
}

/* -------------- 键盘管理 -------------*/
-(void)configKeyboard{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用。
    manager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    manager.toolbarManageBehaviour = IQAutoToolbarByTag; // 最新版的设置键盘的returnKey的关键字 ,可以点击键盘上的next键，自动跳转到下一个输入框，最后一个输入框点击完成，自动收起键盘。
}

+(AppDelegate* )shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

//- (void)applicationDidEnterBackground:(UIApplication *)application {
//
//    NSInteger unreadcount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
//    [UIApplication sharedApplication].applicationIconBadgeNumber  = (int)unreadcount;
//}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

-(void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[CKJPushManager manager] applicationDidEnterBackground:application];
}

-(void)applicationWillEnterForeground:(UIApplication *)application {
    [[CKJPushManager manager] applicationWillEnterForeground:application];
    [[CKVersionCheckManager shareInstance] showForceUpdate];
}

-(void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
//    [LocalPushManager application:application didReceiveLocalNotification:notification];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[CKJPushManager manager] application:application didRegisterUserNotificationSettings:notificationSettings];
}

//收到推送消息 基于iOS 7 及以上的系统版本
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[CKJPushManager manager] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    [[PushManager manager] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[CKJPushManager manager] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    [[PushManager manager] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    [[RCloudManager manager] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[CKJPushManager manager] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    [[PushManager manager] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[PushManager manager] application:application didReceiveRemoteNotification:userInfo];
}

@end

