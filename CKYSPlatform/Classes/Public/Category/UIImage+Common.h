//
//  UIImage+Common.h
//  yingzi_iOS
//
//  Created by YW on 15/7/15.
//  Copyright (c) 2015年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_Common)
- (UIImage*)scaledToSize:(CGSize)targetSize;//压缩图片
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
+ (UIImage *)imageWithColor:(UIColor *)aColor;
+ (UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
//旋转图片
+ (UIImage *)fixOrientation:(UIImage *)aImage;
/**
 *  获取网络图片的宽和高
 *
 *  @param imgUrl 传入网络图片url
 *
 *  @return 返回一个数组 有俩内容：@[w,h];
 */
+ (NSMutableArray *)getImgWidthAndHeight:(NSString *)imgUrl;




/**
 *  根据颜色创建图片
 */
+ (UIImage *)imageWithColor:(UIColor*)color rect:(CGRect)rect;

/**
 *  根据图片名自动加载适配iOS6\7的图片
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;
+ (UIImage *)gradientResizedImage:(NSString *)name;

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
