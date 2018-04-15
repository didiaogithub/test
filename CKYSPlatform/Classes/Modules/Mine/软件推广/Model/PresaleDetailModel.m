//
//  PresaleDetailModel.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/1/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "PresaleDetailModel.h"

@implementation PresaleDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;;
    }
    [super setValue:value forKey:key];
}
+(PresaleDetailModel *)getPresaleDetailWithdictionary:(NSDictionary*)dict
{
    
    return [[self alloc] initPresaleDetailWithdictionary:dict];
    
}
-(instancetype)initPresaleDetailWithdictionary:(NSDictionary*)dict
{
    if (self=[super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
