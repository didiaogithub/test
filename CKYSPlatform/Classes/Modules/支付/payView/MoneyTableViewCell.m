//
//  MoneyTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/8/27.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "MoneyTableViewCell.h"

@implementation MoneyTableViewCell
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
        make.top.mas_offset(0);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-AdaptedHeight(20));
    }];
    
    
    _textLable = [UILabel configureLabelWithTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_BODYTITLE_FONT];
    [bankView addSubview:_textLable];
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(30);
        make.height.mas_offset(AdaptedHeight(40));
        make.bottom.mas_offset(0);
    }];
    _textLable.text = @"待支付金额:";
    _moneyLable = [UILabel configureLabelWithTextColor:[UIColor redColor] textAlignment:NSTextAlignmentRight font:MAIN_BODYTITLE_FONT];
    [bankView addSubview:_moneyLable];
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_textLable);
        make.left.equalTo(_textLable.mas_right).offset(AdaptedWidth(5));
        make.right.mas_offset(-AdaptedWidth(30));
    }];


}
@end
