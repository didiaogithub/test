//
//  UIView+Layer.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/24.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "UIView+Layer.h"

@implementation UIView (Layer)
+ (UIView *)configureViewWithbankColor:(UIColor *)color andFrame:(CGRect)rect
{
    UIView *bankView = [[UIView alloc] init];
    bankView.backgroundColor = color;
    bankView.frame = rect;
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [bankImageView setImage:[UIImage resizedImage:@"shadowbank"]];
    bankImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bankView addSubview:bankImageView];
    return bankView;
}


@end
