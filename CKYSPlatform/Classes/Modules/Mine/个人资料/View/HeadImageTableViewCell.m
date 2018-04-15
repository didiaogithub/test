//
//  HeadImageTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/28.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "HeadImageTableViewCell.h"

@implementation HeadImageTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    UIView *headView = [[UIView alloc] init];
    [self.contentView addSubview:headView];
    headView.layer.cornerRadius = 5;
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    //店铺头像 lable
    _headLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [headView addSubview:_headLable];
    _headLable.text = @"店铺头像";
    [_headLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(30);
        make.left.mas_offset(15);
    }];
   
    //头像按钮
    _headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:_headImageButton];
    _headImageButton.layer.cornerRadius = 30;
    _headImageButton.clipsToBounds = YES;
    [_headImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.right.mas_offset(-30);
        make.size.mas_offset(CGSizeMake(60, 60));
        
    }];
    [_headImageButton addTarget:self action:@selector(clickHeadButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //头像下面的线
    UILabel *firstLine = [UILabel creatLineLable];
    [headView addSubview:firstLine];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageButton.mas_bottom).offset(10);
        make.left.equalTo(_headLable.mas_left);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - 40, 1));
    }];
    //店铺名称
    _shopNameLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [headView addSubview:_shopNameLable];
    _shopNameLable.text = @"店铺名称";
    [_shopNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLine.mas_bottom).offset(15);
        make.left.left.equalTo(_headLable.mas_left);
        make.width.mas_offset(AdaptedWidth(60));
    }];
    //可编辑的输入框
    _shopNameTextField = [[UITextField alloc] init];
    [headView addSubview:_shopNameTextField];
    _shopNameTextField.textAlignment = NSTextAlignmentRight;
    _shopNameTextField.delegate = self;
    _shopNameTextField.textColor = TitleColor;
    _shopNameTextField.font = MAIN_TITLE_FONT;
    _shopNameTextField.placeholder = @"未填写";
    [_shopNameTextField setValue:SubTitleColor forKeyPath:@"_placeholderLabel.textColor"];
    [_shopNameTextField setValue:MAIN_SUBTITLE_FONT forKeyPath:@"_placeholderLabel.font"];
    [_shopNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLine.mas_bottom);
        make.left.equalTo(_shopNameLable.mas_right).offset(3);
        make.right.equalTo(_headImageButton.mas_right);
        make.height.mas_offset(45);
    }];
    
    //第二条线
    UILabel *secondLineLable = [UILabel creatLineLable];
    [headView addSubview:secondLineLable];
    [secondLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shopNameTextField.mas_bottom);
        make.left.equalTo(firstLine.mas_left);
        make.width.and.height.mas_equalTo(firstLine);
    }];
    //昵称
    
    _shopNickNameLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [headView addSubview:_shopNickNameLable];
    _shopNickNameLable.text = @"昵称";
    [_shopNickNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLineLable.mas_bottom).offset(15);
        make.left.equalTo(_shopNameLable.mas_left);
        make.width.mas_offset(AdaptedWidth(60));
        make.height.mas_equalTo(_shopNameLable);
        make.bottom.mas_offset(-15);
    }];
    
    //可输入的昵称框
    _shopNickNameTextField = [[UITextField alloc] init];
    [headView addSubview:_shopNickNameTextField];
    _shopNickNameTextField.textColor = TitleColor;
    _shopNickNameTextField.font = MAIN_TITLE_FONT;
    _shopNickNameTextField.textAlignment = NSTextAlignmentRight;
    _shopNickNameTextField.delegate = self;
    [_shopNickNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLineLable.mas_bottom);
        make.left.equalTo(_shopNickNameLable.mas_right).offset(3);
        make.right.equalTo(_shopNameTextField.mas_right);
        make.bottom.mas_offset(0);
    }];


}
-(void)refreshWithModel:(UserModel *)userModel{
    NSString *headPath = [NSString stringWithFormat:@"%@",userModel.headfile];
    NSString *picUrl = [NSString loadImagePathWithString:headPath];
//    [_headImageButton sd_setImageWithURL:[NSURL URLWithString:picUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"name"] options:SDWebImageRefreshCached];
    [_headImageButton sd_setImageWithURL:[NSURL URLWithString:picUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"name"]];


}

#pragma mark-点击换头像
-(void)clickHeadButton:(UIButton *)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeHeadImageWithButton:)]) {
        [self.delegate changeHeadImageWithButton:button];
    }
  
}



@end
