//
//  AppDelegate.h
//  CKYSPlatform
//
//  Created by ckys on 16/6/28.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageAlert.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) NSInteger paymentType;
@property (nonatomic, strong) MessageAlert *messageByPushAler;
@property (nonatomic, copy)   NSString *isToothVc;

+(AppDelegate* )shareAppDelegate;

@end

