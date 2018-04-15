//
//  FFAlertView.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "FFAlertView.h"

@interface FFAlertView ()

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

#define Padding 30
#define AlertTitleFont 16
#define AlertContentFont 14

@implementation FFAlertView

+(instancetype)shareInstance {
    static FFAlertView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FFAlertView alloc] initPrivate];
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
    
    [self setDefaultPropertyValue];
    
    CGFloat alertH = (SCREEN_HEIGHT/5*2.0 < SCREEN_WIDTH-Padding*2)?(SCREEN_WIDTH):(SCREEN_HEIGHT/5*2.0);
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    //最外层view
    self.bigView = [[UIView alloc]init];
    [self addSubview:self.bigView];
    self.bigView.backgroundColor = [UIColor whiteColor];
    self.bigView.layer.cornerRadius = 5;
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(Padding);
        make.right.mas_offset(-Padding);
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(alertH);
    }];
    
    
    self.titleLabel = [UILabel configureLabelWithTextColor:self.titleColor textAlignment:self.titleTextAlignment font:self.titleFont];
    self.titleLabel.numberOfLines = 0;
    [self.bigView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(10));
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.bigView addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(Padding);
        make.right.equalTo(self.mas_right).offset(-Padding);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.mas_centerY).offset(alertH*0.5-10);
    }];

    
    self.contentLabel = [UILabel configureLabelWithTextColor:self.contentColor textAlignment:NSTextAlignmentLeft font:self.contentFont];
    [self.contentScrollView addSubview:self.contentLabel];
    self.contentLabel.text = @"";
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScrollView.mas_top);
        make.left.equalTo(self.mas_left).offset(Padding+10);
        make.right.equalTo(self.mas_right).offset(-Padding-10);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.closeBtn];
    [self.closeBtn setImage:[UIImage imageNamed:@"takecashcolose"] forState:UIControlStateNormal];
    [self.closeBtn setImage:[UIImage imageNamed:@"takecashcolose"] forState:UIControlStateSelected];
    [self.closeBtn addTarget:self action:@selector(dismissFFAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bigView.mas_bottom).offset(20);
        make.left.mas_offset(SCREEN_WIDTH/2-30);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    
    
}

-(void)dismissFFAlertView {
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

//重新置为默认值
- (void)setDefaultPropertyValue {
    self.titleFont = [UIFont systemFontOfSize:AlertTitleFont];
    self.titleColor = [UIColor colorWithHexString:@"#333333"];
    self.titleTextAlignment = NSTextAlignmentCenter;
    self.contentFont = [UIFont systemFontOfSize:AlertContentFont];
    self.contentColor = [UIColor colorWithHexString:@"#666666"];
}

-(void)showAlert:(NSString *)title content:(NSString*)content {
    _titleLabel.text = title;
    _titleLabel.textColor = self.titleColor;
    _titleLabel.font = self.titleFont;
    _titleLabel.textAlignment = self.titleTextAlignment;
    _contentLabel.textColor = self.contentColor;
    _contentLabel.font = self.contentFont;
    //重新置为默认值
    [self setDefaultPropertyValue];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSFontAttributeName value:self.contentLabel.font range:NSMakeRange(0, [content length])];
    self.contentLabel.attributedText = attributedString;
    
    NSDictionary *attributes = @{NSFontAttributeName:self.contentLabel.font,  NSParagraphStyleAttributeName:paragraphStyle};
    CGSize s = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*(Padding+10), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    self.contentScrollView.contentSize = CGSizeMake(0, s.height);
    
    [self.bigView layoutIfNeeded];
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        self.alpha = 1;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
        _titleLabel.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

@end
