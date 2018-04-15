//
//  CKUncaughtExceptionHandle.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/31.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKUncaughtExceptionHandle.h"
#import "UIViewController+CurrentVC.h"
#import "CommonMethod.h"

// 崩溃时的回调函数
void FFUncaughtExceptionHandler(NSException * exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason]; // // 崩溃的原因  可以有崩溃的原因(数组越界,字典nil,调用未知方法...) 崩溃的控制器以及方法
    NSString *name = [exception name];
    
    //获取手机状态信息，网络，机型，系统
    NSString *deviceType = [CommonMethod getCurrentDeviceModel];
    NSString *wifiMsg = [CommonMethod getWifiName];
    if (IsNilOrNull(wifiMsg)) {
        wifiMsg = @"noWifiMsg";
    }
    NSString *sysVersion = [NSString stringWithFormat:@"%f", [[[UIDevice currentDevice] systemVersion] floatValue]];
    NSString *isp = [CommonMethod getMobileProvider];
    NSDictionary *infoDic = @{@"设备型号":deviceType, @"wifi":wifiMsg, @"系统版本":sysVersion, @"运营商":isp};
    NSString *tgStr = [KUserdefaults objectForKey:KSales];
    UIViewController *topController = [UIViewController currentVC];
    NSDictionary *dict = @{@"类名": [NSString stringWithFormat:@"%@", [topController class]], @"发生的时间":[NSDate date], @"创客id": KCKidstring, @"推广人id": tgStr};
    
    NSString *url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@ \n错误的类:\n%@ \n手机信息\n%@",name,reason,[arr componentsJoinedByString:@"\n"], dict, infoDic];
    
    [KUserdefaults setObject:url forKey:@"CKUncaughtExceptionLog"];

    [[XNArchiverManager shareInstance] xnArchiverObject:url archiverName:@"UncaughtException"];
}


@implementation CKUncaughtExceptionHandle


+(void)setDefaultHandler {
    NSSetUncaughtExceptionHandler(&FFUncaughtExceptionHandler);
}

+(NSUncaughtExceptionHandler *)getHandler {
    return NSGetUncaughtExceptionHandler();
}

+(void)TakeException:(NSException *)exception {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * path = [docPath stringByAppendingPathComponent:@"UncaughtException.txt"];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(void)sendExceptionLog {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"UncaughtException"];
    NSString *exception = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (exception != nil) {
        NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
        NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
        NSDictionary *appDic = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [appDic objectForKey:@"CFBundleShortVersionString"];
        NSString *devicetype = [NSString stringWithFormat:@"ios%@", version];
        
        NSDictionary *params = @{@"ckid": ckid, DeviceId:uuid, @"devicetype":devicetype, @"content":exception};
        NSString *upLoadErrUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, UploadErrorLog];
        [HttpTool postWithUrl:upLoadErrUrl params:params success:^(id json) {
            NSDictionary *dict = json;
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
            if ([code isEqualToString:@"200"]) {
                // 删除文件
                NSFileManager *fileManger = [NSFileManager defaultManager];
                [fileManger removeItemAtPath:filePath error:nil];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

@end
