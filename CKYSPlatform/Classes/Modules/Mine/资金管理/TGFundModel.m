//
//  TGFundModel.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/1/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "TGFundModel.h"

@implementation TGFundModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+(TGFundModel *)getTgFundModelWithDictionary:(NSDictionary *)dict{
    
    return [[self alloc]initWithTgFundListDictionary:dict];
}
-(instancetype)initWithTgFundListDictionary:(NSDictionary *)dict
{
    //初始化数组
    self.tgDetailArray=[[NSMutableArray alloc]init];
    
    //定义一个不可变数组接一下
    
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
        //如果数组存在
        NSArray *topListmodels = dict[@"ordersheet"];
        if ([topListmodels count]>0)
        {
            for (NSDictionary *detailDic in topListmodels)
            {
                self.tgDetailModel = [TGFundDetailModel getTgFundDetailWithdictionary:detailDic];
                [self.tgDetailArray addObject:self.tgDetailModel];
                
            }
        }
    }
    return self;
    
}
@end
