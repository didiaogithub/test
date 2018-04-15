//
//  YundouModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/12/28.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YundouModel : NSObject
/**当前云豆库值*/
@property (nonatomic, copy) NSString *ylibmoney;
/**云豆库昨日到账*/
@property (nonatomic, copy) NSString *addmoneyYesterday;
/**云豆库今日到账*/
@property (nonatomic, copy) NSString *addmoneyToday;
/**最大可提现额度*/
@property (nonatomic, copy) NSString *maxCash;
/**是否锁定  是否有锁定记录（0：没有锁定记录  1：有锁定记录）*/
@property (nonatomic, copy) NSString *islock;
/**当前产品库值*/
@property (nonatomic, copy) NSString *glibmoney;

@end
