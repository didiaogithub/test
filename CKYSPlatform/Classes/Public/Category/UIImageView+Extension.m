//
//  UIImageView+Extension.m
//  TT_Project
//
//  Created by 庞宏侠 on 17/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

- (void)hx_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    // 先获取本地缓存
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"imageCache"];
    
    //如果目录imageCache不存在，创建目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]) {
        NSError *error=nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:&error];
        
    }
    
    NSString *localpath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/imageCache/headimage.png"];
    
    // 获取缓存先显示 如果没有，则显示占位图
    if ([[NSFileManager defaultManager] fileExistsAtPath:localpath]) {
        UIImage *localImage = [UIImage imageWithContentsOfFile:localpath];
        if (localImage) {
            self.image = localImage;
        } else if (placeholder) {
            self.image = placeholder;
        }
    } else {
        if (placeholder) {
            self.image = placeholder;
        }
    }
    
    // 下载图片进行缓存
    // 通过GCD的方式创建一个新的线程来异步加载图片
    dispatch_queue_t queue =
    dispatch_queue_create("cacheimage", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self downLoadImageWithUrl:url];  //回调
    });
}

- (void)downLoadImageWithUrl:(NSURL *)url {
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    // 通知主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        if (imageData){
            self.image = [UIImage imageWithData:imageData];
            [self cacheImage:imageData];
        }
    });
}

// 本地缓存
- (void)cacheImage:(NSData *)imageData
{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *localpath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/imageCache/headimage.png"];
    [[NSFileManager defaultManager] createFileAtPath:localpath contents:imageData attributes:nil];
}


@end
