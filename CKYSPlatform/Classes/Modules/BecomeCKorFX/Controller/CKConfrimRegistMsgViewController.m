//
//  CKConfrimRegistMsgViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/14.
//  Copyright © 2018年 ckys. All rights reserved.
//  

#import "CKConfrimRegistMsgViewController.h"
#import "CKConfirmRegisterTableViewCell.h"
#import "CKMainPageModel.h"
#import "CKUpdateIdCardViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface CKConfrimRegistMsgViewController ()<UITableViewDelegate, UITableViewDataSource, CKIdentifyCodeCellwDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *agreementBtn;
@property (nonatomic, copy)   NSString *realName;
@property (nonatomic, copy)   NSString *phoneNo;
/**验证码*/
@property (nonatomic, copy)   NSString *identifyCode;
@property (nonatomic, copy)   NSString *pwd;
@property (nonatomic, copy)   NSString *confirmPwd;

/**手持身份证*/
@property (nonatomic, copy) NSString *handimgfile;
/**身份证正面*/
@property (nonatomic, copy) NSString *frontimgfile;
/**身份证反面*/
@property (nonatomic, copy) NSString *backimgfile;
/**身份证号码*/
@property (nonatomic, copy) NSString *idcardno;

@property (nonatomic, copy) NSString *inviteCode;

@property (nonatomic, copy) NSString *vertifyCode;

@end

@implementation CKConfrimRegistMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"确认店铺信息";
    [KUserdefaults setObject:@"0" forKey:KexitRegister];
    [KUserdefaults synchronize];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RootNavigationBack"] style:UIBarButtonItemStylePlain target:self action:@selector(exitRegister)];
    left.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = left;
    [self initComponents];
    
}


//- (BOOL)navigationShouldPopOnBackButton {
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    return NO;
//}

- (void)initComponents {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NaviAddHeight) style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionHeaderHeight = 0.1;
        self.tableView.estimatedSectionFooterHeight = 0.1;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10+64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-NaviAddHeight) style:UITableViewStylePlain];

    }
    
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor tt_grayBgColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self addTableViewFooterView];
    
}

- (void)addTableViewFooterView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    view.backgroundColor = [UIColor tt_grayBgColor];
    
    self.agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:self.agreementBtn];
    [self.agreementBtn setImage:[UIImage imageNamed:@"pinkselected"] forState:UIControlStateSelected];
    [self.agreementBtn setImage:[UIImage imageNamed:@"giftwhite"] forState:UIControlStateNormal];
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(50);
        make.left.mas_offset(SCREEN_WIDTH/2-130);
        make.size.mas_offset(CGSizeMake(20, 20));
    }];
    [self.agreementBtn addTarget:self action:@selector(clickAgreementButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *agreementLabel = [UILabel configureLabelWithTextColor:[UIColor grayColor] textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [view addSubview:agreementLabel];
    agreementLabel.text = @"我已经阅读并同意";
    [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreementBtn.mas_top);
        make.left.equalTo(self.agreementBtn.mas_right).offset(5);
        make.bottom.equalTo(self.agreementBtn.mas_bottom);
    }];
    
    //蓝色字
    UIButton *protocalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:protocalBtn];
    [protocalBtn setTitle:@"《创客村协议》" forState:UIControlStateNormal];
    protocalBtn.titleLabel.font  = MAIN_NAMETITLE_FONT;
    [protocalBtn setTitleColor:[UIColor tt_blueColor] forState:UIControlStateNormal];
    protocalBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [protocalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(agreementLabel.mas_top);
        make.left.equalTo(agreementLabel.mas_right);
        make.bottom.equalTo(agreementLabel.mas_bottom);
    }];
    [protocalBtn addTarget:self action:@selector(seeAgreement) forControlEvents:UIControlEventTouchUpInside];
    
    //同意按钮
    UIImageView *bankbuttonImageView = [[UIImageView alloc] init];
    [view addSubview:bankbuttonImageView];
    bankbuttonImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bankbuttonImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [bankbuttonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreementBtn.mas_bottom).offset(15);
        make.left.mas_offset(25);
        make.right.mas_offset(-25);
        make.height.mas_offset(44);
    }];
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:nextBtn];
    [nextBtn setBackgroundColor:[UIColor clearColor]];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bankbuttonImageView);
    }];
    [nextBtn addTarget:self action:@selector(rigisterCKorFX) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = view;
}

/**-点击同意协议按钮*/
-(void)clickAgreementButton:(UIButton *)button{
    button.selected = !button.selected;
}

- (void)seeAgreement {
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
}

