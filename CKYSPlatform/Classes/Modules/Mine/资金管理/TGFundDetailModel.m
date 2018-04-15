//
//  TGFundDetailModel.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/1/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "TGFundDetailModel.h"

@implementation TGFundDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+(TGFundDetailModel *)getTgFundDetailWithdictionary:(NSDictionary*)dict
{
    return [[self alloc] initTgFundDetailWithdictionary:dict];
    
}
-(instancetype)initTgFundDetailWithdictionary:(NSDictionary*)dict
{
    if (self=[super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
