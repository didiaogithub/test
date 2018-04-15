//
//  CacheManager.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CacheManager.h"
#import "MessageModel.h"
#import "CKMainPageModel.h"
#import "CKSysMsgModel.h"
#import "CKOfficialMsgModel.h"
#import "OrderModel.h"
#import "CKUserMsgListModel.h"
#import "CKGroupModel.h"

@implementation CacheManager

+(instancetype)shareInstance {
    static CacheManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CacheManager alloc] initPrivate];
    });
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        
    }
    return self;
}


-(void)cleanDBCacheData {
    NSString *predicate = [NSString stringWithFormat:@"ckid != '%@'", KCKidstring];
    RLMResults *results = [MessageModel objectsWhere:predicate];
    RLMResults *results1 = [CKMainPageModel objectsWhere:predicate];
    RLMResults *results2 = [CKSysMsgListModel objectsWhere:predicate];
    RLMResults *results3 = [CKOfficialMsgModel objectsWhere:predicate];
    RLMResults *results4 = [OrderModel objectsWhere:predicate];
    RLMResults *results5 = [CKSysMsgModel allObjects];
    RLMResults *results6 = [CKUserMsgListModel allObjects];
    RLMResults *results7 = [CKGroupModel allObjects];
    RLMResults *results8 = [CKGroupInfoModel allObjects];

    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    if (results.count > 0) {
        [realm deleteObjects:results];
    }
    if (results1.count > 0) {
        [realm deleteObjects:results1];
    }
    if (results2.count > 0) {
        [realm deleteObjects:results2];
    }
    if (results3.count > 0) {
        [realm deleteObjects:results3];
    }
    if (results4.count > 0) {
        [realm deleteObjects:results4];
    }
    if (results5.count > 0) {
        [realm deleteObjects:results5];
    }
    if (results6.count > 0) {
        [realm deleteObjects:results6];
    }
    if (results7.count > 0) {
        [realm deleteObjects:results7];
    }
    if (results8.count > 0) {
        [realm deleteObjects:results8];
    }
    [realm commitWriteTransaction];
}


-(void)cleanAllCacheData {
    NSLog(@"清除所有缓存");
    
//    NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
//    NSDictionary *dictionary = [defatluts dictionaryRepresentation];
//    for(NSString *key in [dictionary allKeys]){
//        [defatluts setObject:@"" forKey:key];
//        [defatluts synchronize];
//    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *homePath = NSHomeDirectory();
    NSString *docPath = [homePath stringByAppendingString:@"/Documents"];
    NSString *libPath = [homePath stringByAppendingString:@"/Library"];
    NSString *tmpPath = [homePath stringByAppendingString:@"/tmp"];
    
    NSArray *a = @[docPath, libPath, tmpPath];
//    NSArray *a = @[libPath, tmpPath];

    for (NSInteger i = 0; i < a.count; i++) {
        NSDirectoryEnumerator *homeDirectoryEnumerator = [fileManager enumeratorAtPath:a[i]];
        NSString *homeFilePath = a[i];
        while((homeFilePath = [homeDirectoryEnumerator nextObject])!=nil) {
            
            NSString *deletePath = [a[i] stringByAppendingPathComponent:homeFilePath];
            if ([fileManager fileExistsAtPath:deletePath]) {
                if ([deletePath.lastPathComponent isEqualToString:@"Preferences"] || [deletePath.lastPathComponent isEqualToString:@"com.ckc.CKYSPlatform.plist"] || [deletePath.lastPathComponent hasPrefix:@"default.realm"] || [deletePath.lastPathComponent hasPrefix:@"CKDefaultValue.plist"]) {// 
                    NSLog(@"不删除deletePath : %@",deletePath);
                    NSLog(@"不删除deletePathLastPath : %@",deletePath.lastPathComponent);
                }else{
                    NSLog(@"deletePath : %@",deletePath);
                    NSLog(@"deletePathLastPath : %@",deletePath.lastPathComponent);
                    [fileManager removeItemAtPath:deletePath error:nil];
                }
            }
        }
    }
}

