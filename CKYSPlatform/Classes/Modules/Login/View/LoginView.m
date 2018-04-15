//
//  LoginView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/19.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "LoginView.h"
@interface LoginView ()
{
    UIView  *_logobankgroundView;

    UIImageView *_telphoneImageView;
    UIImageView *_passwordImageView;
    UIImageView * _loginImageView;
    UIButton *_loginButton;
}
@property (nonatomic, strong)STCountDownButton *countDownCode;
@end
@implementation LoginView
-(instancetype)initWithFrame:(CGRect)frame andTypeStr:(NSString *)typestr{
    if (self = [super initWithFrame:frame]) {
        [self createLoginViewWith:typestr];
    }
    return self;
}
-(void)createLoginViewWith:(NSString *)typestr{
    
    //1 密码登录  2 验证码登录
    _logobankgroundView = [[UIView alloc] init];
    [self addSubview:_logobankgroundView];
    [_logobankgroundView setBackgroundColor:[UIColor tt_bigRedBgColor]];
    [_logobankgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(200));
    }];
    

    _returnImageView = [[UIImageView alloc] init];
    [self addSubview:_returnImageView];
    [_returnImageView setImage:[UIImage imageNamed:@"backwhite"]];
    [_returnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(35));
        make.left.mas_offset(AdaptedWidth(15));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(10), AdaptedHeight(20)));

    }];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:returnButton];
    returnButton.tag = 288;
    [returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(80, 50));
    }];
    [returnButton addTarget:self action:@selector(clickReturnButton:) forControlEvents:UIControlEventTouchUpInside];


    UIImageView *logoImageView = [[UIImageView alloc] init];
    [self addSubview:logoImageView];
    UIImage *imageLogo = [UIImage imageNamed:@"logo"];
    [logoImageView setImage:imageLogo];
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(60));
        make.left.mas_offset(SCREEN_WIDTH/2-AdaptedWidth(50));
        make.width.mas_offset(AdaptedWidth(100));
        make.height.mas_offset(AdaptedHeight(95));
    }];
    
    //下背景view
    UIView *bottomBankView = [[UIView alloc] init];
    [self addSubview:bottomBankView];
    [bottomBankView setBackgroundColor:[UIColor whiteColor]];
    [bottomBankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logobankgroundView.mas_bottom);
        make.left.right.bottom.mas_offset(0);
    }];
    
    //云的图片
    UIImageView *cloundImageView = [[UIImageView alloc] init];
    [bottomBankView addSubview:cloundImageView];
    [cloundImageView setImage:[UIImage imageNamed:@"loginclound"]];
    [cloundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(61));
    }];
    //让创业像呼吸一样轻松
    UIImageView *sloganIMageView = [[UIImageView alloc] init];
    [bottomBankView addSubview:sloganIMageView];
    [sloganIMageView setImage:[UIImage imageNamed:@"slogan"]];
    sloganIMageView.contentMode = UIViewContentModeScaleAspectFit;
    [sloganIMageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cloundImageView.mas_bottom).offset(AdaptedHeight(40));
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(20));
    }];

    float leftW = 0;
    if (iphone4){
        leftW = 50;
    }else{
        leftW = 34;
    }
    
    //底部imageview
    UIImageView *passImageView = [[UIImageView alloc] init];
    [bottomBankView addSubview:passImageView];
    passImageView.userInteractionEnabled = YES;
    [passImageView setImage:[UIImage imageNamed:@"loginborder"]];
    passImageView.contentMode = UIViewContentModeScaleAspectFit;
    [passImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sloganIMageView.mas_bottom).offset(AdaptedHeight(30));
        make.left.mas_offset(AdaptedWidth(50));
        make.right.mas_offset(-AdaptedWidth(50));
        make.height.mas_offset(AdaptedHeight(40));
    }];
    
    //创建
    _telphoneImageView = [[UIImageView alloc] init];
    UIImage *telImage = [UIImage imageNamed:@"手机"];
    [_telphoneImageView setImage:[telImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _telphoneImageView.frame = CGRectMake(10, 0, leftW, 21);
    _telphoneImageView.contentMode= UIViewContentModeCenter;
    
    _telphoneTextField = [[UITextField alloc] init];
    [passImageView addSubview:_telphoneTextField];
    _telphoneTextField.delegate = self;
    [_telphoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(passImageView);
    }];
    _telphoneTextField.placeholder = CheckMsgPhoneHolder;
    _telphoneTextField.leftView = _telphoneImageView;
    _telphoneTextField.leftViewMode = UITextFieldViewModeAlways;
    _telphoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    //输入密码框
    UIImageView *codeBankImageView = [[UIImageView alloc] init];
    [bottomBankView addSubview:codeBankImageView];
    codeBankImageView.userInteractionEnabled = YES;
    [codeBankImageView setImage:[UIImage imageNamed:@"loginborder"]];
    codeBankImageView.contentMode = UIViewContentModeScaleAspectFit;
    [codeBankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passImageView.mas_bottom).offset(AdaptedHeight(8));
        make.left.mas_offset(AdaptedWidth(50));
        make.right.mas_offset(-AdaptedWidth(50));
        make.height.mas_offset(AdaptedHeight(40));
    }];
    
    NSString *tipStr = @"*非大陆手机用户请在手机号码前输入国际电话区号。例如香港手机用户:0852手机号码";
    CGFloat h = [tipStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil].size.height + 1;
    
    if([typestr isEqualToString:@"1"]){//密码登录界面
        //密码 或者验证码 图标
        _passwordImageView = [[UIImageView alloc] init];
        UIImage *codeImage = [UIImage imageNamed:@"lock"];
        [_passwordImageView setImage:codeImage];
        _passwordImageView.frame = CGRectMake(10, 0, leftW, 21);
        _passwordImageView.contentMode= UIViewContentModeCenter;
        //密码textfiled
        _passwordTextField = [[UITextField alloc] init];
        [codeBankImageView addSubview:_passwordTextField];
        _passwordTextField.placeholder = @"请输入密码";
        [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(codeBankImageView);
            
        }];
        _passwordTextField.delegate = self;
        _passwordTextField.leftView = _passwordImageView;
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    }else if ([typestr isEqualToString:@"2"]){ //验证码登录界面
    
        //密码 或者验证码 图标
        _passwordImageView = [[UIImageView alloc] init];
        UIImage *codeImage = [UIImage imageNamed:@"verificationcode"];
        [_passwordImageView setImage:codeImage];
        _passwordImageView.frame = CGRectMake(10, 0, leftW, 21);
        _passwordImageView.contentMode= UIViewContentModeCenter;
        //密码textfiled
        _passwordTextField = [[UITextField alloc] init];
        [codeBankImageView addSubview:_passwordTextField];
        _passwordTextField.placeholder = @"请输入验证码";

        [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(codeBankImageView);
            make.width.mas_offset(SCREEN_WIDTH-AdaptedWidth(200));
            
        }];
        _passwordTextField.leftView = _passwordImageView;
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UILabel *rightLabale = [UILabel creatLineLable];
        [codeBankImageView addSubview:rightLabale];
        [rightLabale mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedHeight(10));
            make.bottom.mas_offset(-AdaptedHeight(10));
            make.width.mas_offset(1.5);
            make.left.equalTo(_passwordTextField.mas_right);
        }];
        
        //发送验证码
        _countDownCode = [[STCountDownButton alloc]init];
        [self addSubview:_countDownCode];
        [_countDownCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(codeBankImageView);
            make.left.equalTo(rightLabale.mas_right);
        }];
        //设置背景颜色
        _countDownCode.backgroundColor = [UIColor clearColor];
        //设置倒计时时长
        [_countDownCode setSecond:60];
          //设置字体大小
        if(iphone4){
           _countDownCode.titleLabel.font = CHINESE_SYSTEM(AdaptedWidth(10));
        }else{
          _countDownCode.titleLabel.font = MAIN_TITLE_FONT;
        }
      
        //设置字体颜色
        [_countDownCode setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
        [_countDownCode addTarget:self
                           action:@selector(startCountDown:)
                 forControlEvents:UIControlEventTouchUpInside];
        

        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 159, SCREEN_WIDTH - 20, h)];
        tipLabel.text = tipStr;
        tipLabel.numberOfLines = 0;
        tipLabel.textColor = [UIColor tt_monthGrayColor];
        if (iphone5) {
            tipLabel.font = [UIFont systemFontOfSize:11.0];
        }else{
            tipLabel.font = [UIFont systemFontOfSize:12.0];
        }
        [self addSubview:tipLabel];

        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(codeBankImageView);
            make.top.equalTo(codeBankImageView.mas_bottom).offset(5);
            make.height.mas_equalTo(h);
        }];
    }
    
    float loginW = 0;
    if(iphone4){
        loginW = AdaptedWidth(50);
    }else{
        loginW = AdaptedWidth(20);
    }
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBankView addSubview:loginButton];
    loginButton.adjustsImageWhenHighlighted = NO;
    [loginButton setImage:[UIImage imageNamed:@"loginbutton"] forState:UIControlStateNormal];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([typestr isEqualToString:@"1"]){
            make.top.equalTo(codeBankImageView.mas_bottom).offset(AdaptedHeight(40));
        }else{
            make.top.equalTo(codeBankImageView.mas_bottom).offset(AdaptedHeight(40+h));
        }
        make.left.mas_offset(loginW);
        make.right.mas_offset(-loginW);
        make.height.mas_offset(45);
    }];
    [loginButton addTarget:self action:@selector(clickLogInButton) forControlEvents:UIControlEventTouchUpInside];

    //验证码登录按钮
    _verificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBankView addSubview:_verificationCodeButton];
    _verificationCodeButton.tag = 289;
    
    _verificationCodeButton.titleLabel.font = MAIN_TITLE_FONT;
    _verificationCodeButton.adjustsImageWhenHighlighted = NO;
    if([typestr isEqualToString:@"1"]){ //密码登录界面
     [_verificationCodeButton setTitle:@"验证码登录" forState:UIControlStateNormal];
    }else if ([typestr isEqualToString:@"2"]){
     [_verificationCodeButton setTitle:@"密码登录" forState:UIControlStateNormal];
    }
   
    [_verificationCodeButton setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
    [_verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).offset(AdaptedHeight(20));
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(50));
    }];
    [_verificationCodeButton addTarget:self action:@selector(clickReturnButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark-限制手机号输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.telphoneTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.telphoneTextField.text.length >= 20){
            self.telphoneTextField.text = [textField.text substringToIndex:20];
            return NO;
        }
    }
    return YES;
}


/**点击获取验证码*/
-(void)startCountDown:(STCountDownButton *)button{
    //点击获取验证码 后开始倒计时
    if (self.delegate && [self.delegate respondsToSelector:@selector(getVertifyCodeWithButton:)]) {
        [self.delegate getVertifyCodeWithButton:button];
    }
}

/**点击登录按钮*/
-(void)clickLogInButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginWithtelphone:andPassWord:)]) {
        [self.delegate loginWithtelphone:_telphoneTextField.text andPassWord:_passwordTextField.text];
    }

}

//点击返回按钮 切换登录方式
-(void)clickReturnButton:(UIButton *)button{
    NSInteger tag = button.tag - 288;
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToViewControllerWithTag:)]) {
        [self.delegate jumpToViewControllerWithTag:tag];
    }
}

@end
