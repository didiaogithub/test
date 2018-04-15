//
//  CloudRecordTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/7.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "CloudRecordTableViewCell.h"
@implementation CloudRecordTableViewCell
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
        make.top.mas_offset(AdaptedHeight(20));
        make.left.equalTo(bankView.mas_left).offset(AdaptedWidth(15));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(30), AdaptedWidth(25)));
    }];
    //操作名称
    _operateLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_operateLable];
    
    //订单号 流水号  姓名
    _leftLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [bankView addSubview:_leftLable];
    
    //操作价钱
    _operatePriceLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(AdaptedWidth(15))];
    [bankView addSubview:_operatePriceLable];



    //时间
    _operateTimeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_NAMETITLE_FONT];
    [bankView addSubview:_operateTimeLable];

    
    //金凤创客才显示 提现锁定   以及是否 按钮
    _takecashlockLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [bankView addSubview:_takecashlockLable];
    
    _islockLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_NAMETITLE_FONT];
    [bankView addSubview:_islockLable];
    
    //操作名称
    [_operateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankView.mas_top).offset(AdaptedHeight(10));
        make.left.equalTo(_leftImageView.mas_right).offset(AdaptedWidth(15));
    }];
    //订单号  流水号 分销姓名
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_operateLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_operateLable.mas_left);
        make.height.mas_offset(15);
    }];
    //交易价格lable
    [_operatePriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(9));
        make.right.mas_offset(-AdaptedWidth(10));

    }];
    
    //以下是自动布局的
    [_operateTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_operatePriceLable.mas_bottom).offset(AdaptedHeight(8));
        make.right.equalTo(_operatePriceLable.mas_right);
        make.height.mas_offset(AdaptedHeight(15));
    }];
    
    //金凤创客  进账锁定
    [_takecashlockLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_operateTimeLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_leftLable.mas_left);
        make.bottom.mas_offset(-AdaptedHeight(8));
    }];
    //是否锁定
    [_islockLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_takecashlockLable.mas_top);
        make.left.equalTo(_takecashlockLable.mas_right);
        make.bottom.equalTo(_takecashlockLable.mas_bottom);
    }];
}

