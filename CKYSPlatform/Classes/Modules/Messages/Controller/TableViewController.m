//
//  TableViewController.m
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TableViewController.h"
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

@interface TableViewController ()<ZJScrollPageViewChildVcDelegate, UITableViewDelegate,UITableViewDataSource>
{
   NSString *_ckidString;
   NSString *_conversationId;
   NSString *_tokenString;
   NSString *_tgidString;//是否推广员
   NSString *_flagStr;
   NSString *_tagString;
}

@property (nonatomic, strong) CKC_CustomProgressView *viewDataLoading;
@property (nonatomic, strong) JGProgressHUD *viewNetError;
@property (nonatomic, copy)   NSString *type; //消息类型
@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong) NSMutableArray *data_array;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, assign) NSTimeInterval startInterval;
@property (nonatomic, assign) NSTimeInterval endInterval;
@property (nonatomic, strong) CKOfficialAlert *noticeAlert;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) MessageModel *messageModel;
@property (nonatomic, strong) CKSysMsgModel *sysTypeModel;
@property (nonatomic, strong) CKOfficialMsgModel *officialModel;
@property (nonatomic, strong) CKSysMsgListModel *sysModel;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation TableViewController

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
    
//    [self loadCache];

    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    //检查一下融云的token是否存在
    _tokenString = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:_ckidString]];
    if ([_type isEqualToString:KMsgType_Customer]) {
        if(IsNilOrNull(_tokenString)){  //如果token为空 重新获取token并连接融云
            [self getRong_CloundToken];
        }
    }
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
    
    [self createLoadDataUI];
    [self createTableView];
    
    [self refreshData];
}

