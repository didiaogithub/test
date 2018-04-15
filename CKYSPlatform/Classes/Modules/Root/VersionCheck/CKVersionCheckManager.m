//
//  CKVersionCheckManager.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKVersionCheckManager.h"
#import "CacheManager.h"
#import "CKCUpdateAlertView.h"

@interface CKVersionCheckManager()<UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *updateAlert;

@end

@implementation CKVersionCheckManager

+(instancetype)shareInstance {
    static CKVersionCheckManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CKVersionCheckManager alloc] initPrivate];
    });
    
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)checkVersion {
    //服务器的版本
    NSString *serviceVersion = [KUserdefaults objectForKey:ServerVersion];
    NSString *forceUpdate = [KUserdefaults objectForKey:Forceupdate];

    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (IsNilOrNull(serviceVersion) || [currentVersion isEqualToString:serviceVersion]) {
        [self requestServiceVersion:^(NSString *latestVersion, NSString *force){
            [self compareVersion:latestVersion forceUpdate:force];
        }];
    }else if([currentVersion compare:serviceVersion] == NSOrderedAscending){
        NSString *appmallverinfo = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_updateInfo"]];
        if (IsNilOrNull(appmallverinfo)) {
            [self requestServiceVersion:^(NSString *latestVersion, NSString *force){
                [self compareVersion:latestVersion forceUpdate:force];
            }];
        }else{
            [self showUpdateAlert:forceUpdate];
        }
    }else{
        
    }
}

-(void)compareVersion:(NSString*)serviceVersion forceUpdate:(NSString*)forceUpdate {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    if ([currentVersion isEqualToString:serviceVersion]) {
        //如果是第一次安装或者更新的，清除所有缓存，清除已请求的服务器版本号；
        if ([self isFirstLoadCurrentVersion]) {
            
            [self transKey];
            [[DefaultValue shareInstance] defaultValue];
            [[CacheManager shareInstance] cleanAllCacheData];
            [KUserdefaults removeObjectForKey:ServerVersion];
        }else{
            if (!IsNilOrNull(currentVersion)) {
                [KUserdefaults setObject:currentVersion forKey:CKLastVersionKey];
            }
        }
    }else if([currentVersion compare:serviceVersion] == NSOrderedAscending){
        [self showUpdateAlert:forceUpdate];
    }else{
    
    }
}

