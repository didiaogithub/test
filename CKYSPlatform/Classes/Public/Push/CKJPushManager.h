//
//  CKJPushManager.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/31.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface CKJPushManager : NSObject <UNUserNotificationCenterDelegate, JPUSHRegisterDelegate>

@property (nonatomic, strong) MessageAlert *messageByPushAler;
@property (nonatomic, copy)   NSString *isToothVc;


+(instancetype)manager;

/**
 *  用户是否关闭了推送
 */
- (BOOL)isAllowedNotification;

/**
 *  注册极光推送
 */
- (void)registerJPushWithapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

-(void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

//收到推送消息 基于iOS 7 及以上的系统版本
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

//进入后台清零是因为如果在前台收到了消息，进入后台再推送消息不从零开始增加
-(void)applicationDidEnterBackground:(UIApplication *)application;

// 点击之后badge清零
- (void)applicationWillEnterForeground:(UIApplication *)application;

@end
