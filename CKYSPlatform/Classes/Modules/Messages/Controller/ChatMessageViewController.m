//
//  ChatMessageViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/7/10.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "ChatMessageViewController.h"

@interface ChatMessageViewController ()
{
    UIView *_navView;
    UILabel *_titleLab;
    UIButton *_backBgBtn;
    NSString *_ckidString;
}
@end

@implementation ChatMessageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    self.navigationItem.title = self.titleString;
    
    //隐藏扩展功能按钮
//    self.chatSessionInputBarControl.additionalButton.hidden = YES;
    
//    删除指定位置的方法： 删除掉定位模块
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    //    删除指定位置的方法：删除掉红包模块
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
    
//    [[RCIMClient sharedRCIMClient] getRemoteHistoryMessages:ConversationType_PRIVATE targetId:self.targetId recordTime:0 count:20 success:^(NSArray *messages) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.conversationMessageCollectionView reloadData];
//        });
//        NSLog(@"获取历史消息成功");
//    } error:^(RCErrorCode status) {
//        NSLog(@"获取历史消息失败");
//    }];
    
}
#pragma mark-用户信息处理
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    if([userId isEqualToString:self.targetId]){
        RCUserInfo *userInfo = [[RCUserInfo alloc]init];
        userInfo.userId = self.targetId;
        userInfo.name = self.titleString;
        if (!IsNilOrNull(self.headUrl)) {
            userInfo.portraitUri = self.headUrl;
        }
        return completion(userInfo);
    }
}

/*!
 发送消息完成的回调
 
 @param stauts          发送状态，0表示成功，非0表示失败
 @param messageCotent   消息内容
 */
- (void)didSendMessage:(NSInteger)stauts
               content:(RCMessageContent *)messageCotent{
    
//  [NSString stringContainsEmoji:textMessage.content]
    
    NSLog(@"发送消息完成的回调%zd",stauts);

    RCTextMessage *textMessage = (RCTextMessage *)messageCotent;
    NSString *postContent = @"";
    if ([messageCotent isKindOfClass:[RCTextMessage class]]){
        postContent = textMessage.content;
    }else if([messageCotent isKindOfClass:[RCImageMessage class]]){
       postContent = @"图片消息";
    }else if ([messageCotent isKindOfClass:[RCVoiceMessage class]]){
       postContent = @"语音消息";
    }
    
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    if (stauts == 0) {
        if(IsNilOrNull(self.targetId)){
          self.targetId = @"";
        }
        
        NSString *uuid = DeviceId_UUID_Value;
        if (IsNilOrNull(uuid)){
            uuid = @"";
        }
        NSString *postMesageUrl = [NSString stringWithFormat:@"%@%@",PostMessageAPI,writeMsg_Url];
        NSDictionary *pramaDic = @{@"senderid":_ckidString,@"rcvid":self.targetId,@"content":postContent,DeviceId:uuid};
        [HttpTool postWithUrl:postMesageUrl params:pramaDic success:^(id json) {
            NSDictionary *dict = json;
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
            if (![code isEqualToString:@"200"]) {
                NSLog(@"%@",dict[@"codeinfo"]);
                return;
            }
            
            [CKCNotificationCenter postNotificationName:@"ReloadMsgCenterDataNoti" object:nil];
            
        } failure:^(NSError *error) {
            NSLog(@"保存消息失败");
        }];
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

- (void)dealloc
{
    self.chatSessionInputBarControl.emojiBoardView.delegate = nil;
//    self.chatSessionInputBarControl.emojiBoardView.dataSource = nil;
}
@end
