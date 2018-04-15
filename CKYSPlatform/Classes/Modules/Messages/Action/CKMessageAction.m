//
//  CKMessageAction.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKMessageAction.h"
#import "DNewsViewController.h"

@implementation CKMessageAction

-(UIViewController *)messageViewController {
    DNewsViewController *messageViewController = [[DNewsViewController alloc] init];
    return messageViewController;
}

@end
