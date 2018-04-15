//
//  CommonMethod.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/15.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonMethod : NSObject


/**
 判断一个Class是否包含某个变量

 @param cls class
 @param name 变量名
 @return BOOL
 */
+(BOOL)isVariableWithClass:(Class)cls varName:(NSString*)name;

/**
 获取当前设备型号

 @return 设备型号
 */
+(NSString *)getCurrentDeviceModel;

/**
 获取WiFi名称

 @return WiFi名称
 */
+(NSString *)getWifiName;

/**
 获取运营商信息

 @return 运营商信息
 */
+(NSString*)getMobileProvider;

@end


