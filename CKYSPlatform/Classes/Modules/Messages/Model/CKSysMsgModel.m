//
//  CKSysMsgModel.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKSysMsgModel.h"

@implementation CKSysMsgModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
    [super setValue:value forKey:key];
}

+(NSString*)primaryKey {
    return @"type_id";
}

@end


@implementation CKSysMsgListModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSString*)primaryKey {
    return @"type";
}

@end