-(void)cleanUserDefaultCache {
    //3.0.2以前的key
    NSString *ckid = [KUserdefaults objectForKey:@"ckid"];
    if (!IsNilOrNull(ckid)) {
        [KUserdefaults removeObjectForKey:@"ckid"];
    }
    
    NSString *mobile = [KUserdefaults objectForKey:@"mobile"];
    if (!IsNilOrNull(mobile)) {
        [KUserdefaults removeObjectForKey:@"mobile"];
    }
    
    NSString *nickName = [KUserdefaults objectForKey:@"nickName"];
    if (!IsNilOrNull(nickName)) {
        [KUserdefaults removeObjectForKey:@"nickName"];
    }
    
    NSString *openid = [KUserdefaults objectForKey:@"openid"];
    if (!IsNilOrNull(openid)) {
        [KUserdefaults removeObjectForKey:@"openid"];
    }
    
    NSString *unionid = [KUserdefaults objectForKey:@"unionid"];
    if (!IsNilOrNull(unionid)) {
        [KUserdefaults removeObjectForKey:@"unionid"];
    }
    
    
    NSString *headImageUrl = [KUserdefaults objectForKey:@"headImageUrl"];
    if (!IsNilOrNull(headImageUrl)) {
        [KUserdefaults removeObjectForKey:@"headImageUrl"];
    }
    
    NSString *password = [KUserdefaults objectForKey:@"password"];
    if (!IsNilOrNull(password)) {
        [KUserdefaults removeObjectForKey:@"password"];
    }
    
    NSString *ispresale = [KUserdefaults objectForKey:@"ispresale"];
    if (!IsNilOrNull(ispresale)) {
        [KUserdefaults removeObjectForKey:@"ispresale"];
    }
    
    NSString *sales = [KUserdefaults objectForKey:@"sales"];
    if (!IsNilOrNull(sales)) {
        [KUserdefaults removeObjectForKey:@"sales"];
    }
    
    
    NSString *status = [KUserdefaults objectForKey:@"status"];
    if (!IsNilOrNull(status)) {
        [KUserdefaults removeObjectForKey:@"status"];
    }
    
    NSString *checkstatus = [KUserdefaults objectForKey:@"checkstatus"];
    if (!IsNilOrNull(checkstatus)) {
        [KUserdefaults removeObjectForKey:@"checkstatus"];
    }
    
    NSString *type = [KUserdefaults objectForKey:@"type"];
    if (!IsNilOrNull(type)) {
        [KUserdefaults removeObjectForKey:@"type"];
    }
    
    NSString *jointype = [KUserdefaults objectForKey:@"jointype"];
    if (!IsNilOrNull(jointype)) {
        [KUserdefaults removeObjectForKey:@"jointype"];
    }
    
    
    NSString *realname = [KUserdefaults objectForKey:@"realname"];
    if (!IsNilOrNull(realname)) {
        [KUserdefaults removeObjectForKey:@"realname"];
    }
    
    NSString *shopname = [KUserdefaults objectForKey:@"shopname"];
    if (!IsNilOrNull(shopname)) {
        [KUserdefaults removeObjectForKey:@"shopname"];
    }
    
}

//新版本第一次运行清除登录状态
-(void)cleanLoginStatusData {
    [KUserdefaults setObject:@"" forKey:KStatus];
    [KUserdefaults setObject:@"" forKey:Ktype];
    [KUserdefaults setObject:@"" forKey:KjoinType];
    [KUserdefaults setObject:@"" forKey:Krealname];
    [KUserdefaults setObject:@"" forKey:kheamImageurl];
    [KUserdefaults setObject:@"" forKey:KSales];
    [KUserdefaults setObject:@"" forKey:Kunionid];
    [KUserdefaults setObject:@"" forKey:KnickName];
    [KUserdefaults setObject:@"" forKey:KopenID];
    [KUserdefaults setObject:@"" forKey:Kpassword];
    [KUserdefaults setObject:@"" forKey:KshopName];
    [KUserdefaults setObject:@"" forKey:Kckid];
    [KUserdefaults setObject:@"" forKey:Kmobile];
    [KUserdefaults setObject:@"" forKey:KMineLoginStatus];
    [KUserdefaults setObject:@"" forKey:KHomeLoginStatus];
    [KUserdefaults setObject:@"" forKey:@"CKYS_USER_HEAD"];
    [KUserdefaults setObject:@"" forKey:@"Kgettermobile"];

}

@end
