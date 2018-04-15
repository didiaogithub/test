//
//  CKSmallTipModel.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/2.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKSmallTipModel.h"

@implementation CKSmallTipModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _classId = value;
    }
    [super setValue:value forKey:key];
}

@end
