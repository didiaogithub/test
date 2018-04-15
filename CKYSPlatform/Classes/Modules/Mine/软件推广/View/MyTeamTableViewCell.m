//
//  MyTeamTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/11.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "MyTeamTableViewCell.h"
@interface MyTeamTableViewCell ()
{
    UIView * bankView;

}
@end
@implementation MyTeamTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTopViews];
    }
    return self;
}
-(void)createTopViews{
    
    bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(5);
        make.left.right.bottom.mas_offset(0);
    }];
    
    _headImageView = [[UIImageView alloc] init];
    [bankView addSubview:_headImageView];
    [_headImageView setImage:[UIImage imageNamed:@"name"]];
    _headImageView.layer.cornerRadius = AdaptedWidth(40)/2;
    _headImageView.clipsToBounds = YES;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(30));
        make.left.mas_offset(AdaptedWidth(15));
        make.width.mas_offset(AdaptedWidth(40));
        make.height.mas_offset(AdaptedWidth(40));
    }];

    //第一行
    _firstLab = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_firstLab];
    [_firstLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.equalTo(_headImageView.mas_right).offset(AdaptedWidth(15));
        make.right.mas_offset(-AdaptedWidth(65));
    }];
    
    //第二行
    _secondLab = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_secondLab];
    [_secondLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstLab.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_firstLab.mas_left);
        make.right.equalTo(_firstLab.mas_right);
    }];
    
    //第三行
    _threenLab = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_threenLab];
    [_threenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secondLab.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_secondLab.mas_left);
        make.right.equalTo(_firstLab.mas_right);
    }];
    
    _textsaleLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_textsaleLable];

    [_textsaleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_threenLab.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_threenLab.mas_left);
        make.bottom.mas_offset(AdaptedHeight(-15));
        make.height.mas_offset(AdaptedHeight(15));
    }];
    
    
    //业绩
    _saleMoneyLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_BODYTITLE_FONT];
    [bankView addSubview:_saleMoneyLable];
    [_saleMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_threenLab.mas_bottom).offset(AdaptedHeight(3));
        make.left.equalTo(_textsaleLable.mas_right);
        make.right.equalTo(_firstLab.mas_right);
        make.bottom.equalTo(_textsaleLable.mas_bottom).offset(AdaptedHeight(5));
    }];
    
    //拨打收件人电话按钮
    _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_phoneButton];
    [_phoneButton setImage:[UIImage imageNamed:@"phoneicon"] forState:UIControlStateNormal];
    [_phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.width.mas_offset(AdaptedWidth(20));
        make.height.mas_offset(AdaptedHeight(20));
        make.right.mas_offset(-AdaptedWidth(40));
    }];
    [_phoneButton addTarget:self action:@selector(clickPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _firstLab.text = @"测试";
    _secondLab.text = @"测试：在哪";
    _threenLab.text = @"测试: 哈哈哈";
    
}
-(void)refreshWithListModel:(MyTeamListModel *)teamListModel{
    
    NSString *logopath = [NSString stringWithFormat:@"%@",teamListModel.logopath];
   NSString *picUrl = [NSString loadImagePathWithString:logopath];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"name"]];
    
    NSString *mobile = [NSString stringWithFormat:@"%@",teamListModel.mobile];
    NSString *smallName = [NSString stringWithFormat:@"%@",teamListModel.smallname];
    NSString *jointime = [NSString stringWithFormat:@"%@",teamListModel.jointime];
    NSString *name = [NSString stringWithFormat:@"%@",teamListModel.name];
    
    
    NSString *gettername = [NSString stringWithFormat:@"%@",teamListModel.gettername];
    NSString *gettermobile = [NSString stringWithFormat:@"%@",teamListModel.gettermobile];
    if (IsNilOrNull(gettername)){
        gettername = @"";
    }
    if (IsNilOrNull(gettermobile)){
        gettermobile = @"";
    }
    
    if (IsNilOrNull(name)){
        name = @"";
    }
    
    if (IsNilOrNull(smallName)) {
        smallName = @"";
    }
    //收件人电话
    if (IsNilOrNull(mobile)) {
        mobile  = @"";
    }
    if (IsNilOrNull(jointime)) {
        jointime  = @"";
    }
    
    NSString *totalPerf = [NSString stringWithFormat:@"%@",teamListModel.totalperf];
    if(IsNilOrNull(totalPerf)){
        totalPerf = @"0.00";
    }
    double totalPerfFloat = [totalPerf doubleValue];
    if ([self.typeString isEqualToString:@"1"]){//分销
            //收件人
      _firstLab.text = [NSString stringWithFormat:@"收件人:%@",name];
       
        //收件人电话
        _secondLab.text = [NSString stringWithFormat:@"收件人电话:%@",mobile];
        //开店时间
        _threenLab.text = [NSString stringWithFormat:@"开店时间:%@",jointime];
        _textsaleLable.text = @"进货总计:";
        //进货总计
        _saleMoneyLable.text = [NSString stringWithFormat:@"¥%.2f",totalPerfFloat];
        
    }else if ([self.typeString isEqualToString:@"2"]){//顾客
        //昵称
        _firstLab.text = [NSString stringWithFormat:@"昵称:%@",smallName];
    
        //收件人
        _secondLab.text = [NSString stringWithFormat:@"收件人:%@",gettername];
        //收件人收件人电话
        _threenLab.text = [NSString stringWithFormat:@"收件人收件人电话:%@",gettermobile];
        //累计消费
        _textsaleLable.text = @"累计消费:";
        //累计消费
        NSString *allm = [NSString stringWithFormat:@"%@",teamListModel.allm];
        if(IsNilOrNull(allm)){
            allm = @"0.00";
        }
        double allmFloat = [allm doubleValue];
        _saleMoneyLable.text = [NSString stringWithFormat:@"¥%.2f",allmFloat];
        
        NSString *logopath = [NSString stringWithFormat:@"%@",teamListModel.head];
        NSString *picUrl = [NSString loadImagePathWithString:logopath];
        
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"name"]];
    
    }else{  //3我的业绩
    
        [bankView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedHeight(1));
            make.bottom.mas_offset(-AdaptedHeight(10));
        }];
        [_headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedHeight(20));
            make.bottom.mas_offset(-AdaptedHeight(30));
        }];
        //头像
        NSString *logopath = [NSString stringWithFormat:@"%@",teamListModel.logopath];
        NSString *picUrl = [NSString loadImagePathWithString:logopath];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"name"]];
        //收件人 name jointype
        NSString *jointype = [NSString stringWithFormat:@"%@",teamListModel.jointype];
        if (IsNilOrNull(jointype)){
            jointype = @"";
        }
        NSString *joinTypeStr = nil;
        if ([jointype isEqualToString:@"SURE"]){
           joinTypeStr = @"创客礼包";
        }else if([jointype isEqualToString:@"NOTSURE"]){
           joinTypeStr = @"低风险礼包";
        }else if([jointype isEqualToString:@"GROUP"]){
           joinTypeStr = @"金凤";
        }else{
           joinTypeStr = @"";
        }
         _firstLab.text = [NSString stringWithFormat:@"收件人:%@(%@)",name,joinTypeStr];
        //收件人电话mobile
        _secondLab.text = [NSString stringWithFormat:@"收件人电话:%@",mobile];
        //开店时间jointime
        _threenLab.text = [NSString stringWithFormat:@"开店时间:%@",jointime];
        [_threenLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-AdaptedHeight(15));
        }];

    }
}
-(void)clickPhoneButton:(UIButton *)button{
    if (self.delegate  && [self.delegate respondsToSelector:@selector(clickMyTeamButtonWithIndex:)]) {
        [self.delegate clickMyTeamButtonWithIndex:self.index];
    }

}

@end
