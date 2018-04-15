//
//  CKOrderViewController.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/11/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "RootBaseViewController.h"

//    下单类型（CK：创客自提订单  WXUSER：商城订单）
//    订单状态（99：全部;0：已取消 1：未付款；2：已付款；4：正在退货，5：退货成功，6：已完成，7：已发货 ）
typedef NS_ENUM(NSInteger, OrderStatus){
    OrderStatusCancel = 0, //已取消
    OrderStatusNotPay = 1, //未付款
    OrderStatusWaitDelivery = 2, //待发货
    OrderStatusReceived = 3, //已收货
    OrderStatusOnReturn = 4, //正在退货
    OrderStatusReturnSuccess = 5, //退货成功
    OrderStatusComplete = 6, //已完成
    OrderStatusMailed = 7 //已发货
};

@interface CKOrderViewController : RootBaseViewController

@end
