//
//  CKChangePasswordViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/16.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKChangePasswordViewController.h"

@interface CKChangePasswordViewController ()

@property (nonatomic, strong) STCountDownButton *countDownCode;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *idCodeTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UITextField *confirmPwdTextField;
@property (nonatomic, strong) UIButton *sumitButton;
@property (nonatomic, copy)   NSString *vertifyCode;

@end

@implementation CKChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    [self initViews];
}

- (void)initViews {

    UIView *contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64+AdaptedHeight(10)+NaviAddHeight);
        make.left.right.mas_offset(0);
        make.height.mas_offset(350);
    }];
    
    self.phoneTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    self.phoneTextField.backgroundColor = [UIColor whiteColor];
    self.phoneTextField.placeholder = @"请输入电话";
    [contentView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-SCREEN_WIDTH*0.5);
        make.left.mas_offset(10);
        make.height.mas_equalTo(49);
        make.top.mas_offset(0);
    }];
    
    _countDownCode = [[STCountDownButton alloc]init];
    [contentView addSubview:_countDownCode];
    _countDownCode.backgroundColor = [UIColor clearColor];
    [_countDownCode setSecond:60];
    _countDownCode.titleLabel.font = MAIN_TITLE_FONT;
    [_countDownCode setTitleColor:TitleColor forState:UIControlStateNormal];
    [_countDownCode addTarget:self action:@selector(startCountDown:)
             forControlEvents:UIControlEventTouchUpInside];
    [_countDownCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.width.mas_offset(120);
        make.height.mas_equalTo(40);
        make.top.mas_offset(5);
    }];
    
    UILabel *sepLineLabel = [UILabel creatLineLable];
    [contentView addSubview:sepLineLabel];
    [sepLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_offset(5);
        make.right.equalTo(_countDownCode.mas_left).offset(5);
        make.width.mas_equalTo(1);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [contentView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
    
    self.idCodeTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    self.idCodeTextField.backgroundColor = [UIColor whiteColor];
    self.idCodeTextField.placeholder = @"请输入验证码";
    [contentView addSubview:self.idCodeTextField];
    [self.idCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-SCREEN_WIDTH*0.5);
        make.left.mas_offset(10);
        make.height.mas_equalTo(49);
        make.top.equalTo(lineLabel.mas_bottom);
    }];
    
    UILabel *idCodeLineLabel = [UILabel creatLineLable];
    [contentView addSubview:idCodeLineLabel];
    [idCodeLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idCodeTextField.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
    
    self.pwdTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    self.pwdTextField.backgroundColor = [UIColor whiteColor];
    self.pwdTextField.placeholder = @"请输入新密码";
    [contentView addSubview:self.pwdTextField];
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-SCREEN_WIDTH*0.5);
        make.left.mas_offset(10);
        make.height.mas_equalTo(49);
        make.top.equalTo(idCodeLineLabel.mas_bottom);
    }];
    
    UILabel *pwdLineLabel = [UILabel creatLineLable];
    [contentView addSubview:pwdLineLabel];
    [pwdLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdTextField.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
    
    self.confirmPwdTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    self.confirmPwdTextField.backgroundColor = [UIColor whiteColor];
    self.confirmPwdTextField.placeholder = @"请再次输入密码";
    [contentView addSubview:self.confirmPwdTextField];
    [self.confirmPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-SCREEN_WIDTH*0.5);
        make.left.mas_offset(10);
        make.height.mas_equalTo(49);
        make.top.equalTo(pwdLineLabel.mas_bottom);
    }];
    
    UILabel *confirmPwdLineLabel = [UILabel creatLineLable];
    [contentView addSubview:confirmPwdLineLabel];
    [confirmPwdLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPwdTextField.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
    
    
    UIImageView *submitBankImageView = [[UIImageView alloc] init];
    [contentView addSubview:submitBankImageView];
    [submitBankImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [submitBankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmPwdLineLabel.mas_bottom).offset(50);
        make.left.mas_offset(AdaptedWidth(35));
        make.right.mas_offset(-AdaptedWidth(35));
        make.height.mas_offset(AdaptedHeight(40));
    }];
    //提交按钮
    _sumitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:_sumitButton];
    _sumitButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [_sumitButton setTitle:@"保存" forState:UIControlStateNormal];
    [_sumitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sumitButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(submitBankImageView);
    }];
    [_sumitButton addTarget:self action:@selector(clickSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 获取验证码
- (void)startCountDown:(STCountDownButton *)button {
    
    if (IsNilOrNull(self.phoneTextField.text)) {
        [self showNoticeView:@"请收入手机号码"];
        return;
    }
        
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSDictionary *pramdDic = @{@"telNo":self.phoneTextField.text, DeviceId:uuid, @"param":@"1", @"devtype":@"2", @"apptype":@"1"};
    NSString *codeUrl = [NSString stringWithFormat:@"%@%@", PostMessageAPI, sendMsg_Url];
    
    [button start];
    [HttpTool postWithUrl:codeUrl params:pramdDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            [button stop];
        }else{
            self.vertifyCode = [NSString stringWithFormat:@"%@",dict[@"validStr"]];
            NSLog(@"获取的验证码:%@", self.vertifyCode);
            [button stop];
        }
    } failure:^(NSError *error) {
        [button stop];
    }];
}

#pragma mark - 保存
- (void)clickSubmitButton {

    if(IsNilOrNull(self.idCodeTextField.text)){
        [self showNoticeView:@"请输入验证码"];
        return;
    }
    
    if (![self.idCodeTextField.text isEqualToString:self.vertifyCode]) {
        [self showNoticeView:CheckMsgVerificationCodeError];
        return;
    }

    if (IsNilOrNull(self.pwdTextField.text)) {
        [self showNoticeView:@"请输入新密码"];
        return;
    }
    if (IsNilOrNull(self.confirmPwdTextField.text)) {
        [self showNoticeView:@"请输入确认密码"];
        return;
    }
    
    if (![self.pwdTextField.text isEqualToString:self.confirmPwdTextField.text]) {
        [self showNoticeView:CheckMsgPwTwiceError];
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *changePassword = [NSString stringWithFormat:@"%@%@", WebServiceAPI, modPassword_Url];
    NSDictionary *pramaDic = @{@"ckid":KCKidstring,@"newpw":self.pwdTextField.text,DeviceId:uuid};

    
    [HttpTool postWithUrl:changePassword params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        [self showNoticeView:@"密码修改成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangePasswordSuccessNotification" object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

@end
