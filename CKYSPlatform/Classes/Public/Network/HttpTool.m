//
//  HttpTool.m
//  CKYSPlatform
//
//  Created by ckys on 16/6/27.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "HttpTool.h"
#import "CodeLoginViewController.h"
#define CKDataRequestTimeOut 10

@implementation HttpTool

+ (void)getWithUrl:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure{
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    serializer.removesKeysWithNullValues = YES;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = serializer;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    manager.requestSerializer.timeoutInterval = CKDataRequestTimeOut;
    
//    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
//    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
//    [paramDict setValue:uuid forKey:@"deviceid"];
//    [paramDict setValue:@"2" forKey:@"devtype"];
//    [paramDict setValue:@"1" forKey:@"apptype"];
//    devtype   1：android  2：ios
//    apptype  1：创客app   2：商城app
    
    NSLog(@"params:%@\nurl:%@", params, url);
    
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [responseObject mj_JSONString];
        NSLog(@"\n\n\n[---POST----Result----]:%@     --request.URL-->%@\n\n\n", jsonStr, url);
        if (success) {
            
            NSDictionary *dict = responseObject;
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
            NSString *noticeString = [NSString stringWithFormat:@"%@",dict[@"codeinfo"]];
            
            //          先初始化弹出的框
            MultipleDevicesAlter *deveiceAlert = [MultipleDevicesAlter shareInstance];
            CloseShopAlter *closeShopAlert = [CloseShopAlter shareInstance];
            
            if(!IsNilOrNull(KCKidstring)){
                if ([code isEqualToString:MutipDeviceLoginCode]){
                    
                    [KUserdefaults setObject:@"" forKey:KMineLoginStatus];
                    [KUserdefaults setObject:@"" forKey:KHomeLoginStatus];
                    [KUserdefaults setObject:@"" forKey:Kunionid];
                    [KUserdefaults setObject:@"" forKey:Kckid];
                    
                    //先弹窗提示被迫下线
                    [deveiceAlert showAlert:noticeString];
                    [CKCNotificationCenter postNotificationName:@"hudstop" object:nil];
                    return;
                }
            }
            
            //店铺已关闭
            if ([code isEqualToString:ShopCloseCode]){
                [KUserdefaults setObject:@"" forKey:KMineLoginStatus];
                [KUserdefaults setObject:@"" forKey:KHomeLoginStatus];
                [KUserdefaults setObject:@"" forKey:Kunionid];
                [KUserdefaults setObject:@"" forKey:Kckid];
                
                //店铺被关闭
                [closeShopAlert showCloseShopAlert:noticeString];
                [CKCNotificationCenter postNotificationName:@"hudstop" object:nil];
                return;
            }
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求错误%@", error);
        if (failure) {
            failure(error);
        }
    }];
    
}


+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure{
    
//  AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    
    if ([url containsString:@"Ckapp3/Regist/getValidateCode"]) {
        manager.requestSerializer.timeoutInterval = 60;
    }else{
        manager.requestSerializer.timeoutInterval = CKDataRequestTimeOut;
    }
    
    NSLog(@"params:%@\nurl:%@", params, url);
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *jsonStr = [responseObject mj_JSONString];
        NSLog(@"\n\n\n[---POST----Result----]:%@     --request.URL-->%@\n\n\n", jsonStr, url);
        if (success){
            
            NSDictionary *dict = responseObject;
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
            NSString *noticeString = [NSString stringWithFormat:@"%@",dict[@"codeinfo"]];
            
//          先初始化弹出的框
            MultipleDevicesAlter *deveiceAlert = [MultipleDevicesAlter shareInstance];
            CloseShopAlter *closeShopAlert = [CloseShopAlter shareInstance];
            
            if(!IsNilOrNull(KCKidstring)){
                if ([code isEqualToString:MutipDeviceLoginCode]){
                    
                    [KUserdefaults setObject:@"" forKey:KMineLoginStatus];
                    [KUserdefaults setObject:@"" forKey:KHomeLoginStatus];
                    [KUserdefaults setObject:@"" forKey:Kunionid];
                    [KUserdefaults setObject:@"" forKey:Kckid];

                    //先弹窗提示被迫下线
                    [deveiceAlert showAlert:noticeString];
                    [CKCNotificationCenter postNotificationName:@"hudstop" object:nil];
                    return;
                }
            }
            
            //店铺已关闭
            if ([code isEqualToString:ShopCloseCode]){
                [KUserdefaults setObject:@"" forKey:KMineLoginStatus];
                [KUserdefaults setObject:@"" forKey:KHomeLoginStatus];
                [KUserdefaults setObject:@"" forKey:Kunionid];
                [KUserdefaults setObject:@"" forKey:Kckid];

                //店铺被关闭
                [closeShopAlert showCloseShopAlert:noticeString];
                [CKCNotificationCenter postNotificationName:@"hudstop" object:nil];
                return;
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求错误%@", error);
        if (failure) {
            failure(error);
        }
    }];
    
}

+(void)uploadImage:(NSData*)imageData url:(NSString*)url name:(NSString*)name parameters:(NSDictionary * )parameters fileName:(NSString*)fileName success:(void (^)(id json))success failure:(void (^)(NSError * error))failure
{
    
    NSLog(@"params:%@\nurl:%@", parameters, url);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData
                                    name:name
                                fileName:fileName
                                mimeType:@"image/jpg"];
    } error:nil];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if([responseObject[@"status"] integerValue] == 1){
            
            success(responseObject);
            
        }else if([responseObject[@"status"] integerValue] == 0){
            
            failure(error);
        }
        
    }];
    
    [uploadTask resume];
    
}

/**上传图片新处理方法*/
+(void)uploadWithUrl:(NSString *)url andImages:(NSArray *)imageArray andPramaDic:(NSDictionary *)paramaDic completion:(void(^)(NSString *url,NSError *error))uploadBlock success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail
{
    
    NSLog(@"params:%@\nurl:%@", paramaDic, url);
    
    
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = serializer;
    manager.requestSerializer.timeoutInterval = CKDataRequestTimeOut;
    [manager POST:url parameters:paramaDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for(NSInteger i = 0; i < imageArray.count; i++)
        {
            UIImage * image = [imageArray objectAtIndex: i];
            // 压缩图片
            
            // 添加一个标记 去分图片名称
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            if (data.length>100*1024) {
                if (data.length>1024*1024) {//1M以及以上
                    data = UIImageJPEGRepresentation(image, 0.1);
                }else if (data.length>512*1024) {//0.5M-1M
                    data = UIImageJPEGRepresentation(image, 0.5);
                }else if (data.length>200*1024) {//0.25M-0.5M
                    data = UIImageJPEGRepresentation(image, 0.9);
                }
            }

            // 上传的参数名
            NSString *now = [NSDate nowTime:@"yyyyMMddHHmmss"];
            NSString * Name = [NSString stringWithFormat:@"%@%zi",now,i+1];
            // 上传filename
            NSString * fileName = [NSString stringWithFormat:@"%@.jpg", Name];
            
            [formData appendPartWithFileData:data name:@"headfile" fileName:fileName mimeType:@"image/jpeg"];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"上传进度");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"[Fail---%@]",error.localizedDescription);
        if (fail) {
            fail(error);
        }
    }];
}

@end
