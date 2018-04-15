//
//  UILabel+configure.h
//  Thinkcoo_2.0
//
//  Created by YZLh on 16/7/4.
//  Copyright © 2016年 link. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (configure)
+(UILabel *)configureLabelWithTextColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment font:(UIFont *)font;
+ (UILabel *)creatLineLable;
@end
