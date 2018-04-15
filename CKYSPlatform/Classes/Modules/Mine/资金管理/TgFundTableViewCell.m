//
//  TgFundTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/1/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "TgFundTableViewCell.h"

@implementation TgFundTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    //背景view
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    bankView.layer.cornerRadius = 5;
    bankView.backgroundColor = [UIColor whiteColor];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
        make.bottom.mas_offset(0);
    }];
    
    UILabel *lastLine = [UILabel creatLineLable];
    [bankView addSubview:lastLine];
    [lastLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH - 15);
        make.height.mas_offset(1);
        make.bottom.mas_offset(0);
    }];
    //左侧图标
    _leftImageView = [[UIImageView alloc] init];
    [bankView addSubview:_leftImageView];
    _leftImageView.image = [UIImage imageNamed:@"salegreen"];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.mas_offset(AdaptedWidth(10));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(25), AdaptedHeight(25)));
    }];
    //操作名称
    _operateLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_operateLable];
    _operateLable.text = @"零售";
    
    
    //操作价钱
    _operatePriceLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [bankView addSubview:_operatePriceLable];
    
    
    //订单号
    _orderNo_Lable = [UILabel configureLabelWithTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [bankView addSubview:_orderNo_Lable];
    
    //时间
    _operateTimeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_SUBTITLE_FONT];
    [bankView addSubview:_operateTimeLable];
    
    
    //操作名称
    [_operateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.equalTo(_leftImageView.mas_right).offset(AdaptedWidth(7));
    }];
    //价钱
    [_operatePriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_operateLable.mas_top);
        make.right.mas_offset(-AdaptedWidth(8));
        
    }];
    //订单号  流水号
    [_orderNo_Lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_operateLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_operateLable.mas_left);
        make.bottom.mas_offset(-AdaptedHeight(10));
    }];
    
    //时间
    [_operateTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderNo_Lable.mas_top);
        make.right.equalTo(_operatePriceLable.mas_right);
        make.bottom.mas_offset(-AdaptedHeight(10));
    }];
    

}
-(void)refreshFundWithModel:(OrderModel *)orderModel{
    
    NSString *orderstatus = [NSString stringWithFormat:@"%@",orderModel.orderstatus];
    if (IsNilOrNull(orderstatus)){
        orderstatus = @"";
    }
    if ([orderstatus isEqualToString:@"4"] || [orderstatus isEqualToString:@"5"]){
        _operateLable.text = @"退货";
        [_leftImageView setImage:[UIImage imageNamed:@"returnred"]];
    }else{
        _operateLable.text = @"零售";
        [_leftImageView setImage:[UIImage imageNamed:@"salegreen"]];
        
    }
    NSString *moneyStr = [NSString stringWithFormat:@"%@",orderModel.money];
    if (IsNilOrNull(moneyStr)) {
        moneyStr = @"";
    }
    if ([orderstatus isEqualToString:@"4"] || [orderstatus isEqualToString:@"5"]){
         _operatePriceLable.text = [NSString stringWithFormat:@"-¥%@",moneyStr];
        _operatePriceLable.textColor = [UIColor tt_redMoneyColor];
    }else{
        _operatePriceLable.text = [NSString stringWithFormat:@"+¥%@",moneyStr];
        _operatePriceLable.textColor = TitleColor;
    }
    
    NSString *orderNo_Str = [NSString stringWithFormat:@"%@",orderModel.no];
    if (IsNilOrNull(orderNo_Str)) {
        orderNo_Str = @"";
    }
    _orderNo_Lable.text = [NSString stringWithFormat:@"订单号:%@",orderNo_Str];
    NSString *timeStr = [NSString stringWithFormat:@"%@",orderModel.time];
    if (IsNilOrNull(timeStr)) {
        timeStr = @"";
    }
    _operateTimeLable.text = timeStr;
    
    
}


@end
