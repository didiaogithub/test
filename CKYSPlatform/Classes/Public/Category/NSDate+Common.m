//
//  NSDate+Common.m
//  yingzi_iOS
//
//  Created by liyongwei on 15/7/31.
//  Copyright (c) 2015年 lyw. All rights reserved.
//

#import "NSDate+Common.h"

@implementation NSDate (NSDate_Common)

//NSDate转化为NSString
+ (NSString *)dateToString:(NSDate *)date formatterType:(NSString *)type
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:type];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
#pragma mark---- 获取当钱的时间戳
+(NSString *)dateNow
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f",a];
    return timeString;
}
+(NSString *)dateMsTime{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
    NSLog(@"%@", timeLocal);
    return timeLocal;
}

//NSString转化为NSDate
+ (NSDate *)stringToDate:(NSString *)dateString formatterType:(NSString *)type
{
//    NSString *dateStr=[dic objectForKey:@"date"];// 2012-05-17 11:23:23
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:type];
    NSDate *fromdate = [format dateFromString:dateString];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate:fromdate];
    NSDate *fromDate = [fromdate dateByAddingTimeInterval:frominterval];
    return fromDate;
}

//获取当前时区的当前时间
+ (NSString*)nowTime:(NSString*)dateType
{
    NSDate * date = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    //[dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateformat setDateFormat:dateType];
    NSString * newDate= [dateformat stringFromDate:date];
    return newDate;
}

//比较两个时间的大小
+ (int)compareDate:(NSString*)date1 withDate:(NSString*)date2 dateFormat:(NSString *)format
{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
//    NSDate *dt1 = [[NSDate alloc] init];
//    NSDate *dt2 = [[NSDate alloc] init];
    NSDate *dt1 = nil;
    NSDate *dt2 = nil;
    dt1 = [df dateFromString:date1];
    dt2 = [df dateFromString:date2];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

// 根据时间比较两个时间的大小：
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd hh:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

@end
