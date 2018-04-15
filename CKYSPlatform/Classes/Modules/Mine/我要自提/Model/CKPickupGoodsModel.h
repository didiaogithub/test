//
//  CKPickupGoodsModel.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/2/26.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

@interface CKPickupGoodsModel : BaseEncodeModel

/**数量*/
@property (nonatomic, copy) NSString *count;
//选中状态
@property(nonatomic,assign)BOOL isSelect;
/**id*/
@property (nonatomic, copy) NSString *ID;
/**名称*/
@property (nonatomic, copy) NSString *name;
/**图片路径*/
@property (nonatomic, copy) NSString *url;
/**描述*/
@property (nonatomic, copy) NSString *desCription;
/**价格*/
@property (nonatomic, copy) NSString * price;
/**no yes*/
@property (nonatomic, copy) NSString *ifspecial;
/***/
@property (nonatomic, copy) NSString *specialprice;
/**可支付  只能自提*/
@property (nonatomic, copy) NSString *ispay;
/**规格*/
@property (nonatomic, copy) NSString *spec;
/**0：非海外购订单 1：海外购订单*/
@property (nonatomic, copy) NSString *isoversea;

@end
