//
//  CKOrderAction.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKOrderAction.h"
#import "CKOrderViewController.h"

@implementation CKOrderAction

-(nonnull UIViewController*)orderViewController {
    CKOrderViewController *orderViewController = [[CKOrderViewController alloc] init];
    return orderViewController;
}

@end
