//
//  LogistTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/21.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "DetailLogistTableViewCell.h"

@implementation DetailLogistTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTopViews];
    }
    return self;
}
-(void)createTopViews{
    
    float leftPaading = 30;
    
    // 初始化控件
    _verticalLable = [UILabel creatLineLable];
    [self.contentView addSubview:_verticalLable];
    _imageViewR = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageViewR];
    
    _latestLogistLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_latestLogistLable];
    _latestTimeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [self.contentView addSubview:_latestTimeLable];
    _bottomLable = [UILabel creatLineLable];
    [self.contentView addSubview:_bottomLable];
    
    // 布局
    [_verticalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(leftPaading);
        make.width.mas_offset(1);
    }];
    [_imageViewR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_verticalLable.mas_top).offset(20);
        make.left.mas_offset(25);
        make.size.mas_offset(CGSizeMake(10, 10));
    }];
    [_latestLogistLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageViewR.mas_top);
        make.left.mas_equalTo(_verticalLable.mas_right).offset(20);
        make.right.mas_equalTo(-20);
    }];
    [_latestTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_latestLogistLable.mas_bottom).offset(5);
        make.left.mas_equalTo(_latestLogistLable.mas_left);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-20);
    }];
    
    [_bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_latestTimeLable.mas_left);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];

    _latestLogistLable.numberOfLines = 0;
    _imageViewR.contentMode = UIViewContentModeScaleAspectFit;
    [_imageViewR setImage:[UIImage imageNamed:@"logist_grey"]];
}

+ (UILabel *)configureLabelWithTextColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment font:(float)size
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:size];
    return label;
}
-(void)refreshWithLogistModel:(LogistModel *)logistModel{
    NSString *logistMessage = [NSString stringWithFormat:@"%@",logistModel.info];
    NSString *time = [NSString stringWithFormat:@"%@",logistModel.time];
    if (IsNilOrNull(logistMessage)) {
        logistMessage = @"暂无物流消息";
    }
    if (IsNilOrNull(time)) {
        time = @"暂无物流消息";
    }
    _latestLogistLable.text = logistMessage;
    _latestTimeLable.text = time;

}
@end
