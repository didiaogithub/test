//
//  XNArchiverManager.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/12/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "XNArchiverManager.h"

@implementation XNArchiverManager

+(instancetype)shareInstance {
    static XNArchiverManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XNArchiverManager alloc] initPrivate];
    });
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        
    }
    return self;
}


- (void)xnArchiverObject:(id)object archiverName:(NSString *)archiverName {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:archiverName];
    [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}

- (id)xnUnarchiverObject:(NSString *)archiverName {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:archiverName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

@end
