//
//  XNKeychain.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "XNKeychain.h"
#import <Security/Security.h>

@implementation XNKeychain

+(NSMutableDictionary*)keychainQuery:(NSString*)key {
    return [NSMutableDictionary dictionaryWithDictionary:@{(id)kSecClass: (id)kSecClassGenericPassword,
                                                           (id)kSecAttrService: key,
                                                           (id)kSecAttrAccount: key,
                                                           (id)kSecAttrAccessible: (id)kSecAttrAccessibleAfterFirstUnlock
                                                           }];
}

+(void)setObject:(id<NSSecureCoding>)obj forKey:(NSString*)key  {
    NSMutableDictionary *query = [self keychainQuery:key];
    SecItemDelete((CFDictionaryRef)query);
    [query setObject:[NSKeyedArchiver archivedDataWithRootObject:obj] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)query, NULL);
}

+(id)valueForKey:(NSString*)key {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self keychainQuery:key];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", key, e);
        } @finally {
        }
    }
    if (keyData) {
        CFRelease(keyData);
    }
    
    return ret;
}

+(void)removeObjectForKey:(NSString*)key {
    NSMutableDictionary *keychainQuery = [self keychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end
