//
//  CKCouponCanUseCell.m
//  CKYSPlatform
//
//  Created by majun on 2018/3/17.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKCouponCanUseCell.h"
@interface CKCouponCanUseCell()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *moneyLable;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *validDate;
@property (nonatomic, strong) UILabel *sendReasonL;
@property (nonatomic, strong) CKCouponModel *couponM;
@end
@implementation CKCouponCanUseCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.imgView = [[UIImageView alloc]init];
    self.imgView.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"#AAAAAA"] rect:CGRectMake(1, 1, 1, 1 )];
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
        make.width.mas_offset(AdaptedWidth(120));
    }];
    
    self.moneyLable = [[UILabel alloc]init];
    self.moneyLable.text = @"¥0.00";
    self.moneyLable.backgroundColor = [UIColor clearColor];
    self.moneyLable.textColor = [UIColor whiteColor];
    self.moneyLable.textAlignment = NSTextAlignmentCenter;
    self.moneyLable.font = [UIFont systemFontOfSize:22];
    [self.contentView addSubview:self.moneyLable];
    [self.moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(AdaptedWidth(120));
    }];
    
    self.nameLable = [UILabel new];
    self.nameLable.text = @"产品券";
    self.nameLable.backgroundColor = [UIColor clearColor];
    self.nameLable.textColor = [UIColor whiteColor];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = [UIFont systemFontOfSize:12];
    self.nameLable.numberOfLines = 0;
    [self.contentView addSubview:self.nameLable];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLable.mas_bottom).offset(0);
        make.width.mas_equalTo(AdaptedWidth(120));
        make.left.mas_offset(0);
        make.height.mas_equalTo(30);
    }];
    
    self.typeLabel = [UILabel new];
    self.typeLabel.text = @"产品进货抵用券";
    self.typeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.typeLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.mas_offset(-10);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    self.validDate = [UILabel new];
    self.validDate.text = @"2017.03.01 00:00-2017.04.25 00:00";
    self.validDate.textColor = [UIColor colorWithHexString:@"#999999"];
    self.validDate.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.validDate];
    [self.validDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom);
        make.right.mas_offset(-10);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    
    UILabel *dashLine = [UILabel creatLineLable];
    dashLine.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    [self.contentView addSubview:dashLine];
    [dashLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.validDate.mas_bottom);
        make.right.mas_offset(-10);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    
    self.sendReasonL = [UILabel new];
    self.sendReasonL.text = @"发放原因：累计销售创客礼包2套";
    self.sendReasonL.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.sendReasonL];
    [self.sendReasonL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.validDate.mas_bottom).offset(1);
        make.right.mas_offset(-10);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.height.mas_equalTo(24);
    }];
    
    UIImageView *uselessView = [UIImageView new];
    uselessView.image = [UIImage imageNamed:@"usedCoupon"];
    uselessView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:uselessView];
    [uselessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(64);
    }];
}
- (void)refreshCouponWithCouponModel:(CKCouponModel *)couponM{
    NSString *money = [NSString stringWithFormat:@"%@", couponM.money];
    if (IsNilOrNull(money)) {
        money = @"0.00";
    }
    if ([money doubleValue] >= 1000.0) {
        self.moneyLable.font = [UIFont systemFontOfSize:20];
    }
    self.moneyLable.text = [NSString stringWithFormat:@"¥%.2f", [money doubleValue]];
    
    NSString *userange = [NSString stringWithFormat:@"%@", couponM.userange];
    if (IsNilOrNull(userange)) {
        userange = @"";
    }
    self.typeLabel.text = userange;
    
    NSString *name = [NSString stringWithFormat:@"%@", couponM.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    self.nameLable.text = name;
    
    NSString *time = [NSString stringWithFormat:@"%@", couponM.time];
    if (IsNilOrNull(time)) {
        time = @"0000.00.00-0000.00.00";
    }
    self.validDate.text = time;
    
    NSString *sendreason = [NSString stringWithFormat:@"%@", couponM.scope];
    if (IsNilOrNull(sendreason)) {
        sendreason = @"";
    }
    self.sendReasonL.text = [NSString stringWithFormat:@"发放原因:%@", sendreason];
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
