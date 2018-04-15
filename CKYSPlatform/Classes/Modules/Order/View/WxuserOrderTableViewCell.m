//
//  WxuserOrderTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/7/6.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "WxuserOrderTableViewCell.h"

@interface WxuserOrderTableViewCell ()

@property (nonatomic, strong) UILabel *orderNumberLable;  //订单编号
@property (nonatomic, strong) UILabel *orderStateLable;  //订单状态
@property (nonatomic, strong) UILabel *buyerNameLable; /**下单用户*/
@property (nonatomic, strong) UILabel *getterNameLable; /**收件人*/
@property (nonatomic, strong) UILabel *priceLable; /**商品价格*/
@property (nonatomic, strong) UIImageView *maskView;

@end

@implementation WxuserOrderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    //底层view
    UIView * bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-1);
        make.left.right.top.mas_offset(0);
    }];
    
    _orderNumberLable = [UILabel configureLabelWithTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_orderNumberLable];
    _orderNumberLable.text = @"订单编号:";
    [_orderNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        make.width.mas_offset(SCREEN_WIDTH*2/3.0);
        make.height.mas_offset(30);
    }];
    
    _orderStateLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(15)];
    [bankView addSubview:_orderStateLable];
    [_orderStateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_orderNumberLable.mas_centerY);
        make.right.mas_offset(-20);
        make.left.equalTo(_orderNumberLable.mas_right);
        make.height.mas_offset(30);
    }];
    
    UILabel *topLine = [UILabel creatLineLable];
    [bankView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_offset(0);
        make.height.mas_offset(1);
        make.left.right.mas_offset(0);
        make.top.equalTo(_orderNumberLable.mas_bottom);
    }];
    
   //下单用户
    _buyerNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_buyerNameLable];
    [_buyerNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderNumberLable.mas_bottom).offset(10);
        make.left.mas_offset(10);
    }];
    
   //收件人
    _getterNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_getterNameLable];
    [_getterNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buyerNameLable.mas_bottom).offset(8);
        make.left.equalTo(_buyerNameLable.mas_left);
        make.bottom.mas_offset(-10);
    }];
    
    UILabel *textNumber = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(AdaptedWidth(12))];
    [bankView addSubview:textNumber];
    textNumber.text = @"订单金额";
    [textNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buyerNameLable.mas_top);
        make.right.mas_offset(-15);
        make.left.equalTo(_buyerNameLable.mas_right);
    }];
    
    //商品单价
    _priceLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(15))];
    [bankView addSubview:_priceLable];
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_getterNameLable);
        make.right.mas_offset(-15);
    }];
    
    
    self.maskView = [UIImageView new];
    self.maskView.image = [UIImage imageNamed:@"shareOrderMask"];
    self.maskView.backgroundColor = [UIColor clearColor];
    self.maskView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(64);
    }];
    self.maskView.hidden = YES;
}

-(void)refreshWithModel:(OrderModel *)model{
    self.orderModel = model;
    
    [self refreshWithStatusLableWithorderModel:self.orderModel];
    
    NSString *buyerName = [NSString stringWithFormat:@"%@",model.buyername];
    if (IsNilOrNull(buyerName)) {
        buyerName = @"";
    }
    _buyerNameLable.text = [NSString stringWithFormat:@"下单用户:%@",buyerName];
    
    NSString *gettername = [NSString stringWithFormat:@"%@",model.gettername];
    if (IsNilOrNull(gettername)) {
        gettername = @"";
    }
    NSString *favormoney = [NSString stringWithFormat:@"%@", model.favormoney];
    if (IsNilOrNull(favormoney) || [favormoney isEqualToString:@"0"] || [favormoney isEqualToString:@"0.00"]) {
        self.maskView.hidden = YES;
        _getterNameLable.text = [NSString stringWithFormat:@"收货人:%@", gettername];
    }else{
        self.maskView.hidden = NO;
        if (gettername.length > 0) {
            gettername = [gettername substringToIndex:1];
            _getterNameLable.text = [NSString stringWithFormat:@"收货人:%@**", gettername];
        }else{
            _getterNameLable.text = [NSString stringWithFormat:@"收货人:"];
        }
    }

    //订单总价
//    NSString *allMoney = [NSString stringWithFormat:@"%@", model.ordermoney];
    NSString *allMoney = [NSString stringWithFormat:@"%@", model.money];

    if (IsNilOrNull(allMoney)) {
        allMoney = @"";
        _priceLable.text = [NSString stringWithFormat:@"%@", allMoney];

    }else{
        _priceLable.text = [NSString stringWithFormat:@"¥%@", allMoney];
    }
}

-(void)refreshWithStatusLableWithorderModel:(OrderModel *)ordeModel{
    //    订单状态（99：全部0：已取消 1：未付款；2：已付款，3：已收货；4：正在退货，5：退货成功，6：已完成，7：已发货  8：支付中（换货的）） 3456有删除按钮
    NSString *orderfrom = [NSString stringWithFormat:@"%@", ordeModel.orderfrom];
    if ([orderfrom isEqualToString:@"3"]) {
        //退换货才加标识
        NSString *orderNo = [NSString stringWithFormat:@"订单编号：%@", ordeModel.no];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:orderNo];
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"order_changeGoods"];
        attch.bounds = CGRectMake(5, -5, 25, 25);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attri appendAttributedString:string];
        _orderNumberLable.attributedText = attri;
    }else{
        _orderNumberLable.text = [NSString stringWithFormat:@"订单编号：%@",ordeModel.no];
    }
    
    
    if([ordeModel.orderstatus isEqualToString:@"0"]){//已取消
        _orderStateLable.text = @"已取消";
    }else if ([ordeModel.orderstatus isEqualToString:@"1"]) {//未付款
        _orderStateLable.text = @"待付款";
    }else if([ordeModel.orderstatus isEqualToString:@"2"]){//待发货
        _orderStateLable.text = @"待发货";
    }else if([ordeModel.orderstatus isEqualToString:@"3"]){//已收货
        _orderStateLable.text = @"已收货";
    }else if ([ordeModel.orderstatus isEqualToString:@"4"]||[ordeModel.orderstatus isEqualToString:@"5"]){//正在退货  和  退货成功
        if([ordeModel.orderstatus isEqualToString:@"4"]){
            _orderStateLable.text = @"正在退货";
        }else{
            _orderStateLable.text = @"退货成功";
        }
    }else if ([ordeModel.orderstatus isEqualToString:@"6"]){//已完成
        _orderStateLable.text = @"已完成";
    }else if ([ordeModel.orderstatus isEqualToString:@"7"]){//已发货
        _orderStateLable.text = @"已发货";
    }else if ([ordeModel.orderstatus isEqualToString:@"7"]){//已发货
        _orderStateLable.text = @"支付中";
    }
}

@end
