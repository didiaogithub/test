//
//  WLWechatView.m
//  WLPlaceHolder
//
//  Created by 王林 on 16/5/11.
//  Copyright © 2016年 com.ptj. All rights reserved.
//

#import "NodataImageView.h"

@interface NodataImageView ()

@property (nonatomic,strong) UIImageView * imageView;

@end

@implementation NodataImageView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void) setup
{
    [self addSubview:self.imageView];
}

- (UIImageView *) imageView
{
    if(_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.frame.size.height/2-100,SCREEN_WIDTH, 200)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"nodatapicture"];
    }
    return _imageView;
}

@end
