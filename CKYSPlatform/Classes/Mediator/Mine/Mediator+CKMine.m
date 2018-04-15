//
//  Mediator+CKMine.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "Mediator+CKMine.h"
#import "CKMineAction.h"

NSString *const CKMineTarget = @"CKMineAction";
NSString *const CKMineActionMineViewController = @"mineViewController";

@implementation Mediator (CKMine)

-(UIViewController*)ckMineViewController {
    MediatorOptions *options = [MediatorOptions optionsWithTargetName:CKMineTarget actionName:CKMineActionMineViewController];
    return [self performWithOptions:options];
}

@end
