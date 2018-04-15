//
//  Mediator+CKOrder.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "Mediator+CKOrder.h"
#import "CKOrderAction.h"

NSString *const CKOrderTarget = @"CKOrderAction";
NSString *const CKOrderActionOrderViewController = @"orderViewController";

@implementation Mediator (CKOrder)

-(UIViewController*)ckOrderViewController {
    MediatorOptions *options = [MediatorOptions optionsWithTargetName:CKOrderTarget actionName:CKOrderActionOrderViewController];
    return [self performWithOptions:options];
}

@end
