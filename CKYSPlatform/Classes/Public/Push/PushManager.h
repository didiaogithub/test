//
//  PushManager.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushManager : NSObject

/**
 *  获取推送实例
 */
+(instancetype)manager;

/** 注册用户通知(推送) */
-(void)registerUserNotification:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/** 远程通知注册成功委托 */
-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;

/** 远程通知注册失败委托 */
-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error;

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
-(void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo;

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

/** 更新域名 */
-(void)updateDomain:(NSDictionary*)dict;
/** 更新支付方式 */
-(void)updatePaymentMethod:(NSDictionary*)dict;

@end
