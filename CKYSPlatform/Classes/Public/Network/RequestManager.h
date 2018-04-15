//
//  RequestManager.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/5/24.
//  Copyright © 2017年 ForgetFairy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 获取网络状态

 - RequestReachabilityStatusUnknown: 未知
 - RequestReachabilityStatusNotReachable: 不可用
 - RequestReachabilityStatusReachableViaWWAN: 蜂窝移动网络
 - RequestReachabilityStatusReachableViaWiFi: Wi-Fi
 */
typedef NS_ENUM(NSInteger, RequestReachabilityStatus) {
    RequestReachabilityStatusUnknown = AFNetworkReachabilityStatusUnknown,
    RequestReachabilityStatusNotReachable = AFNetworkReachabilityStatusNotReachable,
    RequestReachabilityStatusReachableViaWWAN = AFNetworkReachabilityStatusReachableViaWWAN,
    RequestReachabilityStatusReachableViaWiFi = AFNetworkReachabilityStatusReachableViaWiFi,
};

/**
 请求方式
 */
typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGet = 0,
    RequestMethodPost = 1,
    RequestMethodPut = 2,
    RequestMethodDelete = 3
};

extern NSString * _Nonnull const RequestManagerReachabilityDidChangeNotification;
extern NSString * _Nonnull const RequestManagerReachabilityNotificationStatusItem;


@interface RequestManager : NSObject

-(nullable instancetype)init __attribute__((unavailable("不允许通过此方法创建实例")));
+(nullable instancetype)new __attribute__((unavailable("不允许通过此方法创建实例")));

/**
 获取RequestManager的实例
 */
+(nonnull instancetype)manager;

/**
 获取网络状态
 */
+(RequestReachabilityStatus)reachabilityStatus;

/**
 设置是否在请求时显示左上角网络标识符 （此方法为全局设置）默认为YES
 */
-(void)setNetworkActivityIndicatorManagerEnabled:(BOOL)isEnabled;

/**
 创建普通HTTP请求 (text/html)

 @param method 请求方式
 @param URLString 请求地址
 @param parameters 参数
 @param error 错误
 @return NSMutableURLRequest
 */
-(nullable NSMutableURLRequest*)HTTPRequestWithMethod:(RequestMethod)method URLString:(nonnull NSString*)URLString parameters:(nullable id)parameters error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/**
 创建JSON请求

 @param method 请求方式
 @param URLString 请求地址
 @param parameters 参数
 @param error 错误
 @return NSMutableURLRequest
 */
-(nullable NSMutableURLRequest*)JSONRequestWithMethod:(RequestMethod)method URLString:(nonnull NSString*)URLString parameters:(nullable id)parameters error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/**
 创建附件表单(二进制流)请求

 @param method 请求方式
 @param URLString 请求地址
 @param parameters 参数
 @param block 添加附件回调
 @param error 错误
 @return NSMutableURLRequest
 */
-(nullable NSMutableURLRequest*)multipartFormRequestWithMethod:(RequestMethod)method URLString:(nonnull NSString*)URLString parameters:(nullable NSDictionary<NSString*, id>*)parameters constructingBodyWithBlock:(nonnull void (^)(id<AFMultipartFormData> _Nonnull formData))block error:(NSError * _Nullable __autoreleasing * _Nullable) error;

/**
 执行数据请求

 @param request NSURLRequest
 @param completionHandler 请求完成回调
 */
-(void)dataWithRequest:(nonnull NSURLRequest*)request completionHandler:(nullable void (^)(NSURLResponse * _Nullable response, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

/**
 执行数据请求

 @param request NSURLRequest
 @param responseConfig response配置
 @param completionHandler 请求完成回调
 */
-(void)dataWithRequest:(nonnull NSURLRequest*)request responseConfig:(nullable id<AFURLResponseSerialization> _Nullable (^)())responseConfig completionHandler:(nullable void (^)(NSURLResponse * _Nullable response, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

-(void)dataWithRequest:(nonnull NSURLRequest*)request uploadProgress:(nullable void (^)(NSProgress * _Nonnull uploadProgress)) uploadProgressBlock
      downloadProgress:(nullable void (^)(NSProgress * _Nonnull downloadProgress)) downloadProgressBlock
     completionHandler:(nullable void (^)(NSURLResponse * _Nullable response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;

/**
 执行上传请求

 @param request NSURLRequest
 @param progressBlock 进度回调
 @param completionHandler 请求完成回调
 */
-(void)uploadWithStreamedRequest:(nonnull NSURLRequest*)request progress:(nonnull void (^)(NSProgress * _Nonnull uploadProgress))progressBlock completionHandler:(nullable void (^)(NSURLResponse * _Nullable response, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

@end
