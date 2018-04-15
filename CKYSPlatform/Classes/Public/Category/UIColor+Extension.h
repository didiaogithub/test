//
//  UIColor+Extension.h
//  
//
//  Created by 家强 on 15/10/14.
//
//

#import <UIKit/UIKit.h>


@interface UIColor (Extension)

/**
 *  生成一个随机颜色
 */
+ (UIColor *)randomColor;

/**
 *  将字符串型的16进制色码(ffffff)转换为UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)string;

/**
 *  UIColor转换为十六进制字符串色码
 */
+ (NSString *)stringFromColor:(UIColor *)color;

/**
 *  UIColor获取RGB值
 */
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color;


/** ---------------- 此项目中常用的颜色 ---------------- */
/**
 *  粉色导航标题颜色 辅助分割线 主要色调
 */
+ (UIColor *)tt_navBgColor;

/**
 *  tabBar背景色
 */
+ (UIColor *)tt_tabBgColor;

/**
 分割线颜色
 */
+ (UIColor *)tt_lineBgColor;

/**
 订单商品背景颜色
 */
+ (UIColor *)tt_littleGrayBgColor;


/**
 商品边框色 灰色——失效文字颜色 登录界面分割线
 */
+ (UIColor *)tt_borderColor;

/**
 *  灰色颜色
 */
+ (UIColor *)tt_grayBgColor;

/**
 *  头像边框
 */
+ (UIColor *)tt_headBoderColor;


/**
 *  消息  订单 顶部分割灰色颜色
 */
+ (UIColor *)tt_deepGrayBgColor;

/**
 *  纯白——渐变背景文字颜色
 */
+ (UIColor *)tt_gradientTitleColor;


/**
 *  主标题 正文 黑色 金额 默认状态文字
 */
+ (UIColor *)tt_bodyTitleColor;



/**
 *  水红——金额-数字文字
 */
+ (UIColor *)tt_redMoneyColor;

/**
 *  绿色-加盟-ck fx选择颜色
 */
+ (UIColor *)tt_greenColor;

/**
 *  蓝色-协议 说明 银行卡 复制
 */
+ (UIColor *)tt_blueColor;

/**
 *  红色-大背景色
 */
+ (UIColor *)tt_bigRedBgColor;
/**
 *  月结 - 淡黑色  数据值
 */
+ (UIColor *)tt_monthLittleBlackColor;

/**
 *  月结灰色的字  主要是文字
 */
+ (UIColor *)tt_monthGrayColor;

@end
