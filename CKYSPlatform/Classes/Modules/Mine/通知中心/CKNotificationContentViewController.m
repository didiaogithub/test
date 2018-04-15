//
//  CKNotificationContentViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/15.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKNotificationContentViewController.h"
#import "ListMessageTableViewCell.h"
#import "ZJScrollPageViewDelegate.h"
#import "MessageModel.h"
#import "ChatMessageViewController.h"
#import <RongIMKit/RongIMKit.h> //融云
#import "CKSysMsgCell.h"
#import "CKSysMsgModel.h"
#import "CKOfficialMsgCell.h"
#import "CKOfficialMsgModel.h"

#import "NoticeListViewController.h"
#import "CKOfficialAlert.h"
#import "CKC_CustomProgressView.h"
#import "WebDetailViewController.h"
#import "ClassDetailViewController.h"


static NSString *ckIdentifier = @"ListMessageTableViewCell";

@interface CKNotificationContentViewController ()<ZJScrollPageViewChildVcDelegate, UITableViewDelegate,UITableViewDataSource>
{
    NSString *_ckidString;
    NSString *_conversationId;
    NSString *_tgidString;//是否推广员
    NSString *_flagStr;
    NSString *_tagString;
}


@property (nonatomic, copy)   NSString *type; //消息类型
@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong) NSMutableArray *data_array;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, strong) CKOfficialAlert *noticeAlert;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) CKSysMsgModel *sysTypeModel;
@property (nonatomic, strong) CKOfficialMsgModel *officialModel;
@property (nonatomic, strong) CKSysMsgListModel *sysModel;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation CKNotificationContentViewController

-(void)passTitleArray:(id)data {
    self.titleArray = data;
}

-(NodataLableView *)nodataLableView {
    if (_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - 64 - 49)];
        _nodataLableView.nodataLabel.text = @"暂无消息";
    }
    return _nodataLableView;
}

-(NSMutableArray *)data_array{
    if (_data_array == nil) {
        _data_array = [NSMutableArray array];
    }
    return _data_array;
}


-(void)zj_viewDidAppearForIndex:(NSInteger)index {
    
    _type = self.titleArray[index];
    
    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;

    if(![_conversationId isEqualToString:@"0"]){
        _conversationId = @"0";
    }
    
    _isLoading = YES;
    [self getMsgDataWithType:_type];
    
    if([_type isEqualToString:KMsgType_System]){
        self.messageTableView.mj_footer = nil;
    }
    
    [self requestNotReadCount:index];
}

-(void)returnIndex:(SelectedIndexBlock)block {
    self.selectedIndexBlock = block;
}

-(void)requestNotReadCount:(NSInteger)index {
    if (self.selectedIndexBlock != nil) {
        self.selectedIndexBlock(index);
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.viewDataLoading stopAnimation];
    NSLog(@"[-------viewWillDisappear------]---[%@]",_type);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor tt_grayBgColor];
    
    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *tgStr = [KUserdefaults objectForKey:KSales];
    _tgidString = IsNilOrNull(tgStr) ? @"0" : tgStr;
    
    [CKCNotificationCenter addObserver:self selector:@selector(refreshMessageData) name:@"refreshMessage" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(getMessageDataWithoutCache) name:@"RequestMessageData" object:nil];
    
    [self initComponnent];
}

-(void)initComponnent {
    
    [self createTableView];
    
    [self refreshData];
}

#pragma mark - 创建顾客消息列表 订单消息  系统消息tableview
-(void)createTableView{
    //消息
    _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - AdaptedHeight(35))];
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messageTableView.backgroundColor = [UIColor tt_grayBgColor];
    [self.view addSubview:_messageTableView];
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
}

-(void)loadCache {
    if ([self getCacheData].count > 0) {
        if (_nodataLableView) {
            [_nodataLableView removeFromSuperview];
        }
        [self.data_array removeAllObjects];
        if([_type isEqualToString:KMsgType_System]){
            for (CKSysMsgListModel *msgM in [self getCacheData]) {
                [self.data_array addObject:msgM];
            }
        }else if([_type isEqualToString:KMsgType_Official]){
            for (CKOfficialMsgModel *msgM in [self getCacheData]) {
                [self.data_array addObject:msgM];
            }
        }
    }
    
    [self.messageTableView.mj_header endRefreshing];
    [self.messageTableView.mj_footer endRefreshing];
    [self.messageTableView reloadData];
}

