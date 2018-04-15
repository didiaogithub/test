//
//  PushManager.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "PushManager.h"
#import <UserNotifications/UserNotifications.h>
#import "CKVersionCheckManager.h"
#import "CKOfficialMsgModel.h"
#import "CKSysMsgModel.h"
#import "MessageModel.h"
#import "OrderModel.h"
#import "ClassModel.h"
#import "CKMainPageModel.h"

@interface PushManager()<UNUserNotificationCenterDelegate>


@end

@implementation PushManager

+(instancetype)manager {
    static PushManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PushManager alloc] initPrivate];
    });
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        
    }
    return self;
}

-(void)registerUserNotification:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registerAPNS:launchOptions];
}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    
    [KUserdefaults setObject:deviceToken forKey:@"AdHocDeviceToken"];
    
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    NSString *auth = [KUserdefaults objectForKey:CKAppServerPushToken];

    
    if (![auth isEqualToString:token] || IsNilOrNull(auth)) {
        
        [KUserdefaults setObject:token forKey:CKAppServerPushToken];

        NSString *url = [NSString stringWithFormat:@"%@%@", PushService, updateDeviceToken];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:token forKey:@"auth"];
        
        if (!IsNilOrNull(KCKidstring)) {
            [params setValue:KCKidstring forKey:@"itemId"];
        }
        
        [HttpTool postWithUrl:url params:params success:^(id json) {
            NSLog(@"上传deviceToken成功");
            NSLog(@"token:%@", token);
            NSString *a = [NSString stringWithFormat:@"PushManage上传deviceToken成功%@", token];
            [KUserdefaults setObject:token forKey:CKAppServerPushToken];
            [KUserdefaults setObject:a forKey:CKAppUpdateTokenStatus];
            [KUserdefaults synchronize];
        } failure:^(NSError *error) {
            NSLog(@"上传deviceToken失败");
            [KUserdefaults removeObjectForKey:CKAppServerPushToken];
            [KUserdefaults setObject:@"PushManage上传deviceToken失败" forKey:CKAppUpdateTokenStatus];
        }];
    }
}


- (void)registerAPNS:(NSDictionary*)launchOptions {
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (sysVer >= 10) {
        // iOS 10
        [self registerPush10];
    } else if (sysVer >= 8) {
        // iOS 8-9
        [self registerPush8to9];
    }
#else
    // iOS 8-9
    [self registerPush8to9];
#endif
}

