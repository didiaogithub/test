//
//  FinalTeamTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/10.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "FinalTeamTableViewCell.h"
@interface FinalTeamTableViewCell ()
{
    UILabel *_leftSalesText;

}
@end
@implementation FinalTeamTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTopViews];
    }
    return self;
}
-(void)createTopViews{
    _bankView = [[UIView alloc] init];
    [self.contentView addSubview:_bankView];
    [_bankView setBackgroundColor:[UIColor whiteColor]];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(5));
        make.left.right.bottom.mas_offset(0);
    }];

    //上面的View
    _topCotentView = [[UIView alloc] init];
    [_bankView addSubview:_topCotentView];
    [_topCotentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(AdaptedHeight(120));
        self.aConstrain = make.bottom.mas_equalTo(0);
    }];
    _headImageView = [[UIImageView alloc] init];
    [_topCotentView addSubview:_headImageView];
    [_headImageView setImage:[UIImage imageNamed:@"name"]];
    _headImageView.layer.cornerRadius = AdaptedWidth(40)/2;
    _headImageView.clipsToBounds = YES;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(20));
        make.left.mas_offset(AdaptedWidth(15));
        make.width.mas_offset(AdaptedWidth(40));
        make.height.mas_offset(AdaptedWidth(40));
    }];

    
    //收件人
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_topCotentView addSubview:_nameLable];
    _nameLable.text = @"收件人:";
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.equalTo(_headImageView.mas_right).offset(AdaptedWidth(15));
        make.right.mas_offset(-AdaptedWidth(65));
    }];
    
    //收件人电话
    _phoneLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    _phoneLable.text = @"收件人电话:";
    [_topCotentView addSubview:_phoneLable];
    [_phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_nameLable.mas_left);
    }];

    //招商人数
    _attractiveLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_topCotentView addSubview:_attractiveLable];
    _attractiveLable.text = @"销售礼包数:";
    [_attractiveLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_nameLable.mas_left);
    }];
    
    _leftSalesText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_topCotentView addSubview:_leftSalesText];
    _leftSalesText.text = @"个人业绩:";
    [_leftSalesText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_attractiveLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_attractiveLable.mas_left);
        make.bottom.mas_offset(-AdaptedHeight(15));
        make.height.mas_offset(15);
    }];
    
    
    //个人业绩
    _salesMoneyLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_BODYTITLE_FONT];
    [_topCotentView addSubview:_salesMoneyLable];
    [_salesMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_attractiveLable.mas_bottom).offset(AdaptedHeight(3));
        make.left.equalTo(_leftSalesText.mas_right);
        make.right.equalTo(_nameLable.mas_right);
        make.bottom.equalTo(_leftSalesText.mas_bottom).offset(AdaptedHeight(5));
    }];
    
    //拨打收件人电话按钮
    _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topCotentView addSubview:_phoneButton];
    [_phoneButton setImage:[UIImage imageNamed:@"phoneicon"] forState:UIControlStateNormal];
    [_phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.right.mas_offset(-AdaptedWidth(40));
        make.width.mas_offset(AdaptedWidth(20));
        make.height.mas_offset(AdaptedHeight(20));
    }];
    [_phoneButton addTarget:self action:@selector(clickPhoneButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    //点击弹出的View
    self.detailContentView = [[UIView alloc] init];
    [_bankView addSubview:self.detailContentView];
    self.detailContentView.hidden = YES;
    [self.detailContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topCotentView.mas_bottom);
        self.bConstrain = make.bottom.mas_equalTo(0);
    }];

    _bottomLine = [UILabel creatLineLable];
    [self.detailContentView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_offset(0);
        make.height.mas_offset(1);
    }];
    
        //进货总计
        _stopupTotalLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
        [self.detailContentView addSubview:_stopupTotalLable];
        _stopupTotalLable.text = @"进货总计¥0.00";
        [_stopupTotalLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomLine.mas_bottom).offset(AdaptedHeight(10));
            make.left.equalTo(_nameLable.mas_left);
            make.right.mas_offset(-AdaptedWidth(10));
        }];
        
        //推广总计
        _attractiveTotalLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
        [self.detailContentView addSubview:_attractiveTotalLable];
        _attractiveTotalLable.text = @"销售礼包总计:¥0.00";
        [_attractiveTotalLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_stopupTotalLable.mas_bottom).offset(AdaptedHeight(5));
            make.left.equalTo(_stopupTotalLable.mas_left);
            make.right.equalTo(_stopupTotalLable.mas_right);
        }];
    
    
         //开店时间
        _joinTimeLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
        [self.detailContentView addSubview:_joinTimeLable];
        _joinTimeLable.text = @"开店时间:";
        [_joinTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_attractiveTotalLable.mas_bottom).offset(AdaptedHeight(5));
            make.left.equalTo(_attractiveTotalLable.mas_left);
            make.right.equalTo(_attractiveTotalLable.mas_right);
            make.bottom.mas_offset(-AdaptedHeight(10));
        }];
}
-(void)clickPhoneButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMyTeamButtonWithIndex:)]) {
        [self.delegate clickMyTeamButtonWithIndex:self.index];
    }

}
-(void)refreshWithListModel:(MyTeamListModel *)teamListModel andOpen:(BOOL)isOpen{
    
    if (isOpen) {  //展开
        self.detailContentView.hidden = NO;
        [self.aConstrain uninstall];
        [self.bConstrain install];
    } else {  //收起
        self.detailContentView.hidden = YES;
        [self.bConstrain uninstall];
        [self.aConstrain install];
    }

    NSLog(@"--------%d",isOpen);
    NSString *logopath = [NSString stringWithFormat:@"%@",teamListModel.logopath];
     NSString *picUrl = [NSString loadImagePathWithString:logopath];
    
     [_headImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"name"]];
    
    NSString *realname = [NSString stringWithFormat:@"%@",teamListModel.realname];
    if (IsNilOrNull(realname)) {
        realname = @"";
    }
    
    NSString *typestr = nil;
    NSString *jointype = [NSString stringWithFormat:@"%@",teamListModel.jointype];
    if (IsNilOrNull(jointype)) {
        jointype = @"";
    }
    if([jointype isEqualToString:@"SURE"]){
        typestr = @"创客礼包";
    }else if([jointype isEqualToString:@"NOTSURE"]){
        typestr = @"低风险礼包";
    }else if ([jointype isEqualToString:@"GROUP"]){
        typestr = @"金凤";
    }else{
        typestr = @"";
    }
    _nameLable.text = [NSString stringWithFormat:@"收件人：%@(%@)",realname,typestr];
   
    //收件人电话
    NSString *mobile = [NSString stringWithFormat:@"%@",teamListModel.mobile];
    if (IsNilOrNull(mobile)) {
        mobile  = @"";
    }
    _phoneLable.text = [NSString stringWithFormat:@"收件人电话：%@",mobile];
    
    //招商人数
    NSString *teamNum = [NSString stringWithFormat:@"%@",teamListModel.teamNum];
    if(IsNilOrNull(teamNum)){
       teamNum = @"";
    }
    _attractiveLable.text = [NSString stringWithFormat:@"销售礼包数:%@",teamNum];
    
    //个人业绩： totalPerf
    NSString *totalPerf = [NSString stringWithFormat:@"%@",teamListModel.totalPerf];
    if(IsNilOrNull(totalPerf)){
        totalPerf = @"0.00";
    }
    double totalPerfFloat = [totalPerf doubleValue];
    _salesMoneyLable.text = [NSString stringWithFormat:@"¥%.2f",totalPerfFloat];

    //展开数据
    //进货总计
    NSString *jhpref = [NSString stringWithFormat:@"%@",teamListModel.jhPerf];
    NSString *zspref = [NSString stringWithFormat:@"%@",teamListModel.zsPerf];
    if (IsNilOrNull(jhpref)) {
        jhpref = @"";
    }
    if (IsNilOrNull(zspref)) {
        zspref = @"";
    }
    double jhpreffloat = [jhpref doubleValue];
    double zspreffloat = [zspref doubleValue];
    
    _stopupTotalLable.text = [NSString stringWithFormat:@"进货总计:%.2f",jhpreffloat];
    //推广总计
    _attractiveTotalLable.text = [NSString stringWithFormat:@"销售礼包总计:%.2f",zspreffloat];
    
    NSString *jointime = [NSString stringWithFormat:@"%@",teamListModel.jointime];
    if(IsNilOrNull(jointime)){
        jointime = @"";
    }
    _joinTimeLable.text = [NSString stringWithFormat:@"开店时间:%@",jointime];
    
}

#if 0
// 使用自动计算高度工具
// If you are not using auto layout, override this method
- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat totalHeight = 0;
    totalHeight += [self.bankView sizeThatFits:size].height;
    totalHeight += 12; // margins
    return CGSizeMake(size.width, totalHeight);
}

#endif


@end
