//
//  CKFileObject.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKFileObject : NSObject

/**
 参数名 必填 （服务端接收时需要传入的参数名称）
 */
@property(nonatomic,strong) NSString *name;

/**
 图片名称 必填
 */
@property(nonatomic,strong) NSString *fileName;

/**
 MIMETYPE 默认 ”image/jpeg“
 */
@property(nonatomic,strong) NSString *mimeType;

/**
 文件MD5摘要，此属性在data设置时自动填充
 */
@property(nonatomic,strong,readonly) NSString *MD5String;

/**
 文件Data
 */
@property(nonatomic,strong) NSData *data;
@end
