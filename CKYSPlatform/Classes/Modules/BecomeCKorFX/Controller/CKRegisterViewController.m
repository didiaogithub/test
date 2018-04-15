//
//  CKRegisterViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKRegisterViewController.h"
#import "WebDetailViewController.h"
#import "QrcodeAlertVeiw.h"  //邀请码弹框
#import <RongIMKit/RongIMKit.h>
#import "CKRegisterView.h"
#import "MinePersonalInfomationViewController.h"
#import "AddressModel.h"
#import "CKMainPageModel.h"

@interface CKRegisterViewController ()<CKRegisterViewDelegate,  QrcodeAlertVeiwDelegate>

@property (nonatomic, copy) NSString *mobileText;
@property (nonatomic, copy) NSString *valitedStr;
@property (nonatomic, copy) NSString *riskType;
@property (nonatomic, copy) NSString *inviteCodeText;
@property (nonatomic, copy) NSString *validateCodeText;
@property (nonatomic, copy) NSString *passwordText;
@property (nonatomic, copy) NSString *morepasswordText;
@property (nonatomic, copy) NSString *serverInviteCode;
@property (nonatomic, copy) NSString *supername;
@property (nonatomic, strong) CKRegisterView *registerView;
@property (nonatomic, strong) QrcodeAlertVeiw *qrcodeAlertView;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation CKRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"确认信息";
    
    self.view.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    [self requestInviteCode];
    self.viewDataLoading.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, SCREEN_WIDTH-20, 30)];
    titleLabel.text = @"确认信息";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = TitleColor;
    titleLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
