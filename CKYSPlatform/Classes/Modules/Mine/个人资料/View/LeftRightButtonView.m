//
//  LeftRightButtonView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/4/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "LeftRightButtonView.h"

@implementation LeftRightButtonView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    //头像下面的线
    _topLineLable = [UILabel creatLineLable];
    [self addSubview:_topLineLable];
    [_topLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_offset(1);
    }];
    
    _leftLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:_leftLable];
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topLineLable.mas_left);
        make.top.bottom.mas_offset(0);
        make.width.mas_offset(AdaptedWidth(70));
        
        
    }];
    
    _rightLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self addSubview:_rightLable];
    _rightLable.numberOfLines = 0;
    [_rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.right.mas_offset(-30);
        make.left.equalTo(_leftLable.mas_right).offset(3);
        
    }];
    
    //可输入的昵称框
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLineLable.mas_bottom);
        make.left.equalTo(_leftLable.mas_right).offset(3);
        make.right.mas_offset(-30);
//        make.height.mas_offset(45);
        make.bottom.mas_offset(0);
    }];
    
    
    
    
}
@end
