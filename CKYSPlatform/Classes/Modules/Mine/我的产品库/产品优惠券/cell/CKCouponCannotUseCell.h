//
//  CKCouponCannotUseCell.h
//  CKYSPlatform
//
//  Created by majun on 2018/3/17.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCouponModel.h"
// 未使用
@interface CKCouponCannotUseCell : UITableViewCell

-(void)refreshCouponWithCouponModel:(CKCouponModel*)couponM;
@end
