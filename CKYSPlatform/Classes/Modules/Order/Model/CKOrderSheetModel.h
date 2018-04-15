//
//  CKOrderSheetModel.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/19.
//  Copyright © 2018年 ckys. All rights reserved.
//
//  订单商品model
#import "BaseEncodeModel.h"

@interface CKOrderSheetModel : BaseEncodeModel

/**订单id*/
@property (nonatomic, copy) NSString *oid;
/**商品id*/
@property (nonatomic, copy) NSString *itemid;
/**名称*/
@property (nonatomic, copy) NSString *name;
/**数量*/
@property (nonatomic, copy) NSString *count;
/**价格*/
@property (nonatomic, copy) NSString *price;
/**商品图片地址*/
@property (nonatomic, copy) NSString *url;
/**规格*/
@property (nonatomic, copy) NSString *spec;
/**0：非海外购订单 1：海外购订单*/
@property (nonatomic, copy) NSString *isoversea;

@end
