//
//  Mediator+CKMainPage.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "Mediator+CKMainPage.h"
#import "CKMainPageAction.h"

NSString *const CKMainPageTarget = @"CKMainPageAction";
NSString *const CKMainPageActionViewController = @"mainPageViewController";
NSString *const CKMainPageActionViewControllerDB = @"mainPageViewControllerDB";


@implementation Mediator (CKMainPage)

-(UIViewController*)ckMainPageViewController {
    MediatorOptions *options = [MediatorOptions optionsWithTargetName:CKMainPageTarget actionName:CKMainPageActionViewController];
    return [self performWithOptions:options];
}

-(UIViewController*)ckWriteMainPageDataToDB:(NSDictionary*)dict ckid:(NSString*)ckid {
    MediatorOptions *options = [MediatorOptions optionsWithTargetName:CKMainPageTarget actionName:CKMainPageActionViewControllerDB];
    options.parameters = @{@"pushDic":dict, @"CKID": ckid};
    return [self performWithOptions:options];
}

@end
