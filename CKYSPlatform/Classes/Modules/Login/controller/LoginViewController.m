//
//  LoginViewController.m
//  CKYSPlatform
//
//  Created by ckys on 16/7/11.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "LoginViewController.h"
#import "CodeLoginViewController.h"
#import "LoginView.h"
#import "DMineViewController.h"
//融云
#import <RongIMKit/RongIMKit.h>
#import "CacheManager.h"

@interface LoginViewController ()<LoginViewDelegate>
{
    NSString *_valitedStr;
    NSString * weixinHeaimageUrl;
    NSString *_smallName;
    NSString *_ckidStr;
    NSString *_tokenStr;
}
@property(nonatomic,strong) LoginView *loginView;

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(LoginView *)loginView{
    if (_loginView == nil) {
        _loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andTypeStr:@"1"];
        _loginView.delegate = self;
    }
    return _loginView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    weixinHeaimageUrl = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:kheamImageurl]];
    _smallName = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KnickName]];
    if (IsNilOrNull(weixinHeaimageUrl)) {
        weixinHeaimageUrl = @"";
    }
    if (IsNilOrNull(_smallName)) {
        _smallName = @"";
    }
    
    [self createViews];
    if([self.typeString isEqualToString:@"noback"]){
        self.loginView.returnImageView.hidden = YES;
    }else{
        self.loginView.returnImageView.hidden = NO;
    }
}

