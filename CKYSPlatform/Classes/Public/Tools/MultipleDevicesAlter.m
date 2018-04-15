//
//  XWAlterVeiw.m
//  XWAleratView

#import "MultipleDevicesAlter.h"
#import "CodeLoginViewController.h"
#import "RootBaseViewController.h"

@interface MultipleDevicesAlter ()
@property(nonatomic,strong)UIViewController *parentVC;
@end

@implementation MultipleDevicesAlter
// 此处实现单利初始化构造方法 此方法会保证MessageAlert 这个类只会被初始化 一次
+ (instancetype)shareInstance
{
    static MultipleDevicesAlter *alert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      
        alert = [[MultipleDevicesAlter alloc] init];
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
    _titleLable.text = CKYSmsg9001;
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
- (void)showAlert:(NSString *)title
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
    [self logout];  //退出登录
}
- (void)dissmiss {
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}
/**点击退出按钮*/
-(void)logout{
    NSString *ckidstr = KCKidstring;
    if(IsNilOrNull(ckidstr)){
       ckidstr = @"";
    }
    NSString *statusStr = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KStatus]];
    NSString *type = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Ktype]];
    NSString *joinType = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KjoinType]];
    NSString *realname = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Krealname]];
    NSString *headurl = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:kheamImageurl]];
    NSString *sales = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    NSString *exitRegister = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KexitRegister]];
    NSString *statusString = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KStatus]];
    if (!IsNilOrNull(statusString)){
        [KUserdefaults removeObjectForKey:KStatus];
    }
    if (!IsNilOrNull(ckidstr)){
        [KUserdefaults removeObjectForKey:Kckid];
    }
    if (!IsNilOrNull(statusStr)){
        [KUserdefaults removeObjectForKey:KStatus];
    }
    if (!IsNilOrNull(type)){
        [KUserdefaults removeObjectForKey:Ktype];
    }
    if (!IsNilOrNull(joinType)){
        [KUserdefaults removeObjectForKey:KjoinType];
    }
    if (!IsNilOrNull(realname)){
        [KUserdefaults removeObjectForKey:Krealname];
    }
    if (!IsNilOrNull(headurl)){
        [KUserdefaults removeObjectForKey:kheamImageurl];
    }
    if (!IsNilOrNull(sales)){
        [KUserdefaults removeObjectForKey:KSales];
    }
    if (!IsNilOrNull(exitRegister)) {
        [KUserdefaults removeObjectForKey:KexitRegister];
    }
    
    [KUserdefaults synchronize];
    //断开与融云服务器的连接，并不再接收远程推送
    [[RCloudManager manager] logout];
    
    // iOS 8 以上可用此方法 关闭APNS推送
    [JPUSHService setTags:0 alias:@"0" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"\n[JPush设置别名]---[%@]",iAlias);
    }];
    
    
    self.parentVC = [self currentVc];
    CodeLoginViewController *login = [[CodeLoginViewController alloc] init];
    login.typeString = @"noback";
    
    //只有异地登录就全部返回到根目录
    [[UIViewController currentVC].navigationController popToRootViewControllerAnimated:YES];
    
    [self.parentVC  presentViewController:login animated:YES completion:^{

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