//    _registerView = [[CKRegisterView alloc] initWithFrame:CGRectMake(0, AdaptedHeight(10)+64+NaviAddHeight, SCREEN_WIDTH, AdaptedHeight(470))];
    
    _registerView = [[CKRegisterView alloc] initWithFrame:CGRectMake(10, 130, SCREEN_WIDTH-20, AdaptedHeight(420))];
    _registerView.delegate = self;

    NSString *unionid = [KUserdefaults objectForKey:Kunionid];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:unionid];
    AddressModel *addressModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (addressModel != nil) {
        NSString *gettermobile = [NSString stringWithFormat:@"%@", addressModel.gettermobile];
        if (!IsNilOrNull(gettermobile)) {
            _registerView.telphoneTextField.text = gettermobile;
        }
    }
    
    [self.view addSubview:self.registerView];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.deleteButton];
    self.deleteButton.frame = CGRectMake(SCREEN_WIDTH-40, 100, 30, 30);
    [self.deleteButton setImage:[UIImage imageNamed:@"deleteImg.png"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
   
    if ([UIScreen mainScreen].bounds.size.height <= 568) {
        titleLabel.frame = CGRectMake(10, 80, SCREEN_WIDTH-20, 30);
        _registerView.frame = CGRectMake(10, 110, SCREEN_WIDTH-20, AdaptedHeight(440));
        self.deleteButton.frame = CGRectMake(SCREEN_WIDTH-40, 80, 30, 30);
    }
}

-(void)clickDeleteButton {
    [CKCNotificationCenter postNotificationName:@"RemoveRegisterNoti" object:nil];
}

#pragma mark - 获取邀请码
-(void)requestInviteCode {
    NSString *localInviteCode = [KUserdefaults objectForKey:@"invitecode"];
    if (IsNilOrNull(localInviteCode)){
        localInviteCode = @"";
    }
    _serverInviteCode = localInviteCode;
    NSString *supername = [KUserdefaults objectForKey:@"supername"];
    if (IsNilOrNull(supername)){
        supername = @"";
    }
    _supername = supername;
    
    NSString *unionid = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Kunionid]];
    if (IsNilOrNull(unionid)){
        return;
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSDictionary *pramaDic = @{@"unionid":unionid, DeviceId:uuid};
    NSString *inviteCodeUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getInviteCode_Url];
    [HttpTool postWithUrl:inviteCodeUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        _serverInviteCode = [NSString stringWithFormat:@"%@",dict[@"inviteCode"]];
        if (IsNilOrNull(_serverInviteCode)){
            _serverInviteCode = @"";
        }
        _supername = [NSString stringWithFormat:@"%@",dict[@"supername"]];
        if (IsNilOrNull(_supername)){
            _supername = @"";
        }
        
        [KUserdefaults setObject:_serverInviteCode forKey:@"invitecode"];
        [KUserdefaults setObject:_supername forKey:@"supername"];
        [KUserdefaults synchronize];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 点击邀请码的弹框
-(void)selectedInviteCode:(UIButton *)button {
    button.hidden = YES;
    if (!IsNilOrNull(_serverInviteCode)) {
        for (UITextField *textF in self.registerView.subviews) {
            [textF resignFirstResponder];
        }
        _qrcodeAlertView = [[QrcodeAlertVeiw alloc]init];
        _qrcodeAlertView.delegate = self;
        _qrcodeAlertView.nameLable.text = [NSString stringWithFormat:@"%@",_supername];
        _qrcodeAlertView.qrcodeLable.text = [NSString stringWithFormat:@"%@",_serverInviteCode];
        [_qrcodeAlertView show];
    }else{
        [self.registerView.invitationTextField becomeFirstResponder];
    }
}

#pragma mark - 复制邀请码
-(void)copyQrcode {
    [self.registerView.invitationTextField becomeFirstResponder];
    self.registerView.invitationTextField.text = _serverInviteCode;
}

#pragma mark - 手动输入
-(void)writeQrcode {
    [_qrcodeAlertView dissmiss];
    [self.registerView.invitationTextField becomeFirstResponder];
}

-(void)rigisterCKorFX:(NSInteger)tag {
    if(tag == 0){ //查看协议
        NSLog(@"点击注册");
        NSString *ckcxyurl = @"";
        RLMResults *result = [[CacheData shareInstance] search:[CKMainPageModel class]];
        if (result.count > 0) {
            CKMainPageModel *mainM = result.firstObject;
            ckcxyurl = [NSString stringWithFormat:@"%@", mainM.ckcxyurl];
        }
        
        WebDetailViewController *protocal = [[WebDetailViewController alloc] init];
        protocal.typeString = @"protocal";
        protocal.detailUrl = ckcxyurl;
        [self.navigationController pushViewController:protocal animated:YES];
    }else if (tag == 1){ //点击注册
        NSLog(@"点击注册");
        [self becomeCKorFX];
    }
}

#pragma mark - 填完信息，检验无误后下一步就是注册成功，自动登录
-(void)becomeCKorFX {
    [self.registerView.telphoneTextField resignFirstResponder];
    [self.registerView.invitationTextField resignFirstResponder];
    [self.registerView.verifyCodeTextField resignFirstResponder];
    _mobileText = self.registerView.telphoneTextField.text;
    _inviteCodeText = self.registerView.invitationTextField.text;
    _validateCodeText = self.registerView.verifyCodeTextField.text;
    _passwordText = self.registerView.setupPassWordTextField.text;
    _morepasswordText = self.registerView.morePassWordTextField.text;
    
    if (IsNilOrNull(_mobileText)){
        [self showNoticeView:CheckMsgPhoneNull];
        return;
    }
    //1开头的默认为大陆号码，增加验证
    if(![NSString isMobile:_mobileText]){
        [self showNoticeView:CheckMsgPhoneError];
        return;
    }
    
    
    if (IsNilOrNull(_inviteCodeText)){
        [self showNoticeView:CheckMsgInviteCodeNull];
        return;
    }
    //密码校验
    if(![_passwordText isEqualToString:_morepasswordText]){
        [self showNoticeView:CheckMsgPwTwiceError];
        return;
    }
    if (IsNilOrNull(_passwordText)) {
        [self showNoticeView:CheckMsgPwNull];
        return;
    }
    if (IsNilOrNull(_morepasswordText)) {
        [self showNoticeView:CheckMsgPwNull];
        return;
    }
    
    
    if (!self.registerView.agreenmentButton.selected) {
        [self showNoticeView:CheckMsgReadProtocolFirst];
        return;
    }
    
    NSString *weixinUnionid = [KUserdefaults objectForKey:Kunionid];
    NSString *weixinHeaimageUrl = [KUserdefaults objectForKey:kheamImageurl];
    NSString *weixinNickName = [KUserdefaults objectForKey:KnickName];
    if (IsNilOrNull(weixinUnionid)) {
        weixinUnionid = @"";
    }
    if (IsNilOrNull(weixinHeaimageUrl)) {
        weixinHeaimageUrl = @"";
    }
    if (IsNilOrNull(weixinNickName)) {
        weixinNickName = @"";
    }

    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    if (IsNilOrNull(self.orderid)) {
        self.orderid = @"";
    }
    
    NSDictionary *appDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [appDic objectForKey:@"CFBundleShortVersionString"];
    NSString *devicetype = [NSString stringWithFormat:@"ios%@", version];
    NSDictionary *params = @{@"mobile":_mobileText, @"invitecode":_inviteCodeText,  @"password":_passwordText, @"unionid":weixinUnionid, @"smallname":weixinNickName, @"headimg":weixinHeaimageUrl, DeviceId:uuid, @"devicetype": devicetype, @"orderid":self.orderid};
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    NSString *registCheckUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ConfirmRegist];
  
    [HttpTool postWithUrl:registCheckUrl params:params success:^(id json) {
        [self.viewDataLoading stopAnimation];

        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            if ([code isEqualToString:@"2002"]) {
                NSString *ckid = [NSString stringWithFormat:@"%@", dict[@"ckid"]];
                if (IsNilOrNull(ckid)) {
                    [self getuserCKidIfckidNull];
                }else{
                    [KUserdefaults setObject:ckid forKey:Kckid];
                }
                
                //注册成功连接融云 并设置token
                [self setupRongTokenDataWithckid:ckid andName:weixinNickName andHeadUrl:weixinHeaimageUrl];
                //注册成功刷新首页和个人中心
                [KUserdefaults setObject:@"minelogin" forKey:KMineLoginStatus];
                [KUserdefaults setObject:@"homelogin" forKey:KHomeLoginStatus];
                
                //是否是预售店 加盟预售店 不需要支付
                NSString *ispresale = [NSString stringWithFormat:@"%@", dict[@"ispresale"]];
                if (IsNilOrNull(ispresale)) {
                    ispresale = @"";
                }
                //保存一些常用的值
                [KUserdefaults setObject:_mobileText forKey:Kmobile];
                [KUserdefaults setObject:_passwordText forKey:Kpassword];
                [KUserdefaults setObject:ispresale forKey:KisPresaleShop];
                //推广人不需要注册（推广人是通过后台分配的账号登录） 凡是注册成功的都把sale设置为0
                [KUserdefaults setObject:@"0" forKey:KSales];
                [KUserdefaults synchronize];
                
                //注册成功之后  设置别名和标签   设置userId  昵称 头像
                [JPUSHService setTags:0 alias:ckid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                    NSLog(@"\n[注册成功后设置别名]---[%@]",iAlias);
                    if(iResCode != 0){
                        [JPUSHService setTags:0 alias:ckid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                            NSLog(@"\n注册失败重置---[%@]",iAlias);
                        }];
                    }
                }];
                [CKCNotificationCenter postNotificationName:@"UpdateUIToLoginSuccessNoti" object:nil];
            }else{
                [self showNoticeView:dict[@"codeinfo"]];
            }
        }else{
            NSString *ckid = [NSString stringWithFormat:@"%@", dict[@"ckid"]];
            if (IsNilOrNull(ckid)) {
                [self getuserCKidIfckidNull];
            }else{
                [KUserdefaults setObject:ckid forKey:Kckid];
            }
            [KUserdefaults setObject:ckid forKey:Kckid];
            //注册成功连接融云 并设置token
            [self setupRongTokenDataWithckid:ckid andName:weixinNickName andHeadUrl:weixinHeaimageUrl];
            //注册成功刷新首页和个人中心
            [KUserdefaults setObject:@"minelogin" forKey:KMineLoginStatus];
            [KUserdefaults setObject:@"homelogin" forKey:KHomeLoginStatus];
            
            //是否是预售店 加盟预售店 不需要支付
            NSString *ispresale = [NSString stringWithFormat:@"%@", dict[@"ispresale"]];
            if (IsNilOrNull(ispresale)) {
                ispresale = @"";
            }
            //保存一些常用的值
            [KUserdefaults setObject:_mobileText forKey:Kmobile];
            [KUserdefaults setObject:_passwordText forKey:Kpassword];
            [KUserdefaults setObject:ispresale forKey:KisPresaleShop];
            //推广人不需要注册（推广人是通过后台分配的账号登录） 凡是注册成功的都把sale设置为0
            [KUserdefaults setObject:@"0" forKey:KSales];
            [KUserdefaults synchronize];
            
            //注册成功之后  设置别名和标签   设置userId  昵称 头像
            [JPUSHService setTags:0 alias:ckid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"\n[注册成功后设置别名]---[%@]",iAlias);
                if(iResCode != 0){
                    [JPUSHService setTags:0 alias:ckid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        NSLog(@"\n注册失败重置---[%@]",iAlias);
                    }];
                }
            }];
            [CKCNotificationCenter postNotificationName:@"UpdateUIToLoginSuccessNoti" object:nil];
        }
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];

        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 注册完成后 应该是已登录状态
