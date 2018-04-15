//
//  TGFundModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/1/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGFundDetailModel.h"
@interface TGFundModel : NSObject

/**订单id*/
@property(nonatomic,copy)NSString *oid;
/**订单号*/
@property(nonatomic,copy)NSString *no;
/**订单状态 订单状态（99：全部 1：未付款；2：已付款；4：正在退货，5：退货成功，7：已发货 ）*/
@property(nonatomic,copy)NSString *orderstatus;
/**订单 明细*/
@property(nonatomic,copy)NSString *ordersheet;
/**下单时间*/
@property(nonatomic,copy)NSString *time;
/**总金额*/
@property(nonatomic,copy)NSString *money;

@property(nonatomic,strong)TGFundDetailModel *tgDetailModel;
@property(nonatomic,strong)NSMutableArray *tgDetailArray;
+(TGFundModel *)getTgFundModelWithDictionary:(NSDictionary *)dict;

@end
