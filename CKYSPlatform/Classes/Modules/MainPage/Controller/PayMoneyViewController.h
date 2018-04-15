//
//  PayMoneyViewController.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/19.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseViewController.h"

@interface PayMoneyViewController : BaseViewController

@property (nonatomic, assign) NSInteger paymentType;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *joinTypeStr;

/**商品自提中  选择 可以购买的 支付总金额*/
@property (nonatomic, copy) NSString *payfeeStr;
/**商品自提中  选择 可以购买的 支付总订单号*/
@property (nonatomic, copy) NSString *oidStr;
/**地址列表的id*/
@property (nonatomic, copy) NSString *addressId;
/**大礼包商品id*/
@property (nonatomic, copy) NSString *itemid;

@property (nonatomic, copy) NSString *fromVC;

@end
