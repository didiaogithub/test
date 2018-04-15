//
//  CKProductLibModel.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKProductLibModel.h"

@implementation CKProductLibModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;;
    }
    [super setValue:value forKey:key];
}

@end
