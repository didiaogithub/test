//
//  CKMonthIncomeTableViewCell.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/16.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKMonthIncomeTableViewCell.h"

@interface CKMonthIncomeTableViewCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation CKMonthIncomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.nameLabel = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#666666"] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.text = @"姓名";
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH*0.5-10);
        make.left.top.mas_offset(10);
        make.height.mas_equalTo(20);
    }];
    
    self.phoneLabel = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#666666"] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:self.phoneLabel];
    self.phoneLabel.text = @"电话";
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH*0.5-10);
        make.left.mas_offset(10);
        make.height.mas_equalTo(20);
    }];
    
    self.dateLabel = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#666666"] textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:self.dateLabel];
    self.dateLabel.text = @"0000-00-00 00:00:00";
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.width.mas_equalTo(SCREEN_WIDTH*0.5-10);
        make.top.mas_offset(10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [self.contentView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)updateCellData:(CKMonthUserModel*)model {
    NSString *name = model.name;
    if (IsNilOrNull(name)) {
        name = @"";
    }
    NSString *jointype = model.jointype;
    if(IsNilOrNull(jointype)){
        jointype = @"";
    }else if([jointype isEqualToString:@"SURE"]){
        jointype = @"（正式）";
    }else if([jointype isEqualToString:@"NOTSURE"]){
        jointype = @"（零风险）";
    }
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@%@", name, jointype];
    NSString *mobile = model.mobile;
    if (IsNilOrNull(mobile)) {
        mobile = @"";
    }
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@", mobile];
    
    NSString *jointime = model.jointime;
    if (IsNilOrNull(jointime)) {
        jointime = @"";
    }
    self.dateLabel.text = [NSString stringWithFormat:@"%@", jointime];
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


@interface CKMonthIncomeExpTableViewCell()

@property (nonatomic, strong) UILabel *nameLabel;


@end

@implementation CKMonthIncomeExpTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    self.nameLabel = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15]];
    self.nameLabel.userInteractionEnabled = YES;
    NSMutableAttributedString *attri1 = [[NSMutableAttributedString alloc] initWithString:@" 创客礼包销售"];
    NSTextAttachment *attch1 = [[NSTextAttachment alloc] init];
    attch1.image = [UIImage imageNamed:@"创客礼包销售"];
    attch1.bounds = CGRectMake(0, -3, 15, 15);
    NSAttributedString *string1 = [NSAttributedString attributedStringWithAttachment:attch1];
    [attri1 insertAttributedString:string1 atIndex:0];
    self.nameLabel.attributedText = attri1;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH*0.5-10);
        make.left.mas_offset(10);
        make.top.bottom.mas_offset(0);
    }];
  
    
    self.moneyLabel = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#666666"] textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:16]];
    [self.contentView addSubview:self.moneyLabel];
    self.moneyLabel.text = @"¥0.00";
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.width.mas_equalTo(SCREEN_WIDTH*0.5-10);
        make.top.bottom.mas_offset(0);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [self.contentView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(1);
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