- (void)registerPush10{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }
    }];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush8to9{
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"register APNS fail. reason : %@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
#warning need process Jpush msg and service msg different
    NSLog(@"fetchCompletionHandler : %@", userInfo);
    
    NSString *pushType = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"pushType"]];
    NSString *type = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"type"]];
    NSDictionary *bodyDic = [userInfo objectForKey:@"body"];

    
    if ([pushType isEqualToString:@"serverPush"]) {
        
        if (userInfo != nil) {
            [KUserdefaults setObject:userInfo forKey:@"receivedPushMsg"];
        }
        
        
        //告诉服务器收到消息了
        NSString *token = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:CKAppServerPushToken]];
        NSString *msgId = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"msgId"]];
        if (!IsNilOrNull(msgId)) {
            NSString *url = [NSString stringWithFormat:@"%@%@", PushService, updateDeviceToken];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:token forKey:@"auth"];
            [params setValue:msgId forKey:@"msgId"];

            if (!IsNilOrNull(KCKidstring)) {
                [params setValue:KCKidstring forKey:@"itemId"];
            }
            
            [HttpTool postWithUrl:url params:params success:^(id json) {
                [KUserdefaults setObject:@"上传消息id成功" forKey:@"CKYS_updataPushmsgId"];
            } failure:^(NSError *error) {
                [KUserdefaults setObject:@"上传消息id失败" forKey:@"CKYS_updataPushmsgId"];
            }];
        }
        
        
        if ([type isEqualToString:@"100"]){//首页推送处理-完成
            NSString *status = [NSString stringWithFormat:@"%@", [bodyDic objectForKey:@"status"]];
            if (!IsNilOrNull(status)) {
                [KUserdefaults setObject:status forKey:KStatus];
            }else{
                [self updateMainPageObject:@"banner" pushMsg:bodyDic];
            }
        }else if ([type isEqualToString:@"200"]){
//            [KUserdefaults setObject:@"CleanWebCache" forKey:@"CleanWebCache"];
            
            [NSString deleteWebCache];
            
            NSArray *lessons = [bodyDic objectForKey:@"lessons"];
            if (lessons != nil) {
                [self addOrUpdateObject:@"ClassModel" pushDict:bodyDic];
            }else{
                [self addOrUpdateObject:@"ClassTitleModel" pushDict:bodyDic];
            }
            
        }else if ([type isEqualToString:@"300"]){
            if ([@"msgtype" isEqualToString:@"MessageModel"]) {
                [self addOrUpdateObject:@"MessageModel" pushDict:bodyDic];
            }else if ([@"msgtype" isEqualToString:@"CKSysMsgListModel"]) {
                [self addOrUpdateObject:@"CKSysMsgListModel" pushDict:bodyDic];
            }else if ([@"msgtype" isEqualToString:@"CKOfficialMsgModel"]) {
                [self addOrUpdateObject:@"CKOfficialMsgModel" pushDict:bodyDic];
            }
        }else if ([type isEqualToString:@"400"]){
            [self addOrUpdateObject:@"OrderModel" pushDict:bodyDic];
        }else if ([type isEqualToString:@"000004"]){//域名更新推送-完成
            [self updateDomain:bodyDic];
        }else if ([type isEqualToString:@"000001"]){//版本更新推送-完成
            NSString *version = [NSString stringWithFormat:@"%@", [bodyDic objectForKey: @"versioncode"]];
            NSString *forceupdate = [NSString stringWithFormat:@"%@", [bodyDic objectForKey:@"forceupdate"]];

            //辅助测试代码
            NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *serviceVersion = [KUserdefaults objectForKey:ServerVersion];
            NSString *forceUpdate = [KUserdefaults objectForKey:Forceupdate];
            NSLog(@"应用版本:%@-推送版本与更新:%@-%@-缓存的版本与更新:%@-%@", currentVersion, version, forceupdate, serviceVersion, forceUpdate);
            
            if (!IsNilOrNull(version)) {
                [[NSUserDefaults standardUserDefaults] setValue:version forKey:ServerVersion];
                if (!IsNilOrNull(forceupdate)){
                    [[NSUserDefaults standardUserDefaults] setValue:forceupdate forKey:Forceupdate];
                }
                [[CKVersionCheckManager shareInstance] compareVersion:version forceUpdate:forceupdate];
            }
        }else if ([type isEqualToString:@"000002"]){//支付方式更新推送
            [self updatePaymentMethod:bodyDic];
        }else if ([type isEqualToString:@"000003"]){//提示msg
            [self processTipMsg:bodyDic];
        }
#warning waitting processing 暂时不做此功能
        //要删除的类型，还有id等
        if ([@"deleteType" isEqualToString:@"ClassModel"]) {
            [self deleteObject:@"ClassModel" predicate:@"classId = '20' AND sortID = '1'"];
        }else if ([@"deleteType" isEqualToString:@"MessageModel"]) {
            [self deleteObject:@"MessageModel" predicate:@"ckid = '50' AND meid = '50123134'"];
        }else if ([@"deleteType" isEqualToString:@"OrderModel"]) {
            [self deleteObject:@"OrderModel" predicate:@"oid = '3482389' AND ckid = '50'"];
        }
    }
}

-(void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    //处理后台推送过来的消息
    NSLog(@"didReceiveRemoteNotification : %@", userInfo);
}

