//
//  PTGroupMemberCollectionViewCell.m
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/13.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "PTGroupMemberCollectionViewCell.h"

@interface PTGroupMemberCollectionViewCell()

@property (nonatomic, strong) UIImageView *headImageView;


@end

@implementation PTGroupMemberCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headImageView.clipsToBounds = YES;
    _headImageView.layer.cornerRadius = 5.f;
    [_headImageView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(55);
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"";
    _nameLabel.textColor = [UIColor colorWithHexString:@"#959595"];
    [_nameLabel setFont:[UIFont systemFontOfSize:13]];
    [_nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_bottom).offset(4);
        make.left.right.bottom.mas_offset(0);
    }];
}

- (void)updateCellData:(PTContactorModel*)userModel {

    self.userId = userModel.meid;
    if (!IsNilOrNull(userModel.remark)) {
        self.nameLabel.text = userModel.remark;
    }else{
        if (!IsNilOrNull(userModel.name)) {
            self.nameLabel.text = userModel.name;
        }else{
            self.nameLabel.text = @"";
        }
    }
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.head] placeholderImage:[UIImage imageNamed:@"name"]];
}



@end
