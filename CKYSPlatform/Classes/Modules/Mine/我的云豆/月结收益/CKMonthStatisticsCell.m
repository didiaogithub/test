//
//  CKMonthStatisticsCell.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/12/28.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKMonthStatisticsCell.h"
#import "CoefficientAlertview.h"

@implementation CKMonthStatisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

#pragma mark - 店铺进货cell
@interface CKMonthCalShopStockCell()

@property (nonatomic, strong) UILabel *codeText;
@property (nonatomic, strong) UILabel *personalText;
@property (nonatomic, strong) UILabel *personalAttractText;
@property (nonatomic, strong) UIImageView *coefficientImageView;
/**店铺进货*/
@property (nonatomic, strong) UILabel *personalAchieveLable;
/**产品销售奖励系数说明*/
@property (nonatomic, strong) UIButton *coefficientButton;

@end

@implementation CKMonthCalShopStockCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

-(void)initComponent {
    
    UILabel *redBlockL = [[UILabel alloc] init];
    [self.contentView addSubview:redBlockL];
    redBlockL.backgroundColor = [UIColor colorWithHexString:@"e53b33"];
    [redBlockL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(AdaptedWidth(10));
        make.width.mas_offset(5);
        make.height.mas_offset(20);
    }];
    
    //左侧店铺
    UILabel *shopText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:shopText];
    shopText.text = @"店铺进货";
    [shopText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(redBlockL);
        make.left.equalTo(redBlockL.mas_right).offset(AdaptedWidth(15));
    }];
    
    _personalAchieveLable = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#3E3E3E"] textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(AdaptedHeight(16))];
    [self.contentView addSubview:_personalAchieveLable];
    _personalAchieveLable.text = @"¥0.00";
    [_personalAchieveLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.equalTo(shopText);
        make.right.mas_offset(-20);
        make.left.equalTo(shopText.mas_right).offset(AdaptedWidth(10));
    }];
    
    //中间的横线
    UILabel *lineL = [UILabel creatLineLable];
    [self.contentView addSubview:lineL];
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(redBlockL.mas_bottom).offset(15);
        make.left.right.mas_offset(0);
        make.height.mas_offset(1);
    }];
    
    
    _codeText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_NAMETITLE_FONT];
    [self.contentView addSubview:_codeText];
    _codeText.text = @"本月产品销售奖励系数";
    [_codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineL.mas_bottom).offset(25);
        make.left.mas_offset(AdaptedWidth(10));
        make.height.mas_offset(20);
        make.width.mas_offset(SCREEN_WIDTH/2);
    }];
    //系数说明图
    _coefficientImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_coefficientImageView];
    _coefficientImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_coefficientImageView setImage:[UIImage imageNamed:@"monthcoefficient0"]];
    [_coefficientImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(lineL.mas_bottom).offset(10);
        make.left.equalTo(_codeText.mas_right).offset(AdaptedWidth(5));
        make.right.mas_offset(-AdaptedWidth(10));
        make.height.mas_offset(35);
    }];
    
    //具体奖励系数请查看
    UILabel *leftCoefficientLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentRight font:MAIN_NAMETITLE_FONT];
    [self.contentView addSubview:leftCoefficientLable];
    leftCoefficientLable.text = @"具体奖励系数请查看";
    [leftCoefficientLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeText.mas_bottom).offset(15);
        make.left.mas_offset(0);
        make.right.mas_offset(-SCREEN_WIDTH/2);
        make.height.mas_offset(20);
    }];
    
    //系数说明
    _coefficientButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_coefficientButton];
    _coefficientButton.tag = 1210;
    [_coefficientButton setTitle:@"《产品销售奖励系数说明》" forState:UIControlStateNormal];
    _coefficientButton.titleLabel.font = MAIN_NAMETITLE_FONT;
    [_coefficientButton setTitleColor:[UIColor tt_blueColor] forState:UIControlStateNormal];
    [_coefficientButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(leftCoefficientLable);
        make.left.equalTo(leftCoefficientLable.mas_right);
    }];
    [_coefficientButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)updateCellData:(NSString*)rechargemoney modulus:(NSString*)modulus {
    
    if (IsNilOrNull(rechargemoney)) {
        //店铺进货
        rechargemoney = @"0.00";
    }
    _personalAchieveLable.text = [NSString stringWithFormat:@"%.2f", [rechargemoney doubleValue]];
    
    if (IsNilOrNull(modulus)){
        modulus = @"0";
    }
    if ([modulus isEqualToString:@"0"]) {
        [_coefficientImageView setImage:[UIImage imageNamed:@"monthcoefficient0"]];
    }else if ([modulus isEqualToString:@"0.05"]){
        [_coefficientImageView setImage:[UIImage imageNamed:@"monthcoefficient5"]];
    }else if ([modulus isEqualToString:@"0.075"]){
        [_coefficientImageView setImage:[UIImage imageNamed:@"monthcoefficient75"]];
    }else if ([modulus isEqualToString:@"0.1"]){
        [_coefficientImageView setImage:[UIImage imageNamed:@"monthcoefficient10"]];
    }else{
        [_coefficientImageView setImage:[UIImage imageNamed:@"monthcoefficient0"]];
    }
    
}
/**点击查看系数说明*/
-(void)clickButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardRate:)]) {
        [self.delegate rewardRate:self];
    }
