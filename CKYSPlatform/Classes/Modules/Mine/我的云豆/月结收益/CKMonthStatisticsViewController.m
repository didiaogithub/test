//
//  CKMonthStatisticsViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/12/28.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKMonthStatisticsViewController.h"
#import "CoefficientAlertview.h"
#import "PersonalStockUpViewController.h"
#import "PersonalSolicitBusinessViewController.h"
#import "TeamStokUpViewController.h"
#import "TeamAttratViewController.h"
#import "AllIncomeView.h"
#import "KKDatePickerView.h"
#import "MonthCalPieView.h"
#import "SCRuleViewController.h"
#import "CKMonthStatisticsCell.h"

@interface CKMonthStatisticsViewController ()<UITableViewDelegate, UITableViewDataSource, KKDatePickerViewDelegate, CKMonthCalShopStockCellDelegate>
{
    CoefficientAlertview *codefficientAlertView;
    NSString *_yearStr;
    NSString *_monthStr;
    NSString *_ckidString;
}

@property (nonatomic, strong) AllIncomeView *allIncomeView;
@property (nonatomic, strong) MonthCalPieView *rationView; /**饼图*/
@property (nonatomic, strong) UITableView *monthTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *xValueArray;
@property (nonatomic, strong) NSMutableArray *yValueArray;
@property (nonatomic, strong) NSMutableArray *gettedArray;
/**
月结总奖励
*/
@property (nonatomic, copy) NSString *totalmoney;
/**
 产品销售奖励费
 */
@property (nonatomic, copy) NSString *salesreward;
/**
 创客礼包销售
 */
@property (nonatomic, copy) NSString *invitemoney;
/**
 礼包销售累计奖励费
 */
@property (nonatomic, copy) NSString *invitetotalreward;

/**
 礼包销售累计利润
 */
@property (nonatomic, copy) NSString *invitereward;
/**
 奖励系数
 */
@property (nonatomic, copy) NSString *modulus;
/**
 店铺进货
 */
@property (nonatomic, copy) NSString *rechargemoney;

@end

@implementation CKMonthStatisticsViewController

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"月结";
    [self createTopViews];
    [self createMonthCaculateTableview];
    [self getMonthData];
    [self createSiftButton];
}

- (void)createTopViews {
    
    _allIncomeView = [[AllIncomeView alloc] initWithFrame:CGRectZero andTypeStr:@"ck"];
    [self.view addSubview:_allIncomeView];
    [_allIncomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(65+NaviAddHeight);
        make.left.right.mas_offset(0);
        if (IPHONE_X) {
            make.height.mas_offset(110);
        }else{
            make.height.mas_offset(100);
        }
    }];
    
    _rationView = [[MonthCalPieView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_rationView];
    [_rationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allIncomeView.mas_bottom).offset(AdaptedHeight(10));
        make.left.right.equalTo(_allIncomeView);
        make.height.mas_offset(140);
    }];
}

#pragma mark - 创建筛选按钮
- (void)createSiftButton {
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"selectconditions"] style:UIBarButtonItemStylePlain target:self action:@selector(clickSiftButton)];
    right.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10;
        self.navigationItem.rightBarButtonItems = @[spaceItem, right];
    }
}

#pragma mark - 点击筛选按钮
-(void)clickSiftButton{
    KKDatePickerView *pickerView = [[KKDatePickerView alloc]initWithFrame:self.view.bounds];
    pickerView.delegate = self;
    [pickerView show];
}

#pragma mark - pickerview代理方法
- (void)pickView:(NSString *)yes month:(NSString *)moth{
    NSLog(@"--年%@--月%@",yes,moth);
    _yearStr = yes;
    _monthStr = moth;
    _allIncomeView.monthLable.text = [NSString stringWithFormat:@"%@月",moth];
    _allIncomeView.yearLable.text = yes;
    NSInteger length = _allIncomeView.monthLable.text.length;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_allIncomeView.monthLable.text ];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:CHINESE_SYSTEM_BOLD(AdaptedHeight(74/2))
                          range:NSMakeRange(0, 2)];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:CHINESE_SYSTEM(AdaptedHeight(29/2))
                          range:NSMakeRange(length-1, 1)];
    _allIncomeView.monthLable.attributedText = AttributedStr;
    [self getMonthData];
}

#pragma mark - 获取月结数据
- (void)getMonthData {
    _ckidString = KCKidstring;
    NSString *getMonthAccountUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/CkMonthly/getMonthStatement"];//@"http://192.168.2.32:90/Ckapp3/CkMonthly/getMonthStatement";
    
    NSString *nowString = [NSDate nowTime:@"yyyy-MM"];
    NSArray *timeArr = [nowString componentsSeparatedByString:@"-"];
    if(IsNilOrNull(_yearStr)){
        _yearStr = [timeArr firstObject];
    }
    if (IsNilOrNull(_monthStr)) {
        _monthStr = [timeArr lastObject];
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSString *devicetype = [NSString getCurrentVersionAndDeviceType];
    
    NSDictionary *pramaDic = @{@"ckid":_ckidString,
                               @"year":_yearStr,
                               @"month":_monthStr,
                               DeviceId:uuid,
                               @"devicetype":devicetype
                               };
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:getMonthAccountUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        [self bindData:dict];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        //网络请求超时 可以显示默认数据
        NSArray *array = @[@"0",@"0", @"0"];
        [self.rationView.chartView updateChartByNumbers:array];
    }];
}

