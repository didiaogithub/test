//
//  CKMineCommon.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKMineCommon : NSObject

@property (nonatomic, strong) JGProgressHUD *viewNetError;

@property (nonatomic, strong) CKC_CustomProgressView *viewDataLoading;

/**
 请求二维码
 */
-(void)requestQRcode:(void(^)(NSString *qrcodeUrl, NSString *localQr, BOOL qrtype))qrCode;


/**
 推广工具名字数组

 @param type 用户类型
 @return 名字数组
 */
+ (NSArray*)userSchemeToolTitleArray:(NSString*)type;

/**
 推广工具图标数组
 
 @param type 用户类型
 @return 名字数组
 */
+ (NSArray*)userSchemeToolIconArray:(NSString*)type;

/**
 必备工具名字数组
 
 @param type 用户类型
 @return 名字数组
 */
+ (NSArray*)userUsefulToolTitleArray:(NSString*)type showCoupon:(BOOL)showCoupon;

/**
 必备工具图标数组
 
 @param type 用户类型
 @return 名字数组
 */
+ (NSArray*)userUsefulToolIconArray:(NSString*)type showCoupon:(BOOL)showCoupon;

@end
