//
//  CKMessageContentViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/12.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKMessageContentViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "ChatMessageViewController.h"
#import <RongIMKit/RongIMKit.h> //融云
#import "CKGroupModel.h"
#import "CKMessageCenterTableViewCell.h"
#import "PTConversationViewController.h"
#import "CKMessageCommon.h"
#import "CKUserMsgListModel.h"

NSString * const MsgListTypeJinFen = @"金粉用户";
NSString * const MsgListTypeYiXiang = @"意向用户";
NSString * const MsgListTypeQianShui = @"潜水用户";
NSString * const MsgListTypeQunZu = @"群发群组";


@interface CKMessageContentViewController ()<ZJScrollPageViewChildVcDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSString *_ckidString;
    NSString *_tokenString;
    NSString *_tgidString;//是否推广员
    NSString *_flagStr;
    NSString *_tagString;
}

@property (nonatomic, strong) CKC_CustomProgressView *viewDataLoading;
@property (nonatomic, strong) JGProgressHUD *viewNetError;
@property (nonatomic, copy)   NSString *type; //消息类型
@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, assign) NSTimeInterval startInterval;
@property (nonatomic, assign) NSTimeInterval endInterval;
@property (nonatomic, assign) NSTimeInterval startLoadMoreInterval;
@property (nonatomic, assign) NSTimeInterval endLoadMoreInterval;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation CKMessageContentViewController


-(void)messageListTitle:(id)data {
    self.titleArray = data;
}

-(NodataLableView *)nodataLableView {
    if (_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - 64 - 49)];
        _nodataLableView.nodataLabel.text = @"暂无消息";
    }
    return _nodataLableView;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)zj_viewDidAppearForIndex:(NSInteger)index {
    
    _type = self.titleArray[index];
    
    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    //检查一下融云的token是否存在
    _tokenString = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:_ckidString]];
    if(IsNilOrNull(_tokenString)){  //如果token为空 重新获取token并连接融云
        [self getRong_CloundToken];
    }
    
    _isLoading = YES;
    [self getMsgData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"[-------viewWillDisappear------]---[%@]",_type);
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
        [self.dataArray removeAllObjects];
        if([_type isEqualToString:MsgListTypeQunZu]){
            for (CKGroupModel *groupM in [self getCacheData]) {
                [self.dataArray addObject:groupM];
            }
        }else{
            for (CKUserMsgListModel *msgModel in [self getCacheData]) {
                [self.dataArray addObject:msgModel];
            }
        }
    }

    [self.messageTableView.mj_header endRefreshing];
    [self.messageTableView.mj_footer endRefreshing];
    [self.messageTableView reloadData];
}

