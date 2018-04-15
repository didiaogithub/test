//
//  XWAlterVeiw.m
//  XWAleratView

#import "CloseShopAlter.h"
#import "CodeLoginViewController.h"

@interface CloseShopAlter ()
@property(nonatomic,strong)UIViewController *parentVC;
@end

@implementation CloseShopAlter
// 此处实现单利初始化构造方法 此方法会保证MessageAlert 这个类只会被初始化 一次
+ (instancetype)shareInstance
{
    static CloseShopAlter *alert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      
        alert = [[CloseShopAlter alloc] init];
        [alert cretaeUI];
    });
    return alert;
}
-(void)cretaeUI{
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    //最底下的view
    
    self.bigView = [[UIView alloc]init];
    [self addSubview:self.bigView];
    
    //中间的线
    UILabel *horizalLable = [UILabel creatLineLable];
    [_bigView addSubview:horizalLable];
    
    //确定按钮
    _sureBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bigView addSubview:_sureBut];
    // 设置控件属性
    [_sureBut setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
    [_sureBut setTitle:@"确定" forState:UIControlStateNormal];
    _sureBut.titleLabel.font = ALL_ALERT_FONT;
    
    // 设置scrollView承载的内容
    _titleLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:ALL_ALERT_FONT];
    [_bigView addSubview:_titleLable];
    _titleLable.text = @"店铺已关闭";
    _titleLable.numberOfLines = 0;

    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(50*SCREEN_WIDTH_SCALE);
        make.right.mas_offset(-50*SCREEN_WIDTH_SCALE);
        make.center.mas_equalTo(self);
        make.height.mas_offset(AdaptedHeight(120));
    }];
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(20));
        make.left.mas_offset(AdaptedWidth(10));
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    [horizalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLable.mas_bottom).offset(10);
        make.left.mas_offset(0);
        make.width.equalTo(_bigView.mas_width);
        make.height.mas_offset(1);
    }];
    
    [_sureBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizalLable.mas_bottom);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(45));
    }];
    [_sureBut addTarget:self action:@selector(clickSurebutton) forControlEvents:UIControlEventTouchUpInside];
    
    _bigView.transform = CGAffineTransformMakeScale(0, 0);
    
    self.bigView.layer.cornerRadius = 5;
    self.bigView.backgroundColor = [UIColor whiteColor];

}
- (void)showCloseShopAlert:(NSString *)title
{
    _titleLable.text = title;
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        self.alpha = 1;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
        _titleLable.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    //被迫下线后收不到推送消息
    [JPUSHService setTags:0 alias:@"0" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"\n[JPush设置别名]---[%@]",iAlias);
    }];
    
}


/**点击确定按钮*/
- (void)clickSurebutton{
    [self dissmiss];
    self.parentVC = [self currentVc];
    [self.parentVC.navigationController popToRootViewControllerAnimated:YES];
}
- (void)dissmiss {
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}
- (UIViewController *)currentVc
{
    UIViewController * currVC = nil;
    UIViewController * Rootvc = self.window.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[RootTabBarController class]]){
            RootTabBarController * tabVC = (RootTabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        } else {
            currVC = Rootvc;
            Rootvc = nil;
        }
    } while (Rootvc!=nil);
    
    return currVC;
}


@end
