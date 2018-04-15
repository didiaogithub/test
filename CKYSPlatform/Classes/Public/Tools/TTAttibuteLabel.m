//
//  TTAttibuteLabel.m
//  TT_Project
//
//  Created by 庞宏侠 on 16/11/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TTAttibuteLabel.h"

@implementation TTAttibuteLabel

- (void)tt_setText:(NSString *)text color:(UIColor *)color left:(NSString *)left right:(NSString *)right
{
    
    // 集中设置
    NSString *textStr = [NSString stringWithFormat:@"%@%@%@",left,text,right];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    [AttributedStr addAttributes:@{NSFontAttributeName:MAIN_TITLE_FONT,NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(left.length, text.length)];
    [AttributedStr addAttributes:@{NSFontAttributeName:MAIN_TITLE_FONT,NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, left.length)];
    [AttributedStr addAttributes:@{NSFontAttributeName:MAIN_TITLE_FONT,NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(left.length + text.length,1)];
    [self setAttributedText:AttributedStr];
    
}
- (void)tt_stocksetText:(NSString *)text left:(NSString *)left right:(NSString *)right anleftColor:(UIColor *)leftColor andMiddlecolor:(UIColor *)middleColor andRightColor:(UIColor *)rightColor leftFont:(UIFont *)leftfont midFont:(UIFont *)midFont rightFont:(UIFont *)rightFont{
    // 集中设置
    NSString *textStr = [NSString stringWithFormat:@"%@%@%@",left,text,right];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    [AttributedStr addAttributes:@{NSFontAttributeName:midFont,NSForegroundColorAttributeName:middleColor} range:NSMakeRange(left.length, text.length)];
    
    [AttributedStr addAttributes:@{NSFontAttributeName:leftfont,NSForegroundColorAttributeName:leftColor} range:NSMakeRange(0, left.length)];
    
    [AttributedStr addAttributes:@{NSFontAttributeName:rightFont,NSForegroundColorAttributeName:rightColor} range:NSMakeRange(left.length + text.length,1)];
    [self setAttributedText:AttributedStr];
}

- (void)setTextLeft:(NSString *)leftstr right:(NSString *)rightstr{
    // 集中设置
    NSString *textStr = [NSString stringWithFormat:@"%@%@",leftstr,rightstr];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    [AttributedStr addAttributes:@{NSFontAttributeName:MAIN_TITLE_FONT,NSForegroundColorAttributeName:SubTitleColor} range:NSMakeRange(0, leftstr.length)];
    [AttributedStr addAttributes:@{NSFontAttributeName:MAIN_TITLE_FONT,NSForegroundColorAttributeName:TitleColor} range:NSMakeRange(leftstr.length, rightstr.length)];

    [self setAttributedText:AttributedStr];
}

- (void)setTextLeft:(NSString *)leftstr right:(NSString *)rightstr andLeftColor:(UIColor *)leftColor andRightColor:(UIColor *)rightColor andLeftFont:(float)leftFont andRightFont:(float)rightFont{
    // 集中设置
    NSString *textStr = [NSString stringWithFormat:@"%@%@",leftstr,rightstr];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    [AttributedStr addAttributes:@{NSFontAttributeName:CHINESE_SYSTEM_BOLD(AdaptedHeight(leftFont)),NSForegroundColorAttributeName:leftColor} range:NSMakeRange(0, leftstr.length)];
    [AttributedStr addAttributes:@{NSFontAttributeName:CHINESE_SYSTEM(AdaptedHeight(rightFont)),NSForegroundColorAttributeName:rightColor} range:NSMakeRange(leftstr.length, rightstr.length)];
    
    [self setAttributedText:AttributedStr];
}

@end
