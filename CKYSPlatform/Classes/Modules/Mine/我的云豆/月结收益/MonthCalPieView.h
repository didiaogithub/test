//
//  MonthCalPieView.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/12/20.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCChart.h"

@interface MonthCalPieView : UIView

@property (nonatomic, strong) SCPieChart *chartView;
/*产品销售奖励费**/
@property (nonatomic, strong) UILabel *saleReturnL;
/*产品销售奖励费值**/
@property (nonatomic, strong) UILabel *saleReturnValueL;
/*创客礼包利润**/
@property (nonatomic, strong) UILabel *dlbProfitL;
/*创客礼包利润值**/
@property (nonatomic, strong) UILabel *dlbProfitLValueL;
/*礼包销售累计奖励费**/
@property (nonatomic, strong) UILabel *totalDLBProfitL;
/*礼包销售累计奖励费值**/
@property (nonatomic, strong) UILabel *totalDLBProfitValueL;

@end
