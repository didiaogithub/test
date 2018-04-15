//
//  TakeCashRecordModel.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/5/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "TakeCashRecordModel.h"

@implementation TakeCashRecordModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(TakeCashRecordModel *)getRecordModelWithDictionary:(NSDictionary *)dict{
    
    return [[self alloc]initWithListDictionary:dict];
}

-(instancetype)initWithListDictionary:(NSDictionary *)dict
{
    //初始化数组
    self.detailArray=[[NSMutableArray alloc]init];
    
    if (self = [super init]){
        //定义一个不可变数组接一下
        [self setValuesForKeysWithDictionary:dict];
        //如果数组存在
        NSArray *topListmodels = dict[@"records"];
        if ([topListmodels count]>0)
        {
            for (NSDictionary *detailDic in topListmodels)
            {
                self.recordDetailModel = [TakeCashRecordDetailModel getDetailWithdictionary:detailDic];
                [self.detailArray addObject:self.recordDetailModel];
                
            }
        }
    }
    return self;
    
}

@end
