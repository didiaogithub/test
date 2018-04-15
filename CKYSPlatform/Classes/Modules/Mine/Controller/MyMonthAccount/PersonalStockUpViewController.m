//
//  PersonalStockUpViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/9.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "PersonalStockUpViewController.h"
#import "PersonalStokUpTableViewCell.h"
#import "PersonalStockModel.h"
#import "RechargeAndAttactiveModel.h"
static NSString *personalStokCell = @"PersonalStokUpTableViewCell";
@interface PersonalStockUpViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_rechargerId;
    NSString *_ckidString;
    NSString *_isDownloadMore;
    UILabel *_totalCountLable;

}
@property(nonatomic,strong)RechargeAndAttactiveModel *rechargeModel;
@property(nonatomic,strong)UITableView *personalStockUpTableView;
/**个人进货数组*/
@property(nonatomic,strong)NSMutableArray *stockUpArray;
@end

@implementation PersonalStockUpViewController
-(NSMutableArray *)stockUpArray{
    if (_stockUpArray == nil) {
        _stockUpArray = [[NSMutableArray alloc] init];
    }
    return _stockUpArray;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *monthcalmode = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_monthcalmode"]];
    if ([monthcalmode isEqualToString:@"1"]) {
        self.navigationItem.title = @"店铺进货";
    }else{
        self.navigationItem.title = @"产品进货";
    }
    
    [self createStokUpTableview];
    [self getPersonalRechargeData];
    //刷新
    [self refreshData];
}
#pragma mark-获取个人进货数据
-(void)getPersonalRechargeData{

    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    if(IsNilOrNull(_rechargerId)){
        _rechargerId = @"0";
    }
    if ([_isDownloadMore isEqualToString:@"1"]) {
        [self.stockUpArray removeAllObjects];
    }
    if (![_isDownloadMore isEqualToString:@"2"]) { //加载更多
        _rechargerId = @"0";
        [self.stockUpArray removeAllObjects];
    }
    
    if(IsNilOrNull(self.yearString)){
        self.yearString = @"";
    }
    if(IsNilOrNull(self.monthString)){
        self.monthString = @"";
    }
    
    NSDictionary *pramaDic = nil;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getRechargeCK_Url];
    if ([self.typeString isEqualToString:@"1"]) { //按月查询个人进货记录 做check
        pramaDic = @{@"ckid":_ckidString,@"year":self.yearString,@"month":self.monthString,@"pagesize":@"20",@"id":_rechargerId,DeviceId:uuid,@"ver":@"301"};
    }else{ //从团队进货查询个人进货记录 不做check
        pramaDic = @{@"ckid":_ckidString,@"year":self.yearString,@"month":self.monthString,@"pagesize":@"20",@"id":_rechargerId,DeviceId:uuid,@"teamckid":self.stockUpCkidString,@"ver":@"301"};
    }
    if (IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        [self.personalStockUpTableView.mj_footer endRefreshing];
        [self.personalStockUpTableView.mj_header endRefreshing];
            NSDictionary *dict = json;
            if ([dict[@"code"] integerValue] != 200){
                [self showNoticeView:dict[@"codeinfo"]];
                return ;
            }
            NSArray *rechargeArr = dict[@"records"];
        if (rechargeArr.count == 0) {
            return;
        }
            for (NSDictionary *rechargeDic in rechargeArr) {
                self.rechargeModel = [[RechargeAndAttactiveModel alloc] init];
                [self.rechargeModel setValuesForKeysWithDictionary:rechargeDic];
                [self.stockUpArray addObject:self.rechargeModel];
            }
    
           _rechargerId = [NSString stringWithFormat:@"%zd",self.stockUpArray.count];

            NSString *recordssize = [NSString stringWithFormat:@"%@",dict[@"recordssize"]];
            if(IsNilOrNull(recordssize)){
                recordssize = @"0";
            }
             [self refreshInviteCount:recordssize];
            [self.personalStockUpTableView reloadData];
        } failure:^(NSError *error) {
            [self.viewDataLoading stopAnimation];
            [self.personalStockUpTableView.mj_footer endRefreshing];
            [self.personalStockUpTableView.mj_header endRefreshing];
            if (error.code == -1009) {
                [self showNoticeView:NetWorkNotReachable];
            }else{
                [self showNoticeView:NetWorkTimeout];
            }
        }];
}
-(void)refreshInviteCount:(NSString *)countStr{
    if (IsNilOrNull(countStr)) {
        countStr = @"0";
    }
    _totalCountLable.text = [NSString stringWithFormat:@"共计%@笔",countStr];
}

-(void)createStokUpTableview{

    //粉条
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor tt_redMoneyColor];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64+NaviAddHeight);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(50));
    }];
    _totalCountLable  = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedHeight(15))];
    [topView addSubview:_totalCountLable];
    _totalCountLable.text = @"共计0笔";
    [_totalCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(AdaptedWidth(15));
        make.right.mas_offset(-AdaptedWidth(15));
    }];

    
    
    _personalStockUpTableView = [[UITableView alloc] init];
    [self.view addSubview:_personalStockUpTableView];
    _personalStockUpTableView.showsVerticalScrollIndicator = NO;
    _personalStockUpTableView.backgroundColor = [UIColor tt_grayBgColor];
    _personalStockUpTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.personalStockUpTableView.rowHeight = UITableViewAutomaticDimension;
    self.personalStockUpTableView.estimatedRowHeight = 44;
    [_personalStockUpTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_offset(SCREEN_HEIGHT - 64-AdaptedHeight(50));
    }];
    
    _personalStockUpTableView.delegate = self;
    _personalStockUpTableView.dataSource = self;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, AdaptedHeight(10))];
    _personalStockUpTableView.tableHeaderView = headerView;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stockUpArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalStokUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:personalStokCell];
    if (cell == nil) {
        cell = [[PersonalStokUpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personalStokCell andTypeStr:@"1"];
    }
    cell.backgroundColor = [UIColor tt_grayBgColor];
    cell.typestr = @"1";
    if ([self.stockUpArray count]) {
        self.rechargeModel = self.stockUpArray[indexPath.row];
        [cell refreshWithModel:self.rechargeModel];
    }
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark-刷新
-(void)refreshData{
    __typeof (self) __weak weakSelf = self;
    self.personalStockUpTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"1";
        [weakSelf.personalStockUpTableView.mj_header beginRefreshing];
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
                    [weakSelf getPersonalRechargeData];
                }else{
                    [weakSelf.personalStockUpTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.personalStockUpTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.personalStockUpTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"2";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf getPersonalRechargeData];
                [weakSelf.personalStockUpTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.personalStockUpTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];

}


@end
