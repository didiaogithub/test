//
//  CKCUpdateAlertView.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/12/20.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKCUpdateAlertView.h"

@interface CKCUpdateAlertView ()
{
    CGFloat Padding;
}

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

#define AlertH SCREEN_HEIGHT/5*2.0
//#define Padding 30

@implementation CKCUpdateAlertView

+(instancetype)shareInstance {
    static CKCUpdateAlertView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CKCUpdateAlertView alloc] initPrivate];
    });
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        [self initComponent];
    }
    return self;
}

-(void)initComponent {
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    //最外层view
    
    UIImage *image = [UIImage imageNamed:@"updateBg"];
    Padding = (SCREEN_WIDTH - image.size.width)*0.5;
    
    self.bgImgView = [UIImageView new];
    self.bgImgView.image = image;
    self.bgImgView.userInteractionEnabled = YES;
    [self addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_offset(Padding);
//        make.right.mas_offset(-Padding);
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(image.size.height);
        make.width.mas_equalTo(image.size.width);
    }];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.confirmBtn];
    [self.confirmBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    self.confirmBtn.layer.cornerRadius = 20.0;
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.backgroundColor = [UIColor redColor];
    [self.confirmBtn addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImgView.mas_bottom).offset(-10);
        make.right.equalTo(self.bgImgView.mas_right).offset(-20);
        make.left.equalTo(self.bgImgView.mas_left).offset(20);
        make.height.mas_equalTo(40);
    }];
    
    self.bigView = [[UIView alloc]init];
    [self addSubview:self.bigView];
    self.bigView.backgroundColor = [UIColor clearColor];
    self.bigView.layer.cornerRadius = 5;
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(Padding);
        make.right.mas_offset(-Padding);
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(AlertH);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.closeBtn];
    [self.closeBtn setImage:[UIImage imageNamed:@"updateClose"] forState:UIControlStateNormal];
    [self.closeBtn setImage:[UIImage imageNamed:@"updateClose"] forState:UIControlStateSelected];
    [self.closeBtn addTarget:self action:@selector(dismissFFAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImgView.mas_top).offset(50);
        make.right.mas_offset(-Padding);
        make.size.mas_offset(CGSizeMake(64, 64));
    }];
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.bigView addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(Padding);
        make.right.equalTo(self.mas_right).offset(-Padding);
        if (IPHONE_X) {
            make.top.equalTo(self.bigView.mas_top).offset(130);
        }else{
            make.top.equalTo(self.bigView.mas_top).offset(100);
        }
        make.bottom.equalTo(self.confirmBtn.mas_top).offset(-10);
    }];
    
    
    self.contentLabel = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#666666"] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15]];
    [self.contentScrollView addSubview:self.contentLabel];
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScrollView.mas_top);
        make.left.equalTo(self.mas_left).offset(Padding+10);
        make.right.equalTo(self.mas_right).offset(-Padding-10);
    }];
    
}

- (void)update {
    NSString *appStr = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:AppStoreUrl]];
    NSURL *appUrl = [NSURL URLWithString:appStr];
    [[UIApplication sharedApplication] openURL:appUrl];
}

-(void)dismissFFAlertView {
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)showUpdateAlert:(NSString*)content forceUpdate:(BOOL)force {

    self.closeBtn.hidden = force;
    
    CGSize s = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*(Padding+10), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    self.contentScrollView.contentSize = CGSizeMake(0, s.height);
    self.contentLabel.text = content;
    
    [self.bigView layoutIfNeeded];
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        self.alpha = 1;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

@end