-(void)createViews{
    //创建自定义的导航栏
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+NaviAddHeight)];
    self.navView.backgroundColor = [UIColor tt_gradientTitleColor];
    [self.view addSubview:self.navView];
    //导航栏标题
    self.titleLabel = [UILabel configureLabelWithTextColor:[UIColor tt_bodyTitleColor] textAlignment:NSTextAlignmentCenter font:NAV_BAR_FONT];//标题lab
    self.titleLabel.frame = CGRectMake(80,30,SCREEN_WIDTH - 160, 30);
    [self.navView addSubview:self.titleLabel];
    //返回按钮
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 25,40, 40)];
    UIImage *image = [UIImage imageNamed:@"returnblack"];
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.backBtn setImage:image forState:UIControlStateNormal];
    [self.backBtn setImage:image forState:UIControlStateHighlighted];
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.backBtn];

    
    [self.view addSubview:self.loginView];
    self.loginView.passwordTextField.keyboardType = UIKeyboardTypeAlphabet;
    self.loginView.passwordTextField.secureTextEntry = YES;
    
}
/**点击登录页面返回按钮  切换登录方式*/
-(void)jumpToViewControllerWithTag:(NSInteger)buttonTag{
    if(buttonTag == 0){ //返回
        if([self.typeString isEqualToString:@"noback"]){
            //多台设备登录 被迫下
        }else{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }else{
        //跳转
        CodeLoginViewController *codeVC = [[CodeLoginViewController alloc] init];
        [self presentViewController:codeVC animated:YES completion:^{
            
        }];
        
    }
}

/**点击登录按钮  进入首页*/
-(void)loginWithtelphone:(NSString *)telphoneText andPassWord:(NSString *)psaaword{
    
    if (IsNilOrNull(telphoneText)){
        [self showNoticeView:CheckMsgPhoneNull];
        return;
    }
    
    if ([telphoneText hasPrefix:@"1"]) {
        if(![NSString isMobile:telphoneText]){
            [self showNoticeView:CheckMsgPhoneError];
            return;
        }
    }
    
    if(IsNilOrNull(psaaword)){
        [self showNoticeView:CheckMsgPwNull];
        return;
    }
    
    weixinHeaimageUrl = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:kheamImageurl]];
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    //devicetype  仅在登陆接口传递
    NSString *loginUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,ckLogin_Url];
    
    NSDictionary *appDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [appDic objectForKey:@"CFBundleShortVersionString"];
    NSString *devicetype = [NSString stringWithFormat:@"ios%@", version];
    
    NSDictionary *pramaDic = @{@"mobile":telphoneText,@"password":psaaword,DeviceId:uuid,@"devicetype": devicetype};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:loginUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if ([code integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        NSString *orderid = [NSString stringWithFormat:@"%@",dict[@"orderid"]];
        if (IsNilOrNull(orderid)) {
            orderid = @"";
        }
        [KUserdefaults setObject:orderid forKey:DLBORDERID];
        
        NSString *ordermoney = [NSString stringWithFormat:@"%@",dict[@"ordermoney"]];
        if (IsNilOrNull(ordermoney)) {
            ordermoney = @"0.00";
        }
        [KUserdefaults setObject:ordermoney forKey:DLBORDERMoney];
        
        NSString *unionid = [NSString stringWithFormat:@"%@",dict[@"unionid"]];
        if (IsNilOrNull(unionid)) {
            unionid = @"";
        }
        [KUserdefaults setObject:unionid forKey:Kunionid];

        
        //微信头像
        NSString *headurl = [NSString stringWithFormat:@"%@",dict[@"headurl"]];
        NSString *picUrl = [NSString loadImagePathWithString:headurl];
        [KUserdefaults setObject:picUrl forKey:kheamImageurl];
        
        //微信昵称
        NSString *smallname = [NSString stringWithFormat:@"%@",dict[@"smallname"]];
        if (IsNilOrNull(smallname)) {
            smallname = @"";
        }
        [KUserdefaults setObject:smallname forKey:KnickName];
        
        NSString *ckid = [NSString stringWithFormat:@"%@",dict[@"ckid"]];
        if (IsNilOrNull(ckid)) {
            ckid = @"";
        }
        [KUserdefaults setObject:ckid forKey:Kckid];
        
        NSString *realname = [NSString stringWithFormat:@"%@",dict[@"realname"]];
        if (IsNilOrNull(realname)) {
            realname = @"";
        }
        [KUserdefaults setObject:realname forKey:Krealname];
        
        NSString *device = [CommonMethod getCurrentDeviceModel];
        if (![device isEqualToString:@"iPhoneSimulator"]) {
            //登录成功后需要再上传一次deviceToken
            NSString *auth = [KUserdefaults objectForKey:CKAppServerPushToken];
            NSString *url = [NSString stringWithFormat:@"%@%@", PushService, updateDeviceToken];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (!IsNilOrNull(auth)) {
                [params setObject:auth forKey:@"auth"];
                [params setObject:KCKidstring forKey:@"itemId"];
                [HttpTool postWithUrl:url params:params success:^(id json) {
                    NSLog(@"上传deviceToken成功");
                    NSString *au = [NSString stringWithFormat:@"登录上传deviceToken成功%@", auth];
                    [KUserdefaults setObject:au forKey:CKAppUpdateTokenStatus];

                    NSLog(@"token:%@", auth);
                } failure:^(NSError *error) {
                    NSLog(@"上传deviceToken失败");
                    [KUserdefaults setObject:@"登录上传deviceToken失败" forKey:CKAppUpdateTokenStatus];

                }];
            }
        }
        //请求token 连接融云服务器
        [self setupRongTokenDataWithckid:ckid andName:smallname andHead:picUrl];
        
        //推广员登录  非推广员登录0是正常创客  非0 保存为推广员id
        NSString *sales = [NSString stringWithFormat:@"%@", dict[@"sales"]];
        if (IsNilOrNull(sales)) {
            sales = @"0";
        }
        [KUserdefaults setObject:sales forKey:KSales];
        
        //店铺名称
        NSString *shopName = [NSString stringWithFormat:@"%@",dict[@"name"]];
        if (IsNilOrNull(shopName)) {
            shopName = @"";
        }
        [KUserdefaults setObject:shopName forKey:KshopName];
        
        NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
        if (IsNilOrNull(type)) {
            type = @"";
        }
        [KUserdefaults setObject:type forKey:Ktype];
        
        NSString *joinType = [NSString stringWithFormat:@"%@",dict[@"jointype"]];
        if (IsNilOrNull(joinType)) {
            joinType = @"";
        }
        [KUserdefaults setObject:joinType forKey:KjoinType];
        
        NSString *status = [NSString stringWithFormat:@"%@",dict[@"status"]];
        if(IsNilOrNull(status)) {
            status = @"";
        }
        [KUserdefaults setObject:status forKey:KStatus];
        
        //登录成功 刷新首页和个人中心
        [KUserdefaults setObject:@"minelogin" forKey:KMineLoginStatus];
        [KUserdefaults setObject:@"homelogin" forKey:KHomeLoginStatus];
        
        
        //保存登录的账号 退出登录的时候需要传
        [KUserdefaults setObject:telphoneText forKey:Kmobile];
        [KUserdefaults synchronize];
        
        [[CacheManager shareInstance] cleanDBCacheData];

        //登录成功之后  设置别名和标签   设置userId  昵称 头像
        
        if ([sales isEqualToString:@"0"]){
            //普通创客登录
            [JPUSHService setTags:0 alias:ckid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"\n[登录成功后设置别名]---[%@]",iAlias);
                if(iResCode != 0){
                    [JPUSHService setTags:0 alias:ckid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        NSLog(@"\n登录重置别名---[%@]",iAlias);
                    }];
                    
                }
            }];
        }else{
            NSString *ckidStr = [NSString stringWithFormat:@"%@_%@",sales,ckid];
            //推广人登录
            [JPUSHService setTags:0 alias:ckidStr fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"\n[推广人登录成功后设置别名]---[%@]",iAlias);
                if(iResCode != 0){
                    [JPUSHService setTags:0 alias:ckidStr fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        NSLog(@"\n登录重置别名---[%@]",iAlias);
                    }];
                    
                }
            }];
            
        }
        
        //2018.3.27添加通知，刷新消息列表
        [CKCNotificationCenter postNotificationName:@"ReloadMsgCenterDataNoti" object:nil];
        
        //完全成功之后关闭所有present页面
        UIViewController *presentVC = self.presentingViewController;
        while (presentVC.presentingViewController) {
            presentVC = presentVC.presentingViewController;
        }
        [presentVC dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}
