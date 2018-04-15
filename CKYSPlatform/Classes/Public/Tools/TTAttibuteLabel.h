//
//  TTAttibuteLabel.h
//  TT_Project
//
//  Created by 庞宏侠 on 16/11/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTAttibuteLabel : UILabel

- (void)tt_setText:(NSString *)text color:(UIColor *)color left:(NSString *)left right:(NSString *)right;

- (void)setTextLeft:(NSString *)leftstr right:(NSString *)rightstr;

- (void)tt_stocksetText:(NSString *)text left:(NSString *)left right:(NSString *)right anleftColor:(UIColor *)leftColor andMiddlecolor:(UIColor *)middleColor andRightColor:(UIColor *)rightColor leftFont:(UIFont *)leftfont midFont:(UIFont *)midFont rightFont:(UIFont *)rightFont;
/**左右不一样的lable*/
- (void)setTextLeft:(NSString *)leftstr right:(NSString *)rightstr andLeftColor:(UIColor *)leftColor andRightColor:(UIColor *)rightColor andLeftFont:(float)leftFont andRightFont:(float)rightFont;

@end
