//
//  IntelligentTooth.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "IntelligentTooth.h"
#import <SobotKit/SobotKit.h>
#import <UserNotifications/UserNotifications.h>

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface IntelligentTooth()<UNUserNotificationCenterDelegate>

@end


@implementation IntelligentTooth

-(instancetype)initPrivate {
    if (self = [super init]) {

    }
    return self;
}

+(instancetype)shareInstance {
    static IntelligentTooth *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[IntelligentTooth alloc] initPrivate];
    });
    return instance;
}

-(void)wisdomToothWith:(UIApplication *)application {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert |UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];
    }else{
        [self registerPush:application];
    }
    // **** 设置推送是否是测试环境 ******
    [[ZCLibClient getZCLibClient] setIsDebugMode:YES];
    // 获取APPKEY
    [[ZCLibClient getZCLibClient].libInitInfo setAppKey:WisdomTooth_AppKey];
    
    [self startToochWisdom];
}

-(void)registerPush:(UIApplication *)application{
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        
        [application registerUserNotificationSettings:notiSettings];
    }
}


-(void)startToochWisdom{
    // 启动
    ZCLibInitInfo *initInfo = [ZCLibInitInfo new];
    // 企业编号 必填
    initInfo.appKey = WisdomTooth_AppKey;
    // 用户id，用于标识用户，建议填写
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if([homeLoginStatus isEqualToString:@"homelogin"]){
        NSString *mobile = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Kmobile]];
        if (!IsNilOrNull(mobile)) {
            initInfo.userId = [NSString stringWithFormat:@"创客APP%@", mobile];
        }
    }else{
        NSString *unionid = [KUserdefaults objectForKey:Kunionid];
        if (!IsNilOrNull(unionid)) {
            initInfo.userId = [NSString stringWithFormat:@"创客APP%@", unionid];
        }
    }
    
    //    初始化智齿客服，会建立长连接通道，监听服务端消息（建议启动应用时调用，没有发起过咨询不会浪费资源，至少转一次人工才有效果）
    [[ZCLibClient getZCLibClient] initZCIMCaht];
    
    //     ReceivedMessageBlock 未读消息数， obj 当前消息  unRead 未读消息数
    [ZCLibClient getZCLibClient].receivedBlock=^(id obj,int unRead){
        NSLog(@"未读消息数量：\n%d,%@",unRead,obj);
    };
    
    //   是否自动提醒
    [[ZCLibClient getZCLibClient] setAutoNotification:YES];
    
    //   设置推送环境  测试模式， 根据此设置调用的推送证书，默认NO  NO ,调用生产环境    YES，测试环境
    
    [[ZCLibClient getZCLibClient] setIsDebugMode:YES];
    
    
    //     关闭推送
    [[ZCLibClient getZCLibClient] removePush:^(NSString *uid, NSData *token, NSError *error) {
        if((uid==nil &&  token==nil) || error!=nil){
            // 移除失败，可设置uid或token(uid可不设置)后再调用
            
        }else{
            // 移除成功
            
        }
    }];
    
    
    //     closeAndoutZCServer 关闭通道，清理内存，退出智齿客服（调用此方法后将不能接收到离线消息，除非再次进入智齿SDK重新激活）
    //      [ZCLibClient  closeAndoutZCServer];
    
    
}

@end
