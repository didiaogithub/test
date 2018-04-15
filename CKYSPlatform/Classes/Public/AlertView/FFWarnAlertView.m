//
//  FFWarnAlertView.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/1/10.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "FFWarnAlertView.h"

@interface FFWarnAlertView()

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic,strong)  UIButton *sureBut;

@end

@implementation FFWarnAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        //最底下的view
        self.bigView = [[UIView alloc]init];
        [self addSubview:_bigView];
        _bigView.layer.cornerRadius = 5;
        _bigView.backgroundColor = [UIColor whiteColor];
        [_bigView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(SCREEN_HEIGHT/2-65);
            make.left.mas_offset(50);
            make.width.mas_offset(SCREEN_WIDTH - 100);
            make.height.mas_offset(130);
        }];
        
        _sureBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bigView addSubview:_sureBut];
        [_sureBut setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
        [_sureBut setTitle:@"确定" forState:UIControlStateNormal];
        _sureBut.titleLabel.font = MAIN_TITLE_FONT;
        [_sureBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.mas_offset(0);
            make.height.mas_equalTo(44);
        }];
        [_sureBut addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *horizalLable = [UILabel creatLineLable];
        [_bigView addSubview:horizalLable];
        [horizalLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_sureBut.mas_top);
            make.left.right.mas_offset(0);
            make.height.mas_offset(1);
        }];
        
        //中间的信息
        _titleLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:14.0f]];
        [_bigView addSubview:_titleLable];
        _titleLable.numberOfLines = 0;
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(20);
            make.left.mas_offset(15);
            make.right.mas_offset(-15);
            make.bottom.equalTo(horizalLable.mas_top);
        }];
        
        
        _bigView.transform = CGAffineTransformMakeScale(0, 0);
        
    }
    return self;
}

- (void)clickSureButton {
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_bigView removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickWarnAlertView:)]) {
            [self.delegate didClickWarnAlertView:self];
        }
    }];
}

- (void)showFFWarnAlertView {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
        _titleLable.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_titleLable becomeFirstResponder];
    }];
}

@end
