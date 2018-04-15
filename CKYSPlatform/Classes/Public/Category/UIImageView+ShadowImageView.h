//
//  UIImageView+ShadowImageView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ShadowImageView)
+ (UIImageView *)configureTopViewWithIMage:(NSString *)imageStr andFrame:(CGRect)rect;
+(UIImageView *)topShadowImageView;
+(UIImageView *)bottomShadowImageView;
@end
