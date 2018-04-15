//
//  PersonalSolicitBusinessViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/9.
//  Copyright © 2016年 ckys. All rights reserved.

#import "PersonalSolicitBusinessViewController.h"
#import "PersonalAttractiveTableViewCell.h"
#import "RechargeAndAttactiveModel.h"
@interface PersonalSolicitBusinessViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_arrtactiveId;
    NSString *_ckidString;
    NSString *_isDownloadMore;
    UILabel *_monthAttractLable;

}
@property(nonatomic,strong)RechargeAndAttactiveModel *attractModel;
@property(nonatomic,strong)UITableView *personalBussinessTableView;
@property(nonatomic,strong)NSMutableArray *attractArray;
@end

@implementation PersonalSolicitBusinessViewController
-(NSMutableArray *)attractArray{
    if (_attractArray == nil) {
        _attractArray = [[NSMutableArray alloc] init];
    }
    return _attractArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *monthcalmode = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_monthcalmode"]];
    if ([monthcalmode isEqualToString:@"1"]) {
        self.navigationItem.title = @"创客礼包销售";
    }else{
        self.navigationItem.title = @"创客礼包推广";
    }
    
    [self createTableview];
    [self getPersonalArrtactiveData];
    [self refreshData];

}

#pragma mark-获取个人招商数据
-(void)getPersonalArrtactiveData{
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    if(IsNilOrNull(_arrtactiveId)){
        _arrtactiveId = @"0";
    }
    if (IsNilOrNull(self.yearString)) {
        self.yearString = @"";
    }
    if (IsNilOrNull(self.monthString)) {
        self.monthString = @"";
    }
    if ([_isDownloadMore isEqualToString:@"1"]) {
        [self.attractArray removeAllObjects];
    }
    if (![_isDownloadMore isEqualToString:@"2"]) { //加载更多
        _arrtactiveId = @"0";
        [self.attractArray removeAllObjects];
        
    }

    NSDictionary *pramaDic = nil;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getInviteCK_Url];
    if ([self.typeString isEqualToString:@"1"]) { //个人招商记录做check
       
        pramaDic = @{@"ckid":_ckidString,@"year":self.yearString,@"month":self.monthString,@"pagesize":@"20",@"id":_arrtactiveId,DeviceId:uuid,@"ver":@"301"};
    }else{ //团队招商 查看个人招商记录 不做check
        pramaDic = @{@"ckid":_ckidString,@"year":self.yearString,@"month":self.monthString,@"pagesize":@"20",@"id":_arrtactiveId,DeviceId:uuid,@"teamckid":self.personalCkidString,@"ver":@"301"};
    }

    if (IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.personalBussinessTableView.mj_header endRefreshing];
        [self.personalBussinessTableView.mj_footer endRefreshing];
        [self.viewDataLoading stopAnimation];
         NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        NSArray *rechargeArr = dict[@"records"];
        if (rechargeArr.count == 0) {
            return;
        }
        for (NSDictionary *rechargeDic in rechargeArr) {
            self.attractModel = [[RechargeAndAttactiveModel alloc] init];
            [self.attractModel setValuesForKeysWithDictionary:rechargeDic];
            [self.attractArray addObject:self.attractModel];
        }
    
        _arrtactiveId = [NSString stringWithFormat:@"%zd",self.attractArray.count];

        NSString *recordssize = [NSString stringWithFormat:@"%@",dict[@"recordssize"]];
        if(IsNilOrNull(recordssize)){
            recordssize = @"0";
        }
        [self refreshInviteCount:recordssize];
        [self.personalBussinessTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.personalBussinessTableView.mj_footer endRefreshing];
        [self.personalBussinessTableView.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}

-(void)createTableview{
    
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor tt_redMoneyColor];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64+NaviAddHeight);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(50));
    }];
    
    _monthAttractLable  = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(15))];
    [topView addSubview:_monthAttractLable];
    
    NSString *monthcalmode = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_monthcalmode"]];
    if ([monthcalmode isEqualToString:@"1"]) {
        _monthAttractLable.text = @"本月销售创客礼包0套";
    }else{
        _monthAttractLable.text = @"本月推广创客礼包0套";
    }
    
    [_monthAttractLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(AdaptedWidth(15));
        make.right.mas_offset(-AdaptedWidth(15));
    }];
    
    _personalBussinessTableView = [[UITableView alloc] init];
    [self.view addSubview:_personalBussinessTableView];
    _personalBussinessTableView.showsVerticalScrollIndicator = NO;
    _personalBussinessTableView.backgroundColor = [UIColor tt_grayBgColor];
    _personalBussinessTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.personalBussinessTableView.rowHeight = UITableViewAutomaticDimension;
    self.personalBussinessTableView.estimatedRowHeight = 44;
    [_personalBussinessTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_offset(SCREEN_HEIGHT - 64-AdaptedHeight(50));
    }];
    _personalBussinessTableView.delegate = self;
    _personalBussinessTableView.dataSource = self;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, AdaptedHeight(10))];
    _personalBussinessTableView.tableHeaderView = headerView;
}
-(void)refreshInviteCount:(NSString *)countStr{
    if (IsNilOrNull(countStr)) {
        countStr = @"0";
    }
    _monthAttractLable.text = [NSString stringWithFormat:@"本月推广创客礼包%@套",countStr];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.attractArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonalAttractiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalAttractiveTableViewCell"];
    if (cell == nil) {
        cell = [[PersonalAttractiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonalAttractiveTableViewCell" andTypeStr:@"1"]; //个人招商传1
    }
    cell.typeStr = @"1";
    cell.backgroundColor = [UIColor tt_grayBgColor];
    if ([self.attractArray count]) {
        self.attractModel = self.attractArray[indexPath.row];
        [cell cellfreshWithModel:self.attractModel];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark-刷新
-(void)refreshData{
    __typeof (self) __weak weakSelf = self;
    self.personalBussinessTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"1";
        [weakSelf.personalBussinessTableView.mj_header beginRefreshing];
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
                    [weakSelf getPersonalArrtactiveData];
                }else{
                    [weakSelf.personalBussinessTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.personalBussinessTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.personalBussinessTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"2";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf getPersonalArrtactiveData];
                [weakSelf.personalBussinessTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.personalBussinessTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
}


@end
