//
//  UILabel+TTSpacing.m
//  TT_Project
//
//  Created by 庞宏侠 on 16/7/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UILabel+TTSpacing.h"

@implementation UILabel (TTSpacing)

- (void)setText:(NSString *)text spacing:(NSInteger)spacing
{
    
    if (text == nil) {
        [self setText:@""];
    } else {
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:spacing];
        paragraphStyle1.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
        [self setAttributedText:attributedString1];
    }
}

- (void)setAttributedText:(NSString *)text spacing:(NSInteger)spacing
{
    if (text == nil) {
        [self setText:@""];
    } else {
        CGFloat lineSpace = 5;
        CGFloat offset = -(1.0/3 * lineSpace) - 1.0/3;
        CGFloat marginLeft = 20;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = lineSpace; // 调整行间距
        NSDictionary *attrs = @{
                                NSFontAttributeName : self.font,
                                NSParagraphStyleAttributeName : paragraphStyle
                                };
        // 计算一行文本的高度
        CGFloat oneHeight = [@"测试Test" boundingRectWithSize:CGSizeMake(screenWidth-marginLeft*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
        CGFloat rowHeight = [self.text boundingRectWithSize:CGSizeMake(screenWidth-marginLeft*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
        // 如果超出一行，则offset=0;
        offset = rowHeight > oneHeight ? 0 : offset;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle1.lineSpacing = spacing; // 调整行间距
        NSRange range = NSMakeRange(0, [text length]);
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:range];
        // 设置文本偏移量
        [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(offset) range:range];
        
        [self setAttributedText:attributedString];
    }
}


/**
 *  设置UILable里的文字两边对齐
 *  maxInteger    : 应占字符数 （中文为1，英文为0.5/个）
 *  currentString : 要显示的文字
 */
- (void)conversionCharacterInterval:(NSInteger)maxInteger current:(NSString *)currentString separator:(NSString *)separator
{
    // 获取到原始字符的长度
    float strLength = [self getLengthOfString:currentString];
    CGRect rect = [[currentString substringToIndex:1] boundingRectWithSize:CGSizeMake(200,self.frame.size.height)
                                                                   options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                attributes:@{NSFontAttributeName: self.font}
                                                                   context:nil];
    
    if (separator.length) {
        currentString = [NSString stringWithFormat:@"%@%@",currentString,separator];
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:currentString];
    
    [attrString addAttribute:NSKernAttributeName value:@(((maxInteger - strLength) * rect.size.width)/(strLength - 1)) range:NSMakeRange(0, strLength-1)];
    if (separator.length) {
        [attrString addAttribute:NSKernAttributeName value:@(0) range:NSMakeRange(strLength-1,2)];
    } else {
        [attrString addAttribute:NSKernAttributeName value:@(0) range:NSMakeRange(strLength-1,1)];
    }
    self.attributedText = attrString;
}

-  (float)getLengthOfString:(NSString*)str {
    
    float strLength = 0;
    char *p = (char *)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (NSInteger i = 0 ; i < [str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            strLength++;
        }
        p++;
    }
    return strLength/2;
}

@end
