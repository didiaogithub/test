//
//  NSDate+Common.h
//  yingzi_iOS
//
//  Created by liyongwei on 15/7/31.
//  Copyright (c) 2015年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDate_Common)

//NSDate转化为NSString
+ (NSString *)dateToString:(NSDate *)date formatterType:(NSString *)type;

#pragma mark---- 获取当钱的时间戳
+(NSString *)dateNow;
#pragma mark---- 获取毫秒的时间戳
+(NSString *)dateMsTime;

//NSString转化为NSDate
+ (NSDate *)stringToDate:(NSString *)dateString formatterType:(NSString *)type;
//比较两个日期
+ (int)compareDate:(NSString*)date1 withDate:(NSString*)date2 dateFormat:(NSString *)format;
+ (NSString*)nowTime:(NSString*)dateType;
// 根据时间比较两个时间的大小：
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

@end
