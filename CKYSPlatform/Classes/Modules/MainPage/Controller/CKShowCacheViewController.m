//
//  CKShowCacheViewController.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/8/10.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKShowCacheViewController.h"
#import "ClassModel.h"
#import "OrderModel.h"
#import "CKOfficialMsgModel.h"
#import "MessageModel.h"
#import "CKSysMsgModel.h"
#import "CKMainPageModel.h"

@interface CKShowCacheViewController ()

@end

@implementation CKShowCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"基本数据", @"首页数据", @"商学院标题课程", @"消息列表", @"订单列表", @"域名和支付方式"];
    
    self.navigationItem.title = arr[self.tag];
    
    UITextView *v = [[UITextView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:v];
    
    switch (self.tag) {
        case 0:
        {
            
            NSArray *keyArr = @[@"CKYSmsgnonetwork", @"CKYSmsgtimeout", @"CKYSmsg9001", @"CKYSmsgtransup", @"CKYSmsgqrcode", @"CKYSmsgpick", @"CKYSmsggetmoney", @"CKYSmsgcharge", @"CKYSmsgchargeCK", @"CKYSmsgchargeFX", @"CKYSmsgBeanToMoneyCK", @"CKYSmsgBeanToMoneyFX", @"CKYSmsgpresale", @"CKYSmsgshopstatus", @"CKYSmsgshopstatusUpdatePersonalInfo", @"CKYSmsgshopstatusPending", @"CKYSmsgshopstatusConnectCKOpen", @"CKYSmsgshopstatusNoRight", @"CheckMsgPhoneHolder", @"CheckMsgPhoneNull", @"CheckMsgPhoneError", @"CheckMsgVerificationCodeError", @"CheckMsgVerificationCodeNull", @"CheckMsgInviteCodeNull", @"CheckMsgInviteCodeError", @"CheckMsgPwTwiceError", @"CheckMsgPwNull", @"CheckMsgReadProtocolFirst", @"CheckMsgSelectAddrFirst", @"CheckMsgSelectGiftFirst", @"CheckMsgQRNotLoad", @"CheckMsgContactPhoneError", @"CheckMsgNameNull", @"CheckMsgAddrNull", @"CheckMsgCanNotChange", @"CKAppServerPushToken", @"CKAppUpdateTokenStatus", @"CKYS_Mobile", @"CKYS_NickName", @"CKYS_openid", @"CKYS_unionid", @"CKYS_headImageUrl", @"CKYS_ckid", @"CKYS_PW", @"CKYS_ispresale", @"CKYS_sales", @"CKYS_status", @"CKYS_checkstatus", @"CKYS_type", @"CKYS_jointype", @"CKYS_realname", @"CKYS_shopname", @"receivedPushMsg", @"GetMainSomeData", @"AdHocDeviceToken", @"CKYS_versioncode", @"CKYS_lastVersion", @"CKYS_forceupdate", @"CKYS_updataPushmsgId"];
            
            NSString *str = @"";
            for (NSString *key in keyArr) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"\n%@ = %@\n", key, [KUserdefaults objectForKey:key]]];
            }
            
            v.text = str;

        }
            break;
        case 1:
        {
            RLMResults *result = [[CacheData shareInstance] search:[CKMainPageModel class]];
            NSString *str = @"";
            for (CKMainPageModel *m in result) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"\n%@\n", m]];
            }
            v.text =  str;
        }
            break;
        case 2:
        {
            RLMResults *result = [[CacheData shareInstance] search:[ClassTitleModel class]];
            NSString *str = @"";
            for (ClassTitleModel *m in result) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"\n%@\n", m]];
            }
            
            if (IsNilOrNull(str)) {
                str = @"暂无缓存，先点击商学院";
            }
            
            RLMResults *result1 = [[CacheData shareInstance] search:[ClassModel class]];
            NSString *str1 = @"";
            for (ClassModel *m in result1) {
                str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@"\n%@\n", m]];
            }
            v.text = [NSString stringWithFormat:@"%@%@", str, str1];
        }
            break;
        case 3:
        {
            RLMResults *result = [[CacheData shareInstance] search:[MessageModel class]];
            NSString *str = @"";
            for (MessageModel *m in result) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"\n%@\n", m]];
            }
            
            if (IsNilOrNull(str)) {
                str = @"暂无缓存，先点击消息";
            }
            
            RLMResults *result1 = [[CacheData shareInstance] search:[CKSysMsgListModel class]];
            NSString *str1 = @"";
            for (CKSysMsgListModel *m in result1) {
                str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@"\n%@\n", m]];
            }
            
            RLMResults *result2 = [[CacheData shareInstance] search:[CKOfficialMsgModel class]];
            NSString *str2 = @"";
            for (CKOfficialMsgModel *m in result2) {
                str2 = [str2 stringByAppendingString:[NSString stringWithFormat:@"\n%@\n", m]];
            }
            
            RLMResults *result3 = [[CacheData shareInstance] search:[CKSysMsgModel class]];
            NSString *str3 = @"";
            for (CKSysMsgModel *m in result3) {
                str3 = [str3 stringByAppendingString:[NSString stringWithFormat:@"\n%@\n", m]];
            }
            
            v.text = [NSString stringWithFormat:@"%@%@%@%@", str, str1, str2, str3];
        }
            break;
        case 4:
        {
            RLMResults *result = [[CacheData shareInstance] search:[OrderModel class]];
            NSString *str = @"";
            for (OrderModel *m in result) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"\n%@\n", m]];
            }
            
            if (IsNilOrNull(str)) {
                str = @"暂无缓存，先点击订单";
            }
            
            v.text = str;
        }
            break;
        case 5:
        {
            NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"CKDefaultValue.plist"];
            //所有的数据列表
            NSMutableDictionary *datalist= [[[NSMutableDictionary alloc]initWithContentsOfFile:filepath]mutableCopy];
            
            v.text = [NSString stringWithFormat:@"%@", datalist];
            
        }
            break;
            
        default:
            break;
    }
    
}

@end
