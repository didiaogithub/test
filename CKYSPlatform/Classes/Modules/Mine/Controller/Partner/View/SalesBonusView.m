//
//  SalesBonusView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/6.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SalesBonusView.h"

@implementation SalesBonusView
-(instancetype)initWithFrame:(CGRect)frame andTypeStr:(NSString *)userType{
    if (self = [super initWithFrame:frame]) {
        [self createUIWithType:userType];
    }
    return self;
}
-(void)createUIWithType:(NSString *)typeStr{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _allSaleBonusText = [UILabel configureLabelWithTextColor:[UIColor tt_monthLittleBlackColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:_allSaleBonusText];
    //总的销售业绩奖励
    _allSaleBonusLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthLittleBlackColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:_allSaleBonusLable];
    
    
    //店铺进货奖励
    _allRechargeText = [UILabel configureLabelWithTextColor:[UIColor tt_monthLittleBlackColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [self addSubview:_allRechargeText];
    
    //值
    _allRechargeLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthLittleBlackColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [self addSubview:_allRechargeLable];
    
    //软件推广奖励
    _allPromoteText = [UILabel configureLabelWithTextColor:[UIColor tt_monthLittleBlackColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [self addSubview:_allPromoteText];
    //值
    _allPromoteLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthLittleBlackColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [self addSubview:_allPromoteLable];
    
    
    if([typeStr isEqualToString:@"ck"]){
        _allSaleBonusText.text = @"普通店铺销售奖励费";
        _allRechargeText.text = @"普通店铺产品销售奖励";
        _allPromoteText.text = @"普通店铺创客礼包推广奖励";
    }else{
        _allSaleBonusText.text = @"合伙人销售奖励费";
        _allRechargeText.text = @"合伙人平台产品销售奖励";
        _allPromoteText.text = @"合伙人平台店铺创客礼包推广奖励";
    }
    
    [_allSaleBonusText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(13));
        make.left.mas_offset(AdaptedWidth(10));
    }];

    [_allSaleBonusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allSaleBonusText.mas_top);
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    UILabel *horizalLable = [UILabel creatLineLable];
    [self addSubview:horizalLable];
    [horizalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allSaleBonusText.mas_bottom).offset(AdaptedHeight(13));
        make.left.right.mas_offset(0);
        make.height.mas_offset(1);
    }];
    
    [_allRechargeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizalLable.mas_bottom).offset(AdaptedHeight(15));
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH/2-1);
    }];
    [_allRechargeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allRechargeText.mas_bottom).offset(AdaptedHeight(20));
        make.left.right.equalTo(_allRechargeText);
        make.bottom.mas_offset(-AdaptedHeight(17));
    }];
    
    //垂直的线
    UILabel *verticalLable = [UILabel creatLineLable];
    [self addSubview:verticalLable];
    [verticalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizalLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.mas_offset(SCREEN_WIDTH/2);
        make.width.mas_offset(1);
        make.bottom.mas_offset(-AdaptedHeight(8));
    }];
    
    [_allPromoteText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allRechargeText.mas_top);
        make.left.mas_offset(SCREEN_WIDTH/2+1);
        make.right.mas_offset(0);
    }];
    [_allPromoteLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allPromoteText.mas_bottom).offset(AdaptedHeight(20));
        make.left.right.equalTo(_allPromoteText);
        make.bottom.mas_offset(-AdaptedHeight(17));
    }];
    
    
    //左侧button
    _rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_rechargeButton];
    _rechargeButton.tag = 3110;
    [_rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizalLable.mas_bottom);
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH/2);
        make.bottom.mas_offset(0);
    }];
    
    
    //右侧button
    _promoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_promoteButton];
    _promoteButton.tag = 3111;
    [_promoteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizalLable.mas_bottom);
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH/2);
        make.bottom.mas_offset(0);
    }];
    
    [_rechargeButton addTarget:self action:@selector(clickSaleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_promoteButton addTarget:self action:@selector(clickSaleButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _allRechargeLable.text = @"0.00";
    _allSaleBonusLable.text = @"0.00";
    _allPromoteLable.text = @"0.00";
}
-(void)clickSaleButton:(UIButton *)button{



}

@end
