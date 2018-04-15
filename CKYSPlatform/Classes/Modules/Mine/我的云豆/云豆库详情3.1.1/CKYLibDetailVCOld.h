//
//  CKYLibDetailVCOld.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/12.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "MineModel.h"

@interface CKYLibDetailVCOld : BaseViewController

@property (nonatomic, strong) MineModel *mindeModel;
@property (nonatomic, copy)   NSString *joinType;
/**最大可提现金额*/
@property (nonatomic, copy)   NSString *maxCash;
/**剩余芸豆*/
@property (nonatomic, copy)   NSString *currentYlibMoney;
@property (nonatomic, copy)   NSString *islock;
@property (nonatomic, copy) NSString *currentGlibMoney;


@end
