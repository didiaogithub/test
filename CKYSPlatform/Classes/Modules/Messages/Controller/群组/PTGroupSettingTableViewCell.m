//
//  PTGroupSettingTableViewCell.m
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/13.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "PTGroupSettingTableViewCell.h"

@implementation PTGroupSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation PTUpdateGroupNameTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *remarkLabel = [[UILabel alloc] init];
    remarkLabel.font = [UIFont systemFontOfSize:13.f];
    remarkLabel.textColor = [UIColor colorWithHexString:@"000000"];
    [self.contentView addSubview:remarkLabel];
    remarkLabel.text = @"群组名称";
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(10);
        make.width.mas_equalTo(60);
    }];
    
    UIImageView *rightArrow = [[UIImageView alloc] init];
    rightArrow.translatesAutoresizingMaskIntoConstraints = NO;
    rightArrow.image = [UIImage imageNamed:@"rightarrow"];
    [self.contentView addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(10);
        make.right.mas_offset(-10);
    }];
    
    self.groupNameLabel = [[UILabel alloc] init];
    self.groupNameLabel.font = [UIFont systemFontOfSize:13.f];
    self.groupNameLabel.textAlignment = NSTextAlignmentRight;
    self.groupNameLabel.textColor = [UIColor colorWithHexString:@"000000"];
    [self.contentView addSubview:self.groupNameLabel];
    self.groupNameLabel.text = @" ";
    [self.groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(remarkLabel.mas_right).offset(10);
        make.right.equalTo(rightArrow.mas_left).offset(-5);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [self.contentView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
}

@end

@implementation PTUpdateAnnounceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *remarkLabel = [[UILabel alloc] init];
    remarkLabel.font = [UIFont systemFontOfSize:13.f];
    remarkLabel.textColor = [UIColor colorWithHexString:@"000000"];
    [self.contentView addSubview:remarkLabel];
    remarkLabel.text = @"群公告";
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(10);
        make.width.mas_equalTo(60);
    }];
    
    self.rightArrow = [[UIImageView alloc] init];
    self.rightArrow.translatesAutoresizingMaskIntoConstraints = NO;
    self.rightArrow.image = [UIImage imageNamed:@"rightarrow"];
    [self.contentView addSubview:self.rightArrow];
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(10);
        make.right.mas_offset(-10);
    }];
    
    self.groupAnnounceLabel = [[UILabel alloc] init];
    self.groupAnnounceLabel.font = [UIFont systemFontOfSize:13.f];
    self.groupAnnounceLabel.textAlignment = NSTextAlignmentRight;
    self.groupAnnounceLabel.textColor = [UIColor colorWithHexString:@"000000"];
    [self.contentView addSubview:self.groupAnnounceLabel];
    self.groupAnnounceLabel.text = @"未设置";
    self.groupAnnounceLabel.numberOfLines = 2;
    [self.groupAnnounceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(remarkLabel.mas_right).offset(10);
        make.right.mas_offset(-25);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [self.contentView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
}

@end


@implementation PTUpdateAnnounceContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    self.backgroundColor = [UIColor whiteColor];
    
    self.announceLabel = [[UILabel alloc] init];
    self.announceLabel.font = [UIFont systemFontOfSize:13.f];
    self.announceLabel.textColor = SubTitleColor;
    [self.contentView addSubview:self.announceLabel];
    self.announceLabel.text = @" ";
    self.announceLabel.numberOfLines = 3;
    [self.announceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(10);
        make.right.mas_offset(-25);
    }];
    
    
    UIImageView *rightArrow = [[UIImageView alloc] init];
    rightArrow.translatesAutoresizingMaskIntoConstraints = NO;
    rightArrow.image = [UIImage imageNamed:@"rightarrow"];
    [self.contentView addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(10);
        make.right.mas_offset(-10);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [self.contentView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
}

@end