-(RLMResults*)getCacheData {
    
    if([_type isEqualToString:KMsgType_System]){
        RLMResults *results = [[CacheData shareInstance] search:[CKSysMsgListModel class] predicate:nil sorted:@"msgtime" ascending:NO];
        return results;
    }else if([_type isEqualToString:KMsgType_Official]){
        RLMResults *results = [[CacheData shareInstance] search:[CKOfficialMsgModel class] predicate:nil sorted:@"time" ascending:NO];
        return results;
    }else{
        return nil;
    }
}

#pragma mark - 设置刷新
-(void)refreshData{
    __typeof (self) __weak weakSelf = self;
    self.messageTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        [weakSelf.messageTableView.mj_header beginRefreshing];
        
        _isLoading = NO;
        
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
                    [weakSelf getMsgDataWithType:_type];
                }else{
                    [weakSelf.messageTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView:NetWorkNotReachable];
                [weakSelf.messageTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.messageTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        
        _isLoading = NO;
        
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf loadMoreMsgDataWithType:_type];
                [weakSelf.messageTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView:NetWorkNotReachable];
                [weakSelf.messageTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
}

-(void)refreshMessageData{
    if(![_conversationId isEqualToString:@"0"]){
        _conversationId = @"0";
    }
    [self getMsgDataWithType:_type];
}

-(void)getMessageDataWithoutCache {
    if ([self getCacheData].count == 0) {
        [self getMsgDataWithType:_type];
    }
}

-(NSString *)getRequestUrl:(NSString *)type {
    
    NSString *requestUrl = @"";
    if ([type isEqualToString:KMsgType_System]){
        requestUrl = [NSString stringWithFormat:@"%@%@", PostMessageAPI, getSysMsgInfo];
    }else if ([type isEqualToString:KMsgType_Official]){
        requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getofficialsMsgs];
    }
    return requestUrl;
}

