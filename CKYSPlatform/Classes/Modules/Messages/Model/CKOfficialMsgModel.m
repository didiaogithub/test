//
//  CKOfficialMsgModel.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKOfficialMsgModel.h"

//@implementation CKOfficialMsgModel
//
//-(void)setValue:(id)value forKey:(NSString *)key{
//    if ([key isEqualToString:@"id"]) {
//        _ID = value;;
//    }
//    [super setValue:value forKey:key];
//}
//
//
//@end

@implementation CKOfficialMsgModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;;
    }
    [super setValue:value forKey:key];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSString*)primaryKey {
    return @"ID";
}

@end
