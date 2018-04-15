//
//  CKMonthIncomeTableViewCell.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/16.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKMonthUserModel.h"

@interface CKMonthIncomeTableViewCell : UITableViewCell

- (void)updateCellData:(CKMonthUserModel*)model;

@end

@interface CKMonthIncomeExpTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *moneyLabel;

@end
