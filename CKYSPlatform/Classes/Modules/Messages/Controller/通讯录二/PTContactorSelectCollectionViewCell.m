//
//  PTContactorSelectCollectionViewCell.m
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/13.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "PTContactorSelectCollectionViewCell.h"

@interface PTContactorSelectCollectionViewCell()

@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation PTContactorSelectCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.headImageView.clipsToBounds = YES;
        self.headImageView.layer.cornerRadius = 5.f;
        self.headImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.headImageView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}

- (void)updateCellData:(PTContactorModel*)contactor {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:contactor.head] placeholderImage:[UIImage imageNamed:@"name"]];
}

@end