#pragma mark - 更新首页数据 - 写的太复杂了，需要调整
-(void)updateMainPageObject:(NSString*)objName pushMsg:(NSDictionary*)pushMsg {

    RLMResults *result = [[CacheData shareInstance] search:[CKMainPageModel class]];
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    if (result.count > 0) {
        
        if ([objName isEqualToString:@"banner"]) {
            for (CKMainPageModel *mainModel in result) {
                [realm beginWriteTransaction];
                [realm deleteObjects:mainModel.bannerArray];
                [realm commitWriteTransaction];
            }
        }else if([objName isEqualToString:@"top3ckheaders"]) {
            for (CKMainPageModel *mainModel in result) {
                [realm beginWriteTransaction];
                [realm deleteObjects:mainModel.top3ckheaderArray];
                [realm commitWriteTransaction];
            }
        }else if([objName isEqualToString:@"topnews"]) {
            for (CKMainPageModel *mainModel in result) {
                [realm beginWriteTransaction];
                [realm deleteObjects:mainModel.topnewsArray];
                [realm commitWriteTransaction];
            }
        }else if([objName isEqualToString:@"mediareport"]) {
            for (CKMainPageModel *mainModel in result) {
                [realm beginWriteTransaction];
                [realm deleteObjects:mainModel.mediareportArray];
                [realm commitWriteTransaction];
            }
        }else if([objName isEqualToString:@"honor_list"]) {
            for (CKMainPageModel *mainModel in result) {
                [realm beginWriteTransaction];
                [realm deleteObjects:mainModel.honorArray];
                [realm commitWriteTransaction];
            }
        }
        
//        if ([pushDict objectForKey:@"cknum"]){
//            for (CKMainPageModel *mainModel in result) {
//                [realm beginWriteTransaction];
//                mainModel.cknum = [pushDict objectForKey:@"cknum"];
//                [realm commitWriteTransaction];
//            }
//        }
    }
    
    if (result.count > 0) {
        for (CKMainPageModel *mainModel in result) {
            CKMainPageModel *mainM = [[CKMainPageModel alloc] init];
            mainM.headurl = mainModel.headurl;
            mainM.moneytoday = mainModel.moneytoday;
            mainM.status = mainModel.status;
            mainM.moneytotal = mainModel.moneytotal;
            mainM.headurl = mainModel.headurl;
            mainM.shopurl = mainModel.shopurl;
            mainM.honorArray = mainModel.honorArray;
            mainM.realname = mainModel.realname;
            mainM.name = mainModel.name;
            mainM.type = mainModel.type;
            mainM.bannerArray = mainModel.bannerArray;
            mainM.ckTotal = mainModel.ckTotal;
            mainM.top3ckheaderArray = mainModel.top3ckheaderArray;
            mainM.cknum = mainModel.cknum;
            mainM.fxTotal = mainModel.fxTotal;
            mainM.topnewsArray = mainModel.topnewsArray;
            mainM.mediareportArray = mainModel.mediareportArray;
            mainM.ckcxyurl = mainModel.ckcxyurl;
            mainM.jointype = mainModel.jointype;
            mainM.ckid = mainModel.ckid;
                        
            NSArray *banners = [pushMsg objectForKey:@"banners"];
            if (banners.count > 0) {
                for (NSDictionary *dic in banners) {
                    Banners *bannerM = [[Banners alloc] init];
                    [bannerM setValuesForKeysWithDictionary:dic];
                    [mainM.bannerArray addObject:bannerM];
                }
            }
            [realm beginWriteTransaction];
            [CKMainPageModel createOrUpdateInRealm:realm withValue:mainM];
            [realm commitWriteTransaction];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DidReceiveBannerUpdatePushNoti object:nil];
        }
    }
}

#pragma mark - 添加或者更新课程、消息、订单
/**
 添加或者更新:
 
 @param objName RLM模型类名
 @param collegeDic 要添加或者更新的课程、消息、订单
 */
