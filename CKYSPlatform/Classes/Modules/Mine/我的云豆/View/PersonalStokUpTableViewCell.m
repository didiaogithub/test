//
//  PersonalStokUpTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/10.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "PersonalStokUpTableViewCell.h"

@implementation PersonalStokUpTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTypeStr:(NSString *)typeStr{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTopViewsWithStr:typeStr];
    }
    return self;
}
-(void)createTopViewsWithStr:(NSString *)typeStr{
    _personbankGroundView = [[UIView alloc] init];
    [self.contentView addSubview:_personbankGroundView];
    _personbankGroundView.backgroundColor = [UIColor whiteColor];
    [_personbankGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(-1);
    }];
    
    //名称
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [_personbankGroundView addSubview:_nameLable];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH/4);
        make.bottom.mas_offset(-AdaptedHeight(15));
    }];
 
    //金额
    _moneyLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_personbankGroundView addSubview:_moneyLable];
    _moneyLable.text =@"¥0.00";
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_nameLable);
        make.left.equalTo(_nameLable.mas_right);
    }];
    
    //时间
    _timeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [_personbankGroundView addSubview:_timeLable];
    if ([typeStr isEqualToString:@"1"]){ //个人进货

        [_timeLable setTextColor:SubTitleColor];
        [_timeLable setTextAlignment:NSTextAlignmentCenter];
        [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_nameLable);
            make.right.mas_offset(-AdaptedWidth(10));
        }];
        
    }else if ([typeStr isEqualToString:@"2"]){//团队进货
        [_timeLable setText:@"查看详情"];
        [_timeLable setTextColor:[UIColor tt_blueColor]];
        [_timeLable setTextAlignment:NSTextAlignmentRight];
        [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_nameLable);
            make.right.mas_offset(-AdaptedWidth(30));
        }];
    }
    
}
-(void)refreshWithModel:(RechargeAndAttactiveModel *)rechargeModel{
    
    
    NSString *paytype = [NSString stringWithFormat:@"%@",rechargeModel.paytype];
    if (IsNilOrNull(paytype)){
        paytype = @"";
    }
    
    NSString *nameStr = [NSString stringWithFormat:@"%@",rechargeModel.name];
    if (IsNilOrNull(nameStr)) {
        nameStr = @"";
    }
    NSString *moneyStr = [NSString stringWithFormat:@"%@",rechargeModel.money];
    if (IsNilOrNull(moneyStr)) {
        moneyStr = @"";
    }
   
    NSString *timeStr = [NSString stringWithFormat:@"%@",rechargeModel.time];
    if (IsNilOrNull(timeStr)) {
        timeStr = @"";
    }
    if ([self.typestr isEqualToString:@"1"]) {//个人进货
    _nameLable.text = paytype;
      _moneyLable.text = [NSString stringWithFormat:@"¥%@",moneyStr];
      _timeLable.text = timeStr;
    }else if ([self.typestr isEqualToString:@"2"]){ //团队进货
        _nameLable.text = nameStr;
        _moneyLable.text = [NSString stringWithFormat:@"¥%@",moneyStr];
        _timeLable.text = @"查看详情";
    }
    
}
@end
