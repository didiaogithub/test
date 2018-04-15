//
//  PersonalRewardTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/9.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "PersonalRewardTableViewCell.h"
@interface PersonalRewardTableViewCell()
{
    UIImageView *_personalImageView;
    UILabel *_codeText;
    UILabel *_personalText;
    UILabel *_personalAttractText;
    UIImageView *_coefficientImageView;
}
@end
@implementation PersonalRewardTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTopViews];
    }
    return self;
}
-(void)createTopViews{
    UIView *personalView = [[UIView alloc] init];
    [self.contentView addSubview:personalView];
    [personalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    //店铺图标
    _personalImageView = [[UIImageView alloc] init];
    [personalView addSubview:_personalImageView];
    _personalImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_personalImageView setImage:[UIImage imageNamed:@"monthsmile"]];
    
    //左侧店铺
    UILabel *shopText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [personalView addSubview:shopText];
    shopText.text = @"店铺业绩";
    //店铺业绩
    _personalAchieveLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedHeight(16))];
    [personalView addSubview:_personalAchieveLable];
    _personalAchieveLable.text = @"¥0.00";
    
    //中间的横线
    UILabel *horizalLineLable = [UILabel creatLineLable];
    [personalView addSubview:horizalLineLable];
    
    
    //*************店铺进货总值*****************
    //店铺进货
    _personalText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(12))];
    [personalView addSubview:_personalText];
    _personalText.text = @"产品进货";
    _personalGoodsLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(AdaptedHeight(14))];
    [personalView addSubview:_personalGoodsLable];
    _personalGoodsLable.text = @"0.00";
    
    //进货按钮
    _personalGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _personalGoodsButton.tag = 1211;
    [personalView addSubview:_personalGoodsButton];
    
    //*************进货和招商中间  垂直的线*****************
    UILabel *verticalLine = [UILabel creatLineLable];
    [personalView addSubview:verticalLine];
    
    //**********************店铺招商创建UI*********************************
    _personalAttractText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(12))];
    [personalView addSubview:_personalAttractText];
    _personalAttractText.text = @"创客礼包推广";
    //店铺招商总值
    _personalAttractLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor]  textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(AdaptedHeight(14))];
    [personalView addSubview:_personalAttractLable];
    _personalAttractLable.text = @"0.00";
    
    //按钮
    _personalAttractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [personalView addSubview:_personalAttractButton];
    _personalAttractButton.tag = 1212;

    
    //第二条水平线
    UILabel *secondLineLable = [UILabel creatLineLable];
    [personalView addSubview:secondLineLable];
   
 //**********************奖励系数所有UI*********************************
    //本月团队奖励系数
    _codeText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_NAMETITLE_FONT];
    [personalView addSubview:_codeText];
    _codeText.text = @"本月产品销售奖励系数";
    
    //系数说明图
    _coefficientImageView = [[UIImageView alloc] init];
    [personalView addSubview:_coefficientImageView];
    _coefficientImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_coefficientImageView setImage:[UIImage imageNamed:@"monthcoefficient0"]];
    
    //具体奖励系数请查看
    UILabel *leftCoefficientLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentRight font:MAIN_NAMETITLE_FONT];
    [personalView addSubview:leftCoefficientLable];
    leftCoefficientLable.text = @"具体奖励系数请查看";
    
    
    //系数说明
    _coefficientButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [personalView addSubview:_coefficientButton];
    _coefficientButton.tag = 1210;
    [_coefficientButton setTitle:@"《产品销售奖励系数说明》" forState:UIControlStateNormal];
    _coefficientButton.titleLabel.font = MAIN_NAMETITLE_FONT;
    [_coefficientButton setTitleColor:[UIColor tt_blueColor] forState:UIControlStateNormal];
    

    //图标
    [_personalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.mas_offset(AdaptedWidth(10));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(28),AdaptedHeight(28)));
    }];
    
    [shopText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.equalTo(_personalImageView);
        make.left.equalTo(_personalImageView.mas_right).offset(AdaptedWidth(8));
        
    }];
    
    //店铺业绩
    [_personalAchieveLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.equalTo(shopText);
        make.right.mas_offset(-AdaptedWidth(15));
    }];
    //横线
    [horizalLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_personalImageView.mas_bottom).offset(AdaptedHeight(15));
        make.left.right.mas_offset(0);
        make.height.mas_offset(1);
    }];
    
  //**********************店铺进货所有UI*********************************
    //店铺进货
    [_personalText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizalLineLable.mas_bottom).offset(AdaptedHeight(20));
        make.left.mas_offset(AdaptedWidth(10));
        make.height.mas_offset(AdaptedHeight(15));
    }];
    //店铺进货数值
    [_personalGoodsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_personalText);
        make.right.mas_offset(-(SCREEN_WIDTH/2+AdaptedWidth(15)));
        make.left.equalTo(_personalText.mas_right);
    }];
    
    
    [_personalGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizalLineLable.mas_top);
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH/2);
        make.height.mas_offset(AdaptedHeight(54));
    }];
    [_personalGoodsButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(SCREEN_WIDTH/2-0.5);
        make.width.mas_offset(1);
        make.top.equalTo(horizalLineLable).offset(AdaptedHeight(7));
        make.height.mas_offset(AdaptedHeight(40));
    }];
    
    //**********************店铺招商所有UI*********************************
    //店铺招商
    [_personalAttractText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_personalText);
        make.left.equalTo(verticalLine.mas_right).offset(AdaptedWidth(3));
    }];
    
    //店铺招商数值
    [_personalAttractLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_personalGoodsLable.mas_top);
        make.right.mas_offset(-AdaptedWidth(15));
        make.left.equalTo(_personalAttractText.mas_right);
        make.width.equalTo(_personalGoodsLable.mas_width);
    }];
    
    [_personalAttractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(_personalGoodsButton);
        make.right.mas_offset(0);
    }];
    [_personalAttractButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [secondLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_personalText.mas_bottom).offset(AdaptedHeight(20));
        make.left.right.height.equalTo(horizalLineLable);
    }];
    
    //**********************系数相关布局*********************************
    float width = 0;
    if (iphone5){
        width = SCREEN_WIDTH/2-10;
    }else{
       width = SCREEN_WIDTH/2-20;
    }
 
    //系数值下面的文字
    [_codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLineLable.mas_bottom).offset(AdaptedHeight(59/2));
        make.left.mas_offset(AdaptedWidth(10));
        make.height.mas_offset(AdaptedHeight(15));
        make.width.mas_offset(width);
    }];
    
    [_coefficientImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(secondLineLable.mas_bottom).offset(AdaptedHeight(15));
        make.left.equalTo(_codeText.mas_right).offset(AdaptedWidth(5));
        make.right.mas_offset(-AdaptedWidth(10));
        make.height.mas_offset(AdaptedHeight(30));
    }];
    
    [leftCoefficientLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeText.mas_bottom).offset(AdaptedHeight(39/2));
        make.left.mas_offset(0);
        make.right.mas_offset(-SCREEN_WIDTH/2);
        make.height.mas_offset(AdaptedHeight(15));
        make.bottom.mas_offset(-AdaptedHeight(20));
    }];
   
    //查看系数说明
    [_coefficientButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(leftCoefficientLable);
        make.left.equalTo(leftCoefficientLable.mas_right);
    }];
    [_coefficientButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];



}
-(void)refreshPersonalWithModel:(MonthAccountModel *)monthModel{
    
    NSString *totalPerfCK = [NSString stringWithFormat:@"%@",monthModel.totalPerfCK];
    if (IsNilOrNull(totalPerfCK)) {
            //店铺业绩
        totalPerfCK = @"0.00";
     }
    double totalPerfCKDouble = [totalPerfCK doubleValue];
    _personalAchieveLable.text = [NSString stringWithFormat:@"%.2f",totalPerfCKDouble];
    
    NSString *inviteCK = [NSString stringWithFormat:@"%@",monthModel.inviteCK];
    if(IsNilOrNull(inviteCK)) { //店铺招商
        inviteCK = @"0.00";
    }
    double inviteCKDouble = [inviteCK doubleValue];
    _personalAttractLable.text = [NSString stringWithFormat:@"%.2f",inviteCKDouble];
    
    NSString *rechargeCK = [NSString stringWithFormat:@"%@",monthModel.rechargeCK];
    if (IsNilOrNull(rechargeCK)) {//店铺进货
       rechargeCK = @"0.00";
    }
    double rechargeCKDouble = [rechargeCK doubleValue];
     _personalGoodsLable.text = [NSString stringWithFormat:@"%.2f",rechargeCKDouble];
    
    NSString *modulus = [NSString stringWithFormat:@"%@",monthModel.modulus];
    if (IsNilOrNull(modulus)){
        modulus = @"0";
    }
    if ([modulus isEqualToString:@"0"]) {
        [_coefficientImageView setImage:[UIImage imageNamed:@"monthcoefficient0"]];
    }else if ([modulus isEqualToString:@"0.05"]){
       [_coefficientImageView setImage:[UIImage imageNamed:@"monthcoefficient5"]];
    }else if ([modulus isEqualToString:@"0.075"]){
        [_coefficientImageView setImage:[UIImage imageNamed:@"monthcoefficient75"]];
    }else if ([modulus isEqualToString:@"0.1"]){
        [_coefficientImageView setImage:[UIImage imageNamed:@"monthcoefficient10"]];
    }else{
       [_coefficientImageView setImage:[UIImage imageNamed:@"monthcoefficient0"]];
    }

}
/**点击查看系数说明*/
-(void)clickButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToVCWithtag:)]) {
        [self.delegate pushToVCWithtag:button.tag];
    }
}

@end
