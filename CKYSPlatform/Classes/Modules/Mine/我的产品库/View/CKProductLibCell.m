//
//  CKProductLibCell.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKProductLibCell.h"

@interface CKProductLibCell ()
/**左侧图标*/
@property (nonatomic, strong) UIImageView *leftImageView;
/**操作名称*/
@property (nonatomic, strong) UILabel *operateLable;
/**操作价格*/
@property (nonatomic, strong) UILabel *operatePriceLable;
/**操作时间*/
@property (nonatomic, strong) UILabel *operateTimeLable;
/**点击查看详情按钮*/
@property (nonatomic, strong) UIButton *detailButton;
/**自提、零售、退货：订单号，进货：支付流水号or内转，分销进货：分销姓名*/
@property (nonatomic, strong) UILabel *leftLable;

@end

@implementation CKProductLibCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    
    self.backgroundColor = [UIColor whiteColor];
    UILabel *lineL = [UILabel creatLineLable];
    [self addSubview:lineL];
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    //左侧图标
    _leftImageView = [[UIImageView alloc] init];
    [self addSubview:_leftImageView];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.mas_offset(15);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(25);
    }];
    
    //操作名称
    _operateLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:_operateLable];
    [_operateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        if (iphone5) {
            make.left.mas_offset(50);
        }else{
           make.left.mas_offset(60);
        }
        make.height.mas_equalTo(25);
    }];
    //操作价钱
    _operatePriceLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(AdaptedWidth(15))];
    [self addSubview:_operatePriceLable];
    [_operatePriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.right.mas_offset(-10);
        make.left.equalTo(_operateLable.mas_right).offset(2);
        make.height.mas_equalTo(25);
    }];
    //订单号 流水号  姓名
    _leftLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [self addSubview:_leftLable];
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_operateLable.mas_bottom).offset(8);
        if (iphone5) {
            make.left.mas_offset(50);
        }else{
            make.left.mas_offset(60);
        }
        make.height.mas_offset(15);
    }];
    
    //时间
    _operateTimeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_NAMETITLE_FONT];
    [self addSubview:_operateTimeLable];
    [_operateTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftLable.mas_top);
        make.right.mas_offset(-10);
        make.height.mas_offset(15);
        make.bottom.mas_offset(-15);
    }];
}

-(void)refreshWithModel:(CKProductLibModel*)model {
    
    /**1：进账  -1：出账*/     //操作金额
    NSString *dir = [NSString stringWithFormat:@"%@", model.dir];
    NSString *moneyStr = [NSString stringWithFormat:@"%@", model.money];
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
        self.operatePriceLable.textColor = TitleColor;
        if ([moneyStr doubleValue] == 0) {
            self.operatePriceLable.text = [NSString stringWithFormat:@"¥%@",moneyStr];
        }else{
            self.operatePriceLable.text = [NSString stringWithFormat:@"+¥%@",moneyStr];
        }
        
    }

    //操作记录
    NSString *operation  = [NSString stringWithFormat:@"%@", model.operation];
    if (IsNilOrNull(operation)) {
        operation = @"";
    }
    self.operateLable.text = operation;
    
    NSString *pythn = [NSString stringWithFormat:@"%@", model.paytn];
    if (IsNilOrNull(pythn)) {
        pythn = @"";
    }

    //操作时间
    NSString *timestr = [NSString stringWithFormat:@"%@",model.time];;
    if (IsNilOrNull(timestr)) {
        timestr = @"";
    }
    self.operateTimeLable.text = timestr;
    
    NSString *imageLeft = @"";
    if ([operation isEqualToString:@"产品库存"]) {
        imageLeft = @"jiamenggreen";
        _leftLable.text = @"";
    }else if ([operation isEqualToString:@"创客礼包进货"]) {
        imageLeft = @"salegreen";
        _leftLable.text = [NSString stringWithFormat:@"订单号:%@", pythn];
    }else if ([operation isEqualToString:@"创客礼包推广"]){
        imageLeft = @"salered";
        _leftLable.text = [NSString stringWithFormat:@"订单号:%@", pythn];
    }else if ([operation isEqualToString:@"自提"]){
        imageLeft = @"takered";
        if (IsNilOrNull(pythn)) {
            _leftLable.text = [NSString stringWithFormat:@"订单号:"];
        }else{
            _leftLable.text = [NSString stringWithFormat:@"订单号:ck%@", pythn];
        }
    }else if ([operation isEqualToString:@"零售"]){
        imageLeft = @"salered";
        if (IsNilOrNull(pythn)) {
            _leftLable.text = [NSString stringWithFormat:@"订单号:"];
        }else{
            _leftLable.text = [NSString stringWithFormat:@"订单号:wxuser%@",pythn];
        }
    }else if([operation isEqualToString:@"退货"]){
        imageLeft = @"returngreen";
        _leftLable.text = [NSString stringWithFormat:@"订单号:%@",pythn];
    }else if ([operation hasPrefix:@"社群"]){
        imageLeft = @"salered";
        if (IsNilOrNull(pythn)) {
            _leftLable.text = [NSString stringWithFormat:@"进货人:"];
        }else{
            _leftLable.text = [NSString stringWithFormat:@"进货人:%@", pythn];
        }
    }else if ([operation isEqualToString:@"产品进货"]){
        imageLeft = @"salegreen";
        _leftLable.text = @"";
    }else if ([operation isEqualToString:@"进货"]){
        NSString *paytn = [NSString stringWithFormat:@"%@", model.paytn];
        if (IsNilOrNull(paytn)) {//云豆内转
            imageLeft = @"yzc";
            _leftLable.text = @"云豆内转";
        }else{//线上支付
            imageLeft = @"rechargegreen";
            _leftLable.text = [NSString stringWithFormat:@"支付流水号:%@",pythn];
        }
    }else if([operation isEqualToString:@"分销"]){
        imageLeft = @"rechargered";
        if (!IsNilOrNull(pythn)) {
             _leftLable.text = [NSString stringWithFormat:@"分销:%@",pythn];
        }else{
            _leftLable.text = @"";
        }
    }else if([operation isEqualToString:@"分销转创客"]){
        imageLeft = @"jiamenggreen";
        if (IsNilOrNull(pythn)) {
            _leftLable.text = @"";
        }else{
           _leftLable.text = [NSString stringWithFormat:@"支付流水号:%@",pythn];
        }
    }else{
        if([dir isEqualToString:@"1"]){ //进账 绿色包包
            imageLeft = @"salegreen";
        }else{//出账 红色包包
            imageLeft = @"salered";
        }
        if (IsNilOrNull(pythn)) {
            _leftLable.text = @"";
        }else{
            _leftLable.text = [NSString stringWithFormat:@"支付流水号:%@",pythn];
        }
    }
    [_leftImageView setImage:[UIImage imageNamed:imageLeft]];
    
    
    BOOL isUpdate = NO;
    if ([UIScreen mainScreen].bounds.size.height <= 667) {
        if ([pythn length] > 8){
            isUpdate = YES;
        }
    }else{
        if ([pythn length] >= 18){
            isUpdate = YES;
        }
    }
    if (isUpdate) {
        [_operateTimeLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_leftLable.mas_bottom).offset(5);
            make.right.mas_offset(-10);
            make.height.mas_offset(15);
            make.bottom.mas_offset(-15);
        }];
    }else{
        [_operateTimeLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_leftLable.mas_top);
            make.right.mas_offset(-10);
            make.height.mas_offset(15);
            make.bottom.mas_offset(-15);
        }];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
