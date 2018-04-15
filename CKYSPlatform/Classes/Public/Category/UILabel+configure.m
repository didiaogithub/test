//
//  UILabel+configure.m
//  Thinkcoo_2.0
//
//  Created by YZLh on 16/7/4.
//  Copyright © 2016年 link. All rights reserved.
//

#import "UILabel+configure.h"

@implementation UILabel (configure)

+ (UILabel *)configureLabelWithTextColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.textAlignment = alignment;
    label.font = font;
    return label;
}
+ (UILabel *)creatLineLable
{
    UILabel * line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor tt_lineBgColor];
    return line;
}
@end
