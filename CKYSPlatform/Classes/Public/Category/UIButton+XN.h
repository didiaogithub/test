//
//  UIButton+XN.h
//  BESTKEEP
//
//  Created by ForgetFairy on 2016/11/17.
//  Copyright © 2016年 YISHANG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XNButtonEdgeInsetsStyle) {
    XNButtonEdgeInsetsStyleTop    = 0, // image在上，label在下
    XNButtonEdgeInsetsStyleLeft   = 1, // image在左，label在右
    XNButtonEdgeInsetsStyleBottom = 2, // image在下，label在上
    XNButtonEdgeInsetsStyleRight  = 3, // image在右，label在左
};

@interface UIButton (XN)

- (void)layoutButtonWithEdgeInsetsStyle:(XNButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
