//
//  LeftPicRightTextView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "LeftPicRightTextView.h"

@implementation LeftPicRightTextView
-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andImage:(NSString *)imageStr isShowRight:(BOOL)isShow andTag:(NSInteger)tag{
    if (self = [super initWithFrame:frame]) {
        [self createUIWithTitle:title andImage:imageStr isShowRight:isShow andTag:tag];
    }
    return self;
}
-(void)createUIWithTitle:(NSString *)title andImage:(NSString *)imageStr isShowRight:(BOOL)isShow andTag:(NSInteger)selectedTag{

    [self setBackgroundColor:[UIColor whiteColor]];
//    @"littlemonth"
    //左边图标
    _leftImageView = [[UIImageView alloc] init];
    [self addSubview:_leftImageView];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_leftImageView setImage:[UIImage imageNamed:imageStr]];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(20));
        make.left.mas_offset(AdaptedWidth(32));
        make.bottom.mas_offset(-AdaptedHeight(20));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(26), AdaptedHeight(25)));
    }];
    

   _rightLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    _rightLable.text = title;
    [self addSubview:_rightLable];
    [_rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftImageView.mas_top);
        make.left.equalTo(_leftImageView.mas_right).offset(AdaptedWidth(30));
        make.bottom.equalTo(_leftImageView.mas_bottom);
    }];
    
    
    _rightImageView = [[UIImageView alloc] init];
    [self addSubview:_rightImageView];
    [_rightImageView setImage:[UIImage imageNamed:@"rightarrow"]];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(23));
        make.right.mas_offset(-AdaptedWidth(10));
        make.bottom.mas_offset(-AdaptedHeight(23));
    }];
    _rightValueLable  = [UILabel configureLabelWithTextColor:[UIColor tt_monthLittleBlackColor] textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self addSubview:_rightValueLable];
    _rightValueLable.text = @"0.00";
    [_rightValueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(_rightLable.mas_right).offset(AdaptedWidth(10));
        make.right.mas_offset(-AdaptedWidth(30));
    }];
    
    if(isShow){ //隐藏不显示
        _rightImageView.hidden = YES;
        _rightValueLable.hidden = YES;

    }else{ //显示右边的
        _rightImageView.hidden = NO;
        _rightValueLable.hidden = NO;
    }

    _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_detailButton];
    _detailButton.tag = selectedTag;
    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
    }];
    [_detailButton addTarget:self action:@selector(clickMonthButton:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickMonthButton:(UIButton *)button{
    NSInteger buttonTag = button.tag - 2110;
    if (self.delegate && [self.delegate respondsToSelector:@selector(monthDetailJumpWithTag:)]) {
        [self.delegate monthDetailJumpWithTag:buttonTag];
    }
}


@end
