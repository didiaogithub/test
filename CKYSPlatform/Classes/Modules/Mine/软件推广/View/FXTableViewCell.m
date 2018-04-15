//
//  FXTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/14.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "FXTableViewCell.h"

@implementation FXTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTopViews];
    }
    return self;
}
-(void)createTopViews{
    
    
//    UILabel *line = [[UILabel alloc] init];
//    [self.contentView addSubview:line];
//    line.backgroundColor = AllSeperoteLineColor;
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(0);
//        make.left.mas_offset(0);
//        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 1));
//        
//    }];
    
    _firstLab = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_SUBTITLE_FONT];
    [self.contentView addSubview:_firstLab];
    
    _secondLab = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_SUBTITLE_FONT];
    [self.contentView addSubview:_secondLab];
    
    
    _threenLab = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_SUBTITLE_FONT];
    [self.contentView addSubview:_threenLab];
    

    _fourView = [[UIView alloc] init];
    [self.contentView addSubview:_fourView];
    
    _detailButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_fourView addSubview:_detailButton];
    _detailButton.tag = 2220;
    _detailButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    
    _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fourView addSubview:_phoneButton];
    _phoneButton.tag = 2221;
    [_phoneButton setImage:[UIImage imageNamed:@"打电话"] forState:UIControlStateNormal];
    
    
    
    
    float width = (SCREEN_WIDTH - 170)/2;
    
    [_firstLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(70*SCREEN_WIDTH_SCALE, 15));
        make.bottom.mas_offset(-15);
        
    }];
    
    [_secondLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstLab.mas_top);
        make.left.equalTo(_firstLab.mas_right);
        make.bottom.mas_offset(-15);
        make.size.mas_offset(CGSizeMake(width, 15));
    }];
    
    
    [_threenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstLab.mas_top);
        make.left.equalTo(_secondLab.mas_right);
        make.bottom.mas_offset(-15);
        make.size.mas_offset(CGSizeMake(width, 15));
    }];
    
    _threenLab.textColor = [UIColor tt_redMoneyColor];

    [_fourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(_threenLab.mas_right);
        make.width.mas_offset(90*SCREEN_WIDTH_SCALE);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fourView.mas_top);
        make.left.equalTo(_fourView.mas_left).offset(15);
        make.bottom.mas_offset(0);
        make.size.mas_offset(CGSizeMake(30*SCREEN_WIDTH_SCALE, 45));
    }];
    [_detailButton setTitle:@"详情" forState:UIControlStateNormal];
    
    //电话
    [_phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailButton.mas_top);
        make.left.equalTo(_detailButton.mas_right).offset(5);
        make.bottom.mas_offset(0);
        make.right.mas_offset(-15);
        make.size.mas_offset(CGSizeMake(30*SCREEN_WIDTH_SCALE, 45));
        
    }];
    
    
    
    [_detailButton addTarget:self action:@selector(clickDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    [_phoneButton addTarget:self action:@selector(clickDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lineLable = [UILabel creatLineLable];
    [self.contentView addSubview:lineLable];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(39);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 1));
        make.bottom.mas_offset(0);
        
    }];
}
-(void)refreshWithListModel:(MyTeamListModel *)teamListmodel{

    NSString *name = [NSString stringWithFormat:@"%@",teamListmodel.name];
    NSString *mobile = [NSString stringWithFormat:@"%@",teamListmodel.mobile];
    if (IsNilOrNull(name)) {
        _firstLab.text = @"";
    }else{
        _firstLab.text = name;
    }
    if (IsNilOrNull(mobile)) {
        _secondLab.text = @"";
    }else{
        _secondLab.text = mobile;
    }
    NSString *totalPerf = [NSString stringWithFormat:@"%@",teamListmodel.totalPerf];
    if (IsNilOrNull(totalPerf)) {
        _threenLab.text = @"¥0.00";
    }else{
        _threenLab.text = [NSString stringWithFormat:@"¥%@",totalPerf];
    }
}
-(void)clickDetailButton:(UIButton *)button{
    if (self.delegate  && [self.delegate respondsToSelector:@selector(clickMyTeamButtonTag:andIndex:)]) {
        [self.delegate clickMyTeamButtonTag:button.tag andIndex:self.index];
    }
    
}


@end
