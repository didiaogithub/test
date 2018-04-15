
#import "MessageAlert.h"
#import "CodeLoginViewController.h"
@interface MessageAlert ()
{
    BOOL isShow; // 此处设置一个标识位
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIButton *sigleSureBtn;
@property (nonatomic, strong) UILabel  *horizalLine;


@end

@implementation MessageAlert

//应用内收到的消息弹窗不用单例，要一层盖一层。其他的弹窗用单例
-(instancetype)init {
    if (self = [super init]) {
        [self creatPushMsgUI];
    }
    return self;
}

-(void)creatPushMsgUI {
    self.frame = [UIScreen mainScreen].bounds;
    //最外层view
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.bigView = [[UIView alloc]init];
    [self addSubview:self.bigView];
    [self.bigView setBackgroundColor:[UIColor whiteColor]];
    
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.bigView addSubview:self.scrollView];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    UILabel *horizalLable = [UILabel creatLineLable];
    [_bigView addSubview:horizalLable];
    
    _rightSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightSureBtn.hidden = YES;
    [_bigView addSubview:_rightSureBtn];
    // 设置控件属性
    [_rightSureBtn setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
    [_rightSureBtn addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
    [_rightSureBtn setTitle:@"查看" forState:UIControlStateNormal];
    _rightSureBtn.titleLabel.font = ALL_ALERT_FONT;
    
    
    _leftCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftCancelBtn.hidden = YES;
    [_bigView addSubview:_leftCancelBtn];
    // 设置控件属性
    [_leftCancelBtn setTitleColor:SubTitleColor forState:UIControlStateNormal];
    [_leftCancelBtn addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
    [_leftCancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    _leftCancelBtn.titleLabel.font = ALL_ALERT_FONT;
    
    _horizalLine = [UILabel creatLineLable];
    [_bigView addSubview:_horizalLine];
    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(AdaptedWidth(50));
        make.right.mas_offset(-AdaptedWidth(50));
        make.center.mas_equalTo(self);
    }];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_offset(150);
    }];
    
    [horizalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_bottom);
        make.left.mas_offset(0);
        make.width.equalTo(_bigView.mas_width);
        make.height.mas_offset(1);
    }];
    
    [_rightSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizalLable.mas_bottom);
        make.left.equalTo(self.mas_centerX);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
        make.height.mas_offset(45);
    }];
    
    
    
    [_leftCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizalLable.mas_bottom);
        make.left.mas_offset(0);
        make.right.equalTo(self.mas_centerX);
        make.bottom.mas_offset(0);
        make.height.mas_offset(45);
    }];
    
    [_horizalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_leftCancelBtn);
        make.left.equalTo(_leftCancelBtn.mas_right);
        make.width.mas_offset(1);
    }];
    
    //收到消息时 只显示确定按钮
    _sigleSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bigView addSubview:_sigleSureBtn];
    // 设置控件属性
    [_sigleSureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_sigleSureBtn addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
    [_sigleSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    _sigleSureBtn.titleLabel.font = ALL_ALERT_FONT;
    [_sigleSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
        make.height.mas_offset(45);
    }];
    
    // 设置scrollView承载的内容
    _titleLabel = [[MLEmojiLabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = ALL_ALERT_FONT;
    _titleLabel.emojiDelegate = self;
    _titleLabel.textColor = TitleColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping; //保留整个字符
    _titleLabel.isNeedAtAndPoundSign = YES;  //是否需要话题和@功能，默认为不需要
    
    
    [self.scrollView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.bottom.mas_offset(-AdaptedHeight(20));
        make.left.right.mas_offset(0);
        make.width.equalTo(self.scrollView);
    }];
    
    
    _bigView.transform = CGAffineTransformMakeScale(0, 0);
    self.bigView.layer.cornerRadius = 5;
    self.bigView.backgroundColor = [UIColor whiteColor];
    
}

// 此处实现单利初始化构造方法 此方法会保证MessageAlert 这个类只会被初始化 一次
+ (instancetype)shareInstance
{
    static MessageAlert *alert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alert = [[MessageAlert alloc] init];
        [alert creatUI];
    });
    return alert;
}

