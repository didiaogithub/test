//
//  XWAlterVeiw.m
//  XWAleratView


#import "SEXAlterVeiw.h"

@interface SEXAlterVeiw ()

@end

@implementation SEXAlterVeiw
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        //最底下的view
        self.bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 120, 150)];
        _bigView.layer.cornerRadius = 5;
        _bigView.backgroundColor = [UIColor whiteColor];
        _bigView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        [self addSubview:_bigView];
       
        float buttonHeight = _bigView.frame.size.height/3;
        float buttonWidth = _bigView.frame.size.width;
        
        //选择男 按钮放
        _boyButton = [self createButtonWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight) andFont:15 andtitle:@"男" andAction:@selector(clickSexButton:) andSelected:NO];
        _boyButton.tag = 10000;
        [_bigView addSubview:_boyButton];
        
        UILabel *horizalLable = [UILabel creatLineLable];
        horizalLable.frame = CGRectMake(0, CGRectGetMaxY(_boyButton.frame), _bigView.frame.size.width, 1);
        [_bigView addSubview:horizalLable];

        
        //选择女 的按钮
        _girlButton = [self createButtonWithFrame:CGRectMake(0,CGRectGetMaxY(horizalLable.frame),buttonWidth ,buttonHeight ) andFont:15 andtitle:@"女" andAction:@selector(clickSexButton:) andSelected:NO];
        _girlButton.tag = 10001;
        [_bigView addSubview:_girlButton];
        
        UILabel *horizalLableGirl = [UILabel creatLineLable];
        horizalLableGirl.frame = CGRectMake(0, CGRectGetMaxY(_girlButton.frame), _bigView.frame.size.width, 1);
        [_bigView addSubview:horizalLableGirl];
        
        //选择保密 的按钮
        _secreteButton = [self createButtonWithFrame:CGRectMake(0,CGRectGetMaxY(horizalLableGirl.frame),buttonWidth, buttonHeight) andFont:15 andtitle:@"保密" andAction:@selector(clickSexButton:) andSelected:YES];
        _secreteButton.tag = 10002;
        [_bigView addSubview:_secreteButton];
       
        _bigView.transform = CGAffineTransformMakeScale(0, 0);
    }
    return self;
}
/**点击确定按钮*/
- (void)clickSexButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedSexClickedWithTag:)]) {
        [self dissmiss];
        [self.delegate selectedSexClickedWithTag:button];
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


- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
        _girlButton.transform = CGAffineTransformIdentity;
        _boyButton.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_boyButton becomeFirstResponder];
    }];
}

-(UIButton *)createButtonWithFrame:(CGRect)frame andFont:(float)fonts andtitle:(NSString *)title andAction:(SEL)action andSelected:(BOOL)selected{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font = [UIFont systemFontOfSize:fonts];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:SubTitleColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateSelected];
    button.selected = selected;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


@end
