//
//  CKBottomView.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKBottomView.h"

@implementation CKBottomView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_buyBtn];
    _buyBtn.backgroundColor = [UIColor tt_redMoneyColor];
    [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _buyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _buyBtn.tag = 60;
    [_buyBtn addTarget:self action:@selector(clickBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.right.mas_offset(0);
        make.width.mas_equalTo(95);
    }];
    
    _changeGoodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_changeGoodsBtn];
    _changeGoodsBtn.backgroundColor = [UIColor blackColor];
    [_changeGoodsBtn setTitle:@"更换礼包" forState:UIControlStateNormal];
    [_changeGoodsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _changeGoodsBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _changeGoodsBtn.tag = 61;
    [_changeGoodsBtn addTarget:self action:@selector(clickBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_changeGoodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_offset(0);
        make.right.equalTo(_buyBtn.mas_left);
        make.width.mas_equalTo(95);
    }];
    
    _moneyLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14.0]];
    [self addSubview:_moneyLable];
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(AdaptedWidth(10));
        make.right.equalTo(_changeGoodsBtn.mas_left);
    }];
}

-(void)clickBottomBtn:(UIButton*)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomViewClickWithIndex:)]) {
        [self.delegate bottomViewClickWithIndex:sender.tag-60];
    }
}

@end

