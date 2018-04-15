//
//  CKCouponNotCanUseCell.h
//  CKYSPlatform
//
//  Created by majun on 2018/3/17.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCouponModel.h"
// 已过期
@interface CKCouponNotCanUseCell : UITableViewCell
-(void)refreshCouponWithCouponModel:(CKCouponModel*)couponM;
@end
