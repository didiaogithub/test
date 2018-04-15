//
//  CKAllIncomeView.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/12.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKAllIncomeView : UIView
/**月份*/
@property(nonatomic,strong)UILabel *monthLable;

/**年份*/
@property(nonatomic,strong)UILabel *yearLable;

/**总值*/
@property(nonatomic,strong)UILabel *allValueLable;
-(instancetype)initWithFrame:(CGRect)frame andTypeStr:(NSString *)userType;

@end
