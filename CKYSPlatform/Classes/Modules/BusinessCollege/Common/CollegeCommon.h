//
//  CollegeCommon.h
//  CKYS
//
//  Created by 忘仙 on 2017/5/18.
//  Copyright © 2017年 ForgetFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompeletionHandle)(id obj, NSError *error);

extern NSString *const getLessonsSort;
extern NSString *const getLessonsBySortId;


@interface CollegeCommon : NSObject

+(void)getCollegeData:(NSString *)requestURL parameter:(NSDictionary *)parameter compeletionHandle:(CompeletionHandle)compeletionHandle;

@end
