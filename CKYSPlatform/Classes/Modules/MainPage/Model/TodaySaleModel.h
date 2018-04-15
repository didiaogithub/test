//
//  TodaySaleModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodaySaleModel : NSObject
/**实销收入*/
@property(nonatomic,strong)NSString *moneytotal;
/**销售金额*/
@property(nonatomic,strong)NSString *moneysales;
/**退货金额*/
@property(nonatomic,strong)NSString *moneyorderback;
/**实销收入*/
@property(nonatomic,strong)NSString *totalNum;

/**我的业绩*/
@property(nonatomic,strong)NSString *myperf;
/**进货总计*/
@property(nonatomic,strong)NSString *jhperf;
/**推广总计*/
@property(nonatomic,strong)NSString *zsperf;
/**总记录条数*/
@property(nonatomic,strong)NSString *recordssize;


@end
