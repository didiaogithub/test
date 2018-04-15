//
//  NSString+Common.h
//  yingzi_iOS
//
//  Created by liyongwei on 15/7/31.
//  Copyright (c) 2015年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Common)

/**
 *  数字字符串加入逗号位数分隔
 */
+ (NSString *)countNumAndChangeformat:(NSString *)num;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
/**
 *  正则 邮箱
 */
+ (BOOL)isEmail:(NSString *)email;
/*
 *  正则 手机号
 */
+ (BOOL)isMobile:(NSString *)mobile;

// 判断 是否是 座机号码
+ (BOOL)isLandlineTelephone:(NSString *)telephone;

//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard;
/**
 * 判断 是否是 PinCode
 */
+ (BOOL)isPinCode:(NSString *)testCode;
/**
 *  判断 是否是包含字母和数字的6-18位密码
 */
+ (BOOL)isPassWord:(NSString *)passWord;

// 验证价格是否格式正确
+ (BOOL)isCheckPrice:(NSString *)price;

// 验证登录名是否由6-20位字母与数字组成
+ (BOOL)isCheckLoginUserName:(NSString *)userName;

// 验证搜索的用户名是否为字母与数字组成 不超过20位
+ (BOOL)isCheckSearchUserName:(NSString *)userName;


// 获取字符串的长度
+(CGFloat)countLength:(NSString*)text  withFont:(UIFont*) font;
/**
 *  字符串里是否包含某字符
 *
 *  @param stringg <#stringg description#>
 *  @param str     <#str description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)string:(NSString*) stringg isContantStr:(NSString*)str;
+ (BOOL)validateNumber:(NSString *)number;

/**检测是否合法的银行卡号*/
+ (BOOL)isCheckCardNo:(NSString*)cardNumber;

+(BOOL)checkCardNo:(NSString*)cardNo;
/*接受后台字符串精度失真问题*/
+(NSString *)reviseString:(NSString *)string;


/**文字竖排显示*/
- (NSString *)VerticalString;
/*带*号的变色*/
+(NSMutableAttributedString *)attributedStrWthStr:(NSString *)commonStr;
/*加载图片判断是否有http*/
+(NSString *)loadImagePathWithString:(NSString *)string;
+(void)deleteWebCache;

+ (NSString *)getCurrentVersionStr;

+ (NSString *)getCurrentVersionAndDeviceType;
    
/**判断字符串是否有表情*/
+ (BOOL)stringContainsEmoji:(NSString *)string;

@end
