//
//  CacheData.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface CacheData : NSObject

+(nonnull instancetype)shareInstance;

/**
 保存对象
 */
-(void)addObject:(nonnull __kindof RLMObject*)obj;

/**
 保存或者更新对象 （如果存在主键相同的对象才会进行更新操作，否则为保存操作）
 */
-(void)addOrUpdateObject:(nonnull __kindof RLMObject*)obj;

/**
 保存或者更新对象 （如果数组中的项存在主键相同的对象才会进行更新操作，否则为保存操作）
 
 @param array `NSArray`, `RLMArray`, or `RLMResults` of `RLMObject`的子类.
 */
-(void)addOrUpdateObjectFromArray:(nonnull id)array;

/**
 保存对象
 
 @param objs 基于NSFastEnumeration协议（NSArray，RLMResults）
 */
-(void)addObjects:(nonnull id<NSFastEnumeration>)objs;

/**
 删除已经存在的对象
 
 @param obj 必须为已经存在于Realm中的对象
 */
-(void)deleteObject:(nonnull __kindof RLMObject*)obj;

/**
 删除已经存在的对象
 
 @param array `NSArray`, `RLMArray`, or `RLMResults` of `RLMObject`的子类 并且是已经存在于realm中.
 */
-(void)deleteObjects:(nonnull id)array;

/**
 删除所有
 
 @param cls 目标Class
 */
-(void)deleteAllObjects:(nonnull Class)cls;


/**
 查询
 
 @param cls 目标Class
 @return 查询结果
 */
-(nullable RLMResults*)search:(nonnull Class)cls;

/**
 查询
 
 @param cls 目标Class
 @param sorted 排序字段名 默认为nil
 @param ascending 排序 默认为YES（正序）   NO（倒序）
 @return 查询结果
 */
-(nullable RLMResults*)search:(nonnull Class)cls sorted:(nullable NSString*)sorted ascending:(BOOL)ascending;

/**
 查询
 
 @param cls 目标Class
 @param predicate 应填写where条件
 @return 查询结果
 */
-(nullable RLMResults*)search:(nonnull Class)cls predicate:(nullable NSString*)predicate;

/**
 查询
 
 @param cls 目标Class
 @param predicate 应填写where条件
 @param sorted 排序字段名 默认为nil
 @param ascending 排序 默认为YES（正序） NO（倒序）
 @return 查询结果
 */
-(nullable RLMResults*)search:(nonnull Class)cls predicate:(nullable NSString*)predicate sorted:(nullable NSString*)sorted ascending:(BOOL)ascending;

@end