- (void)exitRegister {
    [KUserdefaults setObject:@"1" forKey:KexitRegister]; // 设置取消注册的状态为NO
    [KUserdefaults synchronize];
    if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *holderArray = @[@"请输入真实姓名", @"请输入手机号码", @"", @"请输入验证码", @"请输入身份证号码", @"请上传证件照", @"登录密码", @"确认密码"];
    if (indexPath.row == 2) {
        CKConfirmRegisterTipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKConfirmRegisterTipCell"];
        if (!cell) {
            cell = [[CKConfirmRegisterTipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKConfirmRegisterTipCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.row == 3) {
        CKIdentifyCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKIdentifyCodeCell"];
        if (!cell) {
            cell = [[CKIdentifyCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKIdentifyCodeCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else if (indexPath.row == 5) {
        CKIdCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKIdCardCell"];
        if (!cell) {
            cell = [[CKIdCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKIdCardCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CKConfirmRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKConfirmRegisterTableViewCell"];
        if (!cell) {
            cell = [[CKConfirmRegisterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKConfirmRegisterTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 6 || indexPath.row == 7) {
            cell.registTextField.secureTextEntry = YES;
        }
        
        if (indexPath.row == 1) {
            NSString *gettermobile = [KUserdefaults objectForKey:@"Kgettermobile"];
            if (IsNilOrNull(gettermobile)) {
                [cell setPlaceHolder:holderArray[indexPath.row]];
            }else{
                [cell setTextFieldText:gettermobile];
            }
        }else{
            [cell setPlaceHolder:holderArray[indexPath.row]];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        if (SCREEN_HEIGHT <= 568) {
            return 50.f;
        }else{
            return 35.f;
        }
    }
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        CKUpdateIdCardViewController *idCardVC = [[CKUpdateIdCardViewController alloc] init];
        [idCardVC setCerBlock:^(NSString *handImgUrl, NSString *frontImgUrl, NSString *backImgUrl) {
            if(!IsNilOrNull(handImgUrl)){
                self.handimgfile = handImgUrl;
            }
            if(!IsNilOrNull(frontImgUrl)){
                self.frontimgfile = frontImgUrl;
            }
            if(!IsNilOrNull(backImgUrl)){
                self.backimgfile = backImgUrl;
            }
            CKIdCardCell *cell = (CKIdCardCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.updateIDLabel.text = @"已上传";
            cell.updateIDLabel.textColor = TitleColor;
        }];
        [self.navigationController pushViewController:idCardVC animated:YES];
    }
}


#pragma mark - 获取验证码--2017.11.29改为先验证，成功后在请求验证码
- (void)vertifyPhoneNo:(CKIdentifyCodeCell *)cell button:(STCountDownButton *)button {
    CKConfirmRegisterTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSLog(@"%@", cell1.registTextField.text);
    self.phoneNo = cell1.registTextField.text;

    if (IsNilOrNull(self.phoneNo)){
        [self showNoticeView:CheckMsgPhoneNull];
        return;
    }
    
    //1开头的默认为大陆号码，增加验证
    if(![NSString isMobile:self.phoneNo]){
        [self showNoticeView:CheckMsgPhoneError];
        return;
    }

    [button start];
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }

    NSDictionary *pramdDic = @{@"mobile":self.phoneNo, @"devicetype":@"ios"};
    NSString *codeUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Regist/getValidateCode"];

    [HttpTool postWithUrl:codeUrl params:pramdDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
//            [button stop];
        }else{
            [self getVertifyCode:button];
        }
    } failure:^(NSError *error) {

//        [button stop];

    }];
}

#pragma mark - 获取验证码
- (void)getVertifyCode:(STCountDownButton *)button {
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }

    NSDictionary *pramdDic = @{@"telNo":self.phoneNo, DeviceId:uuid, @"param":@"1", @"devtype":@"2", @"apptype":@"1"};
    NSString *codeUrl = [NSString stringWithFormat:@"%@%@", PostMessageAPI, sendMsg_Url];

    [HttpTool postWithUrl:codeUrl params:pramdDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
        }else{
            self.vertifyCode = [NSString stringWithFormat:@"%@",dict[@"validStr"]];
            NSLog(@"获取的验证码:%@", self.vertifyCode);
        }
    } failure:^(NSError *error) {
    }];
}

//注册
#pragma mark - 填完信息，检验无误后下一步就是注册成功，自动登录
-(void)rigisterCKorFX {
    
    CKConfirmRegisterTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSLog(@"%@", cell.registTextField.text);
    CKConfirmRegisterTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSLog(@"%@", cell1.registTextField.text);
    CKIdentifyCodeCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSLog(@"%@", cell3.registTextField.text);
    CKConfirmRegisterTableViewCell *cell4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSLog(@"%@", cell4.registTextField.text);
    CKConfirmRegisterTableViewCell *cell6 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    NSLog(@"%@", cell6.registTextField.text);
    CKConfirmRegisterTableViewCell *cell7 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
    NSLog(@"%@", cell7.registTextField.text);
    // 验证上传身份证照
    CKIdCardCell *cell5 = (CKIdCardCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    NSString *state =  cell5.updateIDLabel.text;
    self.realName = cell.registTextField.text;
    self.phoneNo = cell1.registTextField.text;
    self.identifyCode = cell3.registTextField.text;
    self.idcardno = cell4.registTextField.text;
    self.pwd = cell6.registTextField.text;
    self.confirmPwd = cell7.registTextField.text;
    
    if (IsNilOrNull(self.realName)) {
        [self showNoticeView:@"请输入姓名"];
    }
    
    if (IsNilOrNull(self.phoneNo)){
        [self showNoticeView:CheckMsgPhoneNull];
        return;
    }
    //1开头的默认为大陆号码，增加验证
    if(![NSString isMobile:self.phoneNo]){
        [self showNoticeView:CheckMsgPhoneError];
        return;
    }
    
    if (IsNilOrNull(self.identifyCode)) {
        [self showNoticeView:@"请输入验证码"];
    }
    
    if (!IsNilOrNull(self.vertifyCode) && ![self.vertifyCode isEqualToString:self.identifyCode]) {
        [self showNoticeView:@"输入的验证码有误"];
    }
    
    if (IsNilOrNull(self.idcardno)) {
        [self showNoticeView:@"请输入身份证号码"];
    }
    
    if (![state isEqualToString:@"已上传"]) {
        [self showNoticeView:@"请上传身份证照"];
        return;
    }
    
    //密码校验
    if(![self.pwd isEqualToString:self.confirmPwd]){
        [self showNoticeView:CheckMsgPwTwiceError];
        return;
    }
    if (IsNilOrNull(self.pwd)) {
        [self showNoticeView:CheckMsgPwNull];
        return;
    }
    if (IsNilOrNull(self.confirmPwd)) {
        [self showNoticeView:CheckMsgPwNull];
        return;
    }
    
    
    if (!self.agreementBtn.selected) {
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
    
   
    if (!IsNilOrNull([KUserdefaults objectForKey:@"invitecode"])) {
         self.inviteCode = [KUserdefaults objectForKey:@"invitecode"];
    }else{
        self.inviteCode = @"";
    }
    NSDictionary *appDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [appDic objectForKey:@"CFBundleShortVersionString"];
    NSString *devicetype = [NSString stringWithFormat:@"ios%@", version];
    NSLog(@"%@-%@-%@-%@-%@-%@-%@-%@-%@", self.phoneNo, self.inviteCode, self.pwd, weixinUnionid, weixinNickName, weixinHeaimageUrl, self.orderid, self.idcardno, self.realName);
    NSDictionary *params = @{@"mobile":self.phoneNo, @"invitecode":self.inviteCode, @"password":self.pwd, @"unionid":weixinUnionid, @"smallname":weixinNickName, @"headimg":weixinHeaimageUrl, DeviceId:uuid, @"devicetype": devicetype, @"orderid":self.orderid, @"idcardno":self.idcardno, @"frontimgfile":self.frontimgfile, @"backimgfile":self.backimgfile, @"handimgfile":self.handimgfile,@"realname":self.realName};
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
                [KUserdefaults setObject:self.phoneNo forKey:Kmobile];
                [KUserdefaults setObject:self.pwd forKey:Kpassword];
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
            [KUserdefaults setObject:self.phoneNo forKey:Kmobile];
            [KUserdefaults setObject:self.pwd forKey:Kpassword];
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
        
        [self exitRegister];
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
        
        [KUserdefaults setObject:@"0" forKey:KexitRegister]; // 设置取消注册的状态为yes
        [KUserdefaults synchronize];
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

-(void)getuserCKidIfckidNull {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }

    NSString *loginUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ckLogin_Url];
    NSDictionary *appDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [appDic objectForKey:@"CFBundleShortVersionString"];
    NSString *devicetype = [NSString stringWithFormat:@"ios%@", version];
    
    NSDictionary *pramaDic = @{@"mobile":self.phoneNo, @"password":self.pwd, DeviceId:uuid, @"devicetype": devicetype};
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
