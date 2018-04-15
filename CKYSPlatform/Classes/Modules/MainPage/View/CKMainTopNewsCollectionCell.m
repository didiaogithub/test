//
//  CKMainTopNewsCollectionCell.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/8/16.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKMainTopNewsCollectionCell.h"

@implementation CKMainTopNewsCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _bestNewImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_bestNewImageView];
    [_bestNewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

-(void)refreshWithCell:(NSMutableArray *)imageArr andIndex:(NSInteger)index{
    NSString *imsgeUrl = imageArr[index];
    NSString *picUrl = [NSString loadImagePathWithString:imsgeUrl];
    
    [_bestNewImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"waitclass"]];
    
}

@end
