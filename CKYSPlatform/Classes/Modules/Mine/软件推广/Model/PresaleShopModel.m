//
//  PresaleShopModel.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/1/18.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "PresaleShopModel.h"

@implementation PresaleShopModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+(PresaleShopModel *)getpreSaleModelWithDictionary:(NSDictionary *)dict{
    
    return [[self alloc]initWithPreSaleListDictionary:dict];
}
-(instancetype)initWithPreSaleListDictionary:(NSDictionary *)dict
{
    //初始化数组
    self.salelistArray=[[NSMutableArray alloc]init];
    
    //定义一个不可变数组接一下

    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
        //已出售  未出售 数组存在
        NSArray *saleListArr = dict[@"salelist"];
        if ([saleListArr count] > 0)
        {
            for (NSDictionary *detailDic in saleListArr)
            {
                self.saleDetailModel = [PresaleDetailModel getPresaleDetailWithdictionary:detailDic];
                [self.salelistArray addObject:self.saleDetailModel];
            }
        }

    }
    return self;
    
}
@end