- (void)creatUI
{
    self.frame = [UIScreen mainScreen].bounds;
    //最外层view
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.bigView = [[UIView alloc]init];
    [self addSubview:self.bigView];
    [self.bigView setBackgroundColor:[UIColor whiteColor]];
    
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.bigView addSubview:self.scrollView];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    UILabel *horizalLable = [UILabel creatLineLable];
    [_bigView addSubview:horizalLable];
    
    _rightSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightSureBtn.hidden = YES;
    [_bigView addSubview:_rightSureBtn];
    // 设置控件属性
    [_rightSureBtn setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
    [_rightSureBtn addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
    [_rightSureBtn setTitle:@"查看" forState:UIControlStateNormal];
    _rightSureBtn.titleLabel.font = ALL_ALERT_FONT;
    
    
    _leftCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftCancelBtn.hidden = YES;
    [_bigView addSubview:_leftCancelBtn];
    // 设置控件属性
    [_leftCancelBtn setTitleColor:SubTitleColor forState:UIControlStateNormal];
    [_leftCancelBtn addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
    [_leftCancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    _leftCancelBtn.titleLabel.font = ALL_ALERT_FONT;
    
    _horizalLine = [UILabel creatLineLable];
    [_bigView addSubview:_horizalLine];
    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(AdaptedWidth(50));
        make.right.mas_offset(-AdaptedWidth(50));
        make.center.mas_equalTo(self);
    }];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_offset(150);
    }];
    
    [horizalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_bottom);
        make.left.mas_offset(0);
        make.width.equalTo(_bigView.mas_width);
        make.height.mas_offset(1);
    }];
    
    [_rightSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizalLable.mas_bottom);
        make.left.equalTo(self.mas_centerX);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
        make.height.mas_offset(45);
    }];
    
    
    
    [_leftCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizalLable.mas_bottom);
        make.left.mas_offset(0);
        make.right.equalTo(self.mas_centerX);
        make.bottom.mas_offset(0);
        make.height.mas_offset(45);
    }];
    
    [_horizalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_leftCancelBtn);
        make.left.equalTo(_leftCancelBtn.mas_right);
        make.width.mas_offset(1);
    }];
    
    //收到消息时 只显示确定按钮
    _sigleSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bigView addSubview:_sigleSureBtn];
    // 设置控件属性
    [_sigleSureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_sigleSureBtn addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
    [_sigleSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    _sigleSureBtn.titleLabel.font = ALL_ALERT_FONT;
    [_sigleSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
        make.height.mas_offset(45);
    }];
    
    // 设置scrollView承载的内容
    _titleLabel = [[MLEmojiLabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = ALL_ALERT_FONT;
    _titleLabel.emojiDelegate = self;
    _titleLabel.textColor = TitleColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping; //保留整个字符
    _titleLabel.isNeedAtAndPoundSign = YES;  //是否需要话题和@功能，默认为不需要
    
    
    [self.scrollView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.bottom.mas_offset(-AdaptedHeight(20));
        make.left.right.mas_offset(0);
        make.width.equalTo(self.scrollView);
    }];
    
    
    _bigView.transform = CGAffineTransformMakeScale(0, 0);
    self.bigView.layer.cornerRadius = 5;
    self.bigView.backgroundColor = [UIColor whiteColor];
    
}

- (void)showCommonAlert:(NSString *)title btnClick:(void(^)(void))block{
    [_leftCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_rightSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.sureBlock = block;
    //添加到窗口上
    [self setAlertText:title];
}

#pragma mark - 专门处理极光推送消息弹框
- (void)showAlert:(NSString *)title btnClick:(void(^)(void))block
{
    [_leftCancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [_rightSureBtn setTitle:@"查看" forState:UIControlStateNormal];
    self.sureBlock = block;
    //添加到窗口上
    [self setAlertText:title];
}
#pragma mark-专门处请求错误消息弹框
- (void)showRequestErrorCode:(NSString *)code errorContent:(NSString *)title{
    
    //添加到窗口上
    [self setAlertText:title];
    [CKCNotificationCenter postNotificationName:@"hudstop" object:nil];
    
}


#pragma mark - 处请求后台推送消息提示样式
- (void)showMsgAlert:(NSString *)title btnClick:(void(^)(void))block {
    [_sigleSureBtn setTitle:@"知道了" forState:UIControlStateNormal];
    self.sureBlock = block;
    //添加到窗口上
    [self setAlertText:title];
}

#pragma mark-将收到的内容展示 并且把框添加到当前window上
-(void)setAlertText:(NSString *)content{
    //赋值
    [_titleLabel setEmojiText:content];
    [self.bigView layoutIfNeeded];
    // 计算scrollView可承载的最大高度
    CGFloat totalH = 4*SCREEN_HEIGHT/5;
    if (self.titleLabel.frame.size.height <= totalH) {
        totalH = self.titleLabel.frame.size.height+40;
    } else {
        totalH = totalH;
    }
    // 更新scrollView布局
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(totalH);
    }];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        self.alpha = 1;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
        _titleLabel.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

/**点击确定按钮*/
- (void)sureButton{
    NSLog(@"点击了确定");
    [self dissmiss];
    if (self.isDealInBlock) {
        self.sureBlock();
    }else{
        [self dealRequestErrorCode:self.errorCode];
    }
    
}
-(void)dealRequestErrorCode:(NSString *)code{
    self.isDealInBlock = YES;
    if ([code isEqualToString:MutipDeviceLoginCode]){
        [self hiddenCancelBtn:YES];
        //情况一处理被迫下线
        //1.清空缓存
        [KUserdefaults setObject:@"" forKey:KStatus];
        [KUserdefaults setObject:@"" forKey:Kckid];
        [KUserdefaults setObject:@"" forKey:Ktype];
        [KUserdefaults setObject:@"" forKey:KjoinType];
        [KUserdefaults setObject:@"" forKey:Krealname];
        [KUserdefaults setObject:@"" forKey:kheamImageurl];
        [KUserdefaults setObject:@"" forKey:KSales];
        [KUserdefaults synchronize];
        //2.断开与融云服务器的连接，并不再接收远程推送
        [[RCloudManager manager] logout];
        
        //3.iOS 8 以上可用此方法 关闭APNS推送
        [JPUSHService setTags:0 alias:@"0" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"\n[JPush设置别名]---[%@]",iAlias);
        }];
        
        //4.只能去验证码登录
        CodeLoginViewController *login = [[CodeLoginViewController alloc] init];
        login.typeString = @"noback";
        [[UIViewController currentVC].navigationController presentViewController:login animated:YES completion:^{
            
        }];
        
        return;
    }
    
    //如果是8001 店铺被关闭 无论在哪个界面都返回到一级界面
    if ([code isEqualToString:ShopCloseCode]){
        //情况二处理店铺被关闭 回到一级界面
        [self hiddenCancelBtn:YES];
        [[UIViewController currentVC].navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    
}
-(void)cancelButton {
    NSLog(@"点击了取消");
    [self dissmiss];
}

- (void)dissmiss{
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

#pragma makr-是否隐藏取消按钮
-(void)hiddenCancelBtn:(BOOL)hidden {
    if (hidden == YES) {
        _leftCancelBtn.hidden = YES;
        _rightSureBtn.hidden = YES;
        _sigleSureBtn.hidden = NO;
        _horizalLine.hidden = YES;
    }else{
        _leftCancelBtn.hidden = NO;
        _rightSureBtn.hidden = NO;
        _sigleSureBtn.hidden = YES;
        _horizalLine.hidden = NO;
    }
    [self layoutSubviews];
}
#pragma mark-EmojiLable 代理方法
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
        }
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
        {
            NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",link];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
        }
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
    
}


@end

