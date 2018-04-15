//
//  XNArchiverManager.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/12/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNArchiverManager : NSObject

/**
 单例

 @return self
 */
+ (instancetype)shareInstance;

/**
 归档

 @param object 归档数据
 @param archiverName 归档名称
 */
- (void)xnArchiverObject:(id)object archiverName:(NSString *)archiverName;

/**
 解归档

 @param archiverName 归档名称
 @return 归档数据
 */
- (id)xnUnarchiverObject:(NSString *)archiverName;


@end
