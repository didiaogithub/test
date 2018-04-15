//
//  NoticeListViewController.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "NoticeListViewController.h"
#import "CKNoticeCell.h"
#import "CKSysMsgModel.h"
#import "NodataLableView.h"


@interface NoticeListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, copy)   NSString *tgidString;
@property (nonatomic, copy)   NSString *ckidString;
@property (nonatomic, copy)   NSString *lineNum;

@end

@implementation NoticeListViewController

-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NodataLableView *)nodataLableView {
    if (_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT - 64)];
        _nodataLableView.nodataLabel.text = @"暂无消息";
    }
    return _nodataLableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
    [self loadCache];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.msgName;
    [self initComponents];
}

-(void)initComponents {
    
    _lineNum = @"0";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        _tableView.frame = CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64-NaviAddHeight-BOTTOM_BAR_HEIGHT);
    }else{
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    _tableView.backgroundColor = [UIColor tt_grayBgColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self refreshData];
    
    [self requestData];
    
}

-(void)requestData {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", PostMessageAPI, getSystemMsgs];
    _lineNum = @"0";
    NSString *rcvtime = @"";
    RLMResults *results = [self getCacheData];
    if (results.count > 0) {
        CKSysMsgModel *msgModel = results.firstObject;
        rcvtime = msgModel.time;
    }
    
    NSMutableDictionary *paramDics = [self generateRequestParams:_lineNum rcvtime:rcvtime];
    
    [HttpTool postWithUrl:requestUrl params:paramDics success:^(id json) {
        
        [self.viewDataLoading stopAnimation];
        NSDictionary *listDic = json;
        NSString *code = [NSString stringWithFormat:@"%@",listDic[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:listDic[@"codeinfo"]];
            [self.tableView.mj_header endRefreshing];
            return ;
        }
    
        NSArray *listArr = listDic[@"list"];
        if (listArr.count == 0) {
            if (self.dataArray.count == 0) {
                [self.tableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArray.count];
            }
            [self.tableView.mj_header endRefreshing];
            return;
        }
        
        [self writeToDB:listArr];

        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        if (self.dataArray.count == 0) {
            [self.tableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArray.count];
        }
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
    }];
}

-(void)writeToDB:(NSArray*)listArr {

    NSMutableArray *tmp = [NSMutableArray array];
    for (NSDictionary *dict in listArr) {
        CKSysMsgModel *msgModel = [[CKSysMsgModel alloc] init];
        [msgModel setValuesForKeysWithDictionary:dict];
        msgModel.type = self.type;
        msgModel.type_id = [NSString stringWithFormat:@"%@_%@", self.type, msgModel.ID];
        [tmp addObject:msgModel];
    }
    
    for (NSInteger i = 0; i < tmp.count; i++) {
        CKSysMsgModel *msgModel = tmp[i];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [CKSysMsgModel createOrUpdateInRealm:realm withValue:msgModel];
        [realm commitWriteTransaction];
    }
    
    [self bindData];
}

-(RLMResults*)getCacheData {
    NSString *predicate = [NSString stringWithFormat:@"type = '%@'", self.type];
    RLMResults *results = [[CacheData shareInstance] search:[CKSysMsgModel class] predicate:predicate sorted:@"time" ascending:NO ];
    return results;
}

-(void)loadCache {
    RLMResults *result = [self getCacheData];
    if (result.count > 0) {
        if (_nodataLableView) {
            [_nodataLableView removeFromSuperview];
        }
        [self.dataArray removeAllObjects];
        
        for (CKSysMsgModel *sysModel in result) {
            CellModel *noticeModel = [self createCellModel:[CKNoticeCell class] userInfo: sysModel height:[CKNoticeCell computeHeight:sysModel.msg]];
            
            SectionModel *noticeSection = [self createSectionModel:@[noticeModel] headerHeight:0.1 footerHeight:0.1];
            [self.dataArray addObject:noticeSection];
        }
        
        [self.tableView reloadData];
    }
}

