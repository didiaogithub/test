//
//  CKCHeaderTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/13.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "CKCHeaderTableViewCell.h"

@interface CKCHeaderTableViewCell()

@end

@implementation CKCHeaderTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.right.bottom.mas_offset(AdaptedWidth(0));
    }];
    
    //头条商品图标
     _goodsImageView = [[UIImageView alloc] init];
    [bankView addSubview:_goodsImageView];
    [_goodsImageView setImage:[UIImage imageNamed:@"waitnews"]];
    
    //头条主标题
    _titleLable = [UILabel configureLabelWithTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM_BOLD(AdaptedHeight(13))];
    _titleLable.numberOfLines = 2;
    [bankView addSubview:_titleLable];
    
    //头条副标题
    _subTitleLable = [UILabel configureLabelWithTextColor:[UIColor grayColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_subTitleLable];
    //头条时间
    _timeLable = [UILabel configureLabelWithTextColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [bankView addSubview:_timeLable];

    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(10));
        make.width.mas_offset(AdaptedWidth(180));
        make.height.mas_offset(AdaptedHeight(90));
        make.bottom.mas_offset(-AdaptedHeight(10));
        
    }];
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsImageView.mas_top);
        make.left.equalTo(_goodsImageView.mas_right).offset(AdaptedWidth(10));
        make.right.mas_offset(-10);
    }];
    
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLable.mas_bottom).offset(AdaptedHeight(5));
        make.left.equalTo(_titleLable.mas_left);
        make.bottom.equalTo(_goodsImageView.mas_bottom).offset(-AdaptedHeight(5));
        make.right.equalTo(_titleLable.mas_right);
    }];
   
}
-(void)refreshWithHeaderModel:(HeaderModel *)headerModel{
    
    NSString *title = [NSString stringWithFormat:@"%@",headerModel.title];
    NSString *time = headerModel.time;
    
    NSString *url = [NSString stringWithFormat:@"%@",headerModel.imgurl];
    NSString *picUrl = [NSString loadImagePathWithString:url];
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"waitnews"]];
    
    if (IsNilOrNull(title)) {
        title = @"";
    }
  
    if (IsNilOrNull(time)) {
        time = @"";
    }

    _titleLable.text = title;
    _timeLable.text = time;
    
}
@end