-(void)setupRongTokenDataWithckid:(NSString *)ckid andName:(NSString *)smallName andHeadUrl:(NSString *)headImageUrl{
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    if(IsNilOrNull(smallName)){
        smallName = ckid;
    }
    if(IsNilOrNull(headImageUrl)){
        headImageUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,DefaultHeadPath];
    }
    NSDictionary *pramaDic = @{@"id":ckid,@"name":smallName,@"pic":headImageUrl,DeviceId:uuid};
    NSString *rongUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getRongYunToken];
    
    [HttpTool postWithUrl:rongUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        NSString *token = [NSString stringWithFormat:@"%@",dict[@"token"]];
        [KUserdefaults setObject:token forKey:ckid];
        [KUserdefaults synchronize];
        
        //链接融云服务器
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            //设置当前登录的用户信息（不设置也有头像  获取token的时候已经把 头像传入）
            [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:smallName portrait:headImageUrl];
            
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", status);
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            
            NSString *ckidString = IsNilOrNull(KCKidstring) ? @"":KCKidstring;
            NSString *uuid = DeviceId_UUID_Value;
            if (IsNilOrNull(uuid)){
                uuid = @"";
            }
            NSString *refreshUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getRongYunToken];
            NSDictionary *refreshPramaDic = @{@"id":ckidString,@"name":smallName,@"pic":headImageUrl,DeviceId:uuid};
            [HttpTool postWithUrl:refreshUrl params:refreshPramaDic success:^(id json) {
                NSDictionary *dict = json;
                NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
                if (![code isEqualToString:@"200"]) {
                    NSLog(@"分销和无风险注册获取token失败%@",dict[@"codeinfo"]);
                    return ;
                }
                NSString *token = [NSString stringWithFormat:@"%@",dict[@"token"]];
                [KUserdefaults setObject:token forKey:ckidString];
                [KUserdefaults synchronize];
            } failure:^(NSError *error) {
            }];
            
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"token错误");
    }];
    
}

