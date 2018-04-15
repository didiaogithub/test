//
//  MyAddressTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/17.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "MyAddressTableViewCell.h"
@interface MyAddressTableViewCell ()
{
    UIImageView *editImageView;
    UIImageView *deleteImageView;
}

@end
@implementation MyAddressTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _bankView = [[UIView alloc] init];
    [self.contentView addSubview:_bankView];
    [_bankView setBackgroundColor:[UIColor whiteColor]];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.bottom.mas_offset(-5);

    }];
    //联系人
    _addressNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BoldTITLE_FONT];
    [_bankView addSubview:_addressNameLable];

    
    //联系电话
    _addressTelPhoneLable = [UILabel configureLabelWithTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:MAIN_BoldTITLE_FONT];
    [_bankView addSubview:_addressTelPhoneLable];


    //地址图标
    _addressImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_addressImageView];
    UIImage *headimage = [UIImage imageNamed:@"定位"];
    _addressImageView.image = [headimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //详细地址
    _addressDetailLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bankView addSubview:_addressDetailLable];
    _addressDetailLable.numberOfLines = 0;
    
    
    //选择地址
    _selectedAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bankView addSubview:_selectedAddressButton];
    
    //中间的线
    middleLine = [UILabel creatLineLable];
    [_bankView addSubview:middleLine];
    
    //设置为默认地址
    _setDefaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bankView addSubview:_setDefaultButton];
    _setDefaultButton.titleEdgeInsets = UIEdgeInsetsMake(15,10, 15, 5);
    _setDefaultButton.titleLabel.font = MAIN_TITLE_FONT;
    _setDefaultButton.tag = 10000;
    
    [_setDefaultButton setImage:[UIImage imageNamed:@"selectgrey"] forState:UIControlStateNormal];
    [_setDefaultButton setImage:[UIImage imageNamed:@"pinkselected"] forState:UIControlStateSelected];
    [_setDefaultButton setTitle:@"设为默认" forState:UIControlStateNormal];
    [_setDefaultButton setTitle:@"默认地址" forState:UIControlStateSelected];
    [_setDefaultButton setTitleColor:SubTitleColor forState:UIControlStateNormal];
    [_setDefaultButton setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateSelected];

    //编辑地址
    editImageView = [[UIImageView alloc] init];
    [_bankView addSubview:editImageView];
    editImageView.contentMode = UIViewContentModeScaleAspectFit;
    [editImageView setImage:[UIImage imageNamed:@"edit"]];
    _editButton = [self createAddressButtonWithTag:10001 andAction:@selector(clickAddressButton:)];
    [_bankView addSubview:_editButton];

    //删除地址
    deleteImageView = [[UIImageView alloc] init];
    [_bankView addSubview:deleteImageView];
    deleteImageView.contentMode = UIViewContentModeScaleAspectFit;
    [deleteImageView setImage:[UIImage imageNamed:@"delete"]];
    _deleteButton = [self createAddressButtonWithTag:10002 andAction:@selector(clickAddressButton:)];
    [_bankView addSubview:_deleteButton];
}
-(void)refreshWithModel:(AddressModel *)addressModel andIndex:(NSInteger)index{
    _addressNameLable.text = addressModel.gettername;
    _addressDetailLable.text = [NSString stringWithFormat:@"%@ %@",addressModel.address,addressModel.homeaddress];
    _addressTelPhoneLable.text = addressModel.gettermobile;
    
    //联系人
    [_addressNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.mas_offset(AdaptedWidth(45));
    }];
    
    //联系电话
    [_addressTelPhoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressNameLable.mas_top);
        make.left.equalTo(_addressNameLable.mas_right).offset(AdaptedWidth(15));
    }];
    
    //定位图片
    [_addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressNameLable.mas_bottom).offset(AdaptedHeight(15));
        make.left.mas_offset(AdaptedWidth(20));
        make.width.mas_offset(AdaptedWidth(14));
        make.height.mas_offset(AdaptedHeight(17));
    }];
    
    //详细地址
    
    [_addressDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressImageView.mas_top);
        make.left.equalTo(_addressNameLable.mas_left);
        make.right.mas_offset(-AdaptedWidth(20));
    }];

    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressDetailLable.mas_bottom).offset(AdaptedHeight(10));
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - 10, 1));
    }];
  //设置地址
    [_setDefaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleLine.mas_bottom);
        make.bottom.mas_offset(0);
        make.left.equalTo(_addressImageView.mas_left);
        make.size.mas_offset(CGSizeMake(110*SCREEN_WIDTH_SCALE, 50));
    }];
//   是否为默认地址（0：否 1：是）
    if ([addressModel.isdefault isEqualToString:@"1"]) {
        _setDefaultButton.selected = YES;
    }else{
        _setDefaultButton.selected = NO;
    }
    [_setDefaultButton addTarget:self action:@selector(clickAddressButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //编辑按钮
    //编辑图片
    [editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleLine.mas_bottom).offset(12);
        make.right.mas_offset(-80);
        make.size.mas_offset(CGSizeMake(60, 20));
        make.bottom.mas_offset(-12);
    }];
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_setDefaultButton.mas_top);
        make.right.equalTo(editImageView.mas_right);
        make.size.mas_offset(CGSizeMake(60, 50));
    }];
    
    //删除按钮
     //删除图片
    [deleteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(editImageView);
        make.right.mas_offset(-AdaptedWidth(15));
        make.size.equalTo(editImageView);
    }];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_setDefaultButton.mas_top);
        make.right.equalTo(deleteImageView.mas_right);
        make.size.equalTo(_editButton);
    }];
    


}
-(void)clickAddressButton:(UIButton *)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressButtonClicked:andRow:)]) {
        [self.delegate addressButtonClicked:button andRow:self.row];
    }
}
/**统一 button*/
-(UIButton *)createAddressButtonWithTag:(NSInteger)tag andAction:(SEL)action{
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


@end
