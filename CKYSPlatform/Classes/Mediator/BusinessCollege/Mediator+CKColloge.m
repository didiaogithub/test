//
//  Mediator+CKColloge.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/5/31.
//  Copyright © 2017年 ForgetFairy. All rights reserved.
//

#import "Mediator+CKColloge.h"
#import "CKCollegeAction.h"

NSString *const CKCollegeTarget = @"CKCollegeAction";
NSString *const CKCollegeActionCollegeViewController = @"collegeViewController";

@implementation Mediator (CKColloge)

-(UIViewController*)ckCollegeViewController {
    MediatorOptions *options = [MediatorOptions optionsWithTargetName:CKCollegeTarget actionName:CKCollegeActionCollegeViewController];
    return [self performWithOptions:options];
}

@end