#pragma mark - 获取验证码--2017.11.29改为先验证，成功后在请求验证码
-(void)getVertifyCode:(STCountDownButton *)button {
    _mobileText = self.registerView.telphoneTextField.text;
    
    if (IsNilOrNull(_mobileText)){
        [self showNoticeView:CheckMsgPhoneNull];
        return;
    }
    
    //1开头的默认为大陆号码，增加验证
    if(![NSString isMobile:_mobileText]){
        [self showNoticeView:CheckMsgPhoneError];
        return;
    }
    
    [button start];
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSDictionary *pramdDic = @{@"mobile":_mobileText, @"devicetype":@"ios"};
    NSString *codeUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Regist/getValidateCode"];
    
    [HttpTool postWithUrl:codeUrl params:pramdDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            [button stop];
        }else{
            [self getVertifyCode];
        }
    } failure:^(NSError *error) {
        [button stop];
    }];
}

#pragma mark - 获取验证码
-(void)getVertifyCode {
    
    _mobileText = self.registerView.telphoneTextField.text;
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }

    NSDictionary *pramdDic = @{@"telNo":_mobileText,DeviceId:uuid,@"param":@"1", @"devtype":@"2", @"apptype":@"1"};
    NSString *codeUrl = [NSString stringWithFormat:@"%@%@", PostMessageAPI, sendMsg_Url];
    [self.registerView.countDownCode start];

    [HttpTool postWithUrl:codeUrl params:pramdDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.registerView.countDownCode stop];
        }else{
            _valitedStr = [NSString stringWithFormat:@"%@",dict[@"validStr"]];
            NSLog(@"验证码%@",_valitedStr);
        }
    } failure:^(NSError *error) {
        [self.registerView.countDownCode stop];
    }];
}

-(void)getuserCKidIfckidNull {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    //devicetype  仅在登陆接口传递
    NSString *loginUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ckLogin_Url];
    NSDictionary *appDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [appDic objectForKey:@"CFBundleShortVersionString"];
    NSString *devicetype = [NSString stringWithFormat:@"ios%@", version];
    
    NSDictionary *pramaDic = @{@"mobile":_mobileText, @"password":_passwordText, DeviceId:uuid, @"devicetype": devicetype};
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:loginUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if ([code integerValue] != 200) {
            return ;
        }
        NSString *ckid = [NSString stringWithFormat:@"%@",dict[@"ckid"]];
        if (!IsNilOrNull(ckid)) {
            [KUserdefaults setObject:ckid forKey:Kckid];
        }
    } failure:^(NSError *error) {
    }];
}

@end
