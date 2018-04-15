//
//  LeftTextRightSwitchView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/4/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "LeftTextRightSwitchView.h"

@implementation LeftTextRightSwitchView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _showLeftLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:_showLeftLable];
    [_showLeftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_equalTo(15);
        make.bottom.mas_offset(0);
    }];
    
    _showSwitch = [[UISwitch alloc] init];
    [self addSubview:_showSwitch];
    _showSwitch.on = YES;
    _showSwitch.onTintColor = [UIColor redColor];
    // 控件大小，不能设置frame，只能用缩放比例
    _showSwitch.transform = CGAffineTransformMakeScale(1, 1);
    [_showSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(5));
        make.right.mas_offset(-30);
        make.size.mas_offset(CGSizeMake(50, AdaptedHeight(35)));
    }];
    //头像下面的线
    _topLineLable = [UILabel creatLineLable];
    [self addSubview:_topLineLable];
    [_topLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_showSwitch.mas_bottom).offset(AdaptedHeight(5));
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_offset(1);
//        make.bottom.mas_offset(0);
    }];

}

@end
