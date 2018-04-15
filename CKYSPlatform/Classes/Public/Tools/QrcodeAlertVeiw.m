//
//  XWAlterVeiw.m
//  XWAleratView

#import "QrcodeAlertVeiw.h"
@interface QrcodeAlertVeiw ()

@end

@implementation QrcodeAlertVeiw

- (instancetype)init
{
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
            make.top.mas_offset(SCREEN_HEIGHT/2-AdaptedHeight(100));
            make.left.mas_offset(AdaptedWidth(60));
            make.width.mas_offset(SCREEN_WIDTH - AdaptedWidth(120));
            make.height.mas_offset(AdaptedHeight(200));
            make.center.equalTo(self);
        }];
    
        //标题
        _titleLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:ALL_ALERT_FONT];
        [_bigView addSubview:_titleLable];
        _titleLable.text = @"邀请码";
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedHeight(10));
            make.left.right.mas_offset(0);
        }];

        //提示信息
        _noticeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM(AdaptedHeight(12))];
        [_bigView addSubview:_noticeLable];
        _noticeLable.text = @"请慎重核实邀请码信息";
        [_noticeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLable.mas_bottom).offset(AdaptedHeight(10));
            make.left.right.mas_offset(0);
        }];
        
        UILabel *textName = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
        [_bigView addSubview:textName];
        textName.text = @"默认邀请人:";
        [textName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_noticeLable.mas_bottom).offset(AdaptedHeight(20));
            make.left.mas_offset(AdaptedWidth(15));
        }];
        
        //上级创客名字
        _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
        [_bigView addSubview:_nameLable];
        [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textName.mas_top);
            make.left.equalTo(textName.mas_right).offset(AdaptedWidth(5));
            make.right.mas_offset(-AdaptedWidth(15));
        }];
        
        UILabel *textCode = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
        [_bigView addSubview:textCode];
        textCode.text = @"默认邀请码:";
        [textCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textName.mas_bottom).offset(AdaptedHeight(15));
            make.left.equalTo(textName);
        }];
        
        //上级创客邀请码
        _qrcodeLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
        [_bigView addSubview:_qrcodeLable];
        [_qrcodeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textCode.mas_top);
            make.left.equalTo(textCode.mas_right).offset(AdaptedWidth(5));
            make.right.equalTo(_nameLable.mas_right);
        }];
        
        UILabel *horizalLable = [UILabel creatLineLable];
        [_bigView addSubview:horizalLable];
        [horizalLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textCode.mas_bottom).offset(AdaptedHeight(15));
            make.left.right.mas_offset(0);
            make.height.mas_offset(1);
        }];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bigView addSubview:_cancelBtn];
        [_cancelBtn setTitleColor:SubTitleColor forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"重新输入" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = ALL_ALERT_FONT;
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(horizalLable.mas_bottom);
            make.left.mas_offset(0);
            make.bottom.mas_offset(0);
            make.height.mas_offset(AdaptedHeight(45));
            make.width.mas_offset((SCREEN_WIDTH-AdaptedWidth(120))/2);
        }];
        [_cancelBtn addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.tag = 0;
 
        
        UILabel *verticalLable = [UILabel creatLineLable];
        [_bigView addSubview:verticalLable];
        [verticalLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(_cancelBtn);
            make.left.equalTo(_cancelBtn.mas_right);
            make.width.mas_offset(1);
        }];
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bigView addSubview:_selectedBtn];
        [_selectedBtn setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
        [_selectedBtn setTitle:@"选择默认" forState:UIControlStateNormal];
        _selectedBtn.titleLabel.font = ALL_ALERT_FONT;
        [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.bottom.equalTo(_cancelBtn);
            make.left.equalTo(verticalLable.mas_right);
        }];
        [_selectedBtn addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
        
        _bigView.transform = CGAffineTransformMakeScale(0, 0);
        
    }
    return self;
}
/**点击确定按钮*/
- (void)sureButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(copyQrcode)]) {
        [self dissmiss];
        [self.delegate copyQrcode];
    }
}

- (void)dissmiss {
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_bigView removeFromSuperview];
        
    }];
}
/**点击取消按钮*/
- (void)clickCancelButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(writeQrcode)]) {
        [self dissmiss];
        [self.delegate writeQrcode];
    }
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
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
