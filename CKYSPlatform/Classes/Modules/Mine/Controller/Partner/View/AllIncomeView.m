//
//  AllIncomeView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "AllIncomeView.h"

@implementation AllIncomeView

-(instancetype)initWithFrame:(CGRect)frame andTypeStr:(NSString *)userType{
    if (self = [super initWithFrame:frame]) {
        [self createUIWithType:userType];
    }
    return self;
}

-(void)createUIWithType:(NSString *)type{
    [self setBackgroundColor:[UIColor whiteColor]];
    //红背景
   
    UIView *redTimeView = [[UILabel alloc] init];
    [self addSubview:redTimeView];
    [redTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_offset(0);
        make.width.mas_offset(AdaptedWidth(177/2));
    }];
    
    UILabel *bankRedLable = [[UILabel alloc] init];
    [redTimeView addSubview:bankRedLable];
    [bankRedLable setBackgroundColor:[UIColor tt_redMoneyColor]];
    [bankRedLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_offset(0);
        make.width.mas_offset(AdaptedWidth(177/2));
    }];
    
    //左侧显示时间
    _monthLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM_BOLD(AdaptedHeight(74/2))];
    [redTimeView addSubview:_monthLable];
    
    [_monthLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.right.mas_offset(0);
    }];
    
    //年
    _yearLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM_BOLD(AdaptedWidth(29/2))];
    [redTimeView addSubview:_yearLable];
    [_yearLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_monthLable.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-AdaptedHeight(15));
    }];
    
    //默认当月时间
    NSString *datestr = [NSDate nowTime:@"yyyy-MM"];
    NSArray *timeArr = [datestr componentsSeparatedByString:@"-"];
    _yearLable.text = [timeArr firstObject];
    _monthLable.text = [NSString stringWithFormat:@"%@月",[timeArr lastObject]];
    
    NSInteger length = _monthLable.text.length;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_monthLable.text ];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:CHINESE_SYSTEM_BOLD(AdaptedHeight(74/2))
                          range:NSMakeRange(0, 2)];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:CHINESE_SYSTEM(AdaptedHeight(29/2))
                          range:NSMakeRange(length-1, 1)];
    _monthLable.attributedText = AttributedStr;
    
    //总资产(元);
    UILabel *allMoneyText = [UILabel configureLabelWithTextColor:[UIColor tt_monthLittleBlackColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:allMoneyText];
    allMoneyText.text = @"总计(元)";
    [allMoneyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.width.mas_offset(AdaptedWidth(85));
        make.left.equalTo(redTimeView.mas_right).offset(AdaptedWidth(10));
    }];
    
    
    //总值
    _allValueLable = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"3E3E3E"] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM_BOLD(AdaptedWidth(24))];
    [self addSubview:_allValueLable];
    _allValueLable.text = @"0.00";
    [_allValueLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(AdaptedHeight(20));
        make.centerY.equalTo(allMoneyText.mas_centerY);
        make.left.equalTo(allMoneyText.mas_right);
        make.right.mas_offset(-10);
    }];
    
    UILabel *detailText = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13.0]];
    [self addSubview:detailText];
    detailText.numberOfLines = 0;
    detailText.text = @"(产品销售奖励费+创客礼包利润+累计销售创客礼包奖励)";
    [detailText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allValueLable.mas_bottom).offset(10);
        make.left.equalTo(allMoneyText.mas_left);
        make.right.mas_offset(-10);
//        make.height.mas_offset(AdaptedHeight(30));
        make.bottom.mas_offset(-10);
    }];
}

@end
