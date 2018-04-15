//
//  SCCouponDetailCell.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/18.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCouponModel.h"
#import "SCCouponDetailModel.h"

@class SCCouponDetailCell;
@protocol SCCouponDetailDelegate <NSObject>

-(void)couponDetailExpand:(SCCouponDetailCell*)cell;
-(void)couponDetailClose:(SCCouponDetailCell*)cell;


@end

@interface SCCouponDetailCell : UITableViewCell

@property (nonatomic, weak) id<SCCouponDetailDelegate> delegate;

-(void)refreshCouponWithCouponModel:(SCCouponModel*)couponM;

@end


@interface SCCouponDetailTypeCell : UITableViewCell

@end

@interface SCCouponDetailOrderCell : UITableViewCell

-(void)refreshCouponOrder:(SCCouponDetailModel*)couponDetailM;

@end
