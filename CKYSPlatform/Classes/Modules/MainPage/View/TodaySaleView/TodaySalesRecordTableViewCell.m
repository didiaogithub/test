//
//  CloudRecordTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/7.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "TodaySalesRecordTableViewCell.h"
@implementation TodaySalesRecordTableViewCell
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
    //左侧图标
    _leftImageView = [[UIImageView alloc] init];
    [bankView addSubview:_leftImageView];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankView.mas_top).offset(AdaptedHeight(20));
        make.left.equalTo(bankView.mas_left).offset(AdaptedWidth(15));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(25), AdaptedHeight(25)));
        make.bottom.mas_offset(-AdaptedHeight(20));
    }];
    //操作名称
    _operateLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(17))];
    [bankView addSubview:_operateLable];
   
    
    _leftLable = [UILabel configureLabelWithTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [bankView addSubview:_leftLable];
    
    //操作价钱
    _operatePriceLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(AdaptedWidth(17))];
    [bankView addSubview:_operatePriceLable];

    //时间
    _operateTimeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_SUBTITLE_FONT];
    [bankView addSubview:_operateTimeLable];
    
    
    
    //操作名称
    [_operateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankView.mas_top).offset(AdaptedHeight(10));
        make.left.equalTo(_leftImageView.mas_right).offset(AdaptedWidth(10));
    }];
    
    _leftLable.numberOfLines = 0;
    //订单号  流水号
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_operateLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_operateLable.mas_left);
        make.right.mas_offset(-AdaptedWidth(5));
        make.bottom.mas_offset(-AdaptedHeight(10));
    }];
    
    //价格
    [_operatePriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_operateLable.mas_top);
        make.right.mas_offset(-AdaptedWidth(10));
        
    }];
    
    //时间
    [_operateTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftLable.mas_top);
        make.right.equalTo(_operatePriceLable.mas_right);
        make.bottom.equalTo(_leftLable.mas_bottom);
    }];

}
- (void)refreshWithModel:(SalelistModel *)model
{
    
    NSString *money = [NSString stringWithFormat:@"%@",model.money];
    if (IsNilOrNull(money)) {
        money = @"¥0.00";
    }
    
    NSString *status = [NSString stringWithFormat:@"%@",model.status];
    if (IsNilOrNull(status)) {
        money = @"";
    }
    
    if ([self.typeString isEqualToString:@"1"]) {
        _operateLable.text = @"销售";
        [_leftImageView setImage:[UIImage imageNamed:@"salegreen"]];
        _operatePriceLable.textColor = TitleColor;
        _operatePriceLable.text = [NSString stringWithFormat:@"+¥%@",money];
    }else if ([self.typeString isEqualToString:@"2"]){
        _operateLable.text = @"退货";
        [_leftImageView setImage:[UIImage imageNamed:@"returnred"]];
        _operatePriceLable.textColor = [UIColor tt_redMoneyColor];
        _operatePriceLable.text = [NSString stringWithFormat:@"-¥%@",money];
    }else{
        if([status isEqualToString:@"2"] || [status isEqualToString:@"3"] || [status isEqualToString:@"6"] || [status isEqualToString:@"7"]){
            _operateLable.text = @"销售";
            [_leftImageView setImage:[UIImage imageNamed:@"salegreen"]];
            _operatePriceLable.textColor = TitleColor;
            _operatePriceLable.text = [NSString stringWithFormat:@"+¥%@",money];
        }else if([status isEqualToString:@"4"] || [status isEqualToString:@"5"]){
            _operateLable.text = @"退货";
            [_leftImageView setImage:[UIImage imageNamed:@"returnred"]];
            _operatePriceLable.textColor = [UIColor tt_redMoneyColor];
            _operatePriceLable.text = [NSString stringWithFormat:@"-¥%@",money];
        }
    
    
    }
  
    NSString *no = [NSString stringWithFormat:@"%@",model.no];
    if (IsNilOrNull(no)) {
        no = @"";
    }
    _leftLable.text = [NSString stringWithFormat:@"订单号:%@",no];
    
    
    NSString *time = [NSString stringWithFormat:@"%@",model.time];
    if (IsNilOrNull(time)) {
        time = @"";
    }
    _operateTimeLable.text = [NSString stringWithFormat:@"%@",time];

}

@end
