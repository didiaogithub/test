//
//  SCCouponCanUseCell.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/15.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCCouponCanUseCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DashLineView.h"

@interface SCCouponCanUseCell()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *moneyLable;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *validDate;
@property (nonatomic, strong) UILabel *sendReasonL;
@property (nonatomic, strong) UILabel *holderNameL;
@property (nonatomic, strong) SCCouponModel *couponM;


@end

@implementation SCCouponCanUseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    self.imgView = [UIImageView new];
    self.imgView.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"#AAAAAA"] rect:CGRectMake(1, 1, 1, 1)];
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
        make.width.mas_equalTo(100);
    }];
    
    self.moneyLable = [UILabel new];
    self.moneyLable.text = @"¥0.00";
    self.moneyLable.backgroundColor = [UIColor clearColor];
    self.moneyLable.textColor = [UIColor whiteColor];
    self.moneyLable.textAlignment = NSTextAlignmentCenter;
    self.moneyLable.font = [UIFont systemFontOfSize:22];
    [self.contentView addSubview:self.moneyLable];
    [self.moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(25);
        make.left.mas_offset(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(100);
    }];
    
    self.nameLable = [UILabel new];
    self.nameLable.text = @" ";
    self.nameLable.backgroundColor = [UIColor clearColor];
    self.nameLable.textColor = [UIColor whiteColor];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = [UIFont systemFontOfSize:12];
    self.nameLable.numberOfLines = 30;
    [self.contentView addSubview:self.nameLable];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLable.mas_bottom).offset(0);
        make.width.mas_equalTo(100);
        make.left.mas_offset(0);
        make.height.mas_equalTo(30);
    }];
    
    self.typeLabel = [UILabel new];
    self.typeLabel.text = @" ";
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
    self.validDate.text = @" ";
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
    self.sendReasonL.text = @"发放原因:";
    self.sendReasonL.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.sendReasonL];
    [self.sendReasonL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.validDate.mas_bottom).offset(1);
        make.right.mas_offset(-10);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.height.mas_equalTo(24);
    }];
    
    
    self.holderNameL = [UILabel new];
    self.holderNameL.text = @"持有人:";
    self.holderNameL.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.holderNameL];
    [self.holderNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.top.equalTo(self.sendReasonL.mas_bottom);
        make.height.mas_equalTo(25);
    }];
}



-(void)refreshCouponWithCouponModel:(SCCouponModel*)couponM {
    self.couponM = couponM;
    
    NSString *imgurl = [NSString stringWithFormat:@"%@", couponM.imgurl];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"couponDefaultBg"]];
    
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
    
    NSString *timelimit = [NSString stringWithFormat:@"%@", couponM.timelimit];
    if (IsNilOrNull(timelimit)) {
        timelimit = @"0000.00.00-0000.00.00";
    }
    self.validDate.text = timelimit;
    
    NSString *sendreason = [NSString stringWithFormat:@"%@", couponM.scope];
    if (IsNilOrNull(sendreason)) {
        sendreason = @"";
    }
    self.sendReasonL.text = [NSString stringWithFormat:@"发放原因:%@", sendreason];
    
    NSString *username = [NSString stringWithFormat:@"%@", couponM.username];
    if (IsNilOrNull(username)) {
        username = @"";
    }
    self.holderNameL.text = [NSString stringWithFormat:@"持有人:%@", username];

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
