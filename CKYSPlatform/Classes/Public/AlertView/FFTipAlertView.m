//
//  FFTipAlertView.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/14.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "FFTipAlertView.h"
#import "TTTAttributedLabel.h"

@interface FFTipAlertView()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;

@end

#define Padding 30
#define AlertTitleFont 16
#define AlertContentFont 13

@implementation FFTipAlertView

+(instancetype)shareInstance {
    static FFTipAlertView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FFTipAlertView alloc] initPrivate];
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
    
    CGFloat alertH = SCREEN_WIDTH-Padding*2-20;
    
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
    
    
    self.contentLabel = [[TTTAttributedLabel alloc] init];
    self.contentLabel.textColor = self.contentColor;
    self.contentLabel.font = self.contentFont;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.delegate = self;
    self.contentLabel.lineSpacing = 6;
    self.contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
    [self.contentScrollView addSubview:self.contentLabel];
   
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScrollView.mas_top);
        make.left.equalTo(self.mas_left).offset(Padding+10);
        make.right.equalTo(self.mas_right).offset(-Padding-10);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.closeBtn];
    [self.closeBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [self.closeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.closeBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.closeBtn.layer.borderWidth = 1;
    [self.closeBtn addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bigView.mas_bottom).offset(-10);
        make.left.equalTo(self.mas_left).offset(Padding+10);
        make.right.equalTo(self.mas_right).offset(-Padding-10);
        make.height.mas_equalTo(44);
    }];
    
    
}

- (void)dismissAlertView {
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
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSFontAttributeName value:self.contentLabel.font range:NSMakeRange(0, [content length])];
    self.contentLabel.attributedText = attributedString;
    
    // 设置可以拨打电话
    NSRange range = [content rangeOfString:@"400-777-1516"];
    [_contentLabel addLinkToPhoneNumber:@"400-777-1516" withRange:range];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:self.contentLabel.font,
                                   NSFontAttributeName,[UIColor blueColor],NSForegroundColorAttributeName,nil];
    [attributedString  setAttributes:attributeDict range:range];
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

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"linkClick");
    [[UIApplication sharedApplication] openURL:url];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    NSLog(@"phoneClick");
    
    [self dismissAlertView];
    
    NSString *number = [[NSString alloc]initWithFormat:@"telprompt://%@", phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
}

@end
