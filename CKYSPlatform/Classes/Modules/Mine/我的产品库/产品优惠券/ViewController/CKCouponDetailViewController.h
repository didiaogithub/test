//
//  CKCouponDetailViewController.h
//  CKYSPlatform
//
//  Created by majun on 2018/3/16.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseViewController.h"
@protocol returnCouponDelegate <NSObject>

- (void)returnMoney:(NSString *)money couponId:(NSString*)couponId;

@end

@interface CKCouponDetailViewController : BaseViewController

@property (nonatomic, weak) id <returnCouponDelegate> delegate;

@property (nonatomic, assign)BOOL isMyProductLib;
@end
