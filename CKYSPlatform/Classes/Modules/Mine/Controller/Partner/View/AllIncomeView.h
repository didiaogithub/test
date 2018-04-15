//
//  AllIncomeView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
// 合计view
@interface AllIncomeView : UIView
/**月份*/
@property(nonatomic,strong)UILabel *monthLable;

/**年份*/
@property(nonatomic,strong)UILabel *yearLable;

/**总值*/
@property(nonatomic,strong)UILabel *allValueLable;
-(instancetype)initWithFrame:(CGRect)frame andTypeStr:(NSString *)userType;

@end
