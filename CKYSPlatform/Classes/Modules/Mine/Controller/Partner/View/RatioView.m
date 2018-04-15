//
//  RatioView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "RatioView.h"
@interface RatioView ()
@property(nonatomic,strong)NSArray *itemsArr;
@end
@implementation RatioView

-(instancetype)initWithFrame:(CGRect)frame andTypeStr:(NSString *)userType{
    if (self = [super initWithFrame:frame]) {
        [self createUIWithType:userType];
    }
    return self;
}
-(void)createUIWithType:(NSString *)type{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    if (_chartView) {
        [_chartView removeFromSuperview];
        _chartView = nil;
    }
    
    float topH = 0;
    if ([type isEqualToString:@"ck"]){
        topH = AdaptedHeight(15);
        self.itemsArr = @[[SCPieChartDataItem dataItemWithValue:0 color:[UIColor colorWithHexString:@"e53b33"] description:@""],
                             [SCPieChartDataItem dataItemWithValue:0 color:[UIColor colorWithHexString:@"FFBd20"] description:@""]
                             ];

    }else{
        topH = AdaptedHeight(25);
        self.itemsArr = @[[SCPieChartDataItem dataItemWithValue:0 color:[UIColor colorWithHexString:@"e53b33"] description:@""],[SCPieChartDataItem dataItemWithValue:0 color:[UIColor tt_blueColor] description:@""],
                          [SCPieChartDataItem dataItemWithValue:0 color:[UIColor colorWithHexString:@"FFBd20"] description:@""]
                          ];
    
    }

    _chartView = [[SCPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/3,topH,AdaptedWidth(90),AdaptedHeight(90)) items:self.itemsArr];
    [self addSubview:_chartView];
    //    chartView.showAbsoluteValues = NO;
    
    //左边的红色表示
    UILabel *redLable = [[UILabel alloc] init];
    [self addSubview:redLable];
    redLable.backgroundColor = [UIColor colorWithHexString:@"e53b33"];
    [redLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(30));
        make.left.mas_offset(AdaptedWidth(10));
        make.width.mas_offset(AdaptedWidth(13));
        make.height.mas_offset(AdaptedHeight(13));
    }];

    //文字
    _firstLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentCenter font:MAIN_NAMETITLE_FONT];
    [self addSubview:_firstLable];
    [_firstLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(redLable);
        make.left.equalTo(redLable.mas_right).offset(AdaptedWidth(15));
    }];
    
    _firstVlaueLable = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"3E3E3E"] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM_BOLD(AdaptedHeight(13))];
    [self addSubview:_firstVlaueLable];
    _firstVlaueLable.text = @"0.00";
    [_firstVlaueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(_firstLable);
        make.left.equalTo(_firstLable.mas_right).offset(AdaptedWidth(10));
        make.right.mas_offset(-AdaptedWidth(150));
    }];
    
    //蓝色
    UILabel *bulleLable = [[UILabel alloc] init];
    [self addSubview:bulleLable];
    bulleLable.backgroundColor = [UIColor tt_blueColor];
    [bulleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(redLable.mas_bottom).offset(AdaptedHeight(20));
        make.width.height.left.equalTo(redLable);
    }];
    
    //文字
    _secondLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentCenter font:MAIN_NAMETITLE_FONT];
    [self addSubview:_secondLable];
    [_secondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(bulleLable);
        make.left.width.equalTo(_firstLable);
    }];
    
    _secondVlaueLable = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"3E3E3E"] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM_BOLD(AdaptedHeight(13))];
    [self addSubview:_secondVlaueLable];
    _secondVlaueLable.text = @"0.00";
    [_secondVlaueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secondLable.mas_top);
        make.left.width.height.right.equalTo(_firstVlaueLable);
    }];
    
    //黄色
    UILabel *yellowLable = [[UILabel alloc] init];
    [self addSubview:yellowLable];
    yellowLable.backgroundColor = [UIColor colorWithHexString:@"FFBd20"];
    
    //文字
    _threenLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentCenter font:MAIN_NAMETITLE_FONT];
    [self addSubview:_threenLable];
    
    if ([type isEqualToString:@"ck"]){
        bulleLable.hidden = YES;
        _secondLable.hidden = YES;
        _secondVlaueLable.hidden = YES;
        _firstLable.text = @"产品销售奖励费";
        _threenLable.text = @"创客礼包利润";
        [yellowLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(redLable.mas_bottom).offset(AdaptedHeight(30));
            make.width.height.left.equalTo(redLable);
        }];
    }else{
        bulleLable.hidden = NO;
        _secondLable.hidden = NO;
        _secondVlaueLable.hidden = NO;
        _firstLable.text = @"普通店铺销售奖励费";
        _secondLable.text = @"合伙人创客礼包推广奖励";
        _threenLable.text = @"合伙人销售业绩奖励";
        [yellowLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bulleLable.mas_bottom).offset(AdaptedHeight(20));
            make.width.height.left.equalTo(redLable);
        }];
        
    }
    [_threenLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(yellowLable);
        make.bottom.mas_offset(-AdaptedHeight(30));
        make.left.width.equalTo(_firstLable);
    }];
    
    _threenValueLable = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"3E3E3E"] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM_BOLD(AdaptedHeight(13))];
    [self addSubview:_threenValueLable];
    _threenValueLable.text = @"0.00";
    [_threenValueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_threenLable.mas_top);
        make.left.width.height.right.equalTo(_firstVlaueLable);
    }];
}

@end
