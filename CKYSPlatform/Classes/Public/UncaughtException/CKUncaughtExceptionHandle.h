//
//  CKUncaughtExceptionHandle.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/31.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKUncaughtExceptionHandle : NSObject

+(void)setDefaultHandler;
+(NSUncaughtExceptionHandler *)getHandler;
+(void)TakeException:(NSException *) exception;

+(void)sendExceptionLog;

@end
