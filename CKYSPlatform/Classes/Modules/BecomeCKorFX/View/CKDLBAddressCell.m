//
//  CKDLBAddressCell.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKDLBAddressCell.h"

@interface CKDLBAddressCell()

@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) UIImageView *addressImageView;
@property (nonatomic, strong) UILabel *addressNameLable;
@property (nonatomic, strong) UILabel *addressDetailLable;
@property (nonatomic, strong) UILabel *addressTelPhoneLable;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) UIImageView *rightImageView;//箭头

@end

@implementation CKDLBAddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    
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
    
    NSString *district = [address stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *detailA = [detaiAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    _addressDetailLable.text = [NSString stringWithFormat:@"%@ %@", district, detailA];
    NSString *mobile = [NSString stringWithFormat:@"%@",addressModel.gettermobile];
    if (IsNilOrNull(mobile)) {
        mobile = @"";
    }
    _addressTelPhoneLable.text = mobile;
    
    NSString *isdefault = [NSString stringWithFormat:@"%@",addressModel.isdefault];
    if (IsNilOrNull(isdefault)) {
        isdefault = @"";
    }
    [_addressDetailLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-41*SCREEN_WIDTH_SCALE);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
