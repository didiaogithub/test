//
//  CKCouponModel.h
//  CKYSPlatform
//
//  Created by majun on 2018/3/17.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

@interface CKCouponModel : BaseEncodeModel

/**
 抵用券id
 */
@property (nonatomic, copy) NSString *voucherid;
/**
 抵用券金额
 */
@property (nonatomic, copy) NSString *money;
/**
 抵用券名称
 */
@property (nonatomic, copy) NSString *name;
/**
 发放原因
 */
@property (nonatomic, copy) NSString *scope;
/**
 有效期
 */
@property (nonatomic, copy) NSString *time;
/**
 背景图片路径
 */
@property (nonatomic, copy) NSString *imgurl;
/**
 使用场景
 */
@property (nonatomic, copy) NSString *userange;

@end
