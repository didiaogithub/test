//
//  ShopHasopenView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/1/18.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "NoSaleShopView.h"

@implementation NoSaleShopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    //昵称
    _firsttLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    _firsttLable.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_firsttLable];
    _firsttLable.text = @"序号";
    [_firsttLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(12.5);
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH/5);
        make.bottom.mas_offset(-12.5);
    }];
    
    UILabel *leftLine = [UILabel creatLineLable];
    [self addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(_firsttLable.mas_right);
        make.size.mas_offset(CGSizeMake(1, 40*SCREEN_HEIGHT_SCALE));
    }];
    

    _secondLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [self addSubview:_secondLable];
     _secondLable.font = [UIFont boldSystemFontOfSize:15];
    _secondLable.text = @"店铺";
    [_secondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firsttLable.mas_top);
        make.left.equalTo(_firsttLable.mas_right);
        make.width.mas_offset(SCREEN_WIDTH * 2/5);
        make.bottom.equalTo(_firsttLable.mas_bottom);
    }];
    
    UILabel *middleLable = [UILabel creatLineLable];
    [self addSubview:middleLable];
    [middleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLine.mas_top);
        make.left.equalTo(_secondLable.mas_right);
        make.size.equalTo(leftLine);
    }];
    
    //
    _threenLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [self addSubview:_threenLable];
    _threenLable.text = @"邀请码";
    _threenLable.font = [UIFont boldSystemFontOfSize:15];
    [_threenLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secondLable.mas_top);
        make.left.equalTo(middleLable.mas_right);
        make.width.mas_offset(SCREEN_WIDTH * 2/5);
        make.bottom.equalTo(_firsttLable.mas_bottom);
    }];
    
}
@end