//    CoefficientAlertview *codefficientAlertView = [[CoefficientAlertview alloc]init];
//    [codefficientAlertView show];
}

@end

#pragma mark - 礼包销售cell
@interface CKMonthCalDLBProfitCell()

@property (nonatomic, strong) UILabel *dlbProfitValueL;

@end

@implementation CKMonthCalDLBProfitCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

-(void)initComponent {
    UILabel *redBlockL = [[UILabel alloc] init];
    [self.contentView addSubview:redBlockL];
    redBlockL.backgroundColor = [UIColor colorWithHexString:@"e53b33"];
    [redBlockL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(AdaptedWidth(10));
        make.width.mas_offset(5);
        make.height.mas_offset(20);
    }];
    
    //左侧店铺
    UILabel *shopText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:shopText];
    shopText.text = @"创客礼包销售";
    [shopText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(redBlockL);
        make.left.equalTo(redBlockL.mas_right).offset(AdaptedWidth(15));
    }];
    
    _dlbProfitValueL = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#3E3E3E"] textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(AdaptedHeight(16))];
    [self.contentView addSubview:_dlbProfitValueL];
    _dlbProfitValueL.text = @"0.00";
    [_dlbProfitValueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.equalTo(shopText);
        make.right.mas_offset(-20);
        make.left.equalTo(shopText.mas_right).offset(AdaptedWidth(10));
    }];
    
}

- (void)updateCellWithInvitemoney:(NSString*)invitemoney {
    if (IsNilOrNull(invitemoney)) {
        invitemoney = @"0.00";
    }
    _dlbProfitValueL.text = [NSString stringWithFormat:@"%.2f", [invitemoney doubleValue]];
}

@end


#pragma mark - 礼包销售奖励柱状图cell
@interface CKColumnCell()<JHColumnChartDelegate, JHTableChartDelegate>

@property (nonatomic, strong) UILabel *totalDLBProfitValueL;

@end

@implementation CKColumnCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

-(void)initComponent {
    UILabel *redBlockL = [[UILabel alloc] init];
    [self addSubview:redBlockL];
    redBlockL.backgroundColor = [UIColor colorWithHexString:@"e53b33"];
    [redBlockL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(AdaptedWidth(10));
        make.width.mas_offset(5);
        make.height.mas_offset(20);
    }];
    
    UILabel *totalDLBProfitL = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    totalDLBProfitL.text = @"累计销售创客礼包奖励";
    [self addSubview:totalDLBProfitL];
    [totalDLBProfitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(redBlockL);
        make.left.equalTo(redBlockL.mas_right).offset(AdaptedWidth(15));
    }];
    
    _totalDLBProfitValueL = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"3E3E3E"] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM_BOLD(AdaptedHeight(16))];
    [self addSubview:_totalDLBProfitValueL];
    _totalDLBProfitValueL.text = @"0.00";
    [_totalDLBProfitValueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(redBlockL);
        make.left.equalTo(totalDLBProfitL.mas_right).offset(AdaptedWidth(10));
        make.right.mas_offset(-20);
    }];
    
    UILabel *lineL = [UILabel creatLineLable];
    [self addSubview:lineL];
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(redBlockL.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    
    NSArray *titleArray = @[@"已获得", @"本月结算", @"未获得"];
    NSArray *colorArray = @[@"#3398DB", @"#6AB4E5", @"#B0D7F1"];
    
    for (NSInteger i = 0; i < titleArray.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6-20+SCREEN_WIDTH/3*i, 70, 20, 15)];
        view.backgroundColor = [UIColor colorWithHexString:colorArray[i]];
        [self addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6+5+SCREEN_WIDTH/3*i, 70, SCREEN_WIDTH/6, 15)];
        label.textColor = TitleColor;
        label.font = [UIFont systemFontOfSize:12];
        label.text = titleArray[i];
        [self addSubview:label];
    }
    
