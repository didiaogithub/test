//
//  CacheManager.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+(instancetype)shareInstance;

-(void)cleanAllCacheData;

-(void)cleanUserDefaultCache;

-(void)cleanDBCacheData;

/**
 清除登录状态和数据
 */
-(void)cleanLoginStatusData;


@end
