//
//  ckc_CustomProgressView.m
//  Thinkcoo_2.0
//
//  Created by 庞宏侠 on 16/6/30.
//  Copyright © 2016年 link. All rights reserved.
//

#import "CKC_CustomProgressView.h"
#import "UIImage+GIF.h"
@implementation CKC_CustomProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    if (self) {
        
        //蒙版按钮  防止重复点击
        _blackBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _blackBt.backgroundColor = [UIColor clearColor];
        [self addSubview:_blackBt];
        [_blackBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [_blackBt addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
       
        //中间loading
        _progressView = [[UIImageView alloc] init];
        [self addSubview:_progressView];
        _progressView.contentMode = UIViewContentModeScaleAspectFit;
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.mas_offset(SCREEN_WIDTH/2-22);
            make.top.mas_offset((SCREEN_HEIGHT-64-49)/2-22);
            make.width.mas_offset(44);
            make.height.mas_offset(44);
        }];
        _progressView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"1.png"],
                                         [UIImage imageNamed:@"2.png"],
                                         [UIImage imageNamed:@"3.png"],
                                         [UIImage imageNamed:@"4.png"],
                                         [UIImage imageNamed:@"5.png"],
                                         [UIImage imageNamed:@"6.png"],
                                         [UIImage imageNamed:@"7.png"],
                                         [UIImage imageNamed:@"8.png"],
                                         [UIImage imageNamed:@"9.png"],
                                         [UIImage imageNamed:@"10.png"],
                                         [UIImage imageNamed:@"11.png"],nil];
        _progressView.animationDuration = 0.5; // in seconds
          [self setHidden:YES];
    }
    return self;
}

- (void)clicked
{
    NSLog(@"点我...");
}

/**
 *  开始动画
 */
- (void)startAnimation
{
    [self setHidden:NO];
    [_progressView startAnimating]; // starts animating
}
/**
 * 结束动画
 */
- (void)stopAnimation
{
    [self setHidden:YES];
    [_progressView stopAnimating]; // starts animating
    [self removeFromSuperview];
}
- (void)showNoticeView:(NSString*)title
{
    if (IsNilOrNull(title)){
        title = @"";
    }
    [self createNoticeView];
    if (self.viewNetError && !self.viewNetError.visible && title.length > 0) {
        self.viewNetError.textLabel.text = title;
        [self.viewNetError showInView:[UIApplication sharedApplication].keyWindow];
        [self.viewNetError dismissAfterDelay:1.5f];
    }

}
-(void)createNoticeView
{
    // 增加网络错误时提示
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.indicatorView = nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionBottomCenter;
    self.viewNetError.marginInsets = (UIEdgeInsets)
    {
        .top = 0.0f,
        .bottom = 60.0f,
        .left = 0.0f,
        .right = 0.0f,

    };
}
@end
