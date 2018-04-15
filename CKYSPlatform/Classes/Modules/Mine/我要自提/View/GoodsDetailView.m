//
//  GoodsDetailView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/21.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "GoodsDetailView.h"

@implementation GoodsDetailView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    UILabel *line = [UILabel creatLineLable];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    _textNumberLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [self addSubview:_textNumberLable];
    _textNumberLable.text = @"数量:";

    [_textNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.left.mas_offset(2);
        make.width.mas_offset(40);
        make.bottom.mas_offset(-20);
    }];
    
    _countView = [[UIView alloc] init];
    [self addSubview:_countView];
    _countView.layer.cornerRadius = 3;
    _countView.layer.borderWidth = 1;
    _countView.layer.borderColor = CKYS_Color(130, 130, 130).CGColor;
    [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.equalTo(_textNumberLable.mas_right);
        make.bottom.mas_offset(-15);
        make.size.mas_offset(CGSizeMake(110, 30));
    }];
    
    //减号按钮
    _reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_countView addSubview:_reduceButton];
    _reduceButton.tag = 1660;
    [_reduceButton setTitle:@"-" forState:UIControlStateNormal];
    [_reduceButton setTitleColor:CKYS_Color(130, 130, 130) forState:UIControlStateNormal];
    [_reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(35, 30));
    }];
    [_reduceButton addTarget:self action:@selector(clickbottomButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //数字
    _countLable = [UILabel configureLabelWithTextColor:CKYS_Color(130, 130, 130) textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [_countView addSubview:_countLable];
    _countLable.text = @"1";
    _countLable.layer.borderWidth = 1;
    _countLable.layer.borderColor = CKYS_Color(130, 130, 130).CGColor;
    [_countLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(33);
        make.size.mas_offset(CGSizeMake(40, 30));
    }];
    
    
    //加号按钮
    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_countView addSubview:_plusButton];
    _plusButton.tag =  1661;
    [_plusButton setTitle:@"+" forState:UIControlStateNormal];
    [_plusButton setTitleColor:CKYS_Color(130, 130, 130) forState:UIControlStateNormal];
    [_plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_reduceButton.mas_top);
        make.left.equalTo(_countLable.mas_right);
        make.size.equalTo(_reduceButton);
    }];
    [_plusButton addTarget:self action:@selector(clickbottomButton:) forControlEvents:UIControlEventTouchUpInside];

    //合计二字
    UILabel *textMoney = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [self addSubview:textMoney];
    textMoney.text = @"合计：";
    
    [textMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(13);
        make.left.equalTo(_countView.mas_right).offset(10);
        make.size.mas_offset(CGSizeMake(50, 13));
    }];
    
    _allMoneyLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:_allMoneyLable];
    _allMoneyLable.text = @"¥0.00";
    [_allMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textMoney.mas_bottom).offset(3);
        make.left.equalTo(textMoney.mas_left);
        make.bottom.mas_offset(-15);
    }];
    
    _nowToBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_nowToBuyButton];
    [_nowToBuyButton setBackgroundColor:[UIColor tt_redMoneyColor]];
    _nowToBuyButton.tag = 1662;
    [_nowToBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [_nowToBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
        make.width.mas_offset(130*SCREEN_WIDTH_SCALE);
    }];
    [_nowToBuyButton addTarget:self action:@selector(clickbottomButton:) forControlEvents:UIControlEventTouchUpInside];
    

}

#pragma mark-点击减号 和   加号 按钮
-(void)clickbottomButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickButtonWithTag:)]) {
        [self.delegate clickButtonWithTag:button.tag];
    }
}


@end
