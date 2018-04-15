//
//  CKConfirmOrderCell.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/10.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKPickupGoodsModel.h"

@interface CKConfirmOrderCell : UITableViewCell


@property (nonatomic, assign) NSInteger chooseCount;
@property (nonatomic, strong) CKPickupGoodsModel *goodModel;


@property(nonatomic,strong)UILabel *rightNumberLable;

- (void)updateCellData:(CKPickupGoodsModel*)model showCount:(BOOL)showCount;

@end
