//
//  TodaySaleView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/4/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "TodaySaleView.h"
@interface TodaySaleView()
{
    UILabel *totalText;
    UILabel *returnText;
    UILabel *allsalesText;
    
}
@end
@implementation TodaySaleView
-(instancetype)initWithFrame:(CGRect)frame andTypeStr:(NSString *)typeStr{
    if (self = [super initWithFrame:frame]) {
        [self createUIWithType:typeStr];
    }
    return self;
}
-(void)createUIWithType:(NSString *)type{
    self.backgroundColor = [UIColor tt_grayBgColor];
    _topView = [[UIView alloc] init];
    [self addSubview:_topView];
    [_topView setBackgroundColor:[UIColor tt_bigRedBgColor]];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH);
        make.height.mas_offset(AdaptedHeight(100));
    }];
    
    

    //实销收入
    _moneyTotalLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM_BOLD(AdaptedHeight(30))];
    [_topView addSubview:_moneyTotalLable];
    _moneyTotalLable.text = @"¥0.00";
    [_moneyTotalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH);
        make.height.mas_offset(AdaptedHeight(40));
    }];
    //实销收入文字
    totalText = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM(AdaptedWidth(14))];
    [_topView addSubview:totalText];
    
    [totalText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyTotalLable.mas_bottom);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH);
        make.bottom.mas_offset(-AdaptedHeight(23));
    }];
    
    _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topView addSubview:_topButton];
    _topButton.tag = 130;
    [_topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_topView);
    }];

    //销售总金额view
    _allsalesView = [[UIView alloc] init];
    [self addSubview:_allsalesView];
    [_allsalesView setBackgroundColor:[UIColor whiteColor]];
    [_allsalesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH/2);
        make.height.mas_offset(AdaptedHeight(50));
    }];
    
    
    float topPading = 0;
    if (iphone4) {
        topPading = AdaptedHeight(3);
    }else{
        topPading = AdaptedHeight(7);
    }
    
    //销售总金额
    _moneySalesLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM(AdaptedHeight(16))];
    [_allsalesView addSubview:_moneySalesLable];
    _moneySalesLable.text = @"¥0.00";
    [_moneySalesLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(topPading);
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH/2);
    }];
    //销售总金额文字
    allsalesText = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM(AdaptedWidth(12))];
    [_allsalesView addSubview:allsalesText];
    
    [allsalesText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneySalesLable.mas_bottom);
        make.left.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH/2);
        make.bottom.mas_offset(-topPading);
    }];
    
   

    _saleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allsalesView addSubview:_saleButton];
    _saleButton.tag = 131;
    
    [_saleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_allsalesView);
        
    }];
    
    //退款订单view
    _returnView = [[UIView alloc] init];
    [self addSubview:_returnView];
    [_returnView setBackgroundColor:[UIColor whiteColor]];
    [_returnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_allsalesView.mas_right);
        make.top.height.width.equalTo(_allsalesView);
        make.right.mas_offset(0);
    }];
    
    //退款金额
    _moneyOrderBackLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM(AdaptedHeight(16))];
    [_returnView addSubview:_moneyOrderBackLable];
    _moneyOrderBackLable.text = @"¥0.00";
    [_moneyOrderBackLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneySalesLable.mas_top);
        make.left.equalTo(_moneySalesLable.mas_right);
        make.width.mas_offset(SCREEN_WIDTH/2);
    }];
    //退款金额金额文字
    returnText = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM(AdaptedWidth(12))];
    [_returnView addSubview:returnText];

    [returnText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyOrderBackLable.mas_bottom);
        make.left.equalTo(_moneyOrderBackLable.mas_left);
        make.width.mas_offset(SCREEN_WIDTH/2);
        make.bottom.mas_offset(-topPading);
    }];
    
    _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_returnView addSubview:_returnButton];
    _returnButton.tag = 132;
    [_returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_returnView);
    }];
    
    if([type isEqualToString:@"1"]){ //今日销售
        totalText.text  =@"实销收入";
        allsalesText.text  =@"销售总金额";
        returnText.text  =@"订单退款";
      [_topButton addTarget:self action:@selector(clickSaleButton:) forControlEvents:UIControlEventTouchUpInside];
    }else{
         totalText.text  =@"我的业绩";
         allsalesText.text  =@"进货总计";
         returnText.text  =@"销售礼包总计";
    }
    
    [_saleButton addTarget:self action:@selector(clickSaleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_returnButton addTarget:self action:@selector(clickSaleButton:) forControlEvents:UIControlEventTouchUpInside];

    
    float topH = 0;
    if (iphone4) {
        topH = AdaptedHeight(102);
    }else{
        topH = AdaptedHeight(110);
    }
    
    UILabel *lineLable = [[UILabel alloc] init];
    [self addSubview:lineLable];
    lineLable.backgroundColor = [UIColor tt_redMoneyColor];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(topH);
        make.left.mas_offset(SCREEN_WIDTH/2-0.5);
        make.width.mas_offset(1);
        make.height.mas_offset(30);
    }];
    
    UIView *countView = [[UIView alloc] init];
    [self addSubview:countView];
    countView.backgroundColor = [UIColor whiteColor];
    [countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allsalesView.mas_bottom).offset(AdaptedHeight(10));
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(40));
        make.bottom.mas_offset(0);
    }];
    
    //总笔数
    _allNumLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [countView addSubview:_allNumLable];
    _allNumLable.text = @"共计: 0笔";
    [_allNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(AdaptedWidth(15));
    }];
    
}
-(void)clickSaleButton:(UIButton *)button{
    NSInteger tag = button.tag - 130;
    if(tag == 0){  //实销收入
        self.topButton.selected = YES;
        self.saleButton.selected = NO;
        self.returnButton.selected = NO;
        self.topButton.userInteractionEnabled = NO;
        self.saleButton.userInteractionEnabled = YES;
        self.returnButton.userInteractionEnabled = YES;
        allsalesText.textColor = SubTitleColor;
        returnText.textColor = SubTitleColor;
        _moneySalesLable.textColor = SubTitleColor;
        _moneyOrderBackLable.textColor = SubTitleColor;
    }else if(tag == 1){ //销售总金额
        self.topButton.selected = NO;
        self.saleButton.selected = YES;
        self.returnButton.selected = NO;
        self.topButton.userInteractionEnabled = YES;
        self.saleButton.userInteractionEnabled = NO;
        self.returnButton.userInteractionEnabled = YES;
        allsalesText.textColor = [UIColor tt_redMoneyColor];
        _moneySalesLable.textColor = [UIColor tt_redMoneyColor];
        _moneyOrderBackLable.textColor = SubTitleColor;
        returnText.textColor = SubTitleColor;
    }else{  //退货
        self.topButton.selected = NO;
        self.saleButton.selected = NO;
        self.returnButton.selected = YES;
        self.topButton.userInteractionEnabled = YES;
        self.saleButton.userInteractionEnabled = YES;
        self.returnButton.userInteractionEnabled = NO;
        allsalesText.textColor = SubTitleColor;
        _moneySalesLable.textColor = SubTitleColor;
        _moneyOrderBackLable.textColor = [UIColor tt_redMoneyColor];
        returnText.textColor = [UIColor tt_redMoneyColor];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshSalesButton:)]) {
        [self.delegate refreshSalesButton:button];
    }
}


@end
