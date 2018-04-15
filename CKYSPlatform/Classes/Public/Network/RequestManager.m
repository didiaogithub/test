//
//  RequestManager.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/5/24.
//  Copyright © 2017年 ForgetFairy. All rights reserved.
//

#import "RequestManager.h"
#import "AFNetworkActivityIndicatorManager.h"

static const char * REQUEST_METHOD[4] = {"GET","POST","PUT","DELETE"};

NSString *const RequestManagerReachabilityDidChangeNotification = @"RequestManagerReachabilityDidChangeNotification";
NSString *const RequestManagerReachabilityNotificationStatusItem = @"RequestManagerReachabilityNotificationStatusItem";

@implementation RequestManager

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        [self setNetworkActivityIndicatorManagerEnabled:YES];
        
        AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [[RequestManager manager] reachabilityDidChangePostNotification:status];
        }];
        
        [reachabilityManager startMonitoring];
    }
    return self;
}

+(instancetype)manager {
    static RequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RequestManager alloc] initPrivate];
    });
    return instance;
}

+(RequestReachabilityStatus)reachabilityStatus {
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    
    return (RequestReachabilityStatus)status;
}

-(void)reachabilityDidChangePostNotification:(AFNetworkReachabilityStatus)status {
    
    NSDictionary *info = @{RequestManagerReachabilityNotificationStatusItem : @(status)};
    [[NSNotificationCenter defaultCenter] postNotificationName:RequestManagerReachabilityDidChangeNotification object:nil userInfo:info];
}

-(NSString *)methodString:(RequestMethod)method {
    const char *methodChar = REQUEST_METHOD[method];
    NSString *methodString = [NSString stringWithUTF8String:methodChar];
    return methodString;
}

-(void)setNetworkActivityIndicatorManagerEnabled:(BOOL)isEnabled {
    [[AFNetworkActivityIndicatorManager sharedManager] setActivationDelay:0];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:isEnabled];
}

-(AFURLSessionManager *)defaultSessionManager {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    return sessionManager;
}

-(NSMutableURLRequest*)HTTPRequestWithMethod:(RequestMethod)method URLString:(NSString*)URLString parameters:(id)parameters error:(NSError *__autoreleasing *)error {
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:[self methodString:method] URLString:URLString parameters:parameters error:error];
    
    return request;
}

-(NSMutableURLRequest*)JSONRequestWithMethod:(RequestMethod)method URLString:(NSString*)URLString parameters:(id)parameters error:(NSError *__autoreleasing *)error {
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:[self methodString:method] URLString:URLString parameters:parameters error:error];
    
    return request;
}

-(NSMutableURLRequest*)multipartFormRequestWithMethod:(RequestMethod)method URLString:(NSString*)URLString parameters:(NSDictionary<NSString*, id>*)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block error:(NSError * __autoreleasing *) error {
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:[self methodString:method] URLString:URLString parameters:parameters constructingBodyWithBlock:block error:error];
    
    return request;
}

-(void)dataWithRequest:(NSURLRequest*)request completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    
    [self dataWithRequest:request responseConfig:nil completionHandler:completionHandler];
}

-(void)dataWithRequest:(NSURLRequest*)request uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
      downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
     completionHandler:(void (^)(NSURLResponse *response, id responseObject,  NSError * error))completionHandler {
    
    AFURLSessionManager *sessionManager = [self defaultSessionManager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:request uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:completionHandler];
    [dataTask resume];
}

-(void)dataWithRequest:(NSURLRequest*)request responseConfig:(id<AFURLResponseSerialization>(^)())responseConfig completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    
    AFURLSessionManager *sessionManager = [self defaultSessionManager];
    
    if(responseConfig) {
        id<AFURLResponseSerialization> responseSerialization = responseConfig();
        if(responseSerialization) {
            sessionManager.responseSerializer = responseSerialization;
        }
    }
    
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:request completionHandler:completionHandler];
    [dataTask resume];
}

-(void)uploadWithStreamedRequest:(NSURLRequest*)request progress:(void (^)(NSProgress *uploadProgress))progressBlock completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    
    AFURLSessionManager *sessionManager = [self defaultSessionManager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    [serializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil]];
    sessionManager.responseSerializer = serializer;
    
    NSURLSessionUploadTask *uploadTask = [sessionManager uploadTaskWithStreamedRequest:request progress:progressBlock completionHandler:completionHandler];
    [uploadTask resume];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