-(void)addOrUpdateObject:(NSString*)objName pushDict:(NSDictionary*)pushDict {
    NSString *ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;

    RLMRealm *realm = [RLMRealm defaultRealm];
    
    if ([objName isEqualToString:@"ClassTitleModel"]){
        RLMResults *result = [[CacheData shareInstance] search:[ClassTitleModel class]];
        ClassTitleModel *clsTitleM = result.firstObject;
        ClassTitleModel *clsTM = [[ClassTitleModel alloc] init];
        [clsTM setValuesForKeysWithDictionary:pushDict];
        clsTM.ckid = clsTitleM.ckid;
        clsTM.lessonTypeArr = clsTitleM.lessonTypeArr;
        NSArray *typeArr = [pushDict objectForKey:@"lessonType"];
        NSMutableArray *sorIDArr = [NSMutableArray array];
        for (lessonType *type in clsTM.lessonTypeArr) {
            [sorIDArr addObject:type.sortID];
        }
        if (typeArr.count > 0) {
            for (NSDictionary *dic in typeArr) {
                lessonType *typeM = [[lessonType alloc] init];
                [typeM setValuesForKeysWithDictionary:dic];
                if (![sorIDArr containsObject:typeM.sortID]) {
                    [clsTM.lessonTypeArr addObject:typeM];
                }
            }
        }
        [realm beginWriteTransaction];
        [NSClassFromString(objName) createOrUpdateInRealm:realm withValue:clsTM];
        [realm commitWriteTransaction];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DidReceiveClassTitleUpdatePushNoti object:nil];
    }else if ([objName isEqualToString:@"ClassModel"]){
        NSArray *typeArr = [pushDict objectForKey:@"lessons"];
//        if (typeArr.count > 0) {
//            for (NSDictionary *dic in typeArr) {
//                ClassModel *clsM = [[ClassModel alloc] init];
//                [clsM setValuesForKeysWithDictionary:dic];
//                clsM.sortID = [dic objectForKey:@"classId"];
//                [realm beginWriteTransaction];
//                [NSClassFromString(objName) createOrUpdateInRealm:realm withValue:clsM];
//                [realm commitWriteTransaction];
//            }
//        }
//        NSMutableDictionary *sortIdDict = [[NSMutableDictionary alloc] init];
        if (typeArr.count > 0) {
            NSMutableArray *sortIDArr = [NSMutableArray array];
            for (NSDictionary *dic in typeArr) {
                NSString *sortID = [dic objectForKey:@"classId"];
                [sortIDArr addObject:sortID];
            }
//            for (NSInteger i = 0; i < sortIDArr.count; i++) {
//                [sortIdDict setObject:sortIDArr[i] forKey:[NSString stringWithFormat:@"%ld", i]];
//            }
            //根据推送的分类id，在点击到对应的分类时请求数据
            if (sortIDArr != nil) {
                [KUserdefaults setObject:sortIDArr forKey:@"CollegeClassPushIdArr"];
            }
        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:DidReceiveClassDetailUpdatePushNoti object:nil userInfo:sortIdDict];
    }else if ([objName isEqualToString:@"CKOfficialMsgModel"]){
        CKOfficialMsgModel *model = [[CKOfficialMsgModel alloc] init];
        [model setValuesForKeysWithDictionary:pushDict];
        model.ckid = ckidString;
        [realm beginWriteTransaction];
        [NSClassFromString(objName) createOrUpdateInRealm:realm withValue:model];
        [realm commitWriteTransaction];
    }else if ([objName isEqualToString:@"CKSysMsgListModel"]){
        CKSysMsgListModel *model = [[CKSysMsgListModel alloc] init];
        [model setValuesForKeysWithDictionary:pushDict];
        model.ckid = ckidString;
        [realm beginWriteTransaction];
        [NSClassFromString(objName) createOrUpdateInRealm:realm withValue:model];
        [realm commitWriteTransaction];
    }else if ([objName isEqualToString:@"MessageModel"]){
        MessageModel *model = [[MessageModel alloc] init];
        [model setValuesForKeysWithDictionary:pushDict];
        model.ckid = ckidString;
        [realm beginWriteTransaction];
        [NSClassFromString(objName) createOrUpdateInRealm:realm withValue:model];
        [realm commitWriteTransaction];
    }else if ([objName isEqualToString:@"OrderModel"]) {
        OrderModel *model = [[OrderModel alloc] init];
        [model setValuesForKeysWithDictionary:pushDict];
        model.ckid = ckidString;
        
        NSArray *ordersheetArr = pushDict[@"ordersheet"];
        if (ordersheetArr.count > 0) {
            for (NSDictionary *dic in ordersheetArr) {
                Ordersheet *orderSheet = [[Ordersheet alloc] init];
                [orderSheet setValuesForKeysWithDictionary:dic];
                orderSheet.sheetKey = [NSString stringWithFormat:@"%@_%@",orderSheet.oid, orderSheet.itemid];
                [model.orderArray addObject:orderSheet];
            }
        }
        
        [realm beginWriteTransaction];
        [NSClassFromString(objName) createOrUpdateInRealm:realm withValue:model];
        [realm commitWriteTransaction];
    }else{
        id model = [[NSClassFromString(objName) alloc] init];
        [model setValuesForKeysWithDictionary:pushDict];
        [realm beginWriteTransaction];
        [NSClassFromString(objName) createOrUpdateInRealm:realm withValue:model];
        [realm commitWriteTransaction];
    }
}

#pragma mark - 删除某条数据
/**
 删除某条数据
 
 @param objName RLM模型类名
 @param predicate 过滤条件
 */
-(void)deleteObject:(NSString*)objName predicate:(NSString*)predicate {
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *results = [NSClassFromString(objName) objectsWhere:predicate];
    if (results.count > 0) {
        [realm beginWriteTransaction];
        [realm deleteObject:results.firstObject];
        [realm commitWriteTransaction];
    }
}

