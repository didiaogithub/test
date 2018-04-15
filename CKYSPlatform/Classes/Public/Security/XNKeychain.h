//
//  XNKeychain.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNKeychain : NSObject

+(void)setObject:(nonnull id<NSSecureCoding>)obj forKey:(nonnull NSString*)key;
+(nullable id)valueForKey:(nonnull NSString*)key;
+(void)removeObjectForKey:(nonnull NSString*)key;

@end