-(void)requestServiceVersion:(void(^)(NSString *serviceVersion, NSString *force))serviceVersionBlock {
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{DeviceId:uuid};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getSomePath_Url];
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            return ;
        }
        
        //ckappcoupon  我的优惠券 显示开关  1：开启   其它： 关闭
        NSString *ckappcoupon = [dict objectForKey:@"ckappcoupon"];
        if (!IsNilOrNull(ckappcoupon)) {
            [KUserdefaults setObject:ckappcoupon forKey:@"CKYS_ckappcoupon"];
        }
        //ckappgift  考试显示开关：  1：开启   其它：关闭
        NSString *ckappgift = [dict objectForKey:@"ckappgift"];
        if (!IsNilOrNull(ckappgift)) {
            [KUserdefaults setObject:ckappgift forKey:@"CKYS_ckappgift"];
        }
        // ckappleader 我的管理者显示开关 ：显示开关 1：开启 其他：关闭
        NSString *ckappleader = [dict objectForKey:@"ckappleader"];
        if (!IsNilOrNull(ckappleader)) {
            [KUserdefaults setObject:ckappleader forKey:@"CKYS_ckappleader"];
        }
        //月结模式开关
        NSString *monthcalmode = [NSString stringWithFormat:@"%@", dict[@"monthcalmode"]];
        if (IsNilOrNull(monthcalmode)) {
            monthcalmode = @"";
        }
        [KUserdefaults setObject:monthcalmode forKey:@"CKYS_monthcalmode"];
        
        NSString *payalertmsg = [NSString stringWithFormat:@"%@", dict[@"payalertmsg"]];
        if (IsNilOrNull(payalertmsg)) {
            payalertmsg = @"";
        }
        [KUserdefaults setObject:payalertmsg forKey:@"payalertmsg"];
        
        
        NSString *ckappiosver = [dict objectForKey:@"ckappiosver"];
        if (!IsNilOrNull(ckappiosver)) {
            [KUserdefaults setObject:ckappiosver forKey:ServerVersion];
        }
        
        NSString *ckappiosforce = [dict objectForKey:@"ckappiosforce"];
        if (!IsNilOrNull(ckappiosforce)) {
            [KUserdefaults setObject:ckappiosforce forKey:Forceupdate];
        }
        
        NSString *ckappverinfo = [dict objectForKey:@"ckappverinfo"];
        if (!IsNilOrNull(ckappverinfo)) {
            [KUserdefaults setObject:ckappverinfo forKey:@"CKYS_updateInfo"];
        }
        
        NSString *updateUrl = [NSString stringWithFormat:@"%@",dict[@"downurl"]];
        if (IsNilOrNull(updateUrl)) {
            updateUrl = @"https://itunes.apple.com/cn/app/id1240024569";
        }
        [KUserdefaults setObject:updateUrl forKey:AppStoreUrl];
        
        [KUserdefaults synchronize];
        
        if (!IsNilOrNull(ckappiosver)) {
            serviceVersionBlock(ckappiosver, ckappiosforce);
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)showUpdateAlert:(NSString*)forceUpdate {
    
    NSString *ckappverinfo = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_updateInfo"]];
    if (IsNilOrNull(ckappverinfo)) {
        ckappverinfo = @"";
    }
    
    if([forceUpdate isEqualToString:@"1"]){
        [[CKCUpdateAlertView shareInstance] showUpdateAlert:ckappverinfo forceUpdate:YES];
    }else{
        [[CKCUpdateAlertView shareInstance] showUpdateAlert:ckappverinfo forceUpdate:NO];
    }
    
    
//    NSString *appStr = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:AppStoreUrl]];
//    NSURL *appUrl = [NSURL URLWithString:appStr];
//    if([forceUpdate isEqualToString:@"1"]){
//        //弹窗提示用户有新版本，只能选择去更新，不能进行其他操作，即使重启，弹窗也在。也只能去更新
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"更新提示" message:@"发现新版本,请前往更新!" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction * action = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
//            [vc presentViewController:alertVC animated:YES completion:nil];
//            [[UIApplication sharedApplication] openURL:appUrl];
//        }];
//
//        [alertVC addAction:action];
//        UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
//        [vc presentViewController:alertVC animated:YES completion:nil];
//
//    }else if([forceUpdate isEqualToString:@"0"]){
//        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"更新提示" message:@"发现新版本,请前往更新!" preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//
//        UIAlertAction * action = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1240024569"];
////            [[UIApplication sharedApplication]openURL:url];
//            [[UIApplication sharedApplication] openURL:appUrl];
//        }];
//
//        [alertVC addAction:action];
//        [alertVC addAction:actionCancel];
//        UIViewController * vc = [[UIApplication sharedApplication].keyWindow rootViewController];
//        [vc presentViewController:alertVC animated:YES completion:nil];
//    }
}

-(BOOL)isFirstLoadCurrentVersion{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *lastVersion = [KUserdefaults objectForKey:CKLastVersionKey];
    
    if (!lastVersion) {
        [KUserdefaults setObject:currentVersion forKey:CKLastVersionKey];
        return YES;
    }else if (![lastVersion isEqualToString:currentVersion]) {
        [KUserdefaults setObject:currentVersion forKey:CKLastVersionKey];
        return YES;  
    }  
    return NO;
}

-(void)showForceUpdate {
    //服务器的版本
    NSString *serviceVersion = [KUserdefaults objectForKey:ServerVersion];
    NSString *forceUpdate = [KUserdefaults objectForKey:Forceupdate];
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if([currentVersion compare:serviceVersion] == NSOrderedAscending && [forceUpdate isEqualToString:@"1"]){
        [self showUpdateAlert:forceUpdate];
    }
}

