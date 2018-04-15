//
//  PTConversationViewController.m
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/9.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "PTConversationViewController.h"
#import "RCDGroupSettingsTableViewController.h"
#import "FFAlertView.h"
#import "PTContactorModel.h"
#import "NSDate+Common.h"
#import "CKMessageCommon.h"
#import "CKCoversationProgressView.h"

@interface PTConversationViewController ()
{
    NSString *_ckidString;
}

@property (nonatomic, copy)   NSString *discussionId;
@property (nonatomic, strong) NSMutableArray *memberIdList;

@property (nonatomic, strong) CKCoversationProgressView *viewDataLoading;
@property (nonatomic, strong) JGProgressHUD *viewNetError;

@end

@implementation PTConversationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    
    RLMResults *result = [CKGroupModel objectsWhere:[NSString stringWithFormat:@"groupid = '%@'", self.groupModel.groupid]];
    if (result.count > 0) {
        self.groupModel = result.firstObject;
        [self.userIdArray removeAllObjects];
        for (CKGroupInfoModel *userInfo in self.groupModel.groupinfoArray) {
            if (![userInfo.meid isEqualToString:_ckidString]) {
                [self.userIdArray addObject:userInfo.meid];
            }
            
        }
    }
    
    self.navigationItem.title = self.groupModel.groupname;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.viewDataLoading stopAnimation];
}

- (BOOL)navigationShouldPopOnBackButton {
    [self.navigationController popToRootViewControllerAnimated:YES];
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLoadDataUI];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    self.navigationItem.title = self.titleString;
    
    if (self.conversationType == ConversationType_DISCUSSION) {
        [[RCIM sharedRCIM] getDiscussion:self.targetId success:^(RCDiscussion *discussion) {
            self.memberIdList = [NSMutableArray arrayWithArray:discussion.memberIdList];
            self.discussionId = discussion.discussionId;
            NSLog(@"%@", [discussion mj_JSONString]);
        } error:^(RCErrorCode status) {
            NSLog(@"%ld",(long)status);
        }];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"creategroup_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(discussionDetail)];
        rightItem.tintColor = [UIColor tt_blueColor];
        self.navigationItem.rightBarButtonItem = rightItem;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    
    //隐藏扩展功能按钮
    //    self.chatSessionInputBarControl.additionalButton.hidden = YES;
    //删除掉红包模块
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:3];
    //删除掉定位模块
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    //隐藏语音输入按钮
    //    self.chatSessionInputBarControl.switchButton.hidden = YES;
    //输入框布局样式
    //    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:8];
    
    //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    NSString *ckid = IsNilOrNull(KCKidstring) ? @"":KCKidstring;
    NSString *smallName = [KUserdefaults objectForKey:KnickName];
    NSString *headImageUrl = [KUserdefaults objectForKey:kheamImageurl];
    if(IsNilOrNull(headImageUrl)){
        headImageUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,DefaultHeadPath];
    }
    
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.name = smallName;
    userInfo.userId = ckid;
    userInfo.portraitUri = headImageUrl;
    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:ckid];
    
    self.displayUserNameInCell = NO;
    
    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    if(IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
}

#pragma mark - 群组详情
- (void)discussionDetail {
    RCDGroupSettingsTableViewController *groupDetail = [[RCDGroupSettingsTableViewController alloc] init];
    groupDetail.groupModel = self.groupModel;
    groupDetail.groupName = self.titleString;
    groupDetail.memberIdList = self.memberIdList;
    groupDetail.annoucemnet = self.groupModel.groupnotice;
    [self.navigationController pushViewController:groupDetail animated:YES];
   
}

#pragma mark - 用户信息处理
//- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
//    if([userId isEqualToString:self.targetId]){
//        RCUserInfo *userInfo = [[RCUserInfo alloc]init];
//        userInfo.userId = self.targetId;
//        userInfo.name = self.titleString;
//        userInfo.portraitUri = self.headUrl;
//        return completion(userInfo);
//    }
//}

- (void)sendMsg:(RCMessageContent *)messageCotent {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.viewDataLoading];
        
