//
//  MessageModel.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/23.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;;
    }
    [super setValue:value forKey:key];
}

+(NSString*)primaryKey {
    return @"meid";
}

@end