#pragma mark - 创建顾客消息列表 订单消息  系统消息tableview
-(void)createTableView{
    //消息
    _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - 64 - 49 - AdaptedHeight(35))];
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
        if ([_type isEqualToString:KMsgType_Customer]) {
            for (MessageModel *msgM in [self getCacheData]) {
                [self.data_array addObject:msgM];
            }
        }else if([_type isEqualToString:KMsgType_System]){
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
    
//    NSString *predicate = [NSString stringWithFormat:@"ckid == '%@'", _ckidString];
//
//    if ([_type isEqualToString:KMsgType_Customer]) {
//        RLMResults *results = [[CacheData shareInstance] search:[MessageModel class] predicate:predicate sorted:@"lastmsgtime" ascending:NO ];
//        return results;
//    }else if([_type isEqualToString:KMsgType_System]){
//        RLMResults *results = [[CacheData shareInstance] search:[CKSysMsgListModel class] predicate:predicate sorted:@"msgtime" ascending:NO];
//        return results;
//    }else if([_type isEqualToString:KMsgType_Official]){
//        RLMResults *results = [[CacheData shareInstance] search:[CKOfficialMsgModel class] predicate:predicate sorted:@"time" ascending:NO];
//        return results;
//    }else{
//        return nil;
//    }
    
    if ([_type isEqualToString:KMsgType_Customer]) {
        RLMResults *results = [[CacheData shareInstance] search:[MessageModel class] predicate:nil sorted:@"lastmsgtime" ascending:NO];
        return results;
    }else if([_type isEqualToString:KMsgType_System]){
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

#pragma mark-获取融云token
-(void)getRong_CloundToken{
    
    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
    NSString *smallName = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KnickName]];
    if (IsNilOrNull(smallName)) {
        smallName = _ckidString;
    }
    NSString *headImageUrl = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:kheamImageurl]];
    if (IsNilOrNull(headImageUrl)) {
        headImageUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,DefaultHeadPath];
    }
    NSDictionary *refreshPramaDic = @{@"id":_ckidString, @"name": smallName, @"pic":headImageUrl, DeviceId:uuid};
    NSString *refreshUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getRongYunToken];
    
    [HttpTool postWithUrl:refreshUrl params:refreshPramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]){
            return ;
        }
        _tokenString = [NSString stringWithFormat:@"%@",dict[@"token"]];
        
        //链接融云服务器
        [[RCIM sharedRCIM] connectWithToken:_tokenString success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            //设置当前登录的用户信息（不设置也有头像  获取token的时候已经把 头像传入）
            [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:_ckidString name: smallName portrait: headImageUrl];
            
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", status);
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSString *refreshUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getRongYunToken];
            NSDictionary *refreshPramaDic = @{@"id":_ckidString, @"name": smallName, @"pic": headImageUrl, DeviceId:uuid};
            [HttpTool postWithUrl:refreshUrl params:refreshPramaDic success:^(id json) {
                NSDictionary *dict = json;
                NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
                if (![code isEqualToString:@"200"]){
                    return ;
                }
                NSString *token = [NSString stringWithFormat:@"%@",dict[@"token"]];
                [KUserdefaults setObject:token forKey:_ckidString];
                [KUserdefaults synchronize];
                
            } failure:^(NSError *error) {
                NSLog(@"token错误");
            }];
            
        }];

        [KUserdefaults setObject:_tokenString forKey:_ckidString];
        [KUserdefaults synchronize];
        
    } failure:^(NSError *error) {
        NSLog(@"token错误");
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
    if ([type isEqualToString:KMsgType_Customer]) {
        requestUrl = [NSString stringWithFormat:@"%@%@", PostMessageAPI, getConversations_Url];
    }else if ([type isEqualToString:KMsgType_System]){
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
    
    if ([_type isEqualToString:KMsgType_Customer]) {
        paramsDic = @{@"ckid":_ckidString,
                      @"pagesize":@"20",
                      @"id":conversationId,
                      DeviceId:uuid
                      };
//        paramsDic = @{@"ckid":@"117333",
//                      @"pagesize":@"20",
//                      @"id":@"0",
//                      @"deviceid":@"04EF87A9-9FE1-4449-84F4-B791A287393C"
//                      };
    }else if ([_type isEqualToString:KMsgType_System]){
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
    if ([_type isEqualToString:KMsgType_Customer]) {
//        RLMResults *result = [self getCacheData];
//        if (result.count > 0) {
//            MessageModel *msgModel = result.lastObject;
//            _conversationId = msgModel.ID;
//        }else{
//            _conversationId = @"0";
//        }
        _conversationId = @"0";
    }else if ([type isEqualToString:KMsgType_Official]){
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
    
//    if (_isLoading) {
//        [[UIApplication sharedApplication].keyWindow addSubview:self.viewDataLoading];
//        [self.viewDataLoading startAnimation];
//    }
    
    
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
            for (NSDictionary *dict in listArr) {
                if ([type isEqualToString:KMsgType_Customer]) {
                    MessageModel *msgModel = [[MessageModel alloc] init];
                    [msgModel setValuesForKeysWithDictionary:dict];
                    msgModel.ckid = _ckidString;
                    [self.data_array addObject:msgModel];
                }else if([type isEqualToString:KMsgType_System]){
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
            
            if (self.data_array.count != 0) {
                if (_nodataLableView) {
                    [_nodataLableView removeFromSuperview];
                }
            }
            
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
//        [self.viewDataLoading stopAnimation];
    }];
}

-(void)loadMoreMsgDataWithType:(NSString*)type{
    
    if ([_type isEqualToString:KMsgType_Customer]) {
        if (_data_array.count > 0) {
            MessageModel *msgModel = _data_array.lastObject;
            _conversationId = msgModel.ID;
        }
    }else if ([type isEqualToString:KMsgType_Official]){
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
            if ([_type isEqualToString:KMsgType_Customer]) {
                MessageModel *msgModel = [[MessageModel alloc] init];
                [msgModel setValuesForKeysWithDictionary:listDic];
                msgModel.ckid = _ckidString;
                [self.data_array addObject:msgModel];
            }else if ([type isEqualToString:KMsgType_Official]){
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
    if ([type isEqualToString:KMsgType_Customer]) {
        for (NSInteger i = 0; i < self.data_array.count; i++) {
            MessageModel *msgModel = self.data_array[i];
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [MessageModel createOrUpdateInRealm:realm withValue:msgModel];
            [realm commitWriteTransaction];
        }
    }else if([type isEqualToString:KMsgType_System]){
        for (CKSysMsgListModel *sysListM in self.data_array) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [CKSysMsgListModel createOrUpdateInRealm:realm withValue:sysListM];
            [realm commitWriteTransaction];
        }
    }else if([type isEqualToString:KMsgType_Official]){
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
    
    if ([_type isEqualToString:KMsgType_Customer]) {
        ListMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ckIdentifier];
        if (cell == nil) {
            cell = [[ListMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ckIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.data_array count]) {
            _messageModel = self.data_array[indexPath.row];
            [cell refreshWithModel:_messageModel];
        }
        return cell;
    }else if([_type isEqualToString:KMsgType_System]){
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
    
    if ([_type isEqualToString:KMsgType_Customer]){
        //点击顾客列表  进入和顾客聊天的详情
        if ([self.data_array count]) {
            _messageModel = self.data_array[indexPath.row];
        }
        //未读数量
        NSString *notReadNum = [NSString stringWithFormat:@"%ld", _messageModel.notreadcount];
        if (IsNilOrNull(notReadNum)){
            notReadNum = @"0";
        }
        
        if(![notReadNum isEqualToString:@"0"]){  //未读数>0清除未读消息
            [self clearMessageNoticeWithMessageModel:_messageModel];
        }
        
        if([_tgidString isEqualToString:@"0"]){//非推广员登录
            ChatMessageViewController *chatMessage = [[ChatMessageViewController alloc] init];
            chatMessage.conversationType = ConversationType_PRIVATE;
            //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
            chatMessage.targetId = _messageModel.meid;
            chatMessage.headUrl = _messageModel.headurl;
            //设置聊天会话界面要显示的标题
            chatMessage.titleString = _messageModel.smallname;
            [self.navigationController pushViewController:chatMessage animated:NO];
        }
    }else if([_type isEqualToString:KMsgType_System]){
        
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

/**添加风火轮*/
-(void)createLoadDataUI {
    // 增加风火轮
    self.viewDataLoading = [[CKC_CustomProgressView alloc] init];
    // 增加网络错误时提示
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.indicatorView = nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionBottomCenter;
    self.viewNetError.marginInsets = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
}

//添加提示view
- (void)showNoticeView:(NSString*)title
{
    if (IsNilOrNull(title)){
        return;
    }
    if (self.viewNetError && !self.viewNetError.visible) {
        self.viewNetError.textLabel.text = title;
        [self.viewNetError showInView:[UIApplication sharedApplication].keyWindow];
        [self.viewNetError dismissAfterDelay:1.5f];
    }
}

-(void)dealloc{
    [CKCNotificationCenter removeObserver:self name:NOTI_NAME_POST object:nil];
    [CKCNotificationCenter removeObserver:self name:@"refreshMessage" object:nil];
    [CKCNotificationCenter removeObserver:self name:@"RequestMessageData" object:nil];
}

@end
