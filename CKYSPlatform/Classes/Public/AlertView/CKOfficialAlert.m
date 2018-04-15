//
//  CKOfficialAlert.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/31.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKOfficialAlert.h"

@interface CKOfficialAlert ()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIView *bigView;

@end

@implementation CKOfficialAlert

+ (instancetype)shareInstance {
    static CKOfficialAlert *alert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alert = [[CKOfficialAlert alloc] init];
        [alert creatUI];
    });
    return alert;
}

- (void)creatUI {
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    //最外层view
    
    self.bigView = [[UIView alloc]init];
    [self addSubview:self.bigView];
    self.bigView.backgroundColor = [UIColor whiteColor];
    self.bigView.layer.cornerRadius = 5;
    
    self.titleLabel = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.bigView addSubview:self.titleLabel];
    
    
    
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.deleteButton];
    [self.deleteButton setImage:[UIImage imageNamed:@"takecashcolose"] forState:UIControlStateNormal];
    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(AdaptedWidth(40));
        make.right.mas_offset(-AdaptedWidth(40));
        make.center.mas_equalTo(self);
    }];
    
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(30));
        make.left.mas_offset(AdaptedWidth(10));
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    self.subTitleLable = [[TTTAttributedLabel alloc] init];
    self.subTitleLable.textColor = SubTitleColor;
    self.subTitleLable.font = [UIFont systemFontOfSize:14];
    self.subTitleLable.lineBreakMode = NSLineBreakByWordWrapping;
    self.subTitleLable.numberOfLines = 0;
    self.subTitleLable.delegate = self;
    self.subTitleLable.lineSpacing = 8;
    self.subTitleLable.enabledTextCheckingTypes = NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
    [self.bigView addSubview:self.subTitleLable];
    
    [self.subTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(AdaptedHeight(20));
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_titleLabel.mas_right);
        make.bottom.mas_offset(-AdaptedHeight(30));
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bigView.mas_bottom).offset(20);
        make.left.mas_offset(SCREEN_WIDTH/2-30);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    
    [self.deleteButton addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)showAlert:(NSString *)title {
    _titleLabel.text = title;
    [self.bigView layoutIfNeeded];
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        self.alpha = 1;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
        _titleLabel.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 关闭弹窗
- (void)dismissAlertView {
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
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
