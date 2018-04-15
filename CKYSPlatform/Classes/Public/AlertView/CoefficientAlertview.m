

#import "CoefficientAlertview.h"
@interface CoefficientAlertview ()

@end

@implementation CoefficientAlertview
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        //最底下的view
        self.bankGroundView = [[UIView alloc]init];
        [self addSubview:_bankGroundView];
        _bankGroundView.layer.cornerRadius = 5;
        _bankGroundView.backgroundColor = [UIColor whiteColor];
        
        [_bankGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(AdaptedWidth(40));
            make.right.mas_offset(-AdaptedWidth(40));
            make.center.mas_equalTo(self);
        }];
        

        //最上面标题名称
        _titleLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:ALL_ALERT_FONT];
        _titleLable.text = @"《产品销售奖励系数说明》";
        [_bankGroundView  addSubview:_titleLable];
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedHeight(30));
            make.left.mas_offset(AdaptedWidth(20));
            make.right.mas_offset(-AdaptedWidth(20));
        }];
        //中间系数内容
        _contentLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_NAMETITLE_FONT];
        [_bankGroundView addSubview:_contentLable];
//        1. 店铺业绩小于或等于5000，产品销售系数为：0
//        2. 店铺业绩大于5000，且小于或等于10000，产品销售系数为：5%
//        3. 店铺业绩大于10000，且小于或等于30000，产品销售系数为：7.5%
//        4. 店铺业绩大于30000，产品销售系数为：10%
        _contentLable.text = @"产品销售奖励系数由店铺业绩决定:\n1. 店铺业绩小于或等于5000，产品销售奖励系数为：0\n2. 店铺业绩大于5000，且小于或等于10000，产品销售奖励系数为：5%\n3. 店铺业绩大于10000，且小于或等于30000，产品销售奖励系数为：7.5%\n4. 店铺业绩大于30000，产品销售奖励系数为：10%\n";
        _contentLable.numberOfLines = 0;
        [_contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLable.mas_bottom).offset(AdaptedHeight(30));
            make.left.mas_offset(AdaptedWidth(30));
            make.right.mas_offset(-AdaptedWidth(30));
        }];

        //mark 富文本
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_contentLable.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];//调整行间距
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_contentLable.text length])];
        _contentLable.attributedText = attributedString;
        
        //公司解释权
        _lastLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:ALL_ALERT_FONT];
        [_bankGroundView addSubview:_lastLable];
        _lastLable.text = @"最终解释权归创客村所有";
        [_lastLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(0);
            make.top.equalTo(_contentLable.mas_bottom).offset(AdaptedHeight(30));
            make.right.mas_offset(0);
            make.bottom.mas_offset(-AdaptedHeight(15));
        }];
        
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.deleteButton];
        [self.deleteButton setImage:[UIImage imageNamed:@"takecashcolose"] forState:UIControlStateNormal];

        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bankGroundView.mas_bottom).offset(AdaptedHeight(20));
            make.left.mas_offset(SCREEN_WIDTH/2-AdaptedWidth(30));
            make.size.mas_offset(CGSizeMake(AdaptedWidth(60), AdaptedWidth(60)));
        }];
        [self.deleteButton addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
        
        _bankGroundView.transform = CGAffineTransformMakeScale(0, 0);
        _titleLable.transform = CGAffineTransformMakeScale(0,0);

    }
    return self;
}
/**关闭弹框*/
- (void)dissmiss {
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_bankGroundView removeFromSuperview];
        
    }];
}
- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bankGroundView.transform = CGAffineTransformIdentity;
        _titleLable.transform = CGAffineTransformIdentity;
        _contentLable.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_titleLable becomeFirstResponder];
    }];
}


@end
