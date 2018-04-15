

#import "InvitationAlterVeiw.h"
@interface InvitationAlterVeiw ()

@end

@implementation InvitationAlterVeiw
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        //最底下的view
        self.bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 120*SCREEN_WIDTH_SCALE, 130)];
        _bigView.layer.cornerRadius = 5;
        _bigView.backgroundColor = [UIColor whiteColor];
        _bigView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        [self addSubview:_bigView];

        float buttonWidth = _bigView.frame.size.width;
    
        //最上面放图片
        _noticeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
        _noticeLable.frame = CGRectMake(0, 15, buttonWidth, 20);
        _noticeLable.text = @"您的邀请码为：";
        [_bigView  addSubview:_noticeLable];

        //邀请码中间的信息
        _titleLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentCenter font:MAIN_BODYTITLE_FONT];
        _titleLable.font = [UIFont boldSystemFontOfSize:20];
        _titleLable.frame = CGRectMake(0, CGRectGetMaxY(_noticeLable.frame)+10, buttonWidth, 20);
        [_bigView addSubview:_titleLable];

        
        //复制按钮
        
        UILabel *horizalLable = [UILabel creatLineLable];
        horizalLable.frame = CGRectMake(0, CGRectGetMaxY(_titleLable.frame)+20, _bigView.frame.size.width, 1);
        [_bigView addSubview:horizalLable];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.bounds = CGRectMake(0, 0, CGRectGetWidth(_bigView.frame)/ 2, 44);
        _cancelBtn.center = CGPointMake(CGRectGetWidth(_bigView.bounds)/4, CGRectGetHeight(_bigView.bounds) - 44 + 24);
        [_cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = MAIN_TITLE_FONT;
        [_cancelBtn setTitleColor:SubTitleColor forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [_bigView addSubview:_cancelBtn];
        
        
         //关闭按钮
        
        UILabel *verticalLable = [UILabel creatLineLable];
        verticalLable.frame = CGRectMake(CGRectGetMaxX(_cancelBtn.frame), CGRectGetMaxY(horizalLable.frame), 1,_cancelBtn.frame.size.height);
        [_bigView addSubview:verticalLable];
        
        _sureBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBut.bounds = CGRectMake(0, 0, CGRectGetWidth(_bigView.frame)/ 2, 44);
        _sureBut.center = CGPointMake(3 * CGRectGetWidth(_bigView.bounds)/4, CGRectGetHeight(_bigView.bounds) - 44 + 24);
        [_sureBut setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
        [_sureBut setTitle:@"复制" forState:UIControlStateNormal];
        _sureBut.titleLabel.font = MAIN_TITLE_FONT;
        [_sureBut addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
        [_bigView addSubview:_sureBut];
        _bigView.transform = CGAffineTransformMakeScale(0, 0);
        _noticeLable.transform = CGAffineTransformMakeScale(0,0);
    }
    return self;
}
/**点击确定按钮*/
- (void)sureButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(copyInvitationCode)]) {
        [self dissmiss];
        [self.delegate copyInvitationCode];
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
- (void)clickCancelButton {
    [self dissmiss];
}
- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
        _titleLable.transform = CGAffineTransformIdentity;
        _noticeLable.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_titleLable becomeFirstResponder];
    }];
}


@end
