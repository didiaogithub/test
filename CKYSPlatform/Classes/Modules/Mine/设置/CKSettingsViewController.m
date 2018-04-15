//
//  CKSettingsViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/6.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKSettingsViewController.h"
#import "WebDetailViewController.h"
#import "CacheManager.h"
#import "CKCUpdateAlertView.h"
#import "CKMainPageModel.h"

@interface CKSettingsViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *updateView;
@property (nonatomic, strong) UILabel *versionLable;
@property (nonatomic, strong) UIButton *versionButton;
@property (nonatomic, strong) UIButton *clearCacheBtn;
@property (nonatomic, copy)   NSString *ckidString;
@property (nonatomic, copy)   NSString *localversionStr;
@property (nonatomic, copy)   NSString *severVersionStr; //服务器返回版本
@property (nonatomic, copy)   NSString *localBuildStr;
@property (nonatomic, copy)   NSString *downLoadUrl;
@property (nonatomic, copy)   NSString *status;
@property (nonatomic, assign) BOOL isCheckVersion;
@property (nonatomic, assign) BOOL isLogOut;
@property (nonatomic, copy) NSString *checkStatus;

@end

@implementation CKSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
    [self getIsIosCheckData];
    [CKCNotificationCenter addObserver:self selector:@selector(toLogOut) name:@"logout" object:nil];
    //获取项目版本号
    _localversionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //获取build版本号
    _localBuildStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [self createViews];
    
}

#pragma mark - 是否显示检查更新按钮
- (void)getIsIosCheckData {
    NSString *isIosCheckUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, IsIosCheck_Url];
    [HttpTool postWithUrl:isIosCheckUrl params:nil success:^(id json) {
        NSDictionary *dic = json;
        if([dic[@"code"] integerValue] != 200){
            return;
        }
        _checkStatus = [NSString stringWithFormat:@"%@",dic[@"code"]];
        if ([_checkStatus isEqualToString:CheckSuccessCode]){ //审核通过
            _updateView.hidden = NO;
            [_versionButton setTitle:@"检查更新" forState:UIControlStateNormal];
            [_updateView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_topView.mas_bottom).offset(AdaptedHeight(10));
                make.height.mas_offset(AdaptedHeight(50));
            }];
        }else{ //审核中
            _updateView.hidden = YES;
            [_updateView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(AdaptedHeight(0));
            }];
        }
    } failure:^(NSError *error) {
        NSLog(@"网络请求超时,请刷新重试");
    }];
    
}

