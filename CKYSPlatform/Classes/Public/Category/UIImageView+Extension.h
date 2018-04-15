//
//  UIImageView+Extension.h
//  TT_Project
//
//  Created by 王家强 on 17/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)


/**
 不使用Sd的缓存

 @param url 图片URL
 @param placeholder 占位图
 */
- (void)hx_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
