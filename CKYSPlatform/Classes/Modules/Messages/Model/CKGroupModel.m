//
//  CKGroupModel.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/17.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKGroupModel.h"

@implementation CKGroupModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
};

+(NSString*)primaryKey {
    return @"groupidKey";
}

@end

@implementation CKGroupInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
};

+(NSString*)primaryKey {
    return @"meid";
}

@end
