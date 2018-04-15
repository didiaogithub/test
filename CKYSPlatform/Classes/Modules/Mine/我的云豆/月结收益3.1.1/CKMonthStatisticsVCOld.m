//
//  CKMonthStatisticsVCOld.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/12.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKMonthStatisticsVCOld.h"
#import "PersonalRewardTableViewCell.h"
#import "TeamRewardTableViewCell.h"
#import "CoefficientAlertview.h"
#import "PersonalStockUpViewController.h"
#import "PersonalSolicitBusinessViewController.h"
#import "TeamStokUpViewController.h"
#import "TeamAttratViewController.h"
#import "MonthAccountModel.h"
#import "CKAllIncomeView.h" //3.1.1界面
#import "KKDatePickerView.h"
#import "RatioView.h"

@interface CKMonthStatisticsVCOld ()<UITableViewDelegate,UITableViewDataSource,PersonalRewardTableViewCellDelegate,TeamRewardTableViewCellDelegate,KKDatePickerViewDelegate>
{
    CoefficientAlertview *codefficientAlertView;
    NSString *_yearStr;
    NSString *_monthStr;
    NSString *_ckidString;
    NSArray *valueArray;
}
@property(nonatomic,strong)CKAllIncomeView *allIncomeView;
/**饼图*/
@property(nonatomic,strong)RatioView *rationView;
@property(nonatomic,strong)MonthAccountModel *monthAccountModel;
@property(nonatomic,strong)UITableView *monthTableView;
@end

@implementation CKMonthStatisticsVCOld

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"月结";
    [self createTopViews];
    [self createMonthCaculateTableview];
    [self getMonthData];
    [self createSiftButton];
}
-(void)createTopViews{
    
    _allIncomeView = [[CKAllIncomeView alloc] initWithFrame:CGRectZero andTypeStr:@"ck"];
    [self.view addSubview:_allIncomeView];
    [_allIncomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(65);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(92));
    }];
    
    _rationView = [[RatioView alloc] initWithFrame:CGRectZero andTypeStr:@"ck"];
    [self.view addSubview:_rationView];
    [_rationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allIncomeView.mas_bottom).offset(AdaptedHeight(10));
        make.left.right.equalTo(_allIncomeView);
        make.height.mas_offset(AdaptedHeight(120));
    }];
}
#pragma maerk-刷新顶部视图内容
-(void)refreshWithModel:(MonthAccountModel *)monthModel{
    NSString * totalMoney = [NSString stringWithFormat:@"%@",monthModel.totalMoney];
    if (IsNilOrNull(totalMoney)) {
        totalMoney = @"0.00";
    }
    double totalMoneyDouble = [totalMoney doubleValue];
    _allIncomeView.allValueLable.text = [NSString stringWithFormat:@"%.2f",totalMoneyDouble];
    
    
    NSString * saleReward = [NSString stringWithFormat:@"%@",monthModel.totalTeam];
    if (IsNilOrNull(saleReward)) { //产品销售奖励
        saleReward = @"0.00";
    }
    double saleRewardDouble = [saleReward doubleValue];
    _rationView.firstVlaueLable.text = [NSString stringWithFormat:@"%.2f",saleRewardDouble];
    
    
    //软件推广
    NSString * totalInvite = [NSString stringWithFormat:@"%@",monthModel.totalInvite];
    if (IsNilOrNull(totalInvite)) { //推荐费 软件推广
        totalInvite = @"0.00";
    }
    double totalInviteDouble = [totalInvite doubleValue];
    _rationView.threenValueLable.text = [NSString stringWithFormat:@"%.2f",totalInviteDouble];
    
    valueArray = @[saleReward,totalInvite];
    [self.rationView.chartView updateChartByNumbers:valueArray];
}

