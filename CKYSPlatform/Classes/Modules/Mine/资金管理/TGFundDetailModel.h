//
//  TGFundDetailModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/1/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGFundDetailModel : NSObject
/**订单id*/
@property(nonatomic,copy)NSString *oid;
/** 商品id*/
@property(nonatomic,copy)NSString *itemid;
/**名称*/
@property(nonatomic,copy)NSString *name;
/**数量*/
@property(nonatomic,copy)NSString *count;
/**价格*/
@property(nonatomic,copy)NSString *price;
/**路径*/
@property(nonatomic,copy)NSString *url;


+(TGFundDetailModel *)getTgFundDetailWithdictionary:(NSDictionary*)dict;
@end
