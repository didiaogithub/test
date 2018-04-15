//
//  CKMainPageCommon.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/5/24.
//  Copyright © 2017年 ForgetFairy. All rights reserved.
//

#import "CKMainPageCommon.h"

@implementation CKMainPageCommon

//+(void)getMainPageData:(CompeletionCallBack)callback{
//    
//    RequestManager *manger = [RequestManager manager];
//    [manger ckDataRequest:RequestMethodGet URLString:[self servicesURL:@"Ckapp3/Index/getMainData"] parameters:nil success:^(id  _Nullable responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
//            if (code == 200) {
//                NSDictionary *dataDic = responseObject;
//                callback(dataDic, nil);
//            }
//            
//        }
//        
//    } failure:^(id  _Nullable responseObject, NSError * _Nullable error) {
//        callback(nil,error);
//        NSLog(@"%@",error);
//    }];
//}
//
//+(NSString *)servicesURL:(NSString *)url {
//    NSString *servicesURL = ApplicationEnvironmentProduction ? @"http://bateckysappserver.ckc8.com" : @"http://testofflineckysappserver.ckc8.com";
//    NSString *URLString = [NSString stringWithFormat:@"%@/%@", servicesURL, url];
//    return URLString;
//}

@end
