//
//  SCCouponModel.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/18.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

@interface SCCouponModel : BaseEncodeModel
/**
 是否展开
 */
@property (nonatomic, assign) BOOL isExpand;
/**
 优惠券id
 */
@property (nonatomic, copy) NSString *couponid;
/**
 优惠券金额
 */
@property (nonatomic, copy) NSString *money;
/**
 优惠券名称
 */
@property (nonatomic, copy) NSString *name;
/**
 发放原因
 */
@property (nonatomic, copy) NSString *scope;
/**
 详细信息
 */
@property (nonatomic, copy) NSString *details;
/**
 有效期
 */
@property (nonatomic, copy) NSString *timelimit;
/**
 背景图片路径
 */
@property (nonatomic, copy) NSString *imgurl;
/**
 使用场景
 */
@property (nonatomic, copy) NSString *userange;
/**
 持有人
 */
@property (nonatomic, copy) NSString *username;

@end
