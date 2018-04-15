//
//  SystemTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/20.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "SystemTableViewCell.h"

@interface SystemTableViewCell()
{
    UILabel *lineLable;


}
@end
@implementation SystemTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
//    _logoImageView = [[UIImageView alloc] init];
//    [self.contentView addSubview:_logoImageView];
//    _logoImageView.layer.borderColor = [UIColor tt_headBoderColor].CGColor;
//    _logoImageView.layer.borderWidth = 1;
//    _logoImageView.layer.cornerRadius = AdaptedWidth(50)/2;
//    _logoImageView.clipsToBounds = YES;
//    UIImage *logoImage = [UIImage imageNamed:@"name"];
//    [_logoImageView setImage:logoImage];
//
//    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(AdaptedHeight(8));
//        make.left.mas_offset(AdaptedWidth(10));
//        make.size.mas_offset(CGSizeMake(AdaptedWidth(50), AdaptedWidth(50)));
//        
//    }];
    
//    _redLable = [[UILabel alloc] init];
//    [self.contentView addSubview:_redLable];
//    _redLable.backgroundColor = [UIColor tt_redMoneyColor];
//    _redLable.layer.cornerRadius = AdaptedWidth(13)/2;
//    _redLable.clipsToBounds = YES;
//    _redLable.hidden = YES;
//    [_redLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_logoImageView.mas_top).offset(2);
//        make.left.equalTo(_logoImageView.mas_left).offset(AdaptedWidth(38));
//        make.size.mas_offset(CGSizeMake(AdaptedWidth(13), AdaptedWidth(13)));
//    }];
    
    
    
    //标题
    _titleLable = [UILabel configureLabelWithTextColor:CKYS_Color(46, 46, 46) textAlignment:NSTextAlignmentLeft font:MAIN_BoldTITLE_FONT];
    [self.contentView addSubview:_titleLable];
    
    //时间
    _timeLable = [UILabel configureLabelWithTextColor:CKYS_Color(155, 155, 155) textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [self.contentView addSubview:_timeLable];
    
    //内容
    _contentLable = [UILabel configureLabelWithTextColor:CKYS_Color(80, 80, 80) textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedHeight(13))];
    [self.contentView addSubview:_contentLable];
    //最底下的线
    lineLable = [UILabel creatLineLable];
    [self.contentView addSubview:lineLable];

    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(16));
        make.left.mas_offset(AdaptedWidth(15));
    }];
    
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLable.mas_top);
        make.left.equalTo(_titleLable.mas_right);
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    
    _contentLable.numberOfLines = 0;
    [_contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_titleLable.mas_left);
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLable.mas_bottom).offset(AdaptedHeight(16));
        make.bottom.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 1));
    }];

}
-(void)refreshWithModel:(MessageModel *)systeModel{
    NSString *titleStr = [NSString stringWithFormat:@"%@",systeModel.title];
    NSString *time = [NSString stringWithFormat:@"%@",systeModel.time];
    NSString *contentStr = [NSString stringWithFormat:@"%@",systeModel.msg];
    if (IsNilOrNull(titleStr)) {
       titleStr = @"";
    }
     _titleLable.text = titleStr;
    if (IsNilOrNull(time)) {
        time = @"";
    }
    _timeLable.text = time;
    if (IsNilOrNull(contentStr)) {
        contentStr = @"";
    }
    _contentLable.text = contentStr;
    
}
@end
