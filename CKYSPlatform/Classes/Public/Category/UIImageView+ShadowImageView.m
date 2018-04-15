//
//  UIImageView+ShadowImageView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "UIImageView+ShadowImageView.h"

@implementation UIImageView (ShadowImageView)
+ (UIImageView *)configureTopViewWithIMage:(NSString *)imageStr andFrame:(CGRect)rect{
   
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:imageStr]];
    imageView.frame = rect;
    return imageView;
}
+(UIImageView *)topShadowImageView{
    
    UIImageView * topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 15)];
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:topImageView];
    [topImageView setImage:[UIImage imageNamed:@"topshadow"]];
    return topImageView;
}
+(UIImageView *)bottomShadowImageView{
    UIImageView * bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-64, SCREEN_WIDTH, 15)];
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:bottomImageView];
    [bottomImageView setImage:[UIImage imageNamed:@"bottomshadow"]];
    return bottomImageView;
}
@end