- (void)refreshWithModel:(YundouAndProductModel *)model {
    /**1：进账  -1：出账*/     //操作金额
    NSString *dir = [NSString stringWithFormat:@"%@",model.dir];
    
    NSString *moneyStr = [NSString stringWithFormat:@"%@",model.money];
    if (IsNilOrNull(moneyStr)) {
        moneyStr = @"0.00";
    }
    
    if([dir isEqualToString:@"-1"]){
        self.operatePriceLable.textColor = [UIColor tt_redMoneyColor];
        if ([moneyStr doubleValue] == 0) {
            self.operatePriceLable.text = [NSString stringWithFormat:@"¥%@",moneyStr];
        }else{
            self.operatePriceLable.text = [NSString stringWithFormat:@"-¥%@",moneyStr];
        }
    }else{
//       1锁定 0不锁
        NSString *isLock = [NSString stringWithFormat:@"%@",model.islock];
        if([isLock isEqualToString:@"1"]){ //锁定
            _takecashlockLable.text = @"提现锁定:";
            _islockLable.text = @"是";
            _islockLable.textColor = [UIColor darkGrayColor];
            _takecashlockLable.textColor = [UIColor darkGrayColor];
        }else{
            _takecashlockLable.text = @"";
            _islockLable.text = @"";
            _islockLable.textColor = [UIColor whiteColor];
            _takecashlockLable.textColor = [UIColor whiteColor];
        }
        self.operatePriceLable.textColor = TitleColor;
        if ([moneyStr doubleValue] == 0) {
            self.operatePriceLable.text = [NSString stringWithFormat:@"¥%@",moneyStr];
        }else{
            self.operatePriceLable.text = [NSString stringWithFormat:@"+¥%@",moneyStr];
        }
    }
    
    //操作记录
    NSString *operation  = [NSString stringWithFormat:@"%@",model.operation];
    if (IsNilOrNull(operation)) {
        operation = @"";
    }
    self.operateLable.text = operation;
    
    NSString *pythn = [NSString stringWithFormat:@"%@",model.paytn];
    if (IsNilOrNull(pythn)) {
        pythn = @"";
    }
    
    NSString *imageLeft = @"";
    if ([operation isEqualToString:@"零售"]){
        imageLeft = @"salegreen";
        if (IsNilOrNull(pythn)) {
            _leftLable.text = [NSString stringWithFormat:@"订单号:"];
        }else{
            _leftLable.text = [NSString stringWithFormat:@"订单号:wxuser%@", pythn];
        }
    }else if ([operation isEqualToString:@"优惠券"]){
        imageLeft = @"salered";
        if (IsNilOrNull(pythn)) {
            _leftLable.text = [NSString stringWithFormat:@"订单号:"];
        }else{
            _leftLable.text = [NSString stringWithFormat:@"订单号:wxuser%@", pythn];
        }
    }else if ([operation hasPrefix:@"社群"]){
        imageLeft = @"salegreen";
        if (IsNilOrNull(pythn)) {
            _leftLable.text = [NSString stringWithFormat:@"进货人:"];
        }else{
            _leftLable.text = [NSString stringWithFormat:@"进货人:%@", pythn];
        }
    }else if ([operation hasPrefix:@"产品进货"]){
        imageLeft = @"salered";
        _leftLable.text = @"";
    }else if ([operation isEqualToString:@"退货"]){
        imageLeft = @"returnred";
        if (IsNilOrNull(pythn)) {
            _leftLable.text = [NSString stringWithFormat:@"订单号:"];
        }else{
            _leftLable.text = [NSString stringWithFormat:@"订单号:wxuser%@",pythn];
        }
    }else if ([operation isEqualToString:@"进货"]){
        imageLeft = @"yzc";
        _leftLable.text = @"云豆内转";
    }else if([operation isEqualToString:@"分销"]){
        imageLeft = @"rechargegreen";
        if (IsNilOrNull(pythn)) {
            _leftLable.text = @"";
        }else{
            _leftLable.text = [NSString stringWithFormat:@"分销:%@", pythn];
        }
    }else if ([operation isEqualToString:@"月结"] || [operation isEqualToString:@"月结扣税"]) {
        imageLeft = @"monthgreen";
        _leftLable.text = @"";
    }else if ([operation isEqualToString:@"销售扣税"]) {
        if([dir isEqualToString:@"1"]){ //进账 绿色包包
            imageLeft = @"salegreen";
        }else{//出账 红色包包
            imageLeft = @"salered";
        }
        if (IsNilOrNull(pythn)) {
            _leftLable.text = [NSString stringWithFormat:@"订单号:"];
        }else{
            _leftLable.text = [NSString stringWithFormat:@"订单号:wxuser%@",pythn];
        }
    }else if ([operation isEqualToString:@"分销扣税"]) {
        if([dir isEqualToString:@"1"]){ //进账 绿色包包
            imageLeft = @"salegreen";
        }else{//出账 红色包包
            imageLeft = @"salered";
        }
        if (IsNilOrNull(pythn)) {
            _leftLable.text = @"";
        }else{
            _leftLable.text = [NSString stringWithFormat:@"分销:%@", pythn];
        }
    }else if ([operation isEqualToString:@"提现"]) {
        imageLeft = @"takecash";
        _leftLable.text = @"";
    }else if ([operation isEqualToString:@"创客礼包进货"]) {
        imageLeft = @"salered";
        _leftLable.text = [NSString stringWithFormat:@"订单号:%@", pythn];
    }else if ([operation isEqualToString:@"创客礼包推广"]){
        imageLeft = @"salegreen";
        _leftLable.text = [NSString stringWithFormat:@"订单号:%@", pythn];
    }else{
        if([dir isEqualToString:@"1"]){ //进账 绿色包包
            imageLeft = @"salegreen";
        }else{//出账 红色包包
            imageLeft = @"salered";
        }
        _leftLable.text = @"";
    }
    
    BOOL isUpdate = NO;
    if ([UIScreen mainScreen].bounds.size.height < 667) {
        if ([pythn length] > 8){
            isUpdate = YES;
        }
    }else{
        if ([pythn length] >= 18){
            isUpdate = YES;
        }
    }
    if (isUpdate){
    
        [_operateTimeLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_operatePriceLable.mas_bottom).offset(AdaptedHeight(31));
        }];
        [_leftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedHeight(30));
        }];
    }else{
        [_operateTimeLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_operatePriceLable.mas_bottom).offset(AdaptedHeight(8));
        }];
        [_leftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedHeight(15));
        }];
    }
    [_leftImageView setImage:[UIImage imageNamed:imageLeft]];
    //操作时间
    NSString *timestr = [NSString stringWithFormat:@"%@",model.time];;
    if (IsNilOrNull(timestr)) {
        timestr = @"";
    }
    self.operateTimeLable.text = timestr;
}

@end
