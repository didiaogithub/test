//
//  CloudRecordTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/7.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "MyResultsRecordTableViewCell.h"
@implementation MyResultsRecordTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(1.5);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    //操作价钱
    _operatePriceLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(AdaptedWidth(17))];
    [bankView addSubview:_operatePriceLable];

    //时间
    _operateTimeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(AdaptedWidth(12))];
    [bankView addSubview:_operateTimeLable];
    
    
    _orderLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(12))];
    [bankView addSubview:_orderLable];


    //价格
    [_operatePriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(10));
        
    }];
    
    //时间
    [_operateTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_operatePriceLable.mas_top);
        make.right.mas_offset(-AdaptedWidth(10));
    }];

    //订单号  流水号
    [_orderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_operatePriceLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_operatePriceLable.mas_left);
        make.right.mas_offset(-AdaptedWidth(10));
        make.bottom.mas_offset(-AdaptedHeight(10));
    }];
    
   
}
- (void)refreshWithModel:(MyTeamListModel *)listModel
{
    
    NSString *money = [NSString stringWithFormat:@"%@",listModel.money];
    if (IsNilOrNull(money)) {
        money = @"0.00";
    }
    double recharegeMoney = [money doubleValue];
    _operatePriceLable.text = [NSString stringWithFormat:@"+¥%.2f",recharegeMoney];
    
    NSString *paytn = [NSString stringWithFormat:@"%@",listModel.paytn];
    if (IsNilOrNull(paytn)) {
        _orderLable.text = @"内转";
    }else{
       _orderLable.text = [NSString stringWithFormat:@"支付流水号:%@",paytn];
    }
    
    NSString *time = [NSString stringWithFormat:@"%@",listModel.time];
    if (IsNilOrNull(time)) {
        time = @"";
    }
    _operateTimeLable.text = [NSString stringWithFormat:@"%@",time];

}

@end
