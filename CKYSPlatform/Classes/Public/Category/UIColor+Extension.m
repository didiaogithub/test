//
//  UIColor+Extension.m
//  
//
//  Created by 家强 on 15/10/14.
//
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

#pragma mark 随机颜色
+(UIColor *)randomColor{
    static BOOL seed = NO;
    if (!seed) {
        seed = YES;
        srandom((unsigned int)time(NULL));
    }
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];//alpha为1.0,颜色完全不透明
}

#pragma mark 十六进制字符串色码转换为UIColor
+ (UIColor *)colorWithHexString:(NSString *)string
{
    // 小写转大写
    NSString *hexColor = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // 判断字符串色码的位数
    if ([hexColor length] < 6)
        return [UIColor whiteColor];
    if ([hexColor hasPrefix:@"#"])
        hexColor = [hexColor substringFromIndex:1];
    if ([hexColor length] != 6)
        return [UIColor whiteColor];
    
    // 分别获取RGB值
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

#pragma mark UIColor转换为十六进制字符串色码
+(NSString *)stringFromColor:(UIColor *)color
{
    const CGFloat *cs=CGColorGetComponents(color.CGColor);
    
    
    NSString *r = [NSString stringWithFormat:@"%@",[self  ToHex:cs[0]*255]];
    NSString *g = [NSString stringWithFormat:@"%@",[self  ToHex:cs[1]*255]];
    NSString *b = [NSString stringWithFormat:@"%@",[self  ToHex:cs[2]*255]];
    return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
}

+(NSString *)ToHex:(int)tmpid
{
    NSString *endtmp=@"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig=tmpid%16;
    int tmp=tmpid/16;
    switch (ttmpig)
    {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
            
    }
    switch (tmp)
    {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat=[[NSString alloc]initWithFormat:@"%i",tmp];
            
    }
    endtmp=[[NSString alloc]initWithFormat:@"%@%@",nStrat,nLetterValue];
    return endtmp;
}


#pragma mark 获取颜色RGB值
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color
{
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

//主色导航标题颜色
+ (UIColor *)tt_navBgColor
{
    return [self colorWithHexString:@"#fe3482"];
}
/**
 *  tabBar背景色
 */
+ (UIColor *)tt_tabBgColor{
  return [self colorWithHexString:@"#0c0c0c"];
}
//商品边框颜色 灰色——失效文字颜色 辅助文字颜色
+ (UIColor *)tt_borderColor
{
    return [self colorWithHexString:@"#e0e0e0"];
}
//主要分割线颜色 #e2e2e2
+ (UIColor *)tt_lineBgColor
{
    return [self colorWithHexString:@"#f3f3f3"];
}
+ (UIColor *)tt_grayBgColor{
   return [self colorWithHexString:@"#f4f4f4"];

}
+ (UIColor *)tt_headBoderColor{
    return [self colorWithHexString:@"#e4e4e4"];
    
}

+ (UIColor *)tt_littleGrayBgColor{
    return [self colorWithHexString:@"#fafafa"];
    
}
+ (UIColor *)tt_deepGrayBgColor{
    return [self colorWithHexString:@"#454545"];
    
}
//渐变文字颜色
+ (UIColor *)tt_gradientTitleColor{
  return [self colorWithHexString:@"#FFFFFF"];

}

//默认字体颜色
+ (UIColor *)tt_bodyTitleColor
{
    return [self colorWithHexString:@"#1b1b1b"];
}


//金额数字文字
+ (UIColor *)tt_redMoneyColor
{
    return [self colorWithHexString:@"#E2231A"];
}
//加盟绿色
+ (UIColor *)tt_greenColor
{
    return [self colorWithHexString:@"#22ac38"];
}
/**
 *  蓝色-协议 说明 银行卡 复制
 */
+ (UIColor *)tt_blueColor{
   return [self colorWithHexString:@"#1488ff"];
}
/**
 *  红色-大背景色
 */
+ (UIColor *)tt_bigRedBgColor{
    return [self colorWithHexString:@"#e22319"];
}
/**
 *  月结灰色的字
 */
+ (UIColor *)tt_monthGrayColor{
    return [self colorWithHexString:@"#999999"];
}

/**
 *  月结灰色黑色的字
 */
+ (UIColor *)tt_monthLittleBlackColor{
    return [self colorWithHexString:@"#666666"];
}


@end
