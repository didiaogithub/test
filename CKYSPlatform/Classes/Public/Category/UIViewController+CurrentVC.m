//
//  UIViewController+CurrentVC.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 17/7/20.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "UIViewController+CurrentVC.h"

@implementation UIViewController (CurrentVC)
+(UIViewController *)currentVC
{
    UIViewController * currVC = nil;
    UIViewController * Rootvc = [UIApplication sharedApplication].keyWindow.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[RootTabBarController class]]){
            RootTabBarController * tabVC = (RootTabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        } else {
            currVC = Rootvc;
            Rootvc = nil;
        }
    } while (Rootvc!=nil);
    return currVC;
}
@end
