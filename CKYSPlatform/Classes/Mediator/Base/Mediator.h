//
//  Mediator.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/5/24.
//  Copyright © 2017年 ForgetFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 协调器参数配置类
 */
@interface MediatorOptions : NSObject

@property(nonnull,nonatomic,strong) NSString *targetName;
@property(nonnull,nonatomic,strong) NSString *actionName;
@property(nullable,nonatomic,strong) NSDictionary<NSString*, id> *parameters;
@property(nonatomic,assign) BOOL shouldCacheTarget;
@property(nullable,nonatomic,strong) NSString *cacheKey;

+(nonnull instancetype)optionsWithTargetName:(nonnull NSString*)targetName actionName:(nonnull NSString*)actionName;

@end



/**
 协调器 各个组件之间调用必须经过协调器 协调器中定义的方法返回类型不允许为void 和 基本类型(int float double 等)
 */
@interface Mediator : NSObject

-(nullable instancetype)init NS_UNAVAILABLE;
+(nullable instancetype)new NS_UNAVAILABLE;

/**
 获取当前协调器实例
 */
+(nonnull instancetype)sharedInstance;

/**
 远程调用（暂不开放）
 */
- (nullable id)performActionWithUrl:(nonnull NSURL *)url completion:(void(^ _Nullable)(NSDictionary * _Nullable info))completion;

/**
 本地调用
 */
-(nullable id)performWithOptions:(nonnull MediatorOptions *)options;

/**
 移除缓存的Target
 */
-(void)removeCacheTargetWithKey:(nonnull NSString*)cacheKey;

/**
 生成Target缓存Key
 */
+(nonnull NSString*)generateCacheKey;

@end
