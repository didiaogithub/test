//
//  BestNewsCollectionViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/5/2.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BestNewsCollectionViewCell.h"

@implementation BestNewsCollectionViewCell
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
        make.top.right.left.bottom.mas_offset(0);
        make.width.mas_offset(AdaptedWidth(250));
        make.height.mas_offset(AdaptedHeight(125));
    }];
}

-(void)refreshWithCell:(NSMutableArray *)imageArr andIndex:(NSInteger)index{
    NSString *imsgeUrl = imageArr[index];
    NSString *picUrl = [NSString loadImagePathWithString:imsgeUrl];
    
    [_bestNewImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"waitclass"]];
   
}
@end
