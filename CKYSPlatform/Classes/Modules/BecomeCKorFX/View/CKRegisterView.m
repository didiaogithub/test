//
//  CKRegisterView.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKRegisterView.h"

@interface CKRegisterView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *telphoneImageView;//手机图标
@property (nonatomic, strong) UILabel *telLineLable; //手机下面的线
@property (nonatomic, strong) UIImageView *verifyCodeImageView; //验证码图标
@property (nonatomic, strong) UILabel *codeLineLable; //验证码下面的线
@property (nonatomic, strong) UIImageView *invitationImageView;//邀请码图标
@property (nonatomic, strong) UILabel *invitationLineLable; //邀请码下面的线
@property (nonatomic, strong) UILabel *agreenMentLable;
@property (nonatomic, strong) UIButton *seeAgreenMentProtocalButton;
@property (nonatomic, strong) UIButton *finalAgreenMentButton;//最底下的同意按钮

@end

@implementation CKRegisterView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeUI];
    }
    return self;
}

-(void)initializeUI {
    
    self.backgroundColor = [UIColor whiteColor];
    _telphoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 34, 21)];
    UIImage *telImage = [UIImage imageNamed:@"手机"];
    [_telphoneImageView setImage:[telImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _telphoneImageView.contentMode= UIViewContentModeCenter;
    
    _telphoneTextField = [[UITextField alloc] init];
    [self addSubview:_telphoneTextField];
    _telphoneTextField.delegate = self;
    [_telphoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(15));
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - AdaptedWidth(30)-20, AdaptedHeight(40)));
    }];
    _telphoneTextField.placeholder = CheckMsgPhoneHolder;
    _telphoneTextField.leftView = _telphoneImageView;
    _telphoneTextField.leftViewMode = UITextFieldViewModeAlways;
    _telphoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    //手机号码下面的线
    _telLineLable =  [UILabel creatLineLable];
    [self addSubview:_telLineLable];
    [_telLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_telphoneTextField.mas_bottom);
        make.left.equalTo(_telphoneTextField.mas_left);
        make.width.equalTo(_telphoneTextField.mas_width);
        make.height.mas_offset(1);
    }];
    
    
    NSString *tipStr = @"*非大陆手机用户请在手机号码前输入国际电话区号。例如香港手机用户：0852手机号码";