//    if (self.chartView) {
//        [self.chartView removeFromSuperview];
//        self.chartView = nil;
//    }
//    
//    self.chartView = [[SCChart alloc] initwithSCChartDataFrame:CGRectMake(10, 100, SCREEN_WIDTH - 20, 150) withSource:self withStyle:SCChartBarStyle];
//    [self.chartView showInView:self.contentView];
    
    if (self.column) {
        [self.column removeFromSuperview];
        self.column = nil;
    }
    
    self.column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 180)];
    
    self.column.originSize = CGPointMake(30, 20);
    /*    The first column of the distance from the starting point     */
    self.column.drawFromOriginX = 20;
    //    column.backgroundColor = [UIColor yellowColor];
    self.column.typeSpace = 20;
    
    self.column.contentInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    /*        Column width         */
    self.column.columnWidth = 30;
    /*        Column backgroundColor         */
    self.column.bgVewBackgoundColor = [UIColor whiteColor];//[UIColor yellowColor];
    /*        X, Y axis font color         */
    self.column.drawTextColorForX_Y = [UIColor blackColor];
    /*        X, Y axis line color         */
    self.column.colorForXYLine = [UIColor darkGrayColor];

    //坐标值字体大小
    self.column.xDescTextFontSize = 12.0;
//    self.column.yDescTextFontSize = 10.0;
    //是否显示折线图
    self.column.isShowLineChart = NO;
    self.column.delegate = self;
    [self addSubview:self.column];
    
    UILabel *xUint = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, CGRectGetMaxY(self.column.frame), 90, 20)];
    xUint.textAlignment = NSTextAlignmentRight;
    xUint.textColor = TitleColor;
    xUint.font = [UIFont systemFontOfSize:12];
    xUint.text = @"单位（个）";
    [self addSubview:xUint];
    
    UILabel *yUint = [[UILabel alloc] initWithFrame:CGRectMake(35, 100, 80, 20)];
    yUint.textColor = TitleColor;
    yUint.font = [UIFont systemFontOfSize:12];
    yUint.text = @"单位（元）";
    [self addSubview:yUint];
}

- (void)updateCellWithInvitereward:(NSString*)invitereward xValueArray:(NSArray*)xValueArray gettedArray:(NSArray*)gettedArray yValueArray:(NSArray*)yValueArray {
    if (IsNilOrNull(invitereward)) {
        invitereward = @"0.00";
    }
    _totalDLBProfitValueL.text = [NSString stringWithFormat:@"%.2f", [invitereward doubleValue]];
    
    self.column.valueArr = yValueArray;
    NSMutableArray *colorArr = [NSMutableArray array];
    for (NSString *getted in gettedArray) {
        if ([getted isEqualToString:@"0"]) {//已获得
            [colorArr addObject:[UIColor colorWithHexString:@"#3398DB"]];
        }else if ([getted isEqualToString:@"1"]) {//本月结算
            [colorArr addObject:[UIColor colorWithHexString:@"#6AB4E5"]];
        }else if ([getted isEqualToString:@"2"]) {//未获得
            [colorArr addObject:[UIColor colorWithHexString:@"#B0D7F1"]];
        }
    }
    
    self.column.columnBGcolorsArr = colorArr;
    self.column.xShowInfoText = xValueArray;
    self.column.lineValueArray = yValueArray;

    self.column.delegate = self;
    [self.column showAnimation];
}

@end
