//
//  FirstCollectionViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "FirstCollectionViewCell.h"

@implementation FirstCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    float tohH = 0;
    if (iphone4) {
        tohH = AdaptedHeight(20);
    }else if(iphone5){
      tohH = AdaptedHeight(15);
    }else if(iphone6){
      tohH = AdaptedHeight(10);
    }else{
      tohH = AdaptedHeight(6);
    }
    _topImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_topImageView];
    _topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(tohH);
        make.left.mas_offset(AdaptedWidth(20));
        make.right.mas_offset(-AdaptedWidth(20));
//        make.height.mas_offset(AdaptedHeight(24));
        make.width.mas_offset(AdaptedWidth(24));
    }];

    _tgLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_NAMETITLE_FONT];
    [self.contentView addSubview:_tgLable];
    [_tgLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(29));
        make.left.right.mas_offset(0);
//        make.height.mas_offset(AdaptedHeight(20));
        make.bottom.mas_offset(-AdaptedHeight(5));
    }];
    

}
-(void)refreshWithCell:(NSArray *)imageArr andTitleArr:(NSArray *)titleArr andIndex:(NSInteger)index{
    NSString *imageStr = imageArr[index];
    [_topImageView setImage:[UIImage imageNamed:imageStr]];
    
    NSString *titleStr = titleArr[index];
    _tgLable.text = titleStr;
}

@end