- (void)createViews {
    
    //logo图  及版本号
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0,AdaptedHeight(10)+64+NaviAddHeight, SCREEN_WIDTH,AdaptedHeight(260))];
    [self.view addSubview:_topView];
    _topView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    [_topView addSubview:logoImageView];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    logoImageView.image = [UIImage imageNamed:@"logockys"];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(40));
        make.left.mas_offset(SCREEN_WIDTH/2-AdaptedWidth(63.5));
        make.width.mas_offset(AdaptedWidth(127));
        make.height.mas_offset(119);
    }];
    
    float topH,bottomH = 0;
    if (iphone4) {
        topH = AdaptedHeight(10);
        bottomH = AdaptedHeight(15);
    }else if (iphone5){
        topH = AdaptedHeight(20);
        bottomH = AdaptedHeight(20);
    }else{
        topH = AdaptedHeight(40);
        bottomH = AdaptedHeight(50);
    }
    
    _versionLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [_topView addSubview:_versionLable];
    [_versionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageView.mas_bottom).offset(topH);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-bottomH);
        
    }];
    
    //检查更新
    _updateView = [[UIView alloc] init];
    [self.view addSubview:_updateView];
    [_updateView setBackgroundColor:[UIColor whiteColor]];
    [_updateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_offset(0);
    }];
    
    //检查更新按钮  是否更新
    _versionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_updateView addSubview:_versionButton];
    [_versionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_updateView);
    }];
    _versionButton.titleLabel.font = MAIN_TITLE_FONT;
    [_versionButton setTitleColor:TitleColor forState:UIControlStateNormal];
    [_versionButton addTarget:self action:@selector(clickVersionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //协议
    UIView * protocalView = [[UIView alloc] init];
    [self.view addSubview:protocalView];
    [protocalView setBackgroundColor:[UIColor whiteColor]];
    [protocalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_updateView.mas_bottom).offset(AdaptedHeight(10));
        make.height.mas_offset(AdaptedHeight(50));
        make.left.right.mas_offset(0);
    }];
    
    float imageH = 0;
    if (iphone4) {
        imageH = 0;
    }else{
        imageH = AdaptedHeight(15);
    }
    UIImageView *leftImageView = [[UIImageView alloc] init];
    [protocalView addSubview:leftImageView];
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftImageView setImage:[UIImage imageNamed:@"ckys"]];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(imageH);
        make.left.mas_offset((SCREEN_WIDTH-30)/3);
        make.width.mas_offset(53);
        make.bottom.mas_offset(-imageH);
    }];
    
    UILabel *rightLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [protocalView addSubview:rightLable];
    rightLable.text = @"创客村协议";
    [rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).offset(5);
        make.top.bottom.equalTo(leftImageView);
        make.width.mas_offset(100);
    }];
    
    
    UIButton *protocalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [protocalView addSubview:protocalButton];
    [protocalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(protocalView);
    }];
    [protocalButton addTarget:self action:@selector(clickProtocalButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:leaveButton];
    [leaveButton setBackgroundColor:[UIColor tt_bigRedBgColor]];
    [leaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(0-BOTTOM_BAR_HEIGHT);
        make.height.mas_offset(50);
    }];
    leaveButton.titleLabel.font = NAV_BAR_FONT;
    [leaveButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [leaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leaveButton addTarget:self action:@selector(clickLeaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [self refreshVersionLable];
    
    
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if(IsNilOrNull(homeLoginStatus)){
        NSString *unionid = [KUserdefaults objectForKey:Kunionid];
        if(IsNilOrNull(unionid)){
            leaveButton.hidden = YES;
        }else{
            leaveButton.hidden = NO;
            [leaveButton setTitle:@"退出" forState:UIControlStateNormal];
        }
    }else{
        leaveButton.hidden = NO;
        [leaveButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    }
    
    
}

- (void)refreshVersionLable {
    NSLog(@"%@",self.checkStatus);
    _versionLable.text = [NSString stringWithFormat:@"当前版本：V%@", _localversionStr];
}

#pragma mark - 点击检查版本更新
- (void)clickVersionButton:(UIButton *)button {
    
    button.userInteractionEnabled = NO;
    _isCheckVersion = YES;
    _isLogOut = NO;
    
    //如果本地 的和服务器的 比较
    [[MessageAlert shareInstance] hiddenCancelBtn:NO];
    [MessageAlert shareInstance].isDealInBlock = YES;
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{DeviceId:uuid};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getSomePath_Url];
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        button.userInteractionEnabled = YES;
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            return ;
        }
        
        //ckappcoupon  我的优惠券 显示开关  1：开启   其它： 关闭
        NSString *ckappcoupon = [dict objectForKey:@"ckappcoupon"];
        if (!IsNilOrNull(ckappcoupon)) {
            [KUserdefaults setObject:ckappcoupon forKey:@"CKYS_ckappcoupon"];
        }
        //ckappgift  考试显示开关：  1：开启   其它：关闭
        NSString *ckappgift = [dict objectForKey:@"ckappgift"];
        if (!IsNilOrNull(ckappgift)) {
            [KUserdefaults setObject:ckappgift forKey:@"CKYS_ckappgift"];
        }
        
        
        // ckappleader 我的管理者显示开关 ：显示开关 1：开启 其他：关闭
        NSString *ckappleader = [dict objectForKey:@"ckappleader"];
        if (!IsNilOrNull(ckappleader)) {
            [KUserdefaults setObject:ckappleader forKey:@"CKYS_ckappleader"];
        }
        //月结模式开关
        NSString *monthcalmode = [NSString stringWithFormat:@"%@", dict[@"monthcalmode"]];
        if (IsNilOrNull(monthcalmode)) {
            monthcalmode = @"";
        }
        [KUserdefaults setObject:monthcalmode forKey:@"CKYS_monthcalmode"];
        
        NSString *payalertmsg = [NSString stringWithFormat:@"%@", dict[@"payalertmsg"]];
        if (IsNilOrNull(payalertmsg)) {
            payalertmsg = @"";
        }
        [KUserdefaults setObject:payalertmsg forKey:@"payalertmsg"];
        
        
        NSString *ckappverinfo = [dict objectForKey:@"ckappverinfo"];
        if (!IsNilOrNull(ckappverinfo)) {
            [KUserdefaults setObject:ckappverinfo forKey:@"CKYS_updateInfo"];
        }
        
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _localBuildStr = currentVersion;
        _severVersionStr = [NSString stringWithFormat:@"%@", [dict objectForKey:@"ckappiosver"]];
        
        NSString *ckappiosver = [dict objectForKey:@"ckappiosver"];
        if (!IsNilOrNull(ckappiosver)) {
            [KUserdefaults setObject:ckappiosver forKey:ServerVersion];
        }
        
        NSString *ckappiosforce = [dict objectForKey:@"ckappiosforce"];
        if (!IsNilOrNull(ckappiosforce)) {
            [KUserdefaults setObject:ckappiosforce forKey:Forceupdate];
        }
        
        NSString *downLoadUrl = [NSString stringWithFormat:@"%@",dict[@"downurl"]];
        if (IsNilOrNull(downLoadUrl)) {
            downLoadUrl = @"";
        }
        [KUserdefaults setObject:downLoadUrl forKey:AppStoreUrl];
        [KUserdefaults synchronize];
        
        _downLoadUrl = downLoadUrl;
        
        //如果本地 的和服务器的 比较
        if ([currentVersion isEqualToString:_severVersionStr]) {
            MessageAlert *updateAlert = [MessageAlert shareInstance];
            NSString *content = @"当前已经是最新版本";
            [updateAlert hiddenCancelBtn:YES];
            [updateAlert showCommonAlert:content btnClick:^{
                [self goloUpadate];
            }];
            
        }else if([currentVersion compare:_severVersionStr] == NSOrderedAscending){
            if (!IsNilOrNull(ckappiosforce) && [ckappiosforce isEqualToString:@"1"]) {
                [[CKCUpdateAlertView shareInstance] showUpdateAlert:ckappverinfo forceUpdate:YES];
            }else{
                [[CKCUpdateAlertView shareInstance] showUpdateAlert:ckappverinfo forceUpdate:NO];
            }
        }else{
            MessageAlert *updateAlert = [MessageAlert shareInstance];
            NSString *content = @"当前已经是最新版本";
            [updateAlert hiddenCancelBtn:YES];
            [updateAlert showCommonAlert:content btnClick:^{
                [self goloUpadate];
            }];
        }
        
        
    } failure:^(NSError *error) {
        button.userInteractionEnabled = YES;
    }];
}

