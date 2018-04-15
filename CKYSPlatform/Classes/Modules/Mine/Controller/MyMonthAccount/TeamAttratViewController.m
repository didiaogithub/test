//
//  TeamAttratViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/10.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "TeamAttratViewController.h"
#import "RechargeAndAttactiveModel.h"
#import "PersonalSolicitBusinessViewController.h"
#import "PersonalAttractiveTableViewCell.h"

static NSString *teamAttractiveCell = @"teamAttractiveCell";
@interface TeamAttratViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_teamInviteId;
    NSString *_isDownloadMore;
    NSString *_ckidString;
    NSString *_refreshNum;
    NSString *_moreNum;
    UILabel *_teamAttrctiveLable;
    
}
@property(nonatomic,strong)RechargeAndAttactiveModel *inviteModle;
@property(nonatomic,strong)UITableView *teamInviteTableView;
/**团队招商数组*/
@property(nonatomic,strong)NSMutableArray *teamInviteArray;
@end

@implementation TeamAttratViewController
-(NSMutableArray *)teamInviteArray{
    if (_teamInviteArray == nil) {
        _teamInviteArray = [[NSMutableArray alloc] init];
    }
    return _teamInviteArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创客礼包销售";
    [self createTeamStokUpTableview];
    [self getTeamAttractData];
    [self refreshData];

    NSLog(@"年%@年 月%@月",self.yearString,self.monthString);
}
#pragma mark-获取团队招商数据
-(void)getTeamAttractData{
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    if(IsNilOrNull(_teamInviteId)){
        _teamInviteId = @"0";
    }
    if (IsNilOrNull(self.yearString)) {
        self.yearString = @"";
    }
    if (IsNilOrNull(self.monthString)) {
        self.monthString = @"";
    }
    if (![_isDownloadMore isEqualToString:@"2"]) { //加载更多
        _teamInviteId = @"0";
    }
    
    NSString *getTeamAttractUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getInviteTeam_Url];
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"year":self.yearString,@"month":self.monthString,@"pagesize":@"20",@"id":_teamInviteId,DeviceId:uuid};
    if (IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    [HttpTool postWithUrl:getTeamAttractUrl params:pramaDic success:^(id json) {
        [self.teamInviteTableView.mj_header endRefreshing];
        [self.teamInviteTableView.mj_footer endRefreshing];
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        if (![_isDownloadMore isEqualToString:@"2"]) {
            [self.teamInviteArray removeAllObjects];
        }

        NSArray *rechargeArr = dict[@"records"];
        for (NSDictionary *rechargeDic in rechargeArr) {
            self.inviteModle = [[RechargeAndAttactiveModel alloc] init];
            [self.inviteModle setValuesForKeysWithDictionary:rechargeDic];
            [self.teamInviteArray addObject:self.inviteModle];
        }
        // 这里模拟了10条数据 使用KVC来获取数组中模型TTInfoModel中num字段的总和
        // 使用KVC 可以获取到数组中的 某个字段的集合 如下
//        NSArray *numArr = [self.teamInviteArray valueForKey:@"num"];
//        NSLog(@"---%@",numArr);
        
        // 使用KVC 还可以通过某些运算符快捷的得到某种结果 比如求和
//        NSNumber *number = [self.teamInviteArray valueForKeyPath:@"@sum.num"]; // @sum 求和运算符
        _teamInviteId = [NSString stringWithFormat:@"%zd",self.teamInviteArray.count];
        NSLog(@"团队招商记录传id==%@",_teamInviteId);

        [self.teamInviteTableView reloadData];
    } failure:^(NSError *error) {
        [self.teamInviteTableView.mj_footer endRefreshing];
        [self.teamInviteTableView.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}
-(void)createTeamStokUpTableview{
    
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    [topView setBackgroundColor:[UIColor tt_redMoneyColor]];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(50));
    }];
    _teamAttrctiveLable  = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(15))];
    [topView addSubview:_teamAttrctiveLable];
    [_teamAttrctiveLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(AdaptedWidth(15));
        make.right.mas_offset(-AdaptedWidth(15));
    }];


    _teamInviteTableView = [[UITableView alloc] init];
    [self.view addSubview:_teamInviteTableView];
    _teamInviteTableView.showsVerticalScrollIndicator = NO;
    _teamInviteTableView.backgroundColor = [UIColor tt_grayBgColor];
    _teamInviteTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.teamInviteTableView.rowHeight = UITableViewAutomaticDimension;
    self.teamInviteTableView.estimatedRowHeight = 44;
    [_teamInviteTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(topView);
        make.top.equalTo(topView.mas_bottom);
        make.height.mas_offset(SCREEN_HEIGHT - 64-AdaptedHeight(50));
    }];
    _teamInviteTableView.delegate = self;
    _teamInviteTableView.dataSource = self;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, AdaptedHeight(10))];
    _teamInviteTableView.tableHeaderView = headerView;
    
    //刷新最上面的值
    [self refreDateString];
}
#pragma mark-
-(void)refreDateString{
    _teamAttrctiveLable.text = [NSString stringWithFormat:@"%@-%@",self.yearString,self.monthString];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.teamInviteArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //团队招商
    PersonalAttractiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:teamAttractiveCell];
    if (cell == nil) {
        cell = [[PersonalAttractiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:teamAttractiveCell andTypeStr:@"2"];
    }
    cell.typeStr = @"2";
    cell.backgroundColor = [UIColor tt_grayBgColor];
    if ([self.teamInviteArray count]) {
        [cell cellfreshWithModel:self.teamInviteArray[indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark-点击cell代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.teamInviteArray count]) {
        _inviteModle = self.teamInviteArray[indexPath.row];
    }
    NSString *num = [NSString stringWithFormat:@"%@",self.inviteModle.num];
    if(IsNilOrNull(num) || [num isEqualToString:@"0"]){
        return;
    }
    
    PersonalSolicitBusinessViewController *inviteVc  = [[PersonalSolicitBusinessViewController alloc] init];
    inviteVc.personalCkidString = _inviteModle.ID;
    inviteVc.typeString = @"2";
    inviteVc.yearString = self.yearString;
    inviteVc.monthString = self.monthString;
    [self.navigationController pushViewController:inviteVc animated:YES];
}
#pragma mark-刷新
-(void)refreshData{
    
    __typeof (self) __weak weakSelf = self;
    self.teamInviteTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"1";
        [weakSelf.teamInviteTableView.mj_header beginRefreshing];
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
                    [weakSelf getTeamAttractData];
                }else{
                    [weakSelf.teamInviteTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.teamInviteTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.teamInviteTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"2";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf getTeamAttractData];
                [weakSelf.teamInviteTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.teamInviteTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];

}



@end
