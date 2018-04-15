//
//  CKMainPageAction.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKMainPageAction : NSObject

-(nonnull UIViewController*)mainPageViewController;

-(nonnull UIViewController *)mainPageViewControllerDB:(nonnull NSDictionary<NSString*, id> *)parameters;

@end