#pragma mark - 点击确定 去更新
- (void)goloUpadate {
    
    if ([_localBuildStr isEqualToString:_severVersionStr]) {
        
    }else if([_localBuildStr compare:_severVersionStr] == NSOrderedAscending){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downLoadUrl]];
    }else{
        
    }
}

#pragma mark - 点击创客村协议
- (void)clickProtocalButton {
    NSLog(@"点击协议");
    NSString *ckcxyurl = @"";
    RLMResults *result = [[CacheData shareInstance] search:[CKMainPageModel class]];
    if (result.count > 0) {
        CKMainPageModel *mainM = result.firstObject;
        ckcxyurl = [NSString stringWithFormat:@"%@", mainM.ckcxyurl];
    }
    //    RLMRealm *realm = [RLMRealm defaultRealm];
    //    [realm invalidate];
    WebDetailViewController *protocal = [[WebDetailViewController alloc] init];
    protocal.typeString = @"protocal";
    protocal.detailUrl = ckcxyurl;
    [self.navigationController pushViewController:protocal animated:YES];
}

#pragma mark - 点击退出按钮
- (void)clickLeaveButton:(UIButton *)button {
    
    [[MessageAlert shareInstance] hiddenCancelBtn:NO];
    [MessageAlert shareInstance].isDealInBlock = YES;
    
    
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if(IsNilOrNull(homeLoginStatus)){
        NSString *unionid = [KUserdefaults objectForKey:Kunionid];
        if(!IsNilOrNull(unionid)){
            [[MessageAlert shareInstance] showCommonAlert:@"确定退出?" btnClick:^{
                [self gotoLogOut];
            }];
        }
    }else{
        [[MessageAlert shareInstance] showCommonAlert:@"确定退出登录?" btnClick:^{
            [self gotoLogOut];
        }];
    }
}

