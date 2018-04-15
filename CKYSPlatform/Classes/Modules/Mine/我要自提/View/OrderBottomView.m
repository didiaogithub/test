//
//  OrderBottomView.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/8/10.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "OrderBottomView.h"

@implementation OrderBottomView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
    }
    return self;
}
-(void)createUI{
    __weak OrderBottomView *bottomView = self;
    
    UILabel *line = [UILabel creatLineLable];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    
    _allSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_allSelectedButton];
    _allSelectedButton.tag = 788;
    UIImage *nomalImage = [UIImage imageNamed:@"giftwhite"];
    UIImage * selectedImage = [UIImage imageNamed:@"pinkselected"];
    [_allSelectedButton setImage:nomalImage forState:UIControlStateNormal];
    [_allSelectedButton setImage:selectedImage forState:UIControlStateSelected];
    [_allSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.equalTo(bottomView.mas_left).offset(10);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    
    [_allSelectedButton addTarget:self action:@selector(clickBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *textLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:textLable];
    textLable.text = @"全选";
    [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_allSelectedButton);
        make.left.equalTo(_allSelectedButton.mas_right).offset(5);
        make.width.mas_offset(AdaptedWidth(35));
    }];
    
    
    UIImageView *bankImageview = [[UIImageView alloc] init];
    [bankImageview setImage:[UIImage imageNamed:@"carrybuybutton"]];
    [self addSubview:bankImageview];
    bankImageview.contentMode = UIViewContentModeScaleAspectFit;;
    [bankImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(7));
        make.right.mas_offset(-AdaptedWidth(5));
        make.bottom.mas_offset(-AdaptedHeight(7));
        make.width.mas_offset(AdaptedWidth(130));
    }];
    
    //立即购买
    _nowGoToBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_nowGoToBuyButton];
    [_nowGoToBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    _nowGoToBuyButton.titleLabel.font = MAIN_TITLE_FONT;
    _nowGoToBuyButton.tag = 789;
    [_nowGoToBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bankImageview);
    }];
    [_nowGoToBuyButton addTarget:self action:@selector(clickBottomButton:) forControlEvents:UIControlEventTouchUpInside];

    

    //总计
    _realPayMoneyLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:_realPayMoneyLable];
    _realPayMoneyLable.text = @"合计：¥0.00";
    [_realPayMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(textLable);
        make.left.equalTo(textLable.mas_right);
        make.right.equalTo(bankImageview.mas_left).offset(-AdaptedWidth(2));
    }];
}
-(void)clickBottomButton:(UIButton *)button{
    if (self.delegate  && [self.delegate respondsToSelector:@selector(bottomViewButtonClicked:)]) {
        [self.delegate bottomViewButtonClicked:button];
    }
}
@end
