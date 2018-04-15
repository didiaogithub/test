//
//  CKMonthIncomeViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/16.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKMonthIncomeViewController.h"
#import "KKDatePickerView.h"
#import "CKMonthIncomeTableViewCell.h"
#import "CKMonthUserModel.h"

static NSString *recordIdentifier = @"CloudRecordTableViewCell";

@interface CKMonthIncomeViewController ()<UITableViewDelegate, UITableViewDataSource, KKDatePickerViewDelegate>
{

    NSString *_yearString;
    NSString *_monthString;
    NSString *_oidString;
    NSString *_ckidString;
    NSString *_isDownloadMore;
}


@property (nonatomic, strong) UITableView *dlbTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, copy)   NSString *salesmoney;

@end

@implementation CKMonthIncomeViewController

- (NodataLableView *)nodataLableView {
    if(_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64-AdaptedHeight(175))];
        _nodataLableView.nodataLabel.text = @"暂无记录";
    }
    return _nodataLableView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self initComponets];
    [self refreshData];
    
    [self requestMonthlyStatementData];
}

- (void)updateDLBReward:(NSString*)salesreward {
    if(IsNilOrNull(salesreward)){
        salesreward = @"0.00";
    }
    _incomeLabel.text = [NSString stringWithFormat:@"¥%@", salesreward];
}

#pragma mark - 请求dlb奖励数据
- (void)requestMonthlyStatementData {
    
    //请求参数年、月为空时，默认从当前年月查询
    if (IsNilOrNull(_yearString)) {
        _yearString = @"";
    }
    if (IsNilOrNull(_monthString)) {
        _monthString = @"";
    }
    if (IsNilOrNull(_oidString)){
        _oidString = @"0";
    }
    if (![_isDownloadMore isEqualToString:@"2"]) {
        _oidString = @"0";
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSDictionary *appDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [appDic objectForKey:@"CFBundleShortVersionString"];
    NSString *devicetype = [NSString stringWithFormat:@"ios%@", version];
    NSDictionary *pramaDic = @{@"ckid":_ckidString, @"year":_yearString, @"month":_monthString, DeviceId:uuid, @"devicetype":devicetype};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/CkMonthly/getMonthlyStatementData"];
    
    _nodataLableView.hidden = YES;
    if(IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            [self.dlbTableView.mj_footer endRefreshing];
            [self.dlbTableView.mj_header endRefreshing];
            return ;
        }
        
        self.salesmoney = [NSString stringWithFormat:@"%@", dict[@"salesmoney"]];
        NSString *salesreward = [NSString stringWithFormat:@"%@", dict[@"salesreward"]];
        [self updateDLBReward:salesreward];
        
        [self.dataArray removeAllObjects];
        NSArray *records = dict[@"records"];
        for (NSDictionary *userDict in records) {
            CKMonthUserModel *userM = [[CKMonthUserModel alloc] init];
            [userM setValuesForKeysWithDictionary:userDict];
            [self.dataArray addObject:userM];
        }
        
        if(![self.dataArray count]){
            _nodataLableView.hidden = NO;
            [self.dlbTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArray.count];
        }
        
        [self.dlbTableView.mj_footer endRefreshing];
        [self.dlbTableView.mj_header endRefreshing];
        [self.dlbTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.dlbTableView.mj_footer endRefreshing];
        [self.dlbTableView.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 点击筛选按钮
- (void)clickSiftButton {
    KKDatePickerView *pickerView = [[KKDatePickerView alloc]initWithFrame:self.view.bounds];
    pickerView.delegate = self;
    [pickerView show];
}
/**点击pickerview代理方法*/
- (void)pickView:(NSString *)yes month:(NSString *)moth{
    
    if (![_oidString isEqualToString:@"0"]){
        _oidString = @"0";
    }
    _isDownloadMore = @"";
    _yearString = yes;
    _monthString = moth;
    
    [self requestMonthlyStatementData];
    
    if([self.dataArray count]){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.dlbTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - 返回
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mrak - UI
- (void)initComponets {
    //头部视图
    UIView *topheaderView = [[UIView alloc] init];
    [self.view addSubview:topheaderView];
    [topheaderView setBackgroundColor:[UIColor tt_bigRedBgColor]];
    [topheaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 200));
    }];
    
    UILabel *titleLabel = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:18]];
    [topheaderView addSubview:titleLabel];
    titleLabel.text = @"月结";
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20+NaviAddHeight);
        make.right.mas_offset(-50);
        make.left.mas_offset(50);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [topheaderView addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"backwhite"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(20, 25));
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
    UIButton *choosebtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [topheaderView addSubview:choosebtn];
    [choosebtn setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
    [choosebtn addTarget:self action:@selector(clickSiftButton) forControlEvents:UIControlEventTouchUpInside];
    [choosebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.size.mas_offset(CGSizeMake(25, 25));
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
    //收入总值
    _incomeLabel = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font: CHINESE_SYSTEM_BOLD(AdaptedWidth(30))];
    [topheaderView addSubview:_incomeLabel];
    _incomeLabel.text = @"¥0.00";
    [_incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(30);
        make.right.mas_offset(-10);
        make.left.mas_offset(10);
        make.height.mas_equalTo(50);
    }];
    
    
    UILabel *expLabel = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [topheaderView addSubview:expLabel];
    expLabel.text = @"(创客礼包销售奖励)";
    [expLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_incomeLabel.mas_bottom).offset(10);
        make.right.mas_offset(-10);
        make.left.mas_offset(10);
        make.height.mas_equalTo(30);
    }];
    
    _dlbTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_dlbTableView];
    [_dlbTableView setBackgroundColor:[UIColor tt_grayBgColor]];
    [_dlbTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topheaderView.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    _dlbTableView.showsVerticalScrollIndicator = NO;
    
    _dlbTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _dlbTableView.delegate = self;
    _dlbTableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.dlbTableView.estimatedSectionHeaderHeight = 0.1;
        self.dlbTableView.estimatedSectionFooterHeight = 0.1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (0 == section) {
        return 1;
    }
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CKMonthIncomeExpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKMonthIncomeExpTableViewCell"];
        if (cell == nil) {
            cell = [[CKMonthIncomeExpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKMonthIncomeExpTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!IsNilOrNull(self.salesmoney)) {
            cell.moneyLabel.text = self.salesmoney;
        }
        return cell;
    }else{
        CKMonthIncomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKMonthIncomeTableViewCell"];
        if (cell == nil) {
            cell = [[CKMonthIncomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKMonthIncomeTableViewCell"];
        }
        if (self.dataArray.count > 0) {
            CKMonthUserModel *userM = self.dataArray[indexPath.row];
            [cell updateCellData:userM];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (void)refreshData {
    __typeof (self) __weak weakSelf = self;
    self.dlbTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"1";
        _yearString = @"";
        _monthString = @"";
        [weakSelf.dlbTableView.mj_header beginRefreshing];
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
        weakSelf.endInterval = [nowDate timeIntervalSince1970];
        
        NSTimeInterval value = weakSelf.endInterval - weakSelf.startInterval;
        CGFloat second = [[NSString stringWithFormat:@"%.2f",value] floatValue];//秒
        NSLog(@"间隔------%f秒",second);
        weakSelf.startInterval = weakSelf.endInterval;
        
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                if (value >= Interval) {
                    [weakSelf requestMonthlyStatementData];
                }else{
                    [weakSelf.dlbTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.dlbTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.dlbTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"2";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf requestMonthlyStatementData];
                //                [weakSelf.dlbTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.dlbTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
    
}

@end
