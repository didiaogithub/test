//
//  PresaleShopModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/1/18.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PresaleDetailModel.h"
@interface PresaleShopModel : NSObject
/**预售店投资时间*/
@property(nonatomic,copy)NSString *saletime;
/**预售店回收时间（已开通数>0时，不显示）*/
@property(nonatomic,copy)NSString *days;


/**这一组总数*/
@property(nonatomic,copy)NSString *allcount;
/**已开通店铺数*/
@property(nonatomic,copy)NSString *opencount;
/**回收字段 已回收数量*/
@property(nonatomic,copy)NSString *recycle;


/**已出售店铺 详情数组*/
@property(nonatomic,strong)NSMutableArray *salelistArray;
@property(nonatomic,strong)PresaleDetailModel *saleDetailModel;
+(PresaleShopModel *)getpreSaleModelWithDictionary:(NSDictionary *)dict;


           



@end
