//
//  TopRedValueView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/6.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "TopRedValueView.h"

@implementation TopRedValueView
-(instancetype)initWithFrame:(CGRect)frame andTitleStr:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        [self createUIWithType:title];
    }
    return self;
}
-(void)createUIWithType:(NSString *)title{
    
    [self setBackgroundColor:[UIColor tt_redMoneyColor]];
    //上面总值
    _topValueLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM_BOLD(AdaptedHeight(30))];
    [self addSubview:_topValueLable];
    [_topValueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH);
        make.height.mas_offset(AdaptedHeight(40));
    }];
    
    //文字
    _topTextLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [self addSubview:_topTextLable];
    _topTextLable.text =  title;
    [_topTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topValueLable.mas_bottom);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH);
        make.bottom.mas_offset(-AdaptedHeight(23));
    }];
    
    _topValueLable.text = @"0.00";
    
}


@end