/**创建筛选按钮*/
-(void)createSiftButton{
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
/**点击筛选按钮*/
-(void)clickSiftButton{
    KKDatePickerView *pickerView = [[KKDatePickerView alloc]initWithFrame:self.view.bounds];
    pickerView.delegate = self;
    [pickerView show];
}
/**点击pickerview代理方法*/
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
#pragma mark-获取月结数据
-(void)getMonthData{
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    NSString *getMonthAccountUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getMonthlyStatement_Url];
    
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
    
    NSDictionary *pramaDic = @{@"ckid":_ckidString, @"year":_yearStr, @"month":_monthStr, DeviceId:uuid};
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:getMonthAccountUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        NSLog(@"月结的字典%@",dict);
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        self.monthAccountModel = [[MonthAccountModel alloc] init];
        [self.monthAccountModel setValuesForKeysWithDictionary:dict];
        [self refreshWithModel:self.monthAccountModel];
        [self.monthTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        //网络请求超时 可以显示默认数据
        NSArray *array = @[@"0",@"0"];
        [self.rationView.chartView updateChartByNumbers:array];
    }];
}
-(void)createMonthCaculateTableview{
    _monthTableView = [[UITableView alloc] init];
    _monthTableView.showsVerticalScrollIndicator = NO;
    _monthTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.monthTableView.rowHeight = UITableViewAutomaticDimension;
    self.monthTableView.estimatedRowHeight = 44;
    [self.monthTableView setBackgroundColor:[UIColor tt_grayBgColor]];
    [self.view addSubview:_monthTableView];
    [_monthTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(233)+64);
        make.left.right.mas_offset(0);
        make.height.mas_offset(SCREEN_HEIGHT-AdaptedHeight(233)-64);
    }];
    _monthTableView.delegate = self;
    _monthTableView.dataSource = self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        PersonalRewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalRewardTableViewCell"];
        if (cell == nil) {
            cell = [[PersonalRewardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonalRewardTableViewCell"];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshPersonalWithModel:self.monthAccountModel];
        return cell;
        
    }else{
        TeamRewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamRewardTableViewCell"];
        if (cell == nil) {
            cell = [[TeamRewardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TeamRewardTableViewCell"];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor tt_grayBgColor];
        [cell refreshTeamWithModel:self.monthAccountModel];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
#pragma mark-点击查看系数1210 个人进货1211 个人招商1212
-(void)pushToVCWithtag:(NSInteger)tag{
    NSString *rechargeCK = [NSString stringWithFormat:@"%@",self.monthAccountModel.rechargeCK];
    if (IsNilOrNull(rechargeCK) || [rechargeCK isEqualToString:@"0.00"]){
        rechargeCK = @"0";
    }
    
    NSString *inviteCK = [NSString stringWithFormat:@"%@",self.monthAccountModel.inviteCK];
    if (IsNilOrNull(inviteCK) || [inviteCK isEqualToString:@"0.00"]){
        inviteCK = @"0";
    }
    if(tag == 1210){
        NSLog(@"查看系数");
        codefficientAlertView = [[CoefficientAlertview alloc]init];
        [codefficientAlertView show];
    }else if(tag == 1211){ //店铺进货
        if (![rechargeCK isEqualToString:@"0"]){
            PersonalStockUpViewController *stockUp = [[PersonalStockUpViewController alloc] init];
            stockUp.typeString = @"1";
            stockUp.yearString = _yearStr;
            stockUp.monthString = _monthStr;
            [self.navigationController pushViewController:stockUp animated:YES];
        }
        
    }else{
        //平台软件推广
        if (![inviteCK isEqualToString:@"0"]) {
            PersonalSolicitBusinessViewController *personalBusiness = [[PersonalSolicitBusinessViewController alloc] init];
            personalBusiness.typeString = @"1";
            personalBusiness.yearString = _yearStr;
            personalBusiness.monthString = _monthStr;
            [self.navigationController pushViewController:personalBusiness animated:YES];
        }
        
    }
}
#pragma mark-点击 团队进货1213 团队招商1214
-(void)pushToTeamVCWithtag:(NSInteger)tag{
    
    NSString *rechargeTeam = [NSString stringWithFormat:@"%@",self.monthAccountModel.rechargeTeam];
    if (IsNilOrNull(rechargeTeam) || [rechargeTeam isEqualToString:@"0.00"]){
        rechargeTeam = @"0";
    }
    
    NSString *inviteTeam = [NSString stringWithFormat:@"%@",self.monthAccountModel.inviteTeam];
    if (IsNilOrNull(inviteTeam) || [inviteTeam isEqualToString:@"0.00"]){
        inviteTeam = @"0";
    }
    
    if (tag == 1213) { //产品进货
        if (![rechargeTeam isEqualToString:@"0"]){
            TeamStokUpViewController *teamStock = [[TeamStokUpViewController alloc] init];
            teamStock.yearString = _yearStr;
            teamStock.monthString = _monthStr;
            [self.navigationController pushViewController:teamStock animated:YES];
        }
        
    }else{ //平台软件销售
        if (![inviteTeam isEqualToString:@"0"]){
            TeamAttratViewController *teamAttract = [[TeamAttratViewController alloc] init];
            teamAttract.yearString = _yearStr;
            teamAttract.monthString = _monthStr;
            [self.navigationController pushViewController:teamAttract animated:YES];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