#pragma mark-退出登录
- (void)gotoLogOut {
    [KUserdefaults setObject:@"" forKey:KStatus];
    [KUserdefaults setObject:@"" forKey:Ktype];
    [KUserdefaults setObject:@"" forKey:KjoinType];
    [KUserdefaults setObject:@"" forKey:Krealname];
    [KUserdefaults setObject:@"" forKey:kheamImageurl];
    [KUserdefaults setObject:@"" forKey:KSales];
    [KUserdefaults setObject:@"" forKey:Kunionid];
    [KUserdefaults setObject:@"" forKey:KnickName];
    [KUserdefaults setObject:@"" forKey:KopenID];
    [KUserdefaults setObject:@"" forKey:Kpassword];
    [KUserdefaults setObject:@"" forKey:KshopName];
    [KUserdefaults setObject:@"" forKey:@"CKYS_USER_HEAD"];
    [KUserdefaults setObject:@"" forKey:@"Kgettermobile"];
    
    [KUserdefaults synchronize];
    //断开与融云服务器的连接，并不再接收远程推送
    [[RCloudManager manager] logout];

    [JPUSHService setTags:0 alias:@"0" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"\n[JPush设置别名]---[%@]",iAlias);
    }];
    
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    switch (status) {
        case RequestReachabilityStatusReachableViaWiFi:
        case RequestReachabilityStatusReachableViaWWAN:{
            NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
            if(IsNilOrNull(homeLoginStatus)){
                [KUserdefaults setObject:@"" forKey:Kckid];
                [KUserdefaults setObject:@"" forKey:Kmobile];
                
                [KUserdefaults setObject:@"" forKey:KMineLoginStatus];
                [KUserdefaults setObject:@"" forKey:KHomeLoginStatus];
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                //调用后台退出登录接口
                [self ckappLogOut];
            }
            
        }
            break;
        default: {
            
            [KUserdefaults setObject:@"" forKey:Kckid];
            [KUserdefaults setObject:@"" forKey:Kmobile];
            
            [KUserdefaults setObject:@"" forKey:KMineLoginStatus];
            [KUserdefaults setObject:@"" forKey:KHomeLoginStatus];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
            break;
    }
    
    
}

#pragma mark - 退出登录
- (void)ckappLogOut {
    //告诉后台退出登录  退出登录新增传递参数：mobile 登录账户，手机号码或推广号码
    NSString *ckidStr = KCKidstring;
    if (IsNilOrNull(ckidStr)){
        [KUserdefaults setObject:@"" forKey:Kckid];
        [KUserdefaults setObject:@"" forKey:Kmobile];
        [KUserdefaults setObject:@"" forKey:KMineLoginStatus];
        [KUserdefaults setObject:@"" forKey:KHomeLoginStatus];
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *loginNumber = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Kmobile]];
    if (IsNilOrNull(loginNumber)){
        loginNumber = @"";
    }
    NSDictionary *pramaDic = @{@"ckid":ckidStr, DeviceId:uuid, @"mobile":loginNumber};
    NSString *stockUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,loginOut_Url];
    [HttpTool postWithUrl:stockUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return;
        }
        NSLog(@"退出登录成功=====%@",dict[@"codeinfo"]);
        
        [KUserdefaults setObject:@"" forKey:Kckid];
        [KUserdefaults setObject:@"" forKey:Kmobile];
        
        //2017.7.17
        //[[CacheManager shareInstance] cleanAllCacheData];
        
        [KUserdefaults setObject:@"" forKey:KMineLoginStatus];
        [KUserdefaults setObject:@"" forKey:KHomeLoginStatus];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        [KUserdefaults setObject:@"" forKey:Kckid];
        [KUserdefaults setObject:@"" forKey:Kmobile];
        [KUserdefaults setObject:@"" forKey:KMineLoginStatus];
        [KUserdefaults setObject:@"" forKey:KHomeLoginStatus];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark-退出登录失败 再调用一次
- (void)toLogOut {
    [self ckappLogOut];
}

@end
