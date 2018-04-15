//
//  CKFileObject.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKFileObject.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation CKFileObject

-(instancetype)init {
    self = [super init];
    if(self) {
        self.mimeType = @"image/jpg";
    }
    return self;
}

-(void)setData:(NSData *)data {
    _data = data;
    if(_data) {
        _MD5String = [CKFileObject calcMD5ForData:_data];
    } else {
        _MD5String = nil;
    }
}

+(NSString*)calcMD5ForData:(NSData *)data
{
    const char* original_str = (const char *)[data bytes];
    NSUInteger len = [data length];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (uint)len, digest);
    return [self encodeFromBuf:digest];
}

+(NSString*)encodeFromBuf:(const unsigned char *) buf
{
    NSMutableString* res = [NSMutableString stringWithCapacity:32];
    for(int  i =0; i < CC_MD5_DIGEST_LENGTH; i++){
        [res appendFormat:@"%02x", buf[i]];
    }
    return res;
}


@end