#pragma mark - 更新域名
-(void)updateDomain:(NSDictionary*)dict {

    NSString *domainImgRegetUrl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainImgRegetUrl"]];
    if (!IsNilOrNull(domainImgRegetUrl)) {
        if (![domainImgRegetUrl hasSuffix:@"/"]) {
            domainImgRegetUrl = [domainImgRegetUrl stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainImgRegetUrl forKey:@"domainImgRegetUrl"];
    }
    
//    NSString *domainName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainName"]];
//    if (!IsNilOrNull(domainName)) {
//        if (![domainName hasSuffix:@"/"]) {
//            domainName = [domainName stringByAppendingString:@"/"];
//        }
//        [[DefaultValue shareInstance] setDefaultValue:domainName forKey:@"domainName"];
//    }
    
    NSString *domainNameRes = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainNameRes"]];
    if (!IsNilOrNull(domainNameRes)) {
        if (![domainNameRes hasSuffix:@"/"]) {
            domainNameRes = [domainNameRes stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNameRes forKey:@"domainNameRes"];
    }
    
    NSString *domainNamePay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainNamePay"]];
    if (!IsNilOrNull(domainNamePay)) {
        if (![domainNamePay hasSuffix:@"/"]) {
            domainNamePay = [domainNamePay stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNamePay forKey:@"domainNamePay"];
    }
    
    NSString *domainSmsMessage = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainSmsMessage"]];
    if (!IsNilOrNull(domainSmsMessage)) {
        if (![domainSmsMessage hasSuffix:@"/"]) {
            domainSmsMessage = [domainSmsMessage stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainSmsMessage forKey:@"domainSmsMessage"];
    }
    
    NSString *domainNameUnionPay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"domainUnionPay"]];
    if (!IsNilOrNull(domainNameUnionPay)) {
        if (![domainNameUnionPay hasSuffix:@"/"]) {
            domainNameUnionPay = [domainNameUnionPay stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNameUnionPay forKey:@"domainNameUnionPay"];
    }
}

-(void)updatePaymentMethod:(NSDictionary*)dict {

    NSString *alipay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"alipay"]];
    if (!IsNilOrNull(alipay)) {
        [[DefaultValue shareInstance] paymentAvaliable:alipay forKey:@"alipay"];
    }
    NSString *wxpay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"wxpay"]];
    if (!IsNilOrNull(wxpay)) {
        [[DefaultValue shareInstance] paymentAvaliable:wxpay forKey:@"wxpay"];
    }
    NSString *unionpay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"unionpay"]];
    if (!IsNilOrNull(unionpay)) {
        [[DefaultValue shareInstance] paymentAvaliable:unionpay forKey:@"unionpay"];
    }
    NSString *applepay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"applepay"]];
    if (!IsNilOrNull(applepay)) {
        [[DefaultValue shareInstance] paymentAvaliable:applepay forKey:@"applepay"];
    }
    
    NSString *jdpay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"jdpay"]];
    if (!IsNilOrNull(jdpay)) {
        [[DefaultValue shareInstance] paymentAvaliable:jdpay forKey:@"jdpay"];
    }
}


-(void)processTipMsg:(NSDictionary*)bodyDic {
    
    NSArray *msgTypeArr = @[@"CKYSmsgnonetwork", @"CKYSmsgtimeout", @"CKYSmsg9001", @"CKYSmsgtransup", @"CKYSmsgqrcode", @"CKYSmsgpick", @"CKYSmsggetmoney", @"CKYSmsgcharge", @"CKYSmsgchargeCK", @"CKYSmsgchargeFX", @"CKYSmsgBeanToMoneyCK", @"CKYSmsgBeanToMoneyFX", @"CKYSmsgpresale", @"CKYSmsgshopstatus", @"CKYSmsgshopstatusUpdatePersonalInfo", @"CKYSmsgshopstatusPending", @"CKYSmsgshopstatusConnectCKOpen", @"CKYSmsgshopstatusNoRight"];
    
    NSArray *appMsgs = [bodyDic objectForKey:@"AppMsgs"];
    if (appMsgs.count > 0) {
        for (NSDictionary *dict in appMsgs) {
            NSString *msgType = [dict objectForKey:@"msgType"];
            NSString *msg = [dict objectForKey:@"msg"];
            if (!IsNilOrNull(msg) && [msgTypeArr containsObject:msgType]) {
                [KUserdefaults setObject:msg forKey:msgType];
            }
        }
    }
    
    
//    NSString *msgType = [bodyDic objectForKey:@"msgType"];
//    NSString *msg = [bodyDic objectForKey:@"msg"];
//
//    NSMutableArray *totalTypeArr = [NSMutableArray array];
//    for (NSInteger i = 10001; i< 20000; i++) {
//        NSString *type = [NSString stringWithFormat:@"msg%ld", i];
//        [totalTypeArr addObject:type];
//    }
//    if (!IsNilOrNull(msg) && [totalTypeArr containsObject:msgType]) {
//        [KUserdefaults setObject:msg forKey:msgType];
//    }
    
}

#pragma -mark dealloc
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
