//
//  CKConfirmRegisterOrderVC.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseViewController.h"


@interface CKConfirmRegisterOrderVC : BaseViewController

/**
 大礼包商品array
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 大礼包订单array
 */
@property (nonatomic, strong) NSMutableArray *orderinfoArray;

/**
 订单或者礼包金额
 */
@property (nonatomic, copy)   NSString *totalMoney;

/**
 从哪个类进入的
 */
@property (nonatomic, copy)   NSString *fromVC;

/**
 创客id
 */
@property (nonatomic, copy)   NSString *ckid;

/**
 更换商品是否显示所有类型大礼包
 */
@property (nonatomic, copy) NSString *showAllTypeDLB;



@end