-(NSDictionary *)getRequestParamsWithId:(NSString *)conversationId sendtime:(NSString*)sendtime {
    
    NSString *tgStr = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    _tgidString = IsNilOrNull(tgStr) ? @"0" : tgStr;
    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
    if(IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
    NSDictionary *paramsDic = [[NSDictionary alloc] init];
    
    if ([_type isEqualToString:KMsgType_System]){
        paramsDic = @{@"ckid":_ckidString,
                      DeviceId:uuid
                      };
    }else if ([_type isEqualToString:KMsgType_Official]){
        paramsDic = @{@"ckid":_ckidString,
                      @"pagesize":@"20",
                      @"id":conversationId,
                      };
        if (!IsNilOrNull(sendtime)) {
            paramsDic = @{@"ckid":_ckidString,
                          @"pagesize":@"20",
                          @"id":conversationId,
                          DeviceId:uuid,
                          @"sendtime":sendtime
                          };
        }
    }
    
    NSMutableDictionary *paramDics = [NSMutableDictionary dictionaryWithDictionary:paramsDic];
    if (![_tgidString isEqualToString:@"0"]){
        [paramDics setValue:_tgidString forKey:@"tgid"];
    }
    
    return paramDics;
}

#pragma mark - 请求消息列表数据
-(void)getMsgDataWithType:(NSString *)type{
    
    NSString *requestUrl = [self getRequestUrl:type];
    NSString *sendtime = @"";
    if ([type isEqualToString:KMsgType_Official]){
        RLMResults *result = [self getCacheData];
        if (result.count > 0) {
            CKOfficialMsgModel *msgModel = result.lastObject;
            _conversationId = msgModel.ID;
            sendtime = msgModel.time;
        }else{
            _conversationId = @"0";
        }
    }else{
        _conversationId = @"0";
    }
    
    
    NSDictionary *parmasDic = [self getRequestParamsWithId:_conversationId sendtime:sendtime];
    
    
    if (_nodataLableView) {
        [_nodataLableView removeFromSuperview];
    }
    
    [HttpTool postWithUrl:requestUrl params:parmasDic success:^(id json) {
        
        //        [self.viewDataLoading stopAnimation];
        NSDictionary *listDic = json;
        NSString *code = [NSString stringWithFormat:@"%@", listDic[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:listDic[@"codeinfo"]];
            [self.messageTableView.mj_header endRefreshing];
            return ;
        }
        
        NSArray *listArr = listDic[@"list"];
        if (listArr.count == 0) {
            if (self.data_array.count == 0 && [self getCacheData].count == 0) {
                [self.messageTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.data_array.count];
                [self.messageTableView.mj_header endRefreshing];
            }else{
                [self loadCache];
            }
        }else{
            if (_nodataLableView) {
                [_nodataLableView removeFromSuperview];
            }
            for (NSDictionary *dict in listArr) {
                if([type isEqualToString:KMsgType_System]){
                    CKSysMsgListModel *msgModel = [[CKSysMsgListModel alloc] init];
                    [msgModel setValuesForKeysWithDictionary:dict];
                    msgModel.ckid = _ckidString;
                    [self.data_array addObject:msgModel];
                }else if([type isEqualToString:KMsgType_Official]){
                    CKOfficialMsgModel *msgModel = [[CKOfficialMsgModel alloc] init];
                    [msgModel setValuesForKeysWithDictionary:dict];
                    msgModel.ckid = _ckidString;
                    [self.data_array addObject:msgModel];
                }
            }
            
            [self cacheData:type];
            
            
            [self loadCache];
        }
    } failure:^(NSError *error) {
        if (self.data_array.count == 0) {
            [self.messageTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.data_array.count];
        }
        
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        
        [self.messageTableView.mj_header endRefreshing];
    }];
}

-(void)loadMoreMsgDataWithType:(NSString*)type{
    
    if ([type isEqualToString:KMsgType_Official]){
        if (_data_array.count > 0) {
            _conversationId = [NSString stringWithFormat:@"%zd", self.data_array.count];
        }
    }
    
    NSString *requestUrl = [self getRequestUrl:type];
    NSDictionary *paramDic = [self getRequestParamsWithId:_conversationId sendtime:nil];
    
    if (_isLoading) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    
    if (_nodataLableView) {
        [_nodataLableView removeFromSuperview];
    }
    
    [HttpTool postWithUrl:requestUrl params:paramDic success:^(id json) {
        
        [self.viewDataLoading stopAnimation];
        NSDictionary *listDic = json;
        NSString *code = [NSString stringWithFormat:@"%@",listDic[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:listDic[@"codeinfo"]];
            [self.messageTableView.mj_header endRefreshing];
            return ;
        }
        NSArray *listArr = listDic[@"list"];
        if (listArr.count == 0) {
            [self.messageTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        
        for (NSDictionary *listDic in listArr) {
            if ([type isEqualToString:KMsgType_Official]){
                CKOfficialMsgModel *msgModel = [[CKOfficialMsgModel alloc] init];
                [msgModel setValuesForKeysWithDictionary:listDic];
                msgModel.ckid = _ckidString;
                [self.data_array addObject:msgModel];
            }
        }
        
        [self cacheData:type];
        
        [self loadCache];
        
    } failure:^(NSError *error) {
        
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        
        [self.messageTableView.mj_footer endRefreshing];
        [self.viewDataLoading stopAnimation];
    }];
}

-(void)cacheData:(NSString*)type {
    if([type isEqualToString:KMsgType_System]){
        
        RLMResults *result = [[CacheData shareInstance] search:[CKSysMsgListModel class]];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObjects:result];
        [realm commitWriteTransaction];
        
        for (CKSysMsgListModel *sysListM in self.data_array) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [CKSysMsgListModel createOrUpdateInRealm:realm withValue:sysListM];
            [realm commitWriteTransaction];
        }
    }else if([type isEqualToString:KMsgType_Official]){
        
        RLMResults *result = [[CacheData shareInstance] search:[CKOfficialMsgModel class]];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObjects:result];
        [realm commitWriteTransaction];
        
        for (CKOfficialMsgModel *offM in self.data_array) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [CKOfficialMsgModel createOrUpdateInRealm:realm withValue:offM];
            [realm commitWriteTransaction];
        }
    }
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([_type isEqualToString:KMsgType_System]){
        CKSysMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKSysMsgCell"];
        if (cell == nil) {
            cell = [[CKSysMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKSysMsgCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.data_array count]) {
            _sysModel = self.data_array[indexPath.row];
            [cell refreshWithModel:_sysModel iconName: [_sysModel.type integerValue]];
        }
        return cell;
    }else if([_type isEqualToString:KMsgType_Official]){
        //官方通知
        CKOfficialMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKOfficialMsgCell"];
        if (cell == nil) {
            cell = [[CKOfficialMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKOfficialMsgCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.data_array count]) {
            _officialModel = self.data_array[indexPath.row];
            [cell refreshWithModel:_officialModel iconName:indexPath.row];
        }
        return cell;
    }
    return nil;
}

#pragma mark - TableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([_type isEqualToString:KMsgType_System]){
        
        //点击顾客列表  进入和顾客聊天的详情
        if ([self.data_array count]) {
            _sysModel = self.data_array[indexPath.row];
        }
        //未读数量
        NSString *notReadNum = [NSString stringWithFormat:@"%ld",_sysModel.notreadnum];
        if (IsNilOrNull(notReadNum)){
            notReadNum = @"0";
        }
        
        if(![notReadNum isEqualToString:@"0"]){  //未读数>0清除未读消息
            [self clearNotReadMsg:_sysModel.type];
        }
        
        NoticeListViewController *list = [[NoticeListViewController alloc] init];
        list.msgName = [NSString stringWithFormat:@"%@", _sysModel.title];
        list.type = [NSString stringWithFormat:@"%@", _sysModel.type];
        [self.navigationController pushViewController:list animated:YES];
    }else{
        
        if ([self.data_array count]) {
            _officialModel = self.data_array[indexPath.row];
        }
        //需要根据通知类型来判断 news;头条 course：课程 plat:官方通知
        if([_officialModel.type isEqualToString:@"news"]){
            NSString *detailUrl = [NSString loadImagePathWithString:_officialModel.url];
            WebDetailViewController *webView = [[WebDetailViewController alloc] init];
            webView.detailUrl = detailUrl;
            webView.typeString = @"news";
            webView.shareTitle = _officialModel.title;
            webView.shareDescrip = _officialModel.msg;
            webView.imgUrl = _officialModel.imgurl;
            [self.navigationController pushViewController:webView animated:YES];
        }else if ([_officialModel.type isEqualToString:@"course"]){
            
            //阅读量设置
            NSString *urlStr = [NSString stringWithFormat:@"%@%@", WebServiceAPI, setViewed];
            NSDictionary *params = @{@"type": @"course", @"id": _officialModel.ID};
            [HttpTool postWithUrl:urlStr params:params success:^(id json) {
                NSDictionary *dict = json;
                NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
                if ([code isEqualToString:@"200"]) {
                    
                }
            } failure:^(NSError *error) {
                
            }];
            
            ClassDetailViewController *classDetail = [[ClassDetailViewController alloc] init];
            NSString *detailUrl = [NSString stringWithFormat:@"%@",_officialModel.url];
            
            if (IsNilOrNull(detailUrl)) {
                detailUrl = @"";
            }
            classDetail.viewsString = [NSString stringWithFormat:@"%@",_officialModel.viewed];
            classDetail.detailUrl = detailUrl;
            [self.navigationController pushViewController:classDetail animated:YES];
            
        }else{
            self.noticeAlert = [CKOfficialAlert shareInstance];
            self.noticeAlert.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.noticeAlert.titleLabel.textColor = [UIColor blackColor];
            self.noticeAlert.subTitleLable.text = _officialModel.msg;
            [self.noticeAlert showAlert: _officialModel.title];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([_type isEqualToString:KMsgType_Official]){
        if (SCREEN_HEIGHT <= 568) {
            return AdaptedHeight(165);
        }
        return AdaptedHeight(150);
    }
    return AdaptedHeight(70);
}

-(void)clearMessageNoticeWithMessageModel:(MessageModel *)messageModel{
    
    NSString *meiId = [NSString stringWithFormat:@"%@",messageModel.meid];
    if (IsNilOrNull(meiId)) {
        meiId = @"";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *clearUrl = [NSString stringWithFormat:@"%@%@", PostMessageAPI, clearAllNotReadMsg_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString, @"senderid":meiId, DeviceId:uuid};
    [HttpTool postWithUrl:clearUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            NSLog(@"%@",dict[@"codeinfo"]);
            return ;
        }
    } failure:^(NSError *error) {
        NSLog(@"网络请求超时，请刷新重试");
    }];
}

-(void)clearNotReadMsg:(NSString*)type {//type:(1：订单 2：开店 3：云豆 4：产品)
    if (IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
    NSString *clearUrl = [NSString stringWithFormat:@"%@%@", PostMessageAPI, clearNotReadNum];
    NSDictionary *pramaDic = @{@"ckid":_ckidString, @"type": type};
    [HttpTool postWithUrl:clearUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            NSLog(@"%@",dict[@"codeinfo"]);
            return ;
        }
    } failure:^(NSError *error) {
        NSLog(@"网络请求超时，请刷新重试");
    }];
}

-(void)dealloc{
    [CKCNotificationCenter removeObserver:self name:NOTI_NAME_POST object:nil];
    [CKCNotificationCenter removeObserver:self name:@"refreshMessage" object:nil];
    [CKCNotificationCenter removeObserver:self name:@"RequestMessageData" object:nil];
}

@end
