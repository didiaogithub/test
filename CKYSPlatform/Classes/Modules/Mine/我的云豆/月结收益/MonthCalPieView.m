//
//  MonthCalPieView.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/12/20.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "MonthCalPieView.h"


@interface MonthCalPieView()

@property (nonatomic, strong) NSArray *itemsArr;

@end

@implementation MonthCalPieView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self setBackgroundColor:[UIColor whiteColor]];
    
    if (_chartView) {
        [_chartView removeFromSuperview];
        _chartView = nil;
    }
    
    float topH = 0;
    topH = AdaptedHeight(15);
    self.itemsArr = @[
                      [SCPieChartDataItem dataItemWithValue:0 color:[UIColor colorWithHexString:@"e53b33"] description:@""],
                      [SCPieChartDataItem dataItemWithValue:0 color:[UIColor colorWithHexString:@"FFBd20"] description:@""],
                      [SCPieChartDataItem dataItemWithValue:0 color:[UIColor tt_blueColor] description:@""]
                      ];
    
    _chartView = [[SCPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, topH, AdaptedWidth(90), AdaptedHeight(90)) items:self.itemsArr];
    [self addSubview:_chartView];
    //    chartView.showAbsoluteValues = NO;
    
    //红色 产品销售奖励费
    UILabel *redBlockL = [[UILabel alloc] init];
    [self addSubview:redBlockL];
    redBlockL.backgroundColor = [UIColor colorWithHexString:@"e53b33"];
    [redBlockL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.left.mas_offset(AdaptedWidth(10));
        make.width.mas_offset(AdaptedWidth(13));
        make.height.mas_offset(20);
    }];
    
    _saleReturnL = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    _saleReturnL.text = @"产品销售奖励费";
    [self addSubview:_saleReturnL];
    [_saleReturnL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(redBlockL);
        make.width.mas_equalTo(100);
        make.left.equalTo(redBlockL.mas_right).offset(AdaptedWidth(15));
    }];
    
    _saleReturnValueL = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"3E3E3E"] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM_BOLD(AdaptedHeight(13))];
    [self addSubview:_saleReturnValueL];
    _saleReturnValueL.text = @"0.00";
    [_saleReturnValueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(_saleReturnL);
        make.left.equalTo(_saleReturnL.mas_right).offset(AdaptedWidth(10));
        make.right.equalTo(_chartView.mas_left).offset(-20);
    }];
    
    //黄色 创客礼包利润
    UILabel *yellowBlockL = [[UILabel alloc] init];
    [self addSubview:yellowBlockL];
    yellowBlockL.backgroundColor = [UIColor colorWithHexString:@"FFBd20"];
    [yellowBlockL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(redBlockL.mas_bottom).offset(20);
        make.width.height.left.equalTo(redBlockL);
    }];
    
    _dlbProfitL = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    _dlbProfitL.text = @"创客礼包利润";
    [self addSubview:_dlbProfitL];
    [_dlbProfitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(yellowBlockL);
        make.left.equalTo(yellowBlockL.mas_right).offset(AdaptedWidth(15));
    }];
    
    _dlbProfitLValueL = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"3E3E3E"] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM_BOLD(AdaptedHeight(13))];
    [self addSubview:_dlbProfitLValueL];
    _dlbProfitLValueL.text = @"0.00";
    [_dlbProfitLValueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dlbProfitL.mas_top);
        make.left.equalTo(_dlbProfitL.mas_right).offset(AdaptedWidth(10));
        make.height.right.equalTo(_saleReturnValueL);
//        make.right.equalTo(_chartView.mas_left).offset(-20);

    }];
    
    //蓝色 礼包销售累计奖励费
    UILabel *blueBlockL = [[UILabel alloc] init];
    [self addSubview:blueBlockL];
    blueBlockL.backgroundColor = [UIColor tt_blueColor];
    [blueBlockL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yellowBlockL.mas_bottom).offset(20);
        make.width.height.left.equalTo(redBlockL);
    }];
    
    _totalDLBProfitL = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    _totalDLBProfitL.text = @"累计销售创客礼包奖励";
    [self addSubview:_totalDLBProfitL];
    [_totalDLBProfitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(blueBlockL);
        make.left.equalTo(blueBlockL.mas_right).offset(AdaptedWidth(15));
    }];
    
    _totalDLBProfitValueL = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"3E3E3E"] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM_BOLD(AdaptedHeight(13))];
    [self addSubview:_totalDLBProfitValueL];
    _totalDLBProfitValueL.text = @"0.00";
    [_totalDLBProfitValueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalDLBProfitL.mas_top);
        make.left.equalTo(_totalDLBProfitL.mas_right).offset(AdaptedWidth(10));
        make.height.right.equalTo(_saleReturnValueL);
//        make.right.equalTo(_chartView.mas_left).offset(-20);
    }];
}

@end
