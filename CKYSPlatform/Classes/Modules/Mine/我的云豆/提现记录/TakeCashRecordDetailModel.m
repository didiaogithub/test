//
//  TakeCashRecordDetailModel.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/5/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "TakeCashRecordDetailModel.h"

@implementation TakeCashRecordDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+(TakeCashRecordDetailModel *)getDetailWithdictionary:(NSDictionary*)dict
{
    
    return [[self alloc]initDetailWithdictionary:dict];
    
}
-(instancetype)initDetailWithdictionary:(NSDictionary*)dict
{
    if (self=[super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
