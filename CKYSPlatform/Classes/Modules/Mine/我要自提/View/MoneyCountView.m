//
//  MoneyCountView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/17.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "MoneyCountView.h"

@implementation MoneyCountView
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
    
    _allMoneyLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:_allMoneyLable];
    _allMoneyLable.text = [NSString stringWithFormat:@"合计:¥"];
    [_allMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(30));
        make.width.mas_offset(AdaptedWidth(SCREEN_WIDTH-AdaptedWidth(196)));
        make.bottom.mas_offset(-AdaptedHeight(10));
    }];
    
    UIImageView *bankImageview = [[UIImageView alloc] init];
    [bankImageview setImage:[UIImage imageNamed:@"carrybuybutton"]];
    [self addSubview:bankImageview];
    bankImageview.contentMode = UIViewContentModeScaleAspectFit;;
    [bankImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(7));
        make.right.mas_offset(-AdaptedWidth(5));
        make.bottom.mas_offset(-AdaptedHeight(7));
        make.width.mas_offset(AdaptedWidth(131));
    }];
    
    //立即购买
    _nowToBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_nowToBuyButton];
    [_nowToBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    _nowToBuyButton.titleLabel.font = MAIN_TITLE_FONT;
    _nowToBuyButton.tag = 789;
    [_nowToBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bankImageview);
    }];
    [_nowToBuyButton addTarget:self action:@selector(clickNowBuyButton) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)clickNowBuyButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moneyCountViewButtonClicked)]) {
        [self.delegate moneyCountViewButtonClicked];
    }

}
@end
