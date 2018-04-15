//
//  WriteOrderTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/8/10.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "WriteOrderTableViewCell.h"

@implementation WriteOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    _bankView = [[UIView alloc] init];
    [self.contentView addSubview:_bankView];
    _bankView.backgroundColor = [UIColor whiteColor];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(0);
    }];
    //联系人
    _addressNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BoldTITLE_FONT];
    [_bankView addSubview:_addressNameLable];
    
    //联系电话
    _addressTelPhoneLable = [UILabel configureLabelWithTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:MAIN_BoldTITLE_FONT];
    [_bankView addSubview:_addressTelPhoneLable];
    
    
    //电话右边的默认地址图标
    _defaultImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_defaultImageView];
    _defaultImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_defaultImageView setImage:[UIImage imageNamed:@"defaultAddress"]];
    
    //地址图标
    _addressImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_addressImageView];
    UIImage *headimage = [UIImage imageNamed:@"定位"];
    _addressImageView.image = [headimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //详细地址
    _addressDetailLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_bankView addSubview:_addressDetailLable];
    
    //右箭头图标
    _rightImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_rightImageView];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_rightImageView setImage:[UIImage imageNamed:@"address"]];

    //底边
    _bottomImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_bottomImageView];
    [_bottomImageView setImage:[UIImage imageNamed:@"分隔彩线"]];
    
    
    //联系人
    [_addressNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(20));
        make.left.mas_offset(AdaptedWidth(31));
    }];
    
    //联系电话
    [_addressTelPhoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressNameLable.mas_top);
        make.left.equalTo(_addressNameLable.mas_right).offset(15);
    }];
    
    [_defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressNameLable.mas_top);
        make.left.equalTo(_addressTelPhoneLable.mas_right).offset(5);
        make.height.mas_offset(20);
        make.width.mas_offset(40);
    }];
    
    
    //定位图片
    [_addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressNameLable.mas_bottom).offset(AdaptedHeight(15));
        make.left.mas_offset(AdaptedWidth(10));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(14), AdaptedHeight(17)));
    }];
    
    //选中默认地址
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressNameLable.mas_bottom);
        make.right.mas_offset(-AdaptedWidth(15));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(16), AdaptedHeight(26)));
    }];
    //详细地址
    _addressDetailLable.numberOfLines = 0;
    [_addressDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressImageView.mas_top);
        make.left.equalTo(_addressNameLable.mas_left);
    }];
    
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressDetailLable.mas_bottom).offset(AdaptedHeight(24));
        make.width.mas_offset(SCREEN_WIDTH);
        make.bottom.mas_offset(0);
        make.height.mas_offset(3);
    }];

}

-(void)refreshWithAddressModel:(AddressModel *)addressModel {
    _addressNameLable.text = [NSString stringWithFormat:@"收货人:%@",addressModel.gettername];
    NSString *address = [NSString stringWithFormat:@"%@",addressModel.address];
    NSString *detaiAddress = [NSString stringWithFormat:@"%@",addressModel.homeaddress];
    if(IsNilOrNull(address)){
        address = @"";
    }
    if(IsNilOrNull(detaiAddress)) {
        detaiAddress = @"";
    }
    _addressDetailLable.text = [NSString stringWithFormat:@"%@%@",address,detaiAddress];
    NSString *mobile = [NSString stringWithFormat:@"%@",addressModel.gettermobile];
    if (IsNilOrNull(mobile)) {
        mobile = @"";
    }
    _addressTelPhoneLable.text = mobile;

    NSString *isdefault = [NSString stringWithFormat:@"%@",addressModel.isdefault];
    
    if ([isdefault isEqualToString:@"1"]) {
        _defaultImageView.hidden = NO;
    }else{
        _defaultImageView.hidden = YES;
    }

    [_addressDetailLable mas_updateConstraints:^(MASConstraintMaker *make) {
         make.right.mas_offset(-41*SCREEN_WIDTH_SCALE);
    }];
}

@end
