//
//  CKMainPageAction.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKMainPageAction.h"
#import "DHomepageViewController.h"

@implementation CKMainPageAction

-(nonnull UIViewController*)mainPageViewController {
    DHomepageViewController *mainPageViewController = [[DHomepageViewController alloc] init];
    return mainPageViewController;
}

-(nonnull UIViewController *)mainPageViewControllerDB:(nonnull NSDictionary<NSString*, id> *)parameters {
    DHomepageViewController *home = [[DHomepageViewController alloc]init];
    home.CKID = parameters[@"CKID"];
    home.pushDic = parameters[@"pushDic"];
    return home;
}

@end