-(void)transKey {
    NSString *ckid = [KUserdefaults objectForKey:@"ckid"];
    if (!IsNilOrNull(ckid)) {
        [KUserdefaults setObject:ckid forKey:Kckid];
        [KUserdefaults removeObjectForKey:@"ckid"];
    }
    
    NSString *mobile = [KUserdefaults objectForKey:@"mobile"];
    if (!IsNilOrNull(mobile)) {
        [KUserdefaults setObject:mobile forKey:Kmobile];
        [KUserdefaults removeObjectForKey:@"mobile"];
    }
    
    NSString *nickName = [KUserdefaults objectForKey:@"nickName"];
    if (!IsNilOrNull(nickName)) {
        [KUserdefaults setObject:nickName forKey:KnickName];
        [KUserdefaults removeObjectForKey:@"nickName"];
    }
    
    NSString *openid = [KUserdefaults objectForKey:@"openid"];
    if (!IsNilOrNull(openid)) {
        [KUserdefaults setObject:openid forKey:KopenID];
        [KUserdefaults removeObjectForKey:@"openid"];
    }
    
    NSString *unionid = [KUserdefaults objectForKey:@"unionid"];
    if (!IsNilOrNull(unionid)) {
        [KUserdefaults setObject:unionid forKey:Kunionid];
        [KUserdefaults removeObjectForKey:@"unionid"];
    }
    
    
    NSString *headImageUrl = [KUserdefaults objectForKey:@"headImageUrl"];
    if (!IsNilOrNull(headImageUrl)) {
        [KUserdefaults setObject:headImageUrl forKey:kheamImageurl];
        [KUserdefaults removeObjectForKey:@"headImageUrl"];
    }
    
    NSString *password = [KUserdefaults objectForKey:@"password"];
    if (!IsNilOrNull(password)) {
        [KUserdefaults setObject:password forKey:Kpassword];
        [KUserdefaults removeObjectForKey:@"password"];
    }
    
    NSString *ispresale = [KUserdefaults objectForKey:@"ispresale"];
    if (!IsNilOrNull(ispresale)) {
        [KUserdefaults setObject:openid forKey:KisPresaleShop];
        [KUserdefaults removeObjectForKey:@"ispresale"];
    }
    
    NSString *sales = [KUserdefaults objectForKey:@"sales"];
    if (!IsNilOrNull(sales)) {
        [KUserdefaults setObject:sales forKey:KSales];
        [KUserdefaults removeObjectForKey:@"sales"];
    }
    
    
    NSString *status = [KUserdefaults objectForKey:@"status"];
    if (!IsNilOrNull(status)) {
        [KUserdefaults setObject:status forKey:KStatus];
        [KUserdefaults removeObjectForKey:@"status"];
    }
    
    NSString *checkstatus = [KUserdefaults objectForKey:@"checkstatus"];
    if (!IsNilOrNull(checkstatus)) {
        [KUserdefaults setObject:checkstatus forKey:KCheckStatus];
        [KUserdefaults removeObjectForKey:@"checkstatus"];
    }
    
    NSString *type = [KUserdefaults objectForKey:@"type"];
    if (!IsNilOrNull(type)) {
        [KUserdefaults setObject:type forKey:Ktype];
        [KUserdefaults removeObjectForKey:@"type"];
    }
    
    NSString *jointype = [KUserdefaults objectForKey:@"jointype"];
    if (!IsNilOrNull(jointype)) {
        [KUserdefaults setObject:jointype forKey:KjoinType];
        [KUserdefaults removeObjectForKey:@"jointype"];
    }
    
    
    NSString *realname = [KUserdefaults objectForKey:@"realname"];
    if (!IsNilOrNull(realname)) {
        [KUserdefaults setObject:realname forKey:Krealname];
        [KUserdefaults removeObjectForKey:@"realname"];
    }
    
    NSString *shopname = [KUserdefaults objectForKey:@"shopname"];
    if (!IsNilOrNull(shopname)) {
        [KUserdefaults setObject:shopname forKey:KshopName];
        [KUserdefaults removeObjectForKey:@"shopname"];
    }
}

@end
