//
//  AllInfoTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/28.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "AllInfoTableViewCell.h"

@implementation AllInfoTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _leftInfoLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [self.contentView addSubview:_leftInfoLable];
    [_leftInfoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(15);
        make.width.mas_offset(AdaptedWidth(60));
        make.bottom.mas_offset(-15);
    }];
    //右边输入框
    _rightTextField = [[UITextField alloc] init];
    [self.contentView addSubview:_rightTextField];
    _rightTextField.delegate = self;
    _rightTextField.placeholder = @"未填写";
    _rightTextField.font = MAIN_TITLE_FONT;
    _rightTextField.textColor = TitleColor;
    [_rightTextField setValue:SubTitleColor forKeyPath:@"_placeholderLabel.textColor"];
    [_rightTextField setValue:MAIN_SUBTITLE_FONT forKeyPath:@"_placeholderLabel.font"];
    _rightTextField.textAlignment = NSTextAlignmentRight;
   

    [_rightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(_leftInfoLable.mas_right).offset(3);
        make.right.mas_offset(-30);
        make.bottom.mas_offset(0);
    }];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_rightButton];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightTextField.mas_top);
        make.left.equalTo(_rightTextField.mas_left);
        make.width.and.height.mas_equalTo(_rightTextField);
    }]; 

}
#pragma mark-点击右边按钮
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    
}

@end
