//
//  MyHonourCollectionViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/28.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "MyHonourCollectionViewCell.h"

@implementation MyHonourCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    
    self.backgroundColor = [UIColor tt_lineBgColor];
    _bankGroundImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_bankGroundImageView];
    [_bankGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(1);
        make.right.bottom.mas_offset(-1);
    }];
}

-(void)refreshWithArray:(NSMutableArray *)honourArray anTag:(NSInteger)index{
    NSString *string = honourArray[index];
    NSString *picUrl = [NSString loadImagePathWithString:string];
    [_bankGroundImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"waithhonour"]];
}


@end
