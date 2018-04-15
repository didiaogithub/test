//
//  YZCTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/4/16.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "YZCTableViewCell.h"

@implementation YZCTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    
    _leftIamgeView = [[UIImageView alloc] init];
    [bankView addSubview:_leftIamgeView];
    [_leftIamgeView setImage:[UIImage imageNamed:@"yzcpayicon"]];
    _leftIamgeView.contentMode = UIViewContentModeScaleAspectFit;
    [_leftIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.mas_offset(AdaptedWidth(40));
        make.width.mas_offset(AdaptedWidth(100));
        make.height.mas_offset(AdaptedHeight(25));
    }];
    
    //选择按钮
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_rightButton];
    _rightButton.userInteractionEnabled = NO;
    
    [_rightButton setImage:[UIImage imageNamed:@"giftwhite"] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"pinkselected"] forState:UIControlStateSelected];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(12));
        make.right.mas_offset(-AdaptedWidth(30));
        make.width.mas_offset(AdaptedWidth(30));
        make.height.mas_offset(AdaptedHeight(30));
    }];


    UILabel *middleGrayLable = [[UILabel alloc] init];
    [bankView addSubview:middleGrayLable];
    [middleGrayLable setBackgroundColor:[UIColor tt_grayBgColor]];
    [middleGrayLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftIamgeView.mas_bottom).offset(AdaptedHeight(15));
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(15));
    }];
    
    UILabel *textLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:textLable];
    [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleGrayLable.mas_bottom);
        make.left.mas_offset(AdaptedWidth(30));
        make.height.mas_offset(AdaptedHeight(40));
        make.bottom.mas_offset(0);
    }];
    textLable.text = @"选择支付方式:";
}


@end
