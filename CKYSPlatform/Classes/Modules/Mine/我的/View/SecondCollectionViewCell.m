//
//  SecondCollectionViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SecondCollectionViewCell.h"

@implementation SecondCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    _topImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_topImageView];
    _topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.mas_offset(AdaptedWidth(20));
//        make.width.mas_offset(20);
        make.right.mas_offset(-AdaptedWidth(20));
        make.height.mas_offset(AdaptedHeight(20));
    }];
    
    _bottomLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_NAMETITLE_FONT];
    [self.contentView addSubview:_bottomLable];
    [_bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topImageView.mas_bottom).offset(AdaptedHeight(8));
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-AdaptedHeight(15));
    }];
}

-(void)refreshWithCell:(NSArray *)imageArr andTitleArr:(NSArray *)titleArr andIndex:(NSInteger)index{
    NSString *titleStr = titleArr[index];
    NSString *imageStr = imageArr[index];
    [_topImageView setImage:[UIImage imageNamed:imageStr]];
    _bottomLable.text = titleStr;
}

@end