#pragma mark - 处理月结数据
- (void)bindData:(NSDictionary*)dict {
    self.invitemoney = [NSString stringWithFormat:@"%@", dict[@"invitemoney"]];
    if (IsNilOrNull(self.invitemoney)) {
        self.invitemoney = @"0";
    }
    self.salesreward = [NSString stringWithFormat:@"%@", dict[@"salesreward"]];
    if (IsNilOrNull(self.salesreward)) {
        self.salesreward = @"0";
    }
    self.invitetotalreward = [NSString stringWithFormat:@"%@", dict[@"invitetotalreward"]];
    if (IsNilOrNull(self.invitetotalreward)) {
        self.invitetotalreward = @"0";
    }
    self.invitereward = [NSString stringWithFormat:@"%@", dict[@"invitereward"]];
    if (IsNilOrNull(self.invitereward)) {
        self.invitereward = @"0";
    }
    self.rechargemoney = [NSString stringWithFormat:@"%@", dict[@"rechargemoney"]];
    if (IsNilOrNull(self.rechargemoney)) {
        self.rechargemoney = @"0";
    }
    self.totalmoney = [NSString stringWithFormat:@"%@", dict[@"totalmoney"]];
    if (IsNilOrNull(self.totalmoney)) {
        self.totalmoney = @"0";
    }
    self.modulus = [NSString stringWithFormat:@"%@", dict[@"modulus"]];
    if (IsNilOrNull(self.modulus)) {
        self.modulus = @"0";
    }
    
    _allIncomeView.allValueLable.text = [NSString stringWithFormat:@"%.2f", [self.totalmoney doubleValue]];
    self.rationView.saleReturnValueL.text = [NSString stringWithFormat:@"%.2f", [self.salesreward doubleValue]];
    self.rationView.dlbProfitLValueL.text = [NSString stringWithFormat:@"%.2f", [self.invitereward doubleValue]];
    self.rationView.totalDLBProfitValueL.text = [NSString stringWithFormat:@"%.2f", [self.invitetotalreward doubleValue]];
    
    NSArray *array = @[self.salesreward, self.invitereward, self.invitetotalreward];
    [self.rationView.chartView updateChartByNumbers:array];
    
    
    NSDictionary *inviterewardData = dict[@"inviterewardData"];
    NSArray *xdata = inviterewardData[@"xdata"];
    self.xValueArray = [NSMutableArray array];
    self.yValueArray = [NSMutableArray array];
    self.gettedArray = [NSMutableArray array];
    for (NSDictionary *xdataDict in xdata) {
        NSString *xvalue = [NSString stringWithFormat:@"%@", xdataDict[@"xvalue"]];
        [self.xValueArray addObject:xvalue];
        [self.gettedArray addObject:[NSString stringWithFormat:@"%@", xdataDict[@"getted"]]];
        
    }
    NSArray *ydata = inviterewardData[@"ydata"];
    for (NSDictionary *ydataDict in ydata) {
        NSString *yvalue = [NSString stringWithFormat:@"%@", ydataDict[@"yvalue"]];
        [self.yValueArray addObject:@[yvalue]];
    }
    
    [self.monthTableView reloadData];
}

