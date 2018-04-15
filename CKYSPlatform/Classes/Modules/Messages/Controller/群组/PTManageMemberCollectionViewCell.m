//
//  PTManageMemberCollectionViewCell.m
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/13.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "PTManageMemberCollectionViewCell.h"

@implementation PTManageMemberCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.manageMemberView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.manageMemberView.image = [UIImage imageNamed:@"add_member"];
    self.manageMemberView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.manageMemberView];
    [self.manageMemberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(55);
    }];
    
}

@end
