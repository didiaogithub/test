//
//  Mediator+CKMessage.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "Mediator+CKMessage.h"
#import "CKMessageAction.h"

NSString *const CKMessageTarget = @"CKMessageAction";
NSString *const CKMessageActionMessageViewController = @"messageViewController";

@implementation Mediator (CKMessage)

-(UIViewController*)ckMessageViewController {
    MediatorOptions *options = [MediatorOptions optionsWithTargetName:CKMessageTarget actionName:CKMessageActionMessageViewController];
    return [self performWithOptions:options];
}

@end