- (RLMResults*)getCacheData {
    
    if([_type isEqualToString:MsgListTypeQunZu]){
        RLMResults *results = [[CacheData shareInstance] search:[CKGroupModel class] sorted:@"grouptime" ascending:NO];
        return results;
    }else{
        RLMResults *results = [[CacheData shareInstance] search:[CKUserMsgListModel class] predicate:[NSString stringWithFormat:@"msgType = '%@'", _type] sorted:@"lastmsgtime" ascending:NO];
        return results;
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
                    [weakSelf getMsgData];
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
        
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
        weakSelf.endLoadMoreInterval = [nowDate timeIntervalSince1970];
        NSTimeInterval value = weakSelf.endLoadMoreInterval - weakSelf.startLoadMoreInterval;
        CGFloat second = [[NSString stringWithFormat:@"%.2f",value] floatValue];//秒
        NSLog(@"间隔------%f秒",second);
        
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                if (value >= Interval) {
                    [weakSelf loadMoreMsgData];
                }else{
                    [weakSelf.messageTableView.mj_footer endRefreshing];
                }
                
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

- (void)refreshMessageData {
    
    [self getMsgData];
}

-(void)getMessageDataWithoutCache {
    if ([self getCacheData].count == 0) {
        [self getMsgData];
    }
}

-(NSString *)getRequestUrl {
    
    if ([_type isEqualToString:MsgListTypeQunZu]) {
        return [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Group/getMyGroups"];
    }else{
        return [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Group/getMyConversations"];
    }
}

-(NSDictionary *)getRequestParams:(NSString*)type {
    
    NSString *rowid = @"0";
    if ([type isEqualToString:@"loadMore"]) {
        rowid = [NSString stringWithFormat:@"%ld", self.dataArray.count];
    }

    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
    if(IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
    
    if ([_type isEqualToString:MsgListTypeQunZu]){
        return @{@"deviceid":uuid, @"ckid":_ckidString, @"pagesize":@"50", @"rowid":rowid};
    }else{
        NSString *conversationtype = @"0";
        if ([_type isEqualToString:MsgListTypeJinFen]) {
            conversationtype = @"0";
        }else if ([_type isEqualToString:MsgListTypeYiXiang]){
            conversationtype = @"1";
        }else if ([_type isEqualToString:MsgListTypeQianShui]){
            conversationtype = @"2";
        }
        return @{@"deviceid":uuid, @"ckid":_ckidString, @"pagesize":@"50", @"rowid":rowid, @"conversationtype":conversationtype};
    }

}

#pragma mark - 请求消息列表数据
-(void)getMsgData {
    
    NSString *requestUrl = [self getRequestUrl];
    NSDictionary *parmasDic = [self getRequestParams:@"refresh"];
    
    if (_nodataLableView) {
        [_nodataLableView removeFromSuperview];
    }
    
    [HttpTool getWithUrl:requestUrl params:parmasDic success:^(id json) {
        
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
            
            RLMResults *result = [[CacheData shareInstance] search:[CKGroupModel class]];
            if (result.count > 0) {
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                [realm deleteObjects:result];
                [realm commitWriteTransaction];
            }
            
            
            if (self.dataArray.count == 0 && [self getCacheData].count == 0) {
                [self.messageTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArray.count];
                [self.messageTableView.mj_header endRefreshing];
            }else{
                [self loadCache];
            }
        }else{
            if (_nodataLableView) {
                [_nodataLableView removeFromSuperview];
            }
            for (NSDictionary *dict in listArr) {
                
                if([_type isEqualToString:MsgListTypeQunZu]){
                    CKGroupModel *groupM = [[CKGroupModel alloc] init];
                    [groupM setValuesForKeysWithDictionary:dict];
                    groupM.groupidKey = [NSString stringWithFormat:@"%@_%@", _ckidString, dict[@"groupid"]];
                    for (NSDictionary *userDict in dict[@"groupinfo"]) {
                        CKGroupInfoModel *memberM = [[CKGroupInfoModel alloc] init];
                        [memberM setValuesForKeysWithDictionary:userDict];
                        [groupM.groupinfoArray addObject:memberM];
                    }
                    
                    //将自己也添加进群组
                    [groupM.groupinfoArray addObject:[CKMessageCommon convertCKInfoToGroupInfo:[CKMessageCommon getCKInfoModel]]];
                    
                    [self.dataArray addObject:groupM];
                }else{
                    CKUserMsgListModel *msgModel = [[CKUserMsgListModel alloc] init];
                    [msgModel setValuesForKeysWithDictionary:dict];
                    msgModel.msgListKey = [NSString stringWithFormat:@"%@_%@_%@", _ckidString, dict[@"meid"], _type];
                    msgModel.msgType = _type;
                    [self.dataArray addObject:msgModel];
                }
            }
            
            [self cacheData:_type];
            
            [self loadCache];
        }
    } failure:^(NSError *error) {
        if (self.dataArray.count == 0) {
            [self.messageTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArray.count];
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

#pragma mark - 加载更多数据
- (void)loadMoreMsgData {
    

    NSString *requestUrl = [self getRequestUrl];
    NSDictionary *paramDic = [self getRequestParams:@"loadMore"];

    if (_isLoading) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }

    if (_nodataLableView) {
        [_nodataLableView removeFromSuperview];
    }

    [HttpTool getWithUrl:requestUrl params:paramDic success:^(id json) {

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


        for (NSDictionary *dict in listArr) {
            if([_type isEqualToString:MsgListTypeQunZu]){
                CKGroupModel *groupM = [[CKGroupModel alloc] init];
                [groupM setValuesForKeysWithDictionary:dict];
                groupM.groupidKey = [NSString stringWithFormat:@"%@_%@", _ckidString, dict[@"groupid"]];
                for (NSDictionary *userDict in dict[@"groupinfo"]) {
                    CKGroupInfoModel *memberM = [[CKGroupInfoModel alloc] init];
                    [memberM setValuesForKeysWithDictionary:userDict];
                    [groupM.groupinfoArray addObject:memberM];
                }
                
                //将自己也添加进群组
                [groupM.groupinfoArray addObject:[CKMessageCommon convertCKInfoToGroupInfo:[CKMessageCommon getCKInfoModel]]];
                [self.dataArray addObject:groupM];
            }else{
                CKUserMsgListModel *msgModel = [[CKUserMsgListModel alloc] init];
                [msgModel setValuesForKeysWithDictionary:dict];
                msgModel.msgListKey = [NSString stringWithFormat:@"%@_%@_%@", _ckidString, dict[@"meid"], _type];
                msgModel.msgType = _type;
                [self.dataArray addObject:msgModel];
            }
        }

        [self cacheData:_type];

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
                
    if([type isEqualToString:MsgListTypeQunZu]){
        
        RLMResults *result = [[CacheData shareInstance] search:[CKGroupModel class]];
        if (result.count > 0) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm deleteObjects:result];
            [realm commitWriteTransaction];
        }
        
        for (CKGroupModel *groupM in self.dataArray) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [CKGroupModel createOrUpdateInRealm:realm withValue:groupM];
            [realm commitWriteTransaction];
        }
    }else{
        
        NSString *predicate = [NSString stringWithFormat:@"msgType = '%@'", _type];

        RLMResults *result = [[CacheData shareInstance] search:[CKUserMsgListModel class] predicate:predicate];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObjects:result];
        [realm commitWriteTransaction];
        
        for (CKUserMsgListModel *msgModel in self.dataArray) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [CKUserMsgListModel createOrUpdateInRealm:realm withValue:msgModel];
            [realm commitWriteTransaction];
        }
    }
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_type isEqualToString:MsgListTypeQunZu]) {
        CKMessageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKMessageCenterTableViewCell"];
        if (cell == nil) {
            cell = [[CKMessageCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKMessageCenterTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.dataArray count]>0) {
            CKGroupModel *groupM = self.dataArray[indexPath.row];
            [cell updateCellWithData:groupM];
        }
        return cell;
    }else{
        CKMessageCenterUserMsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKMessageCenterUserMsgListCell"];
        if (cell == nil) {
            cell = [[CKMessageCenterUserMsgListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKMessageCenterUserMsgListCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.dataArray count]>0) {
            CKUserMsgListModel *msgModel = self.dataArray[indexPath.row];
            [cell updateCellWithData:msgModel];
        }
        
        return cell;
    }
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AdaptedHeight(70);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    NSLog(@"当前状态：%ld", status);
    // 判断融云登录状态
    if (status !=  ConnectionStatus_Connected) {
        [RCloudManager manager];
    }
    
    if([_type isEqualToString:MsgListTypeQunZu]){
        CKGroupModel *groupM = [[CKGroupModel alloc] init];
        groupM = self.dataArray[indexPath.row];
        PTConversationViewController *conversationVC = [[PTConversationViewController alloc] init];
        conversationVC.conversationType = ConversationType_DISCUSSION;
        conversationVC.groupModel = groupM;
        conversationVC.targetId = groupM.rygroupid;
        conversationVC.titleString = groupM.groupname;
        conversationVC.groupId = groupM.groupid;
        conversationVC.userIdArray = [NSMutableArray array];
        for (CKGroupInfoModel *userModel in groupM.groupinfoArray) {
            if (![userModel.meid isEqualToString:_ckidString]) {
                [conversationVC.userIdArray addObject:userModel.meid];
            }
        }
        [self.navigationController pushViewController:conversationVC animated:YES];
    }else{
        
        CKUserMsgListModel *msgModel = [[CKUserMsgListModel alloc] init];
        msgModel = self.dataArray[indexPath.row];

        NSString *ifread = [NSString stringWithFormat:@"%@", msgModel.ifread];
        if ([ifread isEqualToString:@"0"]) {
            //未读数量
            NSString *notreadnum = [NSString stringWithFormat:@"%@", msgModel.notreadnum];
            if ([notreadnum integerValue] > 0) {//未读数>0清除未读消息
                [self userMsgNotReadNO:msgModel];
            }
        }
        
        ChatMessageViewController *chatMessage = [[ChatMessageViewController alloc] init];
        chatMessage.conversationType = ConversationType_PRIVATE;
        chatMessage.targetId = msgModel.meid;
        chatMessage.headUrl = msgModel.head;
        if (!IsNilOrNull(msgModel.remark)) {
            chatMessage.titleString = msgModel.remark;
        }else{
            chatMessage.titleString = msgModel.name;
        }
        
        [self.navigationController pushViewController:chatMessage animated:NO];
    }
}

-(void)userMsgNotReadNO:(CKUserMsgListModel *)messageModel{
    
    NSString *meiId = [NSString stringWithFormat:@"%@", messageModel.meid];
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

-(void)createLoadDataUI {
    self.viewDataLoading = [[CKC_CustomProgressView alloc] init];
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

- (void)dealloc {
    [CKCNotificationCenter removeObserver:self name:NOTI_NAME_POST object:nil];
    [CKCNotificationCenter removeObserver:self name:@"refreshMessage" object:nil];
    [CKCNotificationCenter removeObserver:self name:@"RequestMessageData" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
