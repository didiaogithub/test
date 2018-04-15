//
//  BankCardTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/3.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BankCardTableViewCell.h"

@implementation BankCardTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    //背景view
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
    }];
    
    //银行卡lable
    _bankCardLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_bankCardLable];
    _bankCardLable.text = @"招商银行储蓄卡";
    [_bankCardLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(20));
        make.left.mas_offset(AdaptedWidth(20));
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - 100, 20));
    }];

    //选择按钮
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_selectedButton];

    UIImage *nomalImage = [UIImage imageNamed:@"giftwhite"];
    UIImage *selectedImage = [UIImage imageNamed:@"pinkselected"];
    [_selectedButton setImage:nomalImage forState:UIControlStateNormal];
    [_selectedButton setImage:selectedImage forState:UIControlStateSelected];

    [_selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.right.mas_offset(-AdaptedWidth(30));
        make.height.mas_offset(AdaptedHeight(21));
        make.width.mas_offset(AdaptedWidth(21));
        make.bottom.mas_offset(-AdaptedHeight(15));
    }];
    [_selectedButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *bottomLable = [UILabel creatLineLable];
    [bankView addSubview:bottomLable];
    [bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bankCardLable.mas_bottom).offset(AdaptedHeight(20));
        make.left.right.mas_offset(0);
        make.height.mas_offset(1);
        make.bottom.mas_offset(0);
    }];

}
-(void)refreshWithModel:(CardModel *)cardModel{
    NSString *name = [NSString stringWithFormat:@"%@",cardModel.bankname];
    NSString *cardNumber = [NSString stringWithFormat:@"%@",cardModel.bankcardno];
    if (IsNilOrNull(cardNumber)) {
        cardNumber = @"";
    }
    if (IsNilOrNull(name)) {
         _bankCardLable.text = @"";
    }else{
        _bankCardLable.text = [NSString stringWithFormat:@"%@(尾号%@)",name,cardNumber];
    }
    NSString *isdefault = cardModel.isdefault;
    if ([isdefault isEqualToString:@"1"]) {
        _selectedButton.selected = YES;
    }else{
        _selectedButton.selected = NO;
    }
}
-(void)clickRightButton:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(setDefaultBankCardWithRow:andButton:)]){
        [self.delegate setDefaultBankCardWithRow:self.row andButton:button];
    }
}

@end
