//
//  TakeCashRecordTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/5/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "TakeCashRecordTableViewCell.h"

@implementation TakeCashRecordTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-AdaptedHeight(10));
        make.left.right.top.mas_offset(0);
    }];
    
    //申请时间
    _timeLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_timeLable];
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(40));
        make.right.mas_offset(-AdaptedWidth(10));
        make.height.mas_offset(AdaptedHeight(15));
    }];
    
    //提现金额
    _takeCashMoneyLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_takeCashMoneyLable];
    [_takeCashMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.right.height.equalTo(_timeLable);
    }];
    //银行卡
    _cardLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_cardLable];
    [_cardLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_takeCashMoneyLable.mas_bottom).offset(AdaptedHeight(8));
         make.left.right.height.equalTo(_timeLable);
    }];
    //提现状态
    _statusLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_statusLable];
    [_statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cardLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.right.height.equalTo(_timeLable);
        self.aConstrain = make.bottom.mas_equalTo(-AdaptedHeight(10));
    }];
    //失败原因
    _becauseLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_becauseLable];
    [_becauseLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_statusLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.right.height.equalTo(_timeLable);
        make.bottom.mas_offset(-AdaptedHeight(10));
    }];
   

}
-(void)refreshWithRecordDetailModel:(TakeCashRecordDetailModel *)recordModel{
    
    NSString *timeStr = [NSString stringWithFormat:@"%@",recordModel.time];
    if (IsNilOrNull(timeStr)){
        timeStr = @"";
    }
    _timeLable.text =  [NSString stringWithFormat:@"申请时间:%@",timeStr];
    //提现金额
    NSString *takeMoneyStr = [NSString stringWithFormat:@"%@",recordModel.money];
    if (IsNilOrNull(takeMoneyStr)){
        takeMoneyStr = @"";
    }
    _takeCashMoneyLable.text =  [NSString stringWithFormat:@"提现金额:%@",takeMoneyStr];
    
    //银行卡
    NSString *cardNameStr = [NSString stringWithFormat:@"%@",recordModel.bankname];
    NSString *cardNoStr = [NSString stringWithFormat:@"%@",recordModel.bankcardno];
    if (IsNilOrNull(cardNameStr)){
        cardNameStr = @"";
    }
    if (IsNilOrNull(cardNoStr)){
        cardNoStr = @"";
    }
    _cardLable.text = [NSString stringWithFormat:@"银 行 卡:%@********%@",cardNameStr,cardNoStr];
    // 转换成可变字符串

    //提现状态  processing success fail
    NSString *string = nil;
    NSString *statusStr = [NSString stringWithFormat:@"%@",recordModel.status];
    if (IsNilOrNull(statusStr)){
        statusStr = @"";
    }
    
    if([statusStr isEqualToString:@"processing"]){
       string = @"正在审核中";
        [self.aConstrain install];
         _becauseLable.hidden = YES;
    }else if ([statusStr isEqualToString:@"success"]){
       string = @"成功";
        [self.aConstrain install];
        _becauseLable.hidden = YES;
    }else if ([statusStr isEqualToString:@"fail"]){
        string = @"审核失败";
        [self.aConstrain uninstall];
        _becauseLable.hidden = NO;
    }
    _statusLable.text =  [NSString stringWithFormat:@"提现状态:%@",string];
    
    
    NSString *becauseStr = [NSString stringWithFormat:@"%@",recordModel.info];
    if (IsNilOrNull(becauseStr)){
        becauseStr = @"";
    }
    _becauseLable.text = [NSString stringWithFormat:@"失败原因:%@",becauseStr];

}
@end