-(void)setupRongTokenDataWithckid:(NSString *)ckid andName:(NSString *)smallName andHead:(NSString *)headImageUrl{
    if(IsNilOrNull(smallName)){
        smallName = ckid;
    }
    if(IsNilOrNull(headImageUrl)){
        headImageUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,DefaultHeadPath];
    }
    
    NSString *rongClound_Token = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:ckid]];
    if (IsNilOrNull(rongClound_Token)){ //本地无token
        NSString *uuid = DeviceId_UUID_Value;
        if (IsNilOrNull(uuid)){
            uuid = @"";
        }
        
        NSDictionary *pramaDic = @{@"id":ckid,@"name":smallName,@"pic":headImageUrl,DeviceId:uuid};
        NSString *rongUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getRongYunToken];
        
        [HttpTool postWithUrl:rongUrl params:pramaDic success:^(id json) {
            NSDictionary *dict = json;
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
            if (![code isEqualToString:@"200"]) {
                return ;
            }
            _tokenStr = [NSString stringWithFormat:@"%@",dict[@"token"]];
            [self connectRCServerWithToken:_tokenStr ckid:ckid smallName:smallName headPath:headImageUrl];
            [KUserdefaults setObject:_tokenStr forKey:ckid];
            [KUserdefaults synchronize];
            
        } failure:^(NSError *error) {
            NSLog(@"token错误");
        }];
        
    }else{
        [self connectRCServerWithToken:rongClound_Token ckid:ckid smallName:smallName headPath:headImageUrl];
    }
    
}
-(void)connectRCServerWithToken:(NSString *)tokenStr ckid:(NSString *)ckid smallName:(NSString *)smallName headPath:(NSString *)headPath{
    //链接融云服务器
    [[RCIM sharedRCIM] connectWithToken:tokenStr success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        //设置当前登录的用户信息（不设置也有头像  获取token的时候已经把 头像传入）
        [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:smallName portrait:headPath];
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%zd", status);
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
        NSDictionary *refreshPramaDic = @{@"id":ckidString,@"name":_smallName,@"pic":weixinHeaimageUrl,DeviceId:uuid};
        [HttpTool postWithUrl:refreshUrl params:refreshPramaDic success:^(id json) {
            NSDictionary *dict = json;
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
            if (![code isEqualToString:@"200"]) {
                return ;
            }
            NSString *token = [NSString stringWithFormat:@"%@",dict[@"token"]];
            [KUserdefaults setObject:token forKey:ckidString];
            [KUserdefaults synchronize];
            
        } failure:^(NSError *error) {
            NSLog(@"token错误");
        }];
        
    }];
}

-(void)backClick:(UIButton*)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
