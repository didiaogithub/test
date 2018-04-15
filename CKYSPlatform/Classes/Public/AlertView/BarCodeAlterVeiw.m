

#import "BarCodeAlterVeiw.h"
@interface BarCodeAlterVeiw ()

@end

@implementation BarCodeAlterVeiw
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        //最底下的view
        self.bigView = [[UIView alloc]initWithFrame:CGRectMake(5, 150*SCREEN_HEIGHT_SCALE, SCREEN_WIDTH - 10,SCREEN_HEIGHT_SCALE*450)];
        _bigView.layer.cornerRadius = 10;
        _bigView.layer.masksToBounds = YES;
        _bigView.backgroundColor = [UIColor whiteColor];
         [self addSubview:_bigView];

        float topH,pading,imageH = 0;
        if (iphone4) {
            topH = 0;
            pading = 0;
            imageH = AdaptedHeight(90);
        }else{
            topH = AdaptedHeight(30);
            pading = AdaptedHeight(15);
            imageH = AdaptedHeight(60);
        }
        
        //最上面放图片
        _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptedWidth(30),AdaptedHeight(30), _bigView.frame.size.width-AdaptedWidth(60), _bigView.frame.size.width-imageH)];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_bigView  addSubview:_titleImageView];
        [_titleImageView setImage:[UIImage imageNamed:@"waitgoods"]];
        
        
        
        //中间的信息
        _titleLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:ALL_ALERT_FONT];
        [_bigView addSubview:_titleLable];
        _titleLable.frame = CGRectMake(0, CGRectGetMaxY(_titleImageView.frame)+pading,_bigView.frame.size.width, 20);

        
        
        UILabel *horizalLable = [UILabel creatLineLable];
        [_bigView addSubview:horizalLable];
        horizalLable.frame = CGRectMake(0, CGRectGetMaxY(_titleLable.frame)+topH,_bigView.frame.size.width, 1);
        
        
        //取消
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bigView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_offset(0);
            make.width.mas_offset((SCREEN_WIDTH-10)/2);
            make.height.mas_offset(AdaptedHeight(45));
        }];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = ALL_ALERT_FONT;
        [_cancelBtn setTitleColor:SubTitleColor forState:UIControlStateNormal];
        [_bigView addSubview:_cancelBtn];
        [_cancelBtn addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *verticalLable = [UILabel creatLineLable];
        [_bigView addSubview:verticalLable];
        [verticalLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(horizalLable.mas_bottom);
            make.left.equalTo(_cancelBtn.mas_right);
            make.width.mas_offset(1);
            make.bottom.mas_offset(0);
        }];
        
       //保存到相册
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bigView addSubview:_saveButton];
        _saveButton.titleLabel.font = ALL_ALERT_FONT;
        _saveButton.frame = CGRectMake(CGRectGetMaxX(verticalLable.frame),CGRectGetMaxY(horizalLable.frame),(SCREEN_WIDTH-10-2)/2,AdaptedHeight(50));
        [_saveButton setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
        [_saveButton setTitle:@"保存到相册" forState:UIControlStateNormal];
        [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cancelBtn.mas_top);
            make.left.equalTo(verticalLable.mas_right);
            make.right.mas_offset(0);
            make.bottom.mas_offset(0);
        }];
        [_saveButton addTarget:self action:@selector(clickSaveButton) forControlEvents:UIControlEventTouchUpInside];
        
        _bigView.transform = CGAffineTransformMakeScale(0, 0);
        _titleImageView.transform = CGAffineTransformMakeScale(0,0);
        
    }
    return self;
}

/**点击确定按钮*/
- (void)clickSaveButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveToPhotobuttonClicked)]) {
        [self.delegate saveToPhotobuttonClicked];
    }
}

- (void)dissmiss {
    [UIView animateWithDuration:.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_bigView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
/**点击取消按钮*/
- (void)clickCancelButton {
    [self dissmiss];
}
- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
        _titleLable.transform = CGAffineTransformIdentity;
        _titleImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_titleLable becomeFirstResponder];
    }];
}


@end
