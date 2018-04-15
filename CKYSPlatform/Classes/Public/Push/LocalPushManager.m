//
//  LocalPushManager.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/15.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "LocalPushManager.h"
#import "UIViewController+CurrentVC.h"

@implementation LocalPushManager

+ (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState == UIApplicationStateActive) {
        return;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([self getCurrentViewControllerWithWindow:keyWindow]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.5 * NSEC_PER_SEC) ), dispatch_get_main_queue(), ^{
            
            NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
            if ([homeLoginStatus isEqualToString:@"homelogin"]) {
                UIViewController *currentVC = [UIViewController currentVC];
                [currentVC.navigationController popToRootViewControllerAnimated:YES];
                currentVC.tabBarController.selectedIndex = 4;
            }
        });
    }
}

//获取当前控制器
+ (UINavigationController *) getCurrentViewControllerWithWindow:(UIWindow *)window {
    UINavigationController *navigationController;
    
    UITabBarController *tabBarController = (UITabBarController *)window.rootViewController;
    
    if (tabBarController.selectedIndex == 0) {
        
        navigationController = window.rootViewController.childViewControllers.firstObject;
        
    }else if (tabBarController.selectedIndex == 1) {
        
        navigationController = window.rootViewController.childViewControllers[1];
        
    }else if (tabBarController.selectedIndex == 3) {
        
        navigationController = window.rootViewController.childViewControllers[3];
        
    }else {
        
        navigationController = window.rootViewController.childViewControllers.firstObject;
    }
    
    return navigationController;
}



/*
 * 检测是否打开推送
 */
+(BOOL )isOpenLocalNotification{
    BOOL isTurnOnPush = YES;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == 0) {
            isTurnOnPush = NO;
        } else {
            isTurnOnPush = YES;
        }
    }
    
    return isTurnOnPush;
}
#pragma mark=====================关闭本地推送=====================
+(void)closeLocalNotification{
    //更新本地状态
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
#pragma mark=====================开启本地推送=====================
+(void)openLocalNotification{
    //更新本地状态
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //获取当前时间
    NSDate *nowDate = [NSDate date];
    NSString *dateStr = [dateFormatter stringFromDate:nowDate];
    //获取今天15：00
    NSString * str_today_date10_00 = [NSString stringWithFormat:@"%@ 15:00:00",[dateStr substringToIndex:10]];
    NSDate * today_date10_00 = [dateFormatter dateFromString:str_today_date10_00];
    //获取明天15：00
    NSString *str_tomorrow_date10_00 =[NSString stringWithFormat:@"%@ 15:00:00",[[LocalPushManager GetTomorrowDay:nowDate] substringToIndex:10]];
    NSDate * tomorrow_date10_00 = [dateFormatter dateFromString:str_tomorrow_date10_00];
    
    long sec;
    if([LocalPushManager compareDate:dateStr withDate:str_today_date10_00]==1){//还没到今天10:00
        sec =[LocalPushManager getSubSecFromData:nowDate ToData:today_date10_00];
    }else{
        sec =[LocalPushManager getSubSecFromData:nowDate ToData:tomorrow_date10_00];
    }
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:sec];
    notification.alertBody = @"您还未参与培训考试，快点参与考试吧";
    notification.alertAction = @"考试啦";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.userInfo = @{
                              @"body":@"创客云商:考试啦"
                              };
    notification.repeatInterval = kCFCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}
//比较两个时间
+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
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
//传入今天的时间，返回明天的时间
+ (NSString *)GetTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateday stringFromDate:beginningOfWeek];
}
/*
 * 计算两个时间的差值
 */
+(long)getSubSecFromData:(NSDate *)fromDate ToData:(NSDate *)toDate{
    NSCalendar *cal = [NSCalendar currentCalendar];
    long sec;
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *d = [cal components:unitFlags fromDate:fromDate toDate:toDate options:0];
    sec = [d hour]*3600+[d minute]*60+[d second];
    //    NSLog(@"second = %ld",[d hour]*3600+[d minute]*60+[d second]);
    return sec;
}

@end
