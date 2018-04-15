//
//  TakeCashHeaderView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/6/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "TakeCashHeaderView.h"

@implementation TakeCashHeaderView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self createUI];
    }
    return self;
}
-(void)createUI{

    self.backgroundColor = [UIColor whiteColor];
    UILabel *bottomLine = [UILabel creatLineLable];
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_offset(1);
        
    }];

    
    UIView *redView = [[UIView alloc] init];
    [self addSubview:redView];
    [redView setBackgroundColor:[UIColor tt_redMoneyColor]];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_offset(0);
        make.width.mas_offset(AdaptedWidth(60+10));
    }];
    
    
    _monthLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM_BOLD(51/2)];
    [redView addSubview:_monthLable];
    [_monthLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(5));
        make.left.right.mas_offset(0);
    }];
    
    
    _yearLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM(AdaptedHeight(21/2))];
    [redView addSubview:_yearLable];
    [_yearLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_monthLable.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-AdaptedHeight(5));
        
    }];
    
    
    _allCountLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedHeight(18))];
    [redView addSubview:_allCountLable];
    [_allCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(redView.mas_right).offset(AdaptedWidth(10));
    }];
}
@end
