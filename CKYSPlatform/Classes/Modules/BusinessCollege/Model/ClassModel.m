//
//  ClassModel.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "ClassModel.h"

@implementation lessonType

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _sortID = value;
    }
    [super setValue:value forKey:key];
}

+(NSString*)primaryKey {
    return @"sortID";
}

@end

@implementation ClassTitleModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSString*)primaryKey {
    return @"ckid";
}

@end


@implementation ClassModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _classId = value;
    }
    [super setValue:value forKey:key];
}

+(NSString*)primaryKey {
    return @"classId";
}

@end