#pragma mark - 设置table
- (void)createMonthCaculateTableview {
    _monthTableView = [[UITableView alloc] init];
    _monthTableView.showsVerticalScrollIndicator = NO;
    _monthTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.monthTableView.rowHeight = UITableViewAutomaticDimension;
    self.monthTableView.estimatedRowHeight = 44;
    [self.monthTableView setBackgroundColor:[UIColor tt_grayBgColor]];
    if (@available(iOS 11.0, *)) {
        self.monthTableView.estimatedSectionFooterHeight = 0.1;
        self.monthTableView.estimatedSectionHeaderHeight = 0.1;
    }
    [self.view addSubview:_monthTableView];
    [_monthTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rationView.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
    }];
    _monthTableView.delegate = self;
    _monthTableView.dataSource = self;
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CKMonthCalShopStockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKMonthCalShopStockCell"];
        if (cell == nil) {
            cell = [[CKMonthCalShopStockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKMonthCalShopStockCell"];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:self.rechargemoney modulus:self.modulus];
        return cell;
        
    }else if(indexPath.section == 1){
        
        CKMonthCalDLBProfitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKMonthCalDLBProfitCell"];
        if (cell == nil) {
            cell = [[CKMonthCalDLBProfitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKMonthCalDLBProfitCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellWithInvitemoney:self.invitemoney];
        return cell;
    }else{
        
        CKColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKColumnCell"];
        if (cell == nil) {
            cell = [[CKColumnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKColumnCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellWithInvitereward:self.invitetotalreward xValueArray:self.xValueArray gettedArray:self.gettedArray yValueArray:self.yValueArray];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) return 150;
    if (1 == indexPath.section) return 50;
    return 300;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (![self.rechargemoney isEqualToString:@"0"]){
            PersonalStockUpViewController *stockUp = [[PersonalStockUpViewController alloc] init];
            stockUp.typeString = @"1";
            stockUp.yearString = _yearStr;
            stockUp.monthString = _monthStr;
            [self.navigationController pushViewController:stockUp animated:YES];
        }
    }else if (indexPath.section == 1) {
        if (![self.invitemoney isEqualToString:@"0"]) {
            PersonalSolicitBusinessViewController *personalBusiness = [[PersonalSolicitBusinessViewController alloc] init];
            personalBusiness.typeString = @"1";
            personalBusiness.yearString = _yearStr;
            personalBusiness.monthString = _monthStr;
            [self.navigationController pushViewController:personalBusiness animated:YES];
        }
    }
}

#pragma mark - 系数
-(void)rewardRate:(CKMonthCalShopStockCell *)ckMonthCalShopStockCell {
    NSString *couponhelpurl = [NSString stringWithFormat:@"%@front/ckappFront/rule/coefficient.html", WebServiceAPI];
    SCRuleViewController *rule = [[SCRuleViewController alloc] init];
    rule.url = couponhelpurl;
    [self.navigationController pushViewController:rule animated:YES];
}

#pragma mark - 点击查看系数1210 个人进货1211 个人招商1212
-(void)pushToVCWithtag:(NSInteger)tag{
//    NSString *rechargeCK = [NSString stringWithFormat:@"%@",self.monthAccountModel.rechargeCK];
//    if (IsNilOrNull(rechargeCK) || [rechargeCK isEqualToString:@"0.00"]){
//        rechargeCK = @"0";
//    }
//
//    NSString *inviteCK = [NSString stringWithFormat:@"%@",self.monthAccountModel.inviteCK];
//    if (IsNilOrNull(inviteCK) || [inviteCK isEqualToString:@"0.00"]){
//        inviteCK = @"0";
//    }
//    if(tag == 1210){
//        NSLog(@"查看系数");
//        codefficientAlertView = [[CoefficientAlertview alloc]init];
//        [codefficientAlertView show];
//    }else if(tag == 1211){ //店铺进货
//        if (![rechargeCK isEqualToString:@"0"]){
//            PersonalStockUpViewController *stockUp = [[PersonalStockUpViewController alloc] init];
//            stockUp.typeString = @"1";
//            stockUp.yearString = _yearStr;
//            stockUp.monthString = _monthStr;
//            [self.navigationController pushViewController:stockUp animated:YES];
//        }
//
//    }else{
//        //平台软件推广
//        if (![inviteCK isEqualToString:@"0"]) {
//            PersonalSolicitBusinessViewController *personalBusiness = [[PersonalSolicitBusinessViewController alloc] init];
//            personalBusiness.typeString = @"1";
//            personalBusiness.yearString = _yearStr;
//            personalBusiness.monthString = _monthStr;
//            [self.navigationController pushViewController:personalBusiness animated:YES];
//        }
//
//    }
}

#pragma mark-点击 团队进货1213 团队招商1214
-(void)pushToTeamVCWithtag:(NSInteger)tag{
    
//    NSString *rechargeTeam = [NSString stringWithFormat:@"%@",self.monthAccountModel.rechargeTeam];
//    if (IsNilOrNull(rechargeTeam) || [rechargeTeam isEqualToString:@"0.00"]){
//        rechargeTeam = @"0";
//    }
//
//    NSString *inviteTeam = [NSString stringWithFormat:@"%@",self.monthAccountModel.inviteTeam];
//    if (IsNilOrNull(inviteTeam) || [inviteTeam isEqualToString:@"0.00"]){
//        inviteTeam = @"0";
//    }
//
//    if (tag == 1213) { //产品进货
//        if (![rechargeTeam isEqualToString:@"0"]){
//            TeamStokUpViewController *teamStock = [[TeamStokUpViewController alloc] init];
//            teamStock.yearString = _yearStr;
//            teamStock.monthString = _monthStr;
//            [self.navigationController pushViewController:teamStock animated:YES];
//        }
//
//    }else{ //平台软件销售
//        if (![inviteTeam isEqualToString:@"0"]){
//            TeamAttratViewController *teamAttract = [[TeamAttratViewController alloc] init];
//            teamAttract.yearString = _yearStr;
//            teamAttract.monthString = _monthStr;
//            [self.navigationController pushViewController:teamAttract animated:YES];
//        }
//
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
