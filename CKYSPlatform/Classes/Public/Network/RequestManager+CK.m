//
//  RequestManager+CK.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "RequestManager+CK.h"

#define CKDataRequestTimeOut 10

NSString *const CKErrorDomain = @"com.ckc.CKYSPlatform";

@implementation RequestManager (CK)


-(void)ckDataRequest:(RequestMethod)method URLString:(NSString*)URLString parameters:(NSDictionary<NSString*, id>*)parameters success:(void (^)(id responseObject))success failure:(void(^)(id responseObject, NSError *error))failure {
        
    NSError *exError;
    NSMutableURLRequest *request = [self HTTPRequestWithMethod:method URLString:URLString parameters:parameters error:&exError];
    if(exError) {
        failure(nil, exError);
        return;
    }
    
    request.timeoutInterval = CKDataRequestTimeOut;
    
    [self dataWithRequest:request responseConfig:^id<AFURLResponseSerialization> _Nullable{
        
        AFHTTPResponseSerializer *serializer;
        if(parameters && [parameters.allKeys containsObject:@"service"]) {
            serializer = [AFHTTPResponseSerializer serializer];
        } else {
            serializer = [AFJSONResponseSerializer serializer];
            [serializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil]];
        }
        
        return serializer;
    } completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSString *jsonStr = [responseObject mj_JSONString];
        NSLog(@"\n\n\n[---%ld----Result----%li--]:%@     --request.URL-->%@\n\n\n", method, (long)httpResponse.statusCode, jsonStr, httpResponse.URL);
        if(error) {
            
            if(httpResponse.statusCode == 502 && error.userInfo[@"NSUnderlyingError"] != nil) {
                
                failure(responseObject, error.userInfo[@"NSUnderlyingError"]);
            } else {
                failure(responseObject, error);
            }
        } else {
            NSDictionary *dict = responseObject;
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
            NSString *noticeString = [NSString stringWithFormat:@"%@",dict[@"codeinfo"]];
            if ([code isEqualToString:MutipDeviceLoginCode]){
                //弹窗提示被迫下线
                MultipleDevicesAlter *deveiceAlert = [MultipleDevicesAlter shareInstance];
                [deveiceAlert showAlert:noticeString];
                [CKCNotificationCenter postNotificationName:@"hudstop" object:nil];
                return;
            }
            if ([code isEqualToString:ShopCloseCode]){
                //弹窗提示店铺被关闭
                CloseShopAlter *closeShopAlert = [CloseShopAlter shareInstance];
                [closeShopAlert showCloseShopAlert:noticeString];
                [CKCNotificationCenter postNotificationName:@"hudstop" object:nil];
                return;
            }
            success(responseObject);
        }
    }];
}

-(void)ckUploadRequest:(RequestMethod)method URLString:(NSString*)URLString parameters:(NSDictionary<NSString*, id>*)parameters file:(CKFileObject*)file success:(void (^)(id responseObject))success failure:(void(^)(id responseObject, NSError *error))failure {
    
    [self ckUploadRequest:method URLString:URLString parameters:parameters files:@[file] progress:nil success:success failure:failure];
    
}

-(void)ckUploadRequest:(RequestMethod)method URLString:(NSString*)URLString parameters:(NSDictionary<NSString*, id>*)parameters file:(CKFileObject*)file progress:(void (^)(int64_t totalUnitCount, int64_t completedUnitCount))progress success:(void (^)(id responseObject))success failure:(void(^)(id responseObject, NSError *error))failure {
    
    [self ckUploadRequest:method URLString:URLString parameters:parameters files:@[file] progress:progress success:success failure:failure];
    
}

-(void)ckUploadRequest:(RequestMethod)method URLString:(NSString*)URLString parameters:(NSDictionary<NSString*, id>*)parameters files:(NSArray<CKFileObject*>*)files progress:(void (^)(int64_t totalUnitCount, int64_t completedUnitCount))progress success:(void (^)(id responseObject))success failure:(void(^)(id responseObject, NSError *error))failure {
    
    if(!files || files.count == 0) {
        NSString *localizedDescription = @"参数：<files> 不允许为空";
        NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: localizedDescription, NSLocalizedFailureReasonErrorKey: localizedDescription};
        failure(nil, [NSError errorWithDomain:CKErrorDomain code:-299 userInfo:errorInfo]);
        return;
    }
    
    NSError *exError;
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (CKFileObject *file in files) {
            [formData appendPartWithFileData:file.data name:file.name fileName:file.fileName mimeType:file.mimeType];
        }
        
    } error:&exError];
    
    if(exError) {
        failure(nil, exError);
        return;
    }
    
    
    [self uploadWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progress) {
            progress(uploadProgress.totalUnitCount, uploadProgress.completedUnitCount);
        }
        
    } completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error) {
            failure(responseObject, error);
        } else {
            success(responseObject);
        }
    }];
}

@end
