//
//  UILabel+TTSpacing.h
//  TT_Project
//
//  Created by 庞宏侠 on 16/7/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TTSpacing)

/**
  为label添加行边距

 @param text 文字
 @param spacing 间距
 */
- (void)setText:(NSString *)text spacing:(NSInteger)spacing;

/**
 设置文本间距

 @param text 文字
 @param spacing 间距
 */
- (void)setAttributedText:(NSString *)text spacing:(NSInteger)spacing;

/**
 *  设置UILable里的文字两边对齐
 *  maxInteger    : 应占字符数 （中文为1，英文为0.5/个）
 *  currentString : 要显示的文字
 */
- (void)conversionCharacterInterval:(NSInteger)maxInteger
                            current:(NSString *)currentString
                          separator:(NSString *)separator;

@end