-(NSMutableDictionary*)generateRequestParams:(NSString*)lineNumber rcvtime:(NSString*)rcvtime {
    //参数：ckid:创客id, tgid:推广人id, pagesize:分页大小, id:行号 type:1：订单 2：开店 3：云豆 4：产品
    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *tgStr = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    _tgidString = IsNilOrNull(tgStr) ? @"0" : tgStr;
    
    NSDictionary *paramsDic = @{@"ckid":_ckidString,
                                @"pagesize":@"20",
                                @"id": lineNumber,
                                @"type": self.type
                                };
    
    NSMutableDictionary *paramDics = [NSMutableDictionary dictionaryWithDictionary:paramsDic];
    if (![_tgidString isEqualToString:@"0"]){
        [paramDics setValue:_tgidString forKey:@"tgid"];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    if (_nodataLableView) {
        [_nodataLableView removeFromSuperview];
    }
    
    return paramDics;
}

-(void)loadMoreMsgData {
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", PostMessageAPI, getSystemMsgs];
    NSInteger i = [_lineNum integerValue];
    _lineNum = [NSString stringWithFormat:@"%ld", i + _dataArray.count];
    
    NSMutableDictionary *paramDics = [self generateRequestParams:_lineNum rcvtime:nil];
    
    [HttpTool postWithUrl:requestUrl params:paramDics success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *listDic = json;
        NSString *code = [NSString stringWithFormat:@"%@",listDic[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:listDic[@"codeinfo"]];
            [self.tableView.mj_header endRefreshing];
            return ;
        }

        NSArray *listArr = listDic[@"list"];
        if (listArr.count == 0) {
            if (self.dataArray.count == 0) {
                [self.tableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArray.count];
            }
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        [self writeToDB:listArr];
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [self.tableView.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
    }];
}

-(void)bindData {
    
    RLMResults *result = [self getCacheData];
    if (result.count > 0) {
        if (_nodataLableView) {
            [_nodataLableView removeFromSuperview];
        }
        [self.dataArray removeAllObjects];
        
        for (CKSysMsgModel *sysModel in result) {
            CellModel *noticeModel = [self createCellModel:[CKNoticeCell class] userInfo: sysModel height:[CKNoticeCell computeHeight:sysModel.msg]];
            
            SectionModel *noticeSection = [self createSectionModel:@[noticeModel] headerHeight:0.1 footerHeight:0.1];
            [self.dataArray addObject:noticeSection];
        }
    }
}

-(CellModel*)createCellModel:(Class)cls userInfo:(id)userInfo height:(CGFloat)height {
    CellModel *model = [[CellModel alloc] init];
    model.selectionStyle = UITableViewCellSelectionStyleNone;
    model.userInfo = userInfo;
    model.height = height;
    model.className = NSStringFromClass(cls);
    return model;
}

-(SectionModel*)createSectionModel:(NSArray<CellModel*>*)items headerHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight {
    SectionModel *model = [SectionModel sectionModelWithTitle:nil cells:items];
    model.headerhHeight = headerHeight;
    model.footerHeight = footerHeight;
    return model;
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_dataArray){
        return _dataArray.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SectionModel *s = _dataArray[section];
    if(s.cells) {
        return s.cells.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionModel *s = _dataArray[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    
    CKNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:item.reuseIdentifier];
    if(!cell) {
        cell = [[NSClassFromString(item.className) alloc] initWithStyle:item.style reuseIdentifier:item.reuseIdentifier];
    }
    cell.selectionStyle = item.selectionStyle;
    cell.accessoryType = item.accessoryType;
    cell.delegate = item.delegate;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModel *s = _dataArray[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    
    if(item.title) {
        cell.textLabel.text = item.title;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithRed:0.294 green:0.298 blue:0.302 alpha:1.00];
    }
    if(item.subTitle) {
        cell.detailTextLabel.text = item.subTitle;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.294 green:0.298 blue:0.302 alpha:1.00];
    }
    
    SEL selector = NSSelectorFromString(@"fillNoticeData:");
    if([cell respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
        [cell performSelector:selector withObject:item.userInfo];
#pragma clang diagnostic pop
    }
}

#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionModel *s = _dataArray[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    return item.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SectionModel *s = _dataArray[section];
    return s.headerhHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SectionModel *s = _dataArray[section];
    return s.footerHeight;
}

#pragma mark - 设置刷新
-(void)refreshData{
    __typeof (self) __weak weakSelf = self;
    self.tableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header beginRefreshing];
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
                    [weakSelf requestData];
                }else{
                    [weakSelf.tableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView:NetWorkNotReachable];
                [weakSelf.tableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.tableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf loadMoreMsgData];
                [weakSelf.tableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView:NetWorkNotReachable];
                [weakSelf.tableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
}

@end
