//
//  TeamStokUpViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/10.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "TeamStokUpViewController.h"
#import "RechargeAndAttactiveModel.h"
#import "PersonalStockUpViewController.h"
#import "PersonalStokUpTableViewCell.h"
static NSString *teamStockUpCell = @"teamStockUpCell";
@interface TeamStokUpViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_teamRechargeId;
    NSString *_isDownloadMore;
    NSString *_ckidString;
    UILabel *_teamStokUpLable;
}
@property(nonatomic,strong)UITableView *stockUpTableView;
@property(nonatomic,strong)RechargeAndAttactiveModel *teamRechargeModel;
/**团队进货数组*/
@property(nonatomic,strong)NSMutableArray *teamstockUpArray;
@end

@implementation TeamStokUpViewController
-(NSMutableArray *)teamstockUpArray{
    if (_teamstockUpArray == nil) {
        _teamstockUpArray = [[NSMutableArray alloc] init];
    }
    return _teamstockUpArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品销售";
    [self createStokUpTableview];
    [self getTeamRechargeData];
    [self refreshData];
}
#pragma mark-获取团队进货数据
-(void)getTeamRechargeData{
    
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    NSString *getTeamRechargeUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getRechargeTeam_Url];
    if(IsNilOrNull(_teamRechargeId)){
        _teamRechargeId = @"0";
    }
    if (IsNilOrNull(self.yearString)) {
        self.yearString = @"";
    }
    if (IsNilOrNull(self.monthString)) {
        self.monthString = @"";
    }
    if (![_isDownloadMore isEqualToString:@"2"]) { //加载更多
        _teamRechargeId = @"0";
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"year":self.yearString,@"month":self.monthString,@"pagesize":@"20",@"id":_teamRechargeId,DeviceId:uuid};
    
    if (IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    [HttpTool postWithUrl:getTeamRechargeUrl params:pramaDic success:^(id json) {
        [self.stockUpTableView.mj_header endRefreshing];
        [self.stockUpTableView.mj_footer endRefreshing];
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        if (![_isDownloadMore isEqualToString:@"2"]) {
            [self.teamstockUpArray removeAllObjects];
        }
        
        NSArray *rechargeArr = dict[@"records"];
        for (NSDictionary *rechargeDic in rechargeArr) {
            self.teamRechargeModel = [[RechargeAndAttactiveModel alloc] init];
            [self.teamRechargeModel setValuesForKeysWithDictionary:rechargeDic];
            [self.teamstockUpArray addObject:self.teamRechargeModel];
        }
        _teamRechargeId = [NSString stringWithFormat:@"%zd",self.teamstockUpArray.count];
        NSLog(@"团队进货记录传id==%@",_teamRechargeId);
        [self.stockUpTableView reloadData];
    } failure:^(NSError *error) {
        [self.stockUpTableView.mj_footer endRefreshing];
        [self.stockUpTableView.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}

-(void)createStokUpTableview{
    
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor tt_redMoneyColor];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(50));
    }];

    
    _teamStokUpLable  = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(15))];
    [topView addSubview:_teamStokUpLable];
    [_teamStokUpLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(AdaptedWidth(15));
        make.right.mas_offset(-AdaptedWidth(15));
    }];

    _stockUpTableView = [[UITableView alloc] init];
    [self.view addSubview:_stockUpTableView];
    _stockUpTableView.showsVerticalScrollIndicator = NO;
    _stockUpTableView.backgroundColor = [UIColor tt_grayBgColor];
    _stockUpTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.stockUpTableView.rowHeight = UITableViewAutomaticDimension;
    self.stockUpTableView.estimatedRowHeight = 44;
    [_stockUpTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(topView.mas_bottom);
        make.height.mas_offset(SCREEN_HEIGHT-64-AdaptedHeight(50));
    }];
    _stockUpTableView.delegate = self;
    _stockUpTableView.dataSource = self;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,AdaptedHeight(10))];
    _stockUpTableView.tableHeaderView = headerView;
    
    //刷新年月数据
    [self refreshYearAndMonth];
}
#pragma mark-刷新年月数值
-(void)refreshYearAndMonth{
    _teamStokUpLable.text = [NSString stringWithFormat:@"%@-%@",self.yearString,self.monthString];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.teamstockUpArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //团队进货
    PersonalStokUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:teamStockUpCell];
    if (cell == nil) {
        cell = [[PersonalStokUpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:teamStockUpCell andTypeStr:@"2"];
    }
    cell.typestr = @"2";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor  = [UIColor tt_grayBgColor];
    if ([self.teamstockUpArray count]) {
        self.teamRechargeModel = self.teamstockUpArray[indexPath.row];
        [cell refreshWithModel:self.teamRechargeModel];
    }
    return cell;
}
#pragma 点击cell代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.teamstockUpArray count]) {
        self.teamRechargeModel = self.teamstockUpArray[indexPath.row];
    }
    NSString *money = [NSString stringWithFormat:@"%@",self.teamRechargeModel.money];
    if(IsNilOrNull(money) || [money isEqualToString:@"0"]){
        return;
    }
    PersonalStockUpViewController *personalStokUp  =[[PersonalStockUpViewController alloc] init];
    personalStokUp.typeString = @"2";
    personalStokUp.yearString = self.yearString;
    personalStokUp.monthString = self.monthString;
    personalStokUp.stockUpCkidString = self.teamRechargeModel.ID;
    
    [self.navigationController pushViewController:personalStokUp animated:YES];
}
#pragma mark-刷新
-(void)refreshData{
    __typeof (self) __weak weakSelf = self;
    self.stockUpTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"1";
        [weakSelf.stockUpTableView.mj_header beginRefreshing];
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
                    [weakSelf getTeamRechargeData];
                }else{
                    [weakSelf.stockUpTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.stockUpTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.stockUpTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"2";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf getTeamRechargeData];
                [weakSelf.stockUpTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.stockUpTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
    
}


@end
