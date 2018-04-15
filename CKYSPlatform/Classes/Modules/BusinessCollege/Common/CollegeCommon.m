//
//  CollegeCommon.m
//  CKYS
//
//  Created by 忘仙 on 2017/5/18.
//  Copyright © 2017年 ForgetFairy. All rights reserved.
//

#import "CollegeCommon.h"
#import "MJExtension.h"

NSString *const getLessonsSort = @"Ckapp3/News/getLessonsSort";
NSString *const getLessonsBySortId = @"Ckapp3/News/getLessonsBySortId";

@implementation CollegeCommon

+(void)getCollegeData:(NSString *)requestURL parameter:(NSDictionary *)parameter compeletionHandle:(CompeletionHandle)compeletionHandle {
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@",WebServiceAPI, requestURL];
    
    [[RequestManager manager] ckDataRequest:RequestMethodPost URLString:URLString parameters:parameter success:^(id  _Nullable responseObject) {
        compeletionHandle(responseObject, nil);
    } failure:^(id  _Nullable responseObject, NSError * _Nullable error) {
        compeletionHandle(nil, error);
    }];
}


@end
