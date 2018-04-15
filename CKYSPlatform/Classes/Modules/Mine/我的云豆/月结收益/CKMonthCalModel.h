//
//  CKMonthCalModel.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/2.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

@interface CKMonthCalModel : BaseEncodeModel

/**
 月结总奖励
 */
@property (nonatomic, copy) NSString *totalmoney;
/**
 产品销售奖励费
 */
@property (nonatomic, copy) NSString *salesreward;
/**
 创客礼包销售利润
 */
@property (nonatomic, copy) NSString *invitemoney;
/**
 礼包销售累计利润
 */
@property (nonatomic, copy) NSString *invitereward;
/**
 奖励系数
 */
@property (nonatomic, copy) NSString *modulus;
/**
 店铺进货
 */
@property (nonatomic, copy) NSString *rechargemoney;
///**
// 礼包销售累计利润明细
// */
//@property (nonatomic, copy) NSString *inviterewardDataArray;


@end
