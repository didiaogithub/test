//
//  XWAlterVeiw.m
//  XWAleratView

#import "XWAlterVeiw.h"
@interface XWAlterVeiw ()

@end

@implementation XWAlterVeiw

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
            make.top.mas_offset(SCREEN_HEIGHT/2-AdaptedHeight(65));
            make.left.mas_offset(AdaptedWidth(50));
            make.width.mas_offset(SCREEN_WIDTH - AdaptedWidth(100));
            make.height.mas_offset(AdaptedHeight(130));
        }];
    
        //中间的信息
        _titleLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:14.0f]];
        [_bigView addSubview:_titleLable];
        _titleLable.numberOfLines = 0;
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedHeight(20));
            make.left.mas_offset(AdaptedWidth(15));
            make.right.mas_offset(-AdaptedWidth(15));
        }];

        
        UILabel *horizalLable = [UILabel creatLineLable];
        [_bigView addSubview:horizalLable];
        [horizalLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLable.mas_bottom);
            make.left.right.mas_offset(0);
            make.height.mas_offset(1);
        }];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bigView addSubview:_cancelBtn];
        [_cancelBtn setTitleColor:SubTitleColor forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = MAIN_TITLE_FONT;
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(horizalLable.mas_bottom);
            make.left.mas_offset(0);
            make.bottom.mas_offset(0);
            make.height.mas_offset(AdaptedHeight(45));
            make.width.mas_offset((SCREEN_WIDTH-AdaptedWidth(100))/2);
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
        _sureBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bigView addSubview:_sureBut];
        [_sureBut setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
        [_sureBut setTitle:@"确定" forState:UIControlStateNormal];
        _sureBut.titleLabel.font = MAIN_TITLE_FONT;
        [_sureBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.bottom.equalTo(_cancelBtn);
            make.left.equalTo(verticalLable.mas_right);
        }];
        [_sureBut addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
        
        _bigView.transform = CGAffineTransformMakeScale(0, 0);
        
    }
    return self;
}
/**点击确定按钮*/
- (void)sureButton {
     [self dissmiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(subuttonClicked)]) {
        [self.delegate subuttonClicked];
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
