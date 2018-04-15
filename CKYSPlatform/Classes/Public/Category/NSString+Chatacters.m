//
//  NSString+Chatacters.m
//  yingzi_iOS
//
//  Created by kewei on 16/3/25.
//  Copyright © 2016年 lyw. All rights reserved.
//

#import "NSString+Chatacters.h"

@implementation NSString (Chatacters)

/* 将汉字装换为拼音 */
- (NSString *)pinyinOfString {
    NSMutableString *name = [[NSMutableString alloc] initWithString:self];
    CFRange range = CFRangeMake(0, 1);
    // 汉子转拼音，去除音调：
    if (! CFStringTransform((__bridge CFMutableStringRef)name, &range, kCFStringTransformMandarinLatin, NO || !CFStringTransform((__bridge CFMutableStringRef)name, &range, kCFStringTransformStripDiacritics, NO))) {
        return @"";
    }
    return name;
}

/* 汉子转换成拼音后，返回大写的首字母 */
- (NSString *)firstCharacterOfString {
    NSMutableString *first = [[NSMutableString alloc] initWithString:[self substringWithRange:NSMakeRange(0, 1)]];
    CFRange range = CFRangeMake(0, 1);
    // 汉子转换为拼音，去除音调：
    if (! CFStringTransform((__bridge CFMutableStringRef)first, &range, kCFStringTransformMandarinLatin, NO) || !CFStringTransform((__bridge CFMutableStringRef)first, &range, kCFStringTransformStripDiacritics, NO)) {
        return @"";
    }
    NSString *result;
    result = [first substringWithRange:NSMakeRange(0, 1)];
    return result.uppercaseString;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+(CGSize)calcuteLableHeightWith:(NSString *)lableText withLableWidth:(float)lableWidth withFont:(UIFont *)font{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize size = [lableText boundingRectWithSize:CGSizeMake(lableWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return size;
    
}

//计算并绘制字符串文本的高度
+(CGSize)getSuitSizeWithString:(NSString *)text fontSize:(float)fontSize bold:(BOOL)bold sizeOfX:(float)x
{
    UIFont *font ;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    CGSize constraint = CGSizeMake(x, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    // 返回文本绘制所占据的矩形空间。
    CGSize contentSize = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return contentSize;
}



@end
