//
//  SalesBonusView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/6.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesBonusView : UIView

/**
 总奖励文字
 */
@property(nonatomic,strong)UILabel *allSaleBonusText;

/**
 总奖励
 */
@property(nonatomic,strong)UILabel *allSaleBonusLable;

/**
 店铺进货奖励文字
 */
@property(nonatomic,strong)UILabel *allRechargeText;
/**
 店铺进货奖励
 */
@property(nonatomic,strong)UILabel *allRechargeLable;

/**
 平台推广奖励文字
 */
@property(nonatomic,strong)UILabel *allPromoteText;

/**
 平台推广奖励
 */
@property(nonatomic,strong)UILabel *allPromoteLable;

@property(nonatomic,strong)UIButton *rechargeButton;
@property(nonatomic,strong)UIButton *promoteButton;


-(instancetype)initWithFrame:(CGRect)frame andTypeStr:(NSString *)userType;
@end
