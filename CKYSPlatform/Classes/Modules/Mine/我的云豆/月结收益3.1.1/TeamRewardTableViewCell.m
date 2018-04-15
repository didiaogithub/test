//
//  TeamRewardTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/9.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "TeamRewardTableViewCell.h"
@interface TeamRewardTableViewCell ()
{
    UIImageView *_teamImageView;
    UILabel *_teamText;
    UILabel *_teamAttractText;
}

@end
@implementation TeamRewardTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTopViews];
    }
    return self;
}
-(void)createTopViews{
    UIView *teamView = [[UIView alloc] init];
    [self.contentView addSubview:teamView];
    [teamView setBackgroundColor:[UIColor whiteColor]];
    [teamView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    //团队图标
    _teamImageView = [[UIImageView alloc] init];
    [teamView addSubview:_teamImageView];
    _teamImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_teamImageView setImage:[UIImage imageNamed:@"teamsale"]];
    
    //************************销售业绩布局**************************
    UILabel *saleText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(12))];
    [teamView addSubview:saleText];
    saleText.text = @"销售业绩";
    //销售业绩
    _teamAchieveLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedHeight(16))];
    [teamView addSubview:_teamAchieveLable];
    _teamAchieveLable.text = @"0.00";

    
    UILabel *lineLable = [UILabel creatLineLable];
    [teamView addSubview:lineLable];
    
    
    //团队进货
    _teamText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(12))];
    [teamView addSubview:_teamText];
    _teamText.text = @"产品销售";
    //团队进货总值
    _teamGoodsLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(AdaptedHeight(14))];
    [teamView addSubview:_teamGoodsLable];
    _teamGoodsLable.text = @"0.00";

    //团队进货按钮
    _teamGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [teamView addSubview:_teamGoodsButton];
    _teamGoodsButton.tag = 1213;
    
    UILabel *verticalLable = [UILabel creatLineLable];
    [teamView addSubview:verticalLable];
    
    //团队招商
    _teamAttractText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(12))];
    [teamView addSubview:_teamAttractText];
    _teamAttractText.text = @"创客礼包销售";
    //团队招商总值
    _teamAttractLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(AdaptedHeight(14))];
    [teamView addSubview:_teamAttractLable];
    _teamAttractLable.text = @"0.00";

    //团队招商按钮
    _teamAttractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [teamView addSubview:_teamAttractButton];
    _teamAttractButton.tag = 1214;
    
    //坐标
    [_teamImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.mas_offset(AdaptedWidth(10));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(28), AdaptedHeight(28)));
    }];
    [saleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.equalTo(_teamImageView);
        make.left.equalTo(_teamImageView.mas_right).offset(AdaptedWidth(8));
    }];
    //销售业绩
    [_teamAchieveLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(saleText);
        make.right.mas_offset(-AdaptedWidth(15));
    }];
    
    
    //中间的横线
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_teamImageView.mas_bottom).offset(AdaptedHeight(15));
        make.left.right.mas_offset(0);
        make.height.mas_offset(1);
    }];
    //团队进货
    [_teamText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLable.mas_bottom).offset(AdaptedHeight(20));
        make.left.mas_offset(AdaptedWidth(10));
        make.bottom.mas_offset(-AdaptedHeight(20));
    }];
    //团队进货数值
    [_teamGoodsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_teamText);
        make.left.equalTo(_teamText.mas_right);
        make.right.mas_offset(-(SCREEN_WIDTH/2+AdaptedWidth(15)));
    }];
    
    [_teamGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLable.mas_bottom);
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH/2);
        make.bottom.mas_offset(0);
    }];
    [_teamGoodsButton addTarget:self action:@selector(clickTeamButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [verticalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLable.mas_bottom).offset(AdaptedHeight(7));
        make.left.mas_offset(SCREEN_WIDTH/2-0.5);
        make.height.mas_offset(AdaptedHeight(40));
        make.width.mas_offset(1);
    }];
    
    //团队招商
    [_teamAttractText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.equalTo(_teamText);
        make.left.equalTo(verticalLable.mas_right).offset(AdaptedWidth(3));
        
    }];
    //团队招商数值
    [_teamAttractLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_teamGoodsLable.mas_top);
        make.left.equalTo(_teamAttractText.mas_right);
        make.right.mas_offset(-AdaptedWidth(15));
        make.width.equalTo(_teamGoodsLable.mas_width);
    }];
    [_teamAttractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.bottom.width.equalTo(_teamGoodsButton);
        make.right.mas_offset(0);
    }];

    [_teamAttractButton addTarget:self action:@selector(clickTeamButton:) forControlEvents:UIControlEventTouchUpInside];


}
-(void)refreshTeamWithModel:(MonthAccountModel *)monthModel{
    //团队收益
    NSString *totalPerfTeam = [NSString stringWithFormat:@"%@",monthModel.totalPerfTeam];
    if(IsNilOrNull(totalPerfTeam)) {
        totalPerfTeam = @"0.00";
 
    }
    double totalPerfTeamDouble = [totalPerfTeam doubleValue];
     _teamAchieveLable.text = [NSString stringWithFormat:@"%.2f",totalPerfTeamDouble];
    //团对进货
    NSString *rechargeTeam = [NSString stringWithFormat:@"%@",monthModel.rechargeTeam];
    if(IsNilOrNull(rechargeTeam)) {
        rechargeTeam = @"0.00";
    }
    double rechargeTeamDouble = [rechargeTeam doubleValue];
    _teamGoodsLable.text = [NSString stringWithFormat:@"%.2f",rechargeTeamDouble];
  
    //团队招商
    NSString *inviteTeam = [NSString stringWithFormat:@"%@",monthModel.inviteTeam];
    if(IsNilOrNull(inviteTeam)) {
        inviteTeam = @"0.00";
    }
    double inviteTeamDouble = [inviteTeam doubleValue];
    _teamAttractLable.text = [NSString stringWithFormat:@"%.2f",inviteTeamDouble];

}
-(void)clickTeamButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToTeamVCWithtag:)]) {
        [self.delegate pushToTeamVCWithtag:button.tag];
    }

}
@end