//        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    });
    
    
    NSTimeInterval period = 0.3; //设置时间间隔
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    
    __block NSInteger i = 0;
    NSLog(@"我是i:%ld", i);
    
    dispatch_source_set_event_handler(_timer, ^{
        
        
        if (i < self.userIdArray.count) {
            NSLog(@"userIdArray:%@", self.userIdArray);
            NSString *targetId = self.userIdArray[i];
            NSLog(@"时间戳%@", [NSDate dateNow]);
            NSLog(@"现在%@- %ld", targetId, i);
            //发消息
            [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:targetId content:messageCotent pushContent:@"" pushData:@"" success:^(long messageId) {
                NSLog(@"第%ld条发送成功:%@--%ld", i, targetId, messageId);
            } error:^(RCErrorCode nErrorCode, long messageId) {
                NSLog(@"第%ld条发送失败:%@--%ld--%ld", i, targetId, nErrorCode, messageId);
                
            }];
            i+=1;
            NSLog(@"此刻i： %ld", i);
        }else{
            NSLog(@"我结束了%ld", i);
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"停止i：%ld", i);
                i = 0;
                
                NSString *postMesageUrl = [NSString stringWithFormat:@"%@%@", PostMessageAPI, @"Msg/CkApp3/sendGroupMessage"];
                RCTextMessage *textMessage = (RCTextMessage *)messageCotent;
                
                _ckidString = KCKidstring;
                if (IsNilOrNull(_ckidString)) {
                    _ckidString = @"";
                }
                
                NSString *uuid = DeviceId_UUID_Value;
                if (IsNilOrNull(uuid)){
                    uuid = @"";
                }
                NSDictionary *pramaDic = @{@"ckid":_ckidString, @"groupid":self.groupId, @"message":textMessage.content, DeviceId:uuid};
                NSLog(@"%@", pramaDic);
                [[RequestManager manager] ckDataRequest:RequestMethodPost URLString:postMesageUrl parameters:pramaDic success:^(id  _Nullable responseObject) {
                    NSDictionary *dict = responseObject;
                    NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
                    if (![code isEqualToString:@"200"]) {
                        NSLog(@"%@",dict[@"codeinfo"]);
                        [self.viewDataLoading stopAnimation];
                        return;
                    }
                    
                    [CKCNotificationCenter postNotificationName:@"ReloadMsgCenterDataNoti" object:nil];
                    [self.viewDataLoading stopAnimation];
                } failure:^(id  _Nullable responseObject, NSError * _Nullable error) {
                    NSLog(@"保存消息失败");
                    [self.viewDataLoading stopAnimation];
                }];
            });
        }
    });
    dispatch_resume(_timer);
}

/*!
 发送消息完成的回调
 
 @param stauts          发送状态，0表示成功，非0表示失败
 @param messageCotent   消息内容
 */
- (void)didSendMessage:(NSInteger)stauts
               content:(RCMessageContent *)messageCotent{
    
    //  [NSString stringContainsEmoji:textMessage.content]
    
//    NSLog(@"发送消息完成的回调%zd",stauts);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chatSessionInputBarControl.inputTextView resignFirstResponder];
    });
    
    if (stauts != 0) {
        return;
    }
    
    RCTextMessage *textMessage = (RCTextMessage *)messageCotent;
    NSString *postContent = @"";
    if ([messageCotent isKindOfClass:[RCTextMessage class]]){
        postContent = textMessage.content;
        //测试代码
        [self sendMsg:messageCotent];
    }else if([messageCotent isKindOfClass:[RCImageMessage class]]){
        postContent = @"图片消息";
    }else if ([messageCotent isKindOfClass:[RCVoiceMessage class]]){
        postContent = @"语音消息";
    }
}

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    NSLog(@"融云链接的状态码%zd",status);
    
}


/**添加风火轮*/
-(void)createLoadDataUI {
    // 增加风火轮
    self.viewDataLoading = [[CKCoversationProgressView alloc] init];
    // 增加网络错误时提示
    self.viewDataLoading.frame = [UIScreen mainScreen].bounds;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
