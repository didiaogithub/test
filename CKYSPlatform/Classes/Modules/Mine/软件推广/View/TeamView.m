//
//  TeamView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/11.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "TeamView.h"

@implementation TeamView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    float widthLable = 0;
    if(iphone5){
        widthLable = 60;
    }else{
        widthLable = 70;
    }
        
     float width = (SCREEN_WIDTH - widthLable*2 - 5 - widthLable)/2;
    //昵称
    _firsttLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_SUBTITLE_FONT];
    [self addSubview:_firsttLable];
    _firsttLable.text = @"昵称";
    [_firsttLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(12);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(widthLable*SCREEN_WIDTH_SCALE, 15));
    }];
    
    UILabel *firstLine = [UILabel creatLineLable];
    [self addSubview:firstLine];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(_firsttLable.mas_right);
        make.size.mas_offset(CGSizeMake(1, 40));
    }];

    // 姓名
    _secondLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_SUBTITLE_FONT];
    [self addSubview:_secondLable];
    _secondLable.text = @"姓名";
    [_secondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firsttLable.mas_top);
        make.left.equalTo(firstLine.mas_right);
        make.size.equalTo(_firsttLable);
    }];
    
    UILabel *secondLable = [UILabel creatLineLable];
    [self addSubview:secondLable];
    [secondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLine.mas_top);
        make.left.equalTo(_secondLable.mas_right);
        make.size.equalTo(firstLine);
    }];
    
    //电话
    _threenLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_SUBTITLE_FONT];
    [self addSubview:_threenLable];
    _threenLable.text = @"电话";
    [_threenLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secondLable.mas_top);
        make.left.equalTo(secondLable.mas_right);
        make.size.mas_offset(CGSizeMake(width, 15));
    }];
    
    
    UILabel *threenLine = [UILabel creatLineLable];
    [self addSubview:threenLine];
    [threenLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLable.mas_top);
        make.left.equalTo(_threenLable.mas_right);
        make.size.equalTo(secondLable);
    }];

    //累计消费
    _fourLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_SUBTITLE_FONT];
    [self addSubview:_fourLable];
    _fourLable.text = @"累计消费";
    [_fourLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_threenLable.mas_top);
        make.left.equalTo(threenLine.mas_right);
        make.size.mas_offset(CGSizeMake(width, 15));
    }];
    
    
    UILabel *fourLine = [UILabel creatLineLable];
    [self addSubview:fourLine];
    [fourLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threenLine.mas_top);
        make.left.equalTo(_fourLable.mas_right);
        make.size.equalTo(threenLine);
    }];
    
    _fiveLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_SUBTITLE_FONT];
    [self addSubview:_fiveLable];
    _fiveLable.text = @"操作";
    [_fiveLable mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(_fourLable.mas_top);
       make.left.equalTo(fourLine.mas_right);
       make.right.mas_offset(0);
       make.height.mas_offset(15);
    }];
    
    UILabel *bottomeLable = [UILabel creatLineLable];
    [self addSubview:bottomeLable];
    [bottomeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(39);
        make.bottom.mas_offset(0);
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH);
    }];
    
}

@end
