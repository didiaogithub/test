//
//  LoginViewController.m
//  CKYSPlatform
//
//  Created by ckys on 16/7/11.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "CodeLoginViewController.h"
#import "LoginViewController.h"
#import "LoginView.h"
#import "DMineViewController.h"
//融云
#import <RongIMKit/RongIMKit.h>
#import "CacheManager.h"


@interface CodeLoginViewController ()<LoginViewDelegate>
{
    NSString *_valitedStr;
    NSString *_weixinHeaimageUrl;
    NSString *_smallName;
    NSString *_ckidStr;
    NSString *_tokenStr;
}

@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, copy) NSString *codePhone;

@end

@implementation CodeLoginViewController

-(LoginView *)loginView{
    if (_loginView == nil) {
        _loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andTypeStr:@"2"];
        _loginView.delegate = self;
    }
    return _loginView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _weixinHeaimageUrl = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:kheamImageurl]];
    _smallName = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KnickName]];

    [self createViews];
    if([self.typeString isEqualToString:@"noback"]){
        self.loginView.returnImageView.hidden = YES;
    }else{
        self.loginView.returnImageView.hidden = NO;
    }
}

-(void)createViews{
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
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
    
        }];
    }
}
/**点击登录按钮  进入首页*/
-(void)loginWithtelphone:(NSString *)telphoneText andPassWord:(NSString *)psaaword{
    
    _weixinHeaimageUrl = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:kheamImageurl]];
    if (IsNilOrNull(telphoneText)) {
        [self showNoticeView:CheckMsgPhoneNull];
        return;
    }
    
    if ([telphoneText hasPrefix:@"1"]) {
        if(![NSString isMobile:telphoneText]){
            [self showNoticeView:CheckMsgPhoneError];
            return;
        }
    }

   //验证码登录
    if(IsNilOrNull(psaaword)){
        [self showNoticeView:CheckMsgVerificationCodeNull];
        return;
    }

    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
  //验证码登录
    if (![psaaword isEqualToString:_valitedStr] || ![_codePhone isEqualToString:telphoneText]) {
        [self showNoticeView:CheckMsgVerificationCodeError];
        return;
    }
    //devicetype  仅在登陆接口传递
        
    NSString *loginUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,ckLoginValidateCode_Url];
    
    NSDictionary *appDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [appDic objectForKey:@"CFBundleShortVersionString"];
    NSString *devicetype = [NSString stringWithFormat:@"ios%@", version];
    NSDictionary *pramaDic = @{@"mobile":telphoneText,@"validatecode":_valitedStr,DeviceId:uuid,@"devicetype": devicetype};
    
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
        //登录成功刷新首页和个人中心
        [KUserdefaults setObject:@"minelogin" forKey:KMineLoginStatus];
        [KUserdefaults setObject:@"homelogin" forKey:KHomeLoginStatus];
        
       
        //登录成功之后 发一个通知 如果是推广人登陆的话 需要调换我的页面和消息页面
        NSString *headurl = [NSString stringWithFormat:@"%@",dict[@"headurl"]];
        
        NSString *picUrl = [NSString loadImagePathWithString:headurl];
        [KUserdefaults setObject:picUrl forKey:kheamImageurl];
    
        NSString *orderid = [NSString stringWithFormat:@"%@",dict[@"orderid"]];
        if (IsNilOrNull(orderid)) {
            orderid = @"";
        }
        
        NSString *ordermoney = [NSString stringWithFormat:@"%@",dict[@"ordermoney"]];
        if (IsNilOrNull(ordermoney)) {
            ordermoney = @"0.00";
        }

        
        NSString *unionid = [NSString stringWithFormat:@"%@",dict[@"unionid"]];
        if (IsNilOrNull(unionid)) {
            unionid = @"";
        }
        [KUserdefaults setObject:unionid forKey:Kunionid];
        
        //微信昵称
        NSString *smallname = [NSString stringWithFormat:@"%@",dict[@"smallname"]];
        if (IsNilOrNull(smallname)){
            smallname = @"";
        }
        [KUserdefaults setObject:smallname forKey:KnickName];

        NSString *ckid = [NSString stringWithFormat:@"%@",dict[@"ckid"]];
        if (IsNilOrNull(ckid)) {
            ckid = @"";
        }
        [KUserdefaults setObject:ckid forKey:Kckid];
       
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
        
        //真实姓名
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
            if (!IsNilOrNull(auth)) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:auth forKey:@"auth"];
                [params setObject:KCKidstring forKey:@"itemId"];
                [HttpTool postWithUrl:url params:params success:^(id json) {
                    NSLog(@"上传deviceToken成功");
                    [KUserdefaults setObject:@"上传deviceToken成功" forKey:CKAppUpdateTokenStatus];
                    NSLog(@"token:%@", auth);
                } failure:^(NSError *error) {
                    NSLog(@"上传deviceToken失败");
                    [KUserdefaults setObject:@"上传deviceToken失败" forKey:CKAppUpdateTokenStatus];
                }];
            }
        }
        
        //设置token
        [self setupRongTokenDataWithckid:ckid andName:smallname andHead:picUrl];
        
        //推广员登录  非推广员登录 0 是正常创客  非0 保存为推广员id
        NSString *sales = [NSString stringWithFormat:@"%@",dict[@"sales"]];
        if (IsNilOrNull(sales)) {
            sales = @"0";
        }
        [KUserdefaults setObject:sales forKey:KSales];
        
        NSString *status = [NSString stringWithFormat:@"%@",dict[@"status"]];
        if(IsNilOrNull(status)){
           status = @"";
        }
        [KUserdefaults setObject:status forKey:KStatus];
        
        //验证码登录保存账号 退出登录需要
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
        }else{ //推广人登录
            NSString *ckidStr = [NSString stringWithFormat:@"%@_%@",sales,ckid];
            //推广人登录
            [JPUSHService setTags:0 alias:ckidStr fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"\n[登录成功后设置别名]---[%@]",iAlias);
                if(iResCode != 0){
                    [JPUSHService setTags:0 alias:ckidStr fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        NSLog(@"\n登录重置别名---[%@]",iAlias);
                    }];
                    
                }
            }];
        
        }
        
        //2018.3.27添加通知，刷新消息列表
        [CKCNotificationCenter postNotificationName:@"ReloadMsgCenterDataNoti" object:nil];
        //完全成功之后关闭所有present的界面
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
        if (IsNilOrNull(ckid)){
            ckid = @"";
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
            [self connctRCServerWithToken:_tokenStr ckid:ckid smallName:smallName headPath:headImageUrl];
            [KUserdefaults setObject:_tokenStr forKey:ckid];
            [KUserdefaults synchronize];
            
        } failure:^(NSError *error) {
                NSLog(@"token错误");
        }];
        
    }else{  //本地有token
        [self connctRCServerWithToken:rongClound_Token ckid:ckid smallName:smallName headPath:headImageUrl];
    }
}
-(void)connctRCServerWithToken:(NSString *)token ckid:(NSString *)ckid smallName:(NSString *)smallName headPath:(NSString *)headPath{
   
    //链接融云服务器
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        //设置当前登录的用户信息（不设置也有头像  获取token的时候已经把 头像传入）
        [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:smallName portrait:headPath];
        
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
        NSDictionary *refreshPramaDic = @{@"id":ckidString,@"name":smallName,@"pic":headPath,DeviceId:uuid};
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
/**点击获取验证码*/
-(void)getVertifyCodeWithButton:(STCountDownButton *)button{
    NSString *phoneText = self.loginView.telphoneTextField.text;
    if (IsNilOrNull(phoneText)){
        [self showNoticeView:CheckMsgPhoneNull];
        return;
    }
    
    //1开头的默认为大陆号码，增加验证
    if(![NSString isMobile:phoneText]){
        [self showNoticeView:CheckMsgPhoneError];
        return;
    }
   
    [button start];
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramdDic = @{@"telNo":phoneText,DeviceId:uuid,@"param":@"1", @"devtype":@"2", @"apptype":@"1"};
    NSString *codeUrl = [NSString stringWithFormat:@"%@%@",PostMessageAPI, sendMsg_Url];
    [HttpTool postWithUrl:codeUrl params:pramdDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        _valitedStr = [NSString stringWithFormat:@"%@",dict[@"validStr"]];
        _codePhone = phoneText;
        NSLog(@"手机号码:%@获取的验证码:%@", _codePhone, _valitedStr);
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)dealloc{
    [CKCNotificationCenter removeObserver:self];
}
@end
