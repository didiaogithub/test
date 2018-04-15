//
//  CKOrderDetailViewController.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/6.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"
#import "AddressModel.h"

@interface CKOrderDetailViewController : BaseViewController

@property (nonatomic, strong) OrderModel *orderModel;
@property (nonatomic, copy)   NSString *orderstatusString;
/**是创客or消费者订单*/
@property (nonatomic, copy)   NSString *typeString;

@property (nonatomic, strong) RLMArray *dataArray;


-(void)reloadOrderWithNewAdress:(AddressModel*)addressModel;

-(void)hiddenChangeAddressBtn;

@end
