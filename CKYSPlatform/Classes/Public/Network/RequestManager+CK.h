//
//  RequestManager+CK.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "RequestManager.h"
#import "CKFileObject.h"

@interface RequestManager (CK)

/**
 数据请求
 
 @param method 请求方式
 @param URLString 请求地址
 @param parameters 参数
 @param success 成功回调
 @param failure 失败回调
 */
-(void)ckDataRequest:(RequestMethod)method URLString:(nonnull NSString*)URLString parameters:(nullable NSDictionary<NSString*, id>*)parameters success:(nonnull void (^)(_Nullable id responseObject))success failure:(nonnull void(^)(_Nullable id responseObject,  NSError * _Nullable error))failure;

/**
 上传
 
 @param method 请求方式
 @param URLString 请求地址
 @param parameters 参数
 @param file 文件
 @param success 成功回调
 @param failure 失败回调
 */
-(void)ckUploadRequest:(RequestMethod)method URLString:(nonnull NSString*)URLString parameters:(nullable NSDictionary<NSString*, id>*)parameters file:(nonnull CKFileObject*)file success:(nonnull void (^)(_Nullable id responseObject))success failure:(nonnull void(^)(_Nullable id responseObject, NSError * _Nullable error))failure;

/**
 上传（带进度）
 
 @param method 请求方式
 @param URLString 请求地址
 @param parameters 参数
 @param file 文件
 @param progress 进度
 @param success 成功回调
 @param failure 失败回调
 */
-(void)ckUploadRequest:(RequestMethod)method URLString:(nonnull NSString*)URLString parameters:(nullable NSDictionary<NSString*, id>*)parameters file:(nonnull CKFileObject*)file progress:(nullable void (^)(int64_t totalUnitCount, int64_t completedUnitCount))progress success:(nonnull void (^)(_Nullable id responseObject))success failure:(nonnull void(^)(_Nullable id responseObject, NSError * _Nullable error))failure;

/**
 多文件上传 （由于服务端限制，此方法暂时不建议使用）
 
 @param method 请求方式
 @param URLString 请求地址
 @param parameters 参数
 @param files 文件集合
 @param progress 进度
 @param success 成功回调
 @param failure 失败回调
 */
-(void)ckUploadRequest:(RequestMethod)method URLString:(nonnull NSString*)URLString parameters:(nullable NSDictionary<NSString*, id>*)parameters files:(nonnull NSArray<CKFileObject*>*)files progress:(nullable void (^)(int64_t totalUnitCount, int64_t completedUnitCount))progress success:(nonnull void (^)(_Nullable id responseObject))success failure:(nonnull void(^)(_Nullable id responseObject, NSError * _Nullable error))failure;

@end
