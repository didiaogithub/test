//
//  HeaderView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/10.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "HeaderView.h"
@interface HeaderView()

@end

@implementation HeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createTopViews];
    }
    return self;
}
-(void)createTopViews{
    
    UIView *bootoomView = [[UIView alloc] init];
    [self addSubview:bootoomView];
    [bootoomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    //上边的view
    UIView *topView = [[UIView alloc] init];
    [bootoomView addSubview:topView];
    topView.backgroundColor = CKYS_Color(38, 42, 49);
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 100*SCREEN_HEIGHT_SCALE));
    }];
    //招商图片
    _leftImageView = [[UIImageView alloc] init];
    [topView addSubview:_leftImageView];
    [_leftImageView setImage:[UIImage imageNamed:@"招商白"]];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(28*SCREEN_HEIGHT_SCALE);
        make.left.equalTo(topView.mas_left).offset(30);
        make.size.mas_offset(CGSizeMake(44*SCREEN_WIDTH_SCALE, 44*SCREEN_HEIGHT_SCALE));
    }];
    //招商人数
    _personCountLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(25))];
    [topView addSubview:_personCountLable];
    _personCountLable.text = @"0";
    _personCountLable.font = [UIFont boldSystemFontOfSize:25];
    [_personCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftImageView.mas_top);
        make.left.equalTo(_leftImageView.mas_right).offset(20);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - 150, 25*SCREEN_HEIGHT_SCALE));
    }];
    //文字
    _textLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [topView addSubview:_textLable];
    _textLable.text = @"招商人数";
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_personCountLable.mas_bottom).offset(8*SCREEN_HEIGHT_SCALE);
        make.left.equalTo(_personCountLable.mas_left);
        make.size.mas_offset(CGSizeMake(150, 15));
    }];
    
    UIView *textView = [[UIView alloc] init];
    [textView setBackgroundColor:[UIColor whiteColor]];
    [bootoomView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(5);
        make.left.equalTo(topView.mas_left);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
        
    }];
    
     _firstLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [textView addSubview:_firstLable];
    [_firstLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_top);
        make.left.equalTo(textView.mas_left).offset(0);
        make.size.mas_offset(CGSizeMake((SCREEN_WIDTH-10)/5, 15));
        make.bottom.mas_offset(0);
    }];
    
    UILabel *leftLine = [UILabel creatLineLable];
    [textView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(3);
        make.bottom.mas_offset(-3);
        make.left.equalTo(_firstLable.mas_right);
        make.width.mas_offset(1);
    }];
    
    _secondLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [textView addSubview:_secondLable];
    [_secondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstLable.mas_top);
        make.left.equalTo(leftLine.mas_right);
        make.size.mas_offset(CGSizeMake((SCREEN_WIDTH-10)/5, 15));
        make.bottom.mas_offset(0);
    }];
    
    UILabel *middleLine = [UILabel creatLineLable];
    [textView addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLine.mas_top);
        make.left.equalTo(_secondLable.mas_right);
        make.size.equalTo(leftLine);
    }];
    
    _threenLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [textView addSubview:_threenLable];
    [_threenLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstLable.mas_top);
        make.left.equalTo(middleLine.mas_right);
        make.size.mas_offset(CGSizeMake((SCREEN_WIDTH-10)*2/5-30, 15));
        make.bottom.mas_offset(0);
    }];
    
    UILabel *rightLable = [UILabel creatLineLable];
    [textView addSubview:rightLable];
    [rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLine.mas_top);
        make.left.equalTo(_threenLable.mas_right);
        make.size.mas_equalTo(leftLine);
    }];
    
    _fourLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [textView addSubview:_fourLable];
    [_fourLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_threenLable.mas_top);
        make.right.mas_equalTo(0);
        make.size.mas_offset(CGSizeMake((SCREEN_WIDTH-10)/5 + 30, 15));
        make.bottom.mas_offset(0);
    }];
      
}


@end