//    CGFloat h = [tipStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil].size.height + 1;
//    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 159, SCREEN_WIDTH - 20, h)];
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = tipStr;
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = [UIColor tt_monthGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_telLineLable.mas_bottom).offset(3);
        make.left.equalTo(_telphoneTextField.mas_left);
        make.right.mas_equalTo(AdaptedWidth(-15));
    }];
    
    //验证码图标
    _verifyCodeImageView = [[UIImageView alloc] init];
    UIImage *codeImage = [UIImage imageNamed:@"verificationcode"];
    [_verifyCodeImageView setImage:[codeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _verifyCodeImageView.frame = CGRectMake(10, 0, 35, 21);
    _verifyCodeImageView.contentMode= UIViewContentModeCenter;
    
    //验证码textfiled
    _verifyCodeTextField = [[UITextField alloc] init];
    [self addSubview:_verifyCodeTextField];
    _verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_telLineLable.mas_bottom).offset(AdaptedHeight(10));
        make.top.equalTo(tipLabel.mas_bottom).offset(AdaptedHeight(10));
        make.left.equalTo(_telphoneTextField.mas_left);
        make.size.mas_offset(CGSizeMake((SCREEN_WIDTH - AdaptedWidth(30))*2/3, AdaptedHeight(40)));
    }];
    _verifyCodeTextField.placeholder = @"请输入验证码";
    _verifyCodeTextField.leftView = _verifyCodeImageView;
    _verifyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    _verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    //发送验证码
    UIImageView *bankcodeImageView = [[UIImageView alloc] init];
    [self addSubview:bankcodeImageView];
    [bankcodeImageView setImage:[UIImage imageNamed:@"postcode"]];
    [bankcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_verifyCodeTextField.mas_right).offset(5);
        make.right.mas_offset(-AdaptedWidth(15));
        make.height.mas_offset(AdaptedHeight(30));
        make.bottom.equalTo(_verifyCodeTextField.mas_bottom);
    }];
    
    
    _countDownCode = [[STCountDownButton alloc]init];
    [self addSubview:_countDownCode];
    //设置背景颜色
    _countDownCode.backgroundColor = [UIColor clearColor];
    //设置倒计时时长
    [_countDownCode setSecond:60];
    //设置字体大小
    _countDownCode.titleLabel.font = MAIN_TITLE_FONT;
    //设置字体颜色
    [_countDownCode setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
    [_countDownCode addTarget:self
                       action:@selector(startCountDown:)
             forControlEvents:UIControlEventTouchUpInside];
    [_countDownCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bankcodeImageView);
    }];
    
    
    //验证码下面的线
    _codeLineLable = [UILabel creatLineLable];
    [self addSubview:_codeLineLable];
    [_codeLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verifyCodeTextField.mas_bottom);
        make.left.equalTo(_verifyCodeTextField.mas_left);
        make.width.equalTo(_verifyCodeTextField.mas_width);
        make.height.mas_offset(1);
    }];
    
    //邀请码
    _invitationImageView = [[UIImageView alloc] init];
    UIImage *invitationImage = [UIImage imageNamed:@"验证码"];
    [_invitationImageView setImage:[invitationImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _invitationImageView.frame = CGRectMake(10, 0, 41, 14);
    _invitationImageView.contentMode= UIViewContentModeCenter;
    
    _invitationTextField = [[UITextField alloc] init];
    [self addSubview:_invitationTextField];
    _invitationTextField.placeholder = @"请输入邀请码";
    _invitationTextField.delegate = self;
    [_invitationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeLineLable.mas_bottom).offset(AdaptedHeight(10));
        make.left.equalTo(_verifyCodeTextField.mas_left);
        make.width.equalTo(_telphoneTextField.mas_width);
        make.height.equalTo(_telphoneTextField.mas_height);
        
    }];
    _invitationTextField.leftView = _invitationImageView;
    _invitationTextField.leftViewMode = UITextFieldViewModeAlways;
    _invitationTextField.keyboardType = UIKeyboardTypeURL;
    
    //邀请码下面的线
    _invitationLineLable = [UILabel creatLineLable];
    [self addSubview:_invitationLineLable];
    [_invitationLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_invitationTextField.mas_bottom);
        make.left.equalTo(_invitationTextField.mas_left);
        make.width.equalTo(_invitationTextField.mas_width);
        make.height.mas_offset(1);
    }];
    
    //创建一个button点击弹出邀请码框
    _inviteSeletedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_inviteSeletedButton];
    [_inviteSeletedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_invitationTextField);
    }];
    [_inviteSeletedButton addTarget:self action:@selector(clickInviteCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //设置登录密码
    UIImageView *passwordImageView = [[UIImageView alloc] init];
    [passwordImageView setImage:[UIImage imageNamed:@"lock"]];
    passwordImageView.frame = CGRectMake(10, 0, 34, 21);
    passwordImageView.contentMode= UIViewContentModeCenter;
    
    _setupPassWordTextField = [[UITextField alloc] init];
    [self addSubview:_setupPassWordTextField];
    [_setupPassWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_invitationLineLable.mas_bottom).offset(AdaptedHeight(10));
        make.left.equalTo(_invitationTextField.mas_left);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - AdaptedWidth(30) - 20, AdaptedHeight(40)));
    }];
    _setupPassWordTextField.placeholder = @"请设置登录密码";
    _setupPassWordTextField.leftView = passwordImageView;
    _setupPassWordTextField.leftViewMode = UITextFieldViewModeAlways;
    _setupPassWordTextField.keyboardType = UIKeyboardTypeAlphabet;
    _setupPassWordTextField.secureTextEntry = YES;
    
    UILabel *passwordLine = [UILabel creatLineLable];
    [self addSubview:passwordLine];
    [passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_setupPassWordTextField.mas_bottom);
        make.left.equalTo(_invitationLineLable.mas_left);
        make.width.equalTo(_setupPassWordTextField.mas_width);
        make.height.mas_offset(1);
    }];
    
    
    //再次设置登录密码
    UIImageView *moretimemageView = [[UIImageView alloc] init];
    [moretimemageView setImage:[UIImage imageNamed:@"lock"]];
    moretimemageView.frame = CGRectMake(10, 0, 34, 21);
    moretimemageView.contentMode= UIViewContentModeCenter;
    
    _morePassWordTextField = [[UITextField alloc] init];
    [self addSubview:_morePassWordTextField];
    [_morePassWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_setupPassWordTextField.mas_bottom).offset(AdaptedHeight(10));
        make.left.equalTo(_setupPassWordTextField.mas_left);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - AdaptedWidth(30) -20 ,AdaptedHeight(40)));
    }];
    _morePassWordTextField.placeholder = @"请再次输入您的密码";
    _morePassWordTextField.leftView = moretimemageView;
    _morePassWordTextField.leftViewMode = UITextFieldViewModeAlways;
    _morePassWordTextField.keyboardType = UIKeyboardTypeAlphabet;
    _morePassWordTextField.secureTextEntry = YES;
    
    UILabel *moreTimePasswordLine = [UILabel creatLineLable];
    [self addSubview:moreTimePasswordLine];
    [moreTimePasswordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_morePassWordTextField.mas_bottom);
        make.left.equalTo(_morePassWordTextField.mas_left);
        make.width.equalTo(passwordLine.mas_width);
        make.height.mas_offset(1);
    }];
    
    _agreenmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_agreenmentButton];
    _agreenmentButton.tag = 182;
    
    [_agreenmentButton setImage:[UIImage imageNamed:@"pinkselected"] forState:UIControlStateSelected];
    [_agreenmentButton setImage:[UIImage imageNamed:@"giftwhite"] forState:UIControlStateNormal];
    [_agreenmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_morePassWordTextField.mas_bottom).offset(AdaptedHeight(40));
        make.left.mas_offset(SCREEN_WIDTH/2-130);
        make.size.mas_offset(CGSizeMake(20, 20));
    }];
    [_agreenmentButton addTarget:self action:@selector(clickAgreenmentButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _agreenMentLable = [UILabel configureLabelWithTextColor:[UIColor grayColor] textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [self addSubview:_agreenMentLable];
    _agreenMentLable.text = @"我已经阅读并同意";
    [_agreenMentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_agreenmentButton.mas_top);
        make.left.equalTo(_agreenmentButton.mas_right).offset(5);
        make.bottom.equalTo(_agreenmentButton.mas_bottom);
    }];
    
    //蓝色字
    _seeAgreenMentProtocalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_seeAgreenMentProtocalButton];
    _seeAgreenMentProtocalButton.tag = 183;
    [_seeAgreenMentProtocalButton setTitle:@"《创客村协议》" forState:UIControlStateNormal];
    _seeAgreenMentProtocalButton.titleLabel.font  = MAIN_NAMETITLE_FONT;
    [_seeAgreenMentProtocalButton setTitleColor:[UIColor tt_blueColor] forState:UIControlStateNormal];
    _seeAgreenMentProtocalButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [_seeAgreenMentProtocalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_agreenMentLable.mas_top);
        make.left.equalTo(_agreenMentLable.mas_right);
        make.bottom.equalTo(_agreenMentLable.mas_bottom);
    }];
    [_seeAgreenMentProtocalButton addTarget:self action:@selector(clickRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //同意按钮
    UIImageView *bankbuttonImageView = [[UIImageView alloc] init];
    [self addSubview:bankbuttonImageView];
    bankbuttonImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bankbuttonImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [bankbuttonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_agreenmentButton.mas_bottom).offset(AdaptedHeight(15));
        make.left.mas_offset(AdaptedWidth(20));
        make.right.mas_offset(-AdaptedWidth(20));
        make.height.mas_offset(AdaptedHeight(40));
    }];
    
    
    _finalAgreenMentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_finalAgreenMentButton];
    _finalAgreenMentButton.tag = 184;
    [_finalAgreenMentButton setBackgroundColor:[UIColor clearColor]];
    [_finalAgreenMentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_finalAgreenMentButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_finalAgreenMentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bankbuttonImageView);
    }];
    [_finalAgreenMentButton addTarget:self action:@selector(clickRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - --- event response 事件相应 ---
- (void)startCountDown:(STCountDownButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getVertifyCode:)]) {
        [self.delegate getVertifyCode:button];
    }
}

/**-点击同意协议按钮*/
-(void)clickAgreenmentButton:(UIButton *)button{
    button.selected = !button.selected;
    
}

/**-点击底下的注册按钮*/
-(void)clickRegisterButton:(UIButton*)btn {
    if(self.delegate && [self.delegate respondsToSelector:@selector(rigisterCKorFX:)]){
        [self.delegate rigisterCKorFX:btn.tag-183];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_telphoneTextField resignFirstResponder];
    [_verifyCodeTextField resignFirstResponder];
    [_invitationTextField resignFirstResponder];
}

#pragma mark - 点击邀请码弹框
-(void)clickInviteCodeButton:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectedInviteCode:)]){
        [self.delegate selectedInviteCode:button];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField != _telphoneTextField) {
        _inviteSeletedButton.hidden = NO;
    }
    if (textField == _invitationTextField) {
        [textField resignFirstResponder];
    }
}

#pragma mark-限制手机号11位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.telphoneTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if (self.telphoneTextField.text.length >= 20){
            self.telphoneTextField.text = [textField.text substringToIndex:20];
            return NO;
        }
    }
    return YES;
}

@end
