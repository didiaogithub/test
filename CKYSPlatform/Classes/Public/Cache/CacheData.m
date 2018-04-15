//
//  CacheData.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CacheData.h"
#import "XNKeychain.h"
#import "CKMainPageCommon.h"

uint64_t const CacheDataCurrentVersion = 9;

NSString *const CacheDataEncryptionKey = @"com.ckc8.ck.data";

@implementation CacheData

+(void)configCacheData {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = CacheDataCurrentVersion;
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < config.schemaVersion) {
  
        }
    };
    
    [RLMRealmConfiguration setDefaultConfiguration:config];
    [RLMRealm defaultRealm];
    
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        
    }
    return self;
}

+(instancetype)shareInstance {
    static CacheData *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [CacheData configCacheData];
        
        instance = [[CacheData alloc] initPrivate];
    });
    return instance;
}

-(RLMRealm*)defaultRealm {
    RLMRealm *realm = [RLMRealm defaultRealm];
    return realm;
}

-(void)addObject:(__kindof RLMObject*)obj {
    RLMRealm *realm = [self defaultRealm];
    
    [realm transactionWithBlock:^{
        [realm addObject:obj];
    }];
}

-(void)addOrUpdateObject:(__kindof RLMObject*)obj {
    RLMRealm *realm = [self defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:obj];
    [realm commitWriteTransaction];
}

-(void)addObjects:(id<NSFastEnumeration>)objs {
    RLMRealm *realm = [self defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObjects:objs];
    [realm commitWriteTransaction];
}

-(void)addOrUpdateObjectFromArray:(id)array {
    RLMRealm *realm = [self defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addOrUpdateObjects:array];
//    [realm addOrUpdateObjectsFromArray:array];
    [realm commitWriteTransaction];
}

-(void)deleteObject:(__kindof RLMObject*)obj {
    RLMRealm *realm = [self defaultRealm];
    
    [realm transactionWithBlock:^{
        [realm deleteObject:obj];
    }];
}

-(void)deleteObjects:(id)array {
    RLMRealm *realm = [self defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObjects:array];
    [realm commitWriteTransaction];
}

-(void)deleteAllObjects:(Class)cls {
    if(![self isSubclassOfCacheObjectClass:cls]) {
        return;
    }
    
    RLMResults *results = [self search:cls];
    
    [self deleteObjects:results];
}

-(RLMResults*)search:(Class)cls {
    return [self search:cls predicate:nil sorted:nil ascending:YES];
}

-(RLMResults*)search:(Class)cls sorted:(NSString*)sorted ascending:(BOOL)ascending {
    return [self search:cls predicate:nil sorted:sorted ascending:ascending];
}

-(RLMResults*)search:(Class)cls predicate:(NSString*)predicate {
    return [self search:cls predicate:predicate sorted:nil ascending:YES];
}

-(RLMResults*)search:(Class)cls predicate:(NSString*)predicate sorted:(NSString*)sorted ascending:(BOOL)ascending {
    if(![self isSubclassOfCacheObjectClass:cls]) {
        return nil;
    }
    
    RLMResults *results;
    if(predicate) {
        results = [cls objectsWhere:predicate];
    } else {
        results = [cls allObjects];
    }
    
    if(results && results.count > 0) {
        if(sorted) {
            results = [results sortedResultsUsingKeyPath:sorted ascending:ascending];
        }
    }
    
    return results;
}

-(BOOL)isSubclassOfCacheObjectClass:(Class)cls {
    if(![cls isSubclassOfClass:[RLMObject class]]) {
        NSLog(@"错误：%@不是RLMObject类", cls);
        return NO;
    }
    return YES;
}

@end
