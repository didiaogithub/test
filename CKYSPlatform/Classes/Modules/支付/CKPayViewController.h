//
//  CKPayViewController.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseViewController.h"

@interface CKPayViewController : BaseViewController
/**支付金额*/
@property (nonatomic, copy) NSString *payfee;
/**订单号*/
@property (nonatomic, copy) NSString *orderId;
/**ckid,ckid不为空，说明是注册过的支付，支付完回首页，设为登录状态*/
@property (nonatomic, copy) NSString *ckid;
@property (nonatomic, assign) NSInteger paymentType;
@property (nonatomic, copy) NSString *addressMobile;

@property (nonatomic, copy) NSString *cktype;
@property (nonatomic, copy) NSString *fromVC;

@end
