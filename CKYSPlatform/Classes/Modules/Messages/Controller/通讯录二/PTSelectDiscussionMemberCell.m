//
//  PTSelectDiscussionMemberCell.m
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/9.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "PTSelectDiscussionMemberCell.h"


@interface PTSelectDiscussionMemberCell()



/**
 *  头像图片
 */
@property(nonatomic, strong) UIImageView *portraitImageView;



@end

@implementation PTSelectDiscussionMemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.selectedImageView = [UIImageView new];
    self.selectedImageView.image = [UIImage imageNamed:@"unselect"];
    [self.contentView addSubview:self.selectedImageView];
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(27);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(21);
    }];
    
    
    self.portraitImageView = [UIImageView new];
    self.portraitImageView.image = [UIImage imageNamed:@"name"];
    [self.contentView addSubview:self.portraitImageView];
    [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedImageView.mas_right).offset(8);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(40);
    }];
    
    
    self.nicknameLabel = [UILabel new];
    self.nicknameLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.nicknameLabel];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portraitImageView.mas_right).offset(8);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(40);
        make.right.mas_offset(-10);
    }];
}

- (void)updateCellWithModel:(PTContactorModel *)user {
    
    if (user) {
        if (!IsNilOrNull(user.remark)) {
            self.nicknameLabel.text = user.remark;
        }else{
            self.nicknameLabel.text = user.name;
        }
        [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:user.head] placeholderImage:[UIImage imageNamed:@"name"]];
    }
    self.portraitImageView.layer.masksToBounds = YES;
    self.portraitImageView.layer.cornerRadius = 40*0.5;
    self.portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        _selectedImageView.image = [UIImage imageNamed:@"select"];
    } else {
        _selectedImageView.image = [UIImage imageNamed:@"unselect"];
    }
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
