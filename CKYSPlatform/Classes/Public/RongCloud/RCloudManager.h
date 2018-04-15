//
//  RCloudManager.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h> //融云
@interface RCloudManager : NSObject

+(instancetype)manager;

-(void)logout;
-(RCConnectionStatus)getConnectState;
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

@end
