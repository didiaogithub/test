//
//  TopUpViewController.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/14.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "MineModel.h"
#import "CKCouponDetailViewController.h"

typedef void(^PayResultBlock)(NSString *statusStr);

@interface TopUpViewController : BaseViewController<returnCouponDelegate>

@property (nonatomic, copy) PayResultBlock payBlock;
@property (nonatomic, assign) NSInteger paymentType;
@property (nonatomic, copy) NSString *couponMoney;
@property (nonatomic, copy) NSString *couponid;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, strong) NSDictionary *dataDic;

-(void)setPayBlock:(PayResultBlock)payBlock;

@end
