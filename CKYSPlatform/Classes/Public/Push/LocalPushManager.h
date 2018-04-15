//
//  LocalPushManager.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/15.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalPushManager : NSObject

//APP本地推送（通知）    非前台状态进行本地推送
+ (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

//开启本地推送
+ (void)openLocalNotification;
//关闭本地通知
+ (void)closeLocalNotification;
//是否开启本地通知
+ (BOOL)isOpenLocalNotification;

@end
