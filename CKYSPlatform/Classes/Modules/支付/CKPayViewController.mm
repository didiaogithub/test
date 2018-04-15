//
//  CKPayViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKPayViewController.h"
#import "PaymentTableViewCell.h"
#import "MoneyTableViewCell.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
//#import <PassKit/PassKit.h>
#import "UPPaymentControl.h"
//#import "UPAPayPlugin.h"
#import "PushManager.h"
#import "JDPAuthSDK.h"
#import "XWAlterVeiw.h"
#import <RongIMKit/RongIMKit.h>
#import "LoginViewController.h"

#import "DHomepageViewController.h"
#import "CKOrderViewController.h"
#import "DMineViewController.h"
#import "TopTipView.h"
#import "FFWarnAlertView.h"
#import "CKConfrimRegistMsgViewController.h"

/**微信*/
#define JionPay_WX @"pay/appmall_pay/weixin/example/app.php"
/**支付宝*/
#define JionPay_Ali @"pay/appmall_pay/alipay/app.php"
/**银联支付~*/
#define JionPay_Union @"pay/appmall_pay/unionpay/pages/payinfo.php"
/**京东支付~*/
#define JionPay_JD @"pay/appmall_pay/jdpay/action/app.php"

@interface CKPayViewController ()<UITableViewDelegate, UITableViewDataSource, XWAlterVeiwDelegate, TopTipViewDelegate>
//@interface CKPayViewController ()<UITableViewDelegate, UITableViewDataSource, XWAlterVeiwDelegate, TopTipViewDelegate, UPAPayPluginDelegate>

@property (nonatomic, copy)   NSString *selectedType;
@property (nonatomic, strong) NSIndexPath *selIndex;//单选，当前选中的行
@property (nonatomic, strong) UITableView *paymentTableView;
@property (nonatomic, strong) NSMutableArray *payMethodArr;
@property (nonatomic, strong) NSMutableArray *summaryItems;
@property (nonatomic, strong) NSMutableArray *shippingMethods;
@property (nonatomic, strong) TopTipView *tipView;

@end

@implementation CKPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeComponent];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewDataLoading stopAnimation];
}

-(void)initializeComponent {
    self.navigationItem.title = @"支付";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RootNavigationBack"] style:UIBarButtonItemStylePlain target:self action:@selector(exitPay)];
    left.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.leftBarButtonItem = left;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10;
        self.navigationItem.leftBarButtonItems = @[spaceItem, left];
    }
    
    // 注册微信支付结果通知
    [CKCNotificationCenter addObserver:self selector:@selector(weixinPayCallBack:) name:WeiXinPay_CallBack object:nil];
    // 注册支付宝支付结果通知
    [CKCNotificationCenter addObserver:self selector:@selector(aliPayCallBack:) name:Alipay_CallBack object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(UUPay:) name:UnionPay_CallBack object:nil];
    
    [self createTableView];
    
    /**获取加盟需要支付的总金额和可用的支付方式*/
    [self getPayMethod];
}

-(void)getPayMethod {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{DeviceId:uuid};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getSomePath_Url];
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.payMethodArr removeAllObjects];
            _payMethodArr = [NSMutableArray arrayWithArray:[[DefaultValue shareInstance] getAvailablePaymentMethod]];
            [self.paymentTableView reloadData];
            [self.viewDataLoading stopAnimation];
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
        
        [KUserdefaults synchronize];
        
        [[PushManager manager] updatePaymentMethod:dict];
        [self updateDomain:dict];
        [_payMethodArr removeAllObjects];
        _payMethodArr = [NSMutableArray arrayWithArray:[[DefaultValue shareInstance] getAvailablePaymentMethod]];
        [self.paymentTableView reloadData];
        [self.viewDataLoading stopAnimation];

    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [_payMethodArr removeAllObjects];
        _payMethodArr = [NSMutableArray arrayWithArray:[[DefaultValue shareInstance] getAvailablePaymentMethod]];
        [self.paymentTableView reloadData];
        [self.viewDataLoading stopAnimation];
    }];
}

-(void)createTableView {
    
    //创建底部的支付按钮
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [bankImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [self.view addSubview:bankImageView];
    bankImageView.userInteractionEnabled = YES;
    bankImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(AdaptedWidth(35));
        make.right.mas_offset(-AdaptedWidth(35));
        make.bottom.mas_offset(-AdaptedHeight(50)-BOTTOM_BAR_HEIGHT);
        make.height.mas_offset(AdaptedHeight(40));
    }];
    //去支付
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankImageView addSubview:payButton];
    [payButton setTitle:@"去支付" forState:UIControlStateNormal];
    payButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(bankImageView);
    }];
    [payButton addTarget:self action:@selector(clickPayButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString *tempStr = @"若您选择线下刷卡支付，请点击跳过";
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankImageView.mas_bottom).offset(8);
        make.left.mas_offset(AdaptedWidth(5));
        make.right.mas_offset(-AdaptedWidth(5));
        make.height.mas_offset(AdaptedWidth(30));
    }];
    
    label.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:tempStr];
    NSRange range = [tempStr rangeOfString:@"击跳过"];
    NSRange range1 = NSMakeRange(range.location+1, range.length - 1);
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range1];
    [attr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range1];
    if (iphone5) {
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, tempStr.length)];
    }else{
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, tempStr.length)];
    }
    
    label.attributedText = attr;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(skipPayOrder) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_top);
        make.left.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    
    
    NSString *payalertmsg = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"payalertmsg"]];
    CGSize s = [payalertmsg boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 87, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    _tipView = [[TopTipView alloc] initWithFrame:CGRectMake(0, 5+64+NaviAddHeight, SCREEN_WIDTH, s.height>=30 ? 14+s.height : 44)];
    _tipView.delegate = self;
    [self.view addSubview:_tipView];
    
    
    _paymentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _paymentTableView.delegate  = self;
    _paymentTableView.dataSource = self;
    _paymentTableView.backgroundColor = [UIColor tt_grayBgColor];
    _paymentTableView.rowHeight = UITableViewAutomaticDimension;
    _paymentTableView.estimatedRowHeight = 44;
    if (@available(iOS 11.0, *)) {
        _paymentTableView.estimatedSectionHeaderHeight = 0.1;
        _paymentTableView.estimatedSectionFooterHeight = 0.1;
    }
    _paymentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_paymentTableView];
    [_paymentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(CGRectGetMaxY(_tipView.frame));
        make.left.right.mas_offset(0);
        make.bottom.equalTo(payButton.mas_top);
    }];
    
    if (IsNilOrNull(payalertmsg)) {
        [self.tipView removeFromSuperview];
        [_paymentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
        }];
    }else{
        self.tipView.tipLabel.text = payalertmsg;
        [_paymentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(CGRectGetMaxY(_tipView.frame));
        }];
    }
    
    NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    if (_payMethodArr.count > 0) {
        [self tableView:self.paymentTableView didSelectRowAtIndexPath:defaultIndexPath];
    }
    
}

#pragma mark - TopTipViewDelegate
- (void)topTipView:(TopTipView *)topView closeTip:(UIButton *)btn {
    [self.tipView removeFromSuperview];
    [self.paymentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
//        if ([_payMethodArr containsObject:@"applepay"]) {
//            if (![PKPaymentAuthorizationViewController class]) {
//                //PKPaymentAuthorizationViewController需iOS8.0以上支持
//                NSLog(@"操作系统不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
//                return _payMethodArr.count - 1;
//            }
//            //检查当前设备是否可以支付
//            if (![PKPaymentAuthorizationViewController canMakePayments]) {
//                //支付需iOS9.0以上支持
//                NSLog(@"设备不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
//                return _payMethodArr.count - 1;
//            }
//            //检查用户是否可进行某种卡的支付，是否支持Amex、MasterCard、Visa与银联四种卡，根据自己项目的需要进行检测
//            NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
//            if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
//                NSLog(@"没有绑定支付卡");
//                return _payMethodArr.count - 1;
//            }
//            return _payMethodArr.count;
//        }
        return _payMethodArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        MoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoneyTableViewCell"];
        if (cell == nil) {
            cell = [[MoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoneyTableViewCell"];
        }
        cell.backgroundColor = [UIColor tt_grayBgColor];
        
        NSString *payMoney = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:DLBORDERMoney]];
        if (IsNilOrNull(payMoney)) {
            self.payfee = @"0.00";
        }else{
            self.payfee = payMoney;
        }
        cell.moneyLable.text = [NSString stringWithFormat:@"¥%@", self.payfee];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentTableViewCell"];
        if (cell==nil) {
            cell = [[PaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PaymentTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor tt_grayBgColor]];
        
        NSString *paymentType = _payMethodArr[indexPath.row];
        if([paymentType isEqualToString:@"alipay"]){  //支付宝
            cell.leftIamgeView.image = [UIImage imageNamed:@"alipay"];
        }else if ([paymentType isEqualToString:@"wxpay"]){  //微信
            cell.leftIamgeView.image = [UIImage imageNamed:@"weixinpay"];
        }else if ([paymentType isEqualToString:@"unionpay"]){  //银联
            cell.leftIamgeView.image = [UIImage imageNamed:@"uupay"];
        }else if ([paymentType isEqualToString:@"jdpay"]){  //jdpay
            cell.leftIamgeView.image = [UIImage imageNamed:@"jdpay"];
        }else if ([paymentType isEqualToString:@"applepay"]){  //applePay
            cell.leftIamgeView.image = [UIImage imageNamed:@"Apple-Pay"];
        }
        
        NSInteger row = [indexPath row];
        NSInteger oldRow = [_selIndex row];
        if (row == oldRow && self.selIndex != nil){
            cell.rightButton.selected = YES;
        }else{
            cell.rightButton.selected = NO;
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = (self.selIndex != nil) ? (self.selIndex.row) : -1;
    if(indexPath.section == 1){  //只有选择支付方式时才进入此判断，否则会crash
        if (newRow != oldRow){
            PaymentTableViewCell *cell = (PaymentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            cell.rightButton.selected = YES;
            PaymentTableViewCell *oldCell = (PaymentTableViewCell *)[tableView cellForRowAtIndexPath:self.selIndex];
            oldCell.rightButton.selected = NO;
            self.selIndex = indexPath;
        }
        
        _selectedType = [NSString stringWithFormat:@"%@", _payMethodArr[indexPath.row]];
        NSLog(@"选择的行:%zd---类型:%@", newRow, _selectedType);
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section == 1){
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *textLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
        [headerView addSubview:textLable];
        [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            make.left.mas_offset(AdaptedWidth(30));
        }];
        textLable.text = @"选择支付方式:";
        return headerView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return AdaptedHeight(40);
    }else{
        return 0.1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark - 点击去支付
-(void)clickPayButton{
    if([_selectedType isEqualToString:@"alipay"]){  //支付宝
        [self clickAlipay];
    }else if ([_selectedType isEqualToString:@"wxpay"]){  //微信
        [self wxPayClick];
    }else if ([_selectedType isEqualToString:@"unionpay"]){  //银联
        [self UPPayClick];
    }else if ([_selectedType isEqualToString:@"jdpay"]){  //京东支付
        [self jdPayClick];
    }else if ([_selectedType isEqualToString:@"applepay"]){  //applePay
//        [self applePayClick];
    }
    
    NSLog(@"支付方式%@ ", _selectedType);
    if (IsNilOrNull(_selectedType)) {
        [self showNoticeView:@"请选择支付方式"];
    }
    
}

-(NSDictionary*)generalPayParams {
    NSDictionary *paramsDic = nil;
    if(!IsNilOrNull(self.orderId)){
        paramsDic = @{@"orderid": self.orderId};
    }
    return paramsDic;
}

#pragma mark - 支付宝支付处理
-(void)clickAlipay{
    self.paymentType = 2;
    self.appDelegate.paymentType = self.paymentType;
    
    NSString *alipayUrl= [NSString stringWithFormat:@"%@%@", WebServicePayAPI, JionPay_Ali];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    if (IsNilOrNull(self.orderId)) {
        self.orderId = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:DLBORDERID]];
    }
    [paramDict setValue:self.orderId forKey:@"orderId"];
    [paramDict setValue:app_Version forKey:@"ver"];
    [paramDict setValue:uuid forKey:@"deviceid"];
    [paramDict setValue:@"2" forKey:@"devtype"];
    [paramDict setValue:@"1" forKey:@"apptype"];
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:alipayUrl params:paramDict success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        
        NSString *code = [NSString stringWithFormat:@"%@", dict[@"code"]];
        if (!IsNilOrNull(code) && ![code isEqualToString:@"200"]) {
            NSString *codeinfo = [NSString stringWithFormat:@"%@", dict[@"codeinfo"]];
            if(codeinfo && codeinfo.length > 0){
//                [self showNoticeView:codeinfo];
                FFWarnAlertView *alertV = [[FFWarnAlertView alloc] init];
                alertV.titleLable.text = codeinfo;
                [alertV showFFWarnAlertView];
            }
            return ;
        }
        
        NSString *payorderString = dict[@"res"];
        NSString *appScheme = @"AlipayCKAPPckys";
        
        [[AlipaySDK defaultService] payOrder:payorderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            /**
             *  支付结果回调，支付宝会返回支付结果信息，一般是走这个方法。 网页端
             */
            NSLog(@"reslut = %@",resultDic);
            
            NSDictionary *userInfo = resultDic;
            NSInteger errCode = [[userInfo objectForKey:@"resultStatus"]integerValue];
            if (errCode == 9000) {
                //支付成功
                [self paySuccess];
            }else if(errCode == 6001){
                [self showNoticeView:@"用户中途取消"];
            }else if(errCode == 8000){
                [self showNoticeView:@"正在处理中，支付结果未知"];
            }else if(errCode == 4000){
                [self showNoticeView:@"订单支付失败"];
            }else if(errCode == 5000){
                [self showNoticeView:@"重复请求"];
            }else if(errCode == 6002){
                [self showNoticeView:@"网络连接出错"];
            }else if(errCode == 6004){
                [self showNoticeView:@"支付结果未知"];
            }else{
                [self showNoticeView:@"其他错误"];
            }
        }];
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        NSLog(@"支付宝错误===%@",error.localizedDescription);
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 监听支付宝支付完成跳转页面 app
- (void)aliPayCallBack:(NSNotification *)notification{
    
    self.paymentType = 2;
    self.appDelegate.paymentType = self.paymentType;
    NSDictionary *userInfo = notification.userInfo;
    NSInteger errCode = [[userInfo objectForKey:@"resultStatus"]integerValue];
    if (errCode == 9000) {
        //支付成功
        [self paySuccess];
    }else if(errCode == 6001){
        [self showNoticeView:@"用户中途取消"];
    }else if(errCode == 8000){
        [self showNoticeView:@"正在处理中，支付结果未知"];
    }else if(errCode == 4000){
        [self showNoticeView:@"订单支付失败"];
    }else if(errCode == 5000){
        [self showNoticeView:@"重复请求"];
    }else if(errCode == 6002){
        [self showNoticeView:@"网络连接出错"];
    }else if(errCode == 6004){
        [self showNoticeView:@"支付结果未知"];
    }else{
        [self showNoticeView:@"其他错误"];
    }
}

#pragma mark - 微信支付处理
- (void)wxPayClick {
    self.paymentType = 1;
    self.appDelegate.paymentType = self.paymentType;
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    NSString *WeixinUrl = [NSString stringWithFormat:@"%@%@", WebServicePayAPI, JionPay_WX];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    if (IsNilOrNull(self.orderId)) {
        self.orderId = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:DLBORDERID]];
    }
    [paramDict setValue:self.orderId forKey:@"orderId"];
    [paramDict setValue:app_Version forKey:@"ver"];
    [paramDict setValue:uuid forKey:@"deviceid"];
    [paramDict setValue:@"2" forKey:@"devtype"];
    [paramDict setValue:@"1" forKey:@"apptype"];
    
    [HttpTool postWithUrl:WeixinUrl params:paramDict success:^(id json) {
        [self.viewDataLoading stopAnimation];
        
        NSDictionary *dict = json;
        
        NSString *code = [NSString stringWithFormat:@"%@", dict[@"code"]];
        if (!IsNilOrNull(code) && ![code isEqualToString:@"200"]) {
            NSString *codeinfo = [NSString stringWithFormat:@"%@", dict[@"codeinfo"]];
            if(codeinfo && codeinfo.length > 0){
                //                [self showNoticeView:codeinfo];
                FFWarnAlertView *alertV = [[FFWarnAlertView alloc] init];
                alertV.titleLable.text = codeinfo;
                [alertV showFFWarnAlertView];
            }
            return ;
        }
        
        NSLog(@"json===%@",json);
        NSString *nonce_str = [json objectForKey:@"noncestr"];
        NSString *prepayId = [json objectForKey:@"prepayid"];
        NSString *sign = [json objectForKey:@"sign"];
        NSString *timestamp = [json objectForKey:@"timestamp"];
        NSString *package = [json objectForKey:@"package"];
        
        PayReq* req             = [[PayReq alloc]init];
        req.partnerId           = WXCommercialTenantId; //微信商户ID
        req.prepayId            = prepayId;
        req.nonceStr            = nonce_str;
        req.timeStamp           = timestamp.intValue;
        req.package             = package;
        req.sign                = sign;
        [WXApi sendReq:req];
        NSLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign);
        
    } failure:^(NSError *error){
        [self.viewDataLoading stopAnimation];
        NSLog(@"微信错误===%@",error.localizedDescription);
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 监听微信支付完成跳转页面
- (void)weixinPayCallBack:(NSNotification *)notification{
    self.paymentType = 1;
    self.appDelegate.paymentType = self.paymentType;
    NSString *object= [NSString stringWithFormat:@"%@",notification.object];
    if ([object isEqualToString:@"0"]) { //成功之后
        //支付成功
        [self paySuccess];
    }else if ([object isEqualToString:@"-1"]){
        [self showNoticeView:@"支付失败"];
    }else if ([object isEqualToString:@"-2"]){
        [self showNoticeView:@"用户中途取消"];
    }else if ([object isEqualToString:@"-3"]){
        [self showNoticeView:@"发送失败"];
    }else if ([object isEqualToString:@"-4"]){
        [self showNoticeView:@"授权失败"];
    }else if ([object isEqualToString:@"-5"]){
        [self showNoticeView:@"微信不支持"];
    }else{
        [self showNoticeView:@"其他错误"];
    }
}

#pragma mark - 银联支付
-(void)UPPayClick {
    NSLog(@"银联支付");
    self.paymentType = 3;
    self.appDelegate.paymentType = self.paymentType;
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    NSString *upPayUrl= [NSString stringWithFormat:@"%@%@", WebServiceUnitPayAPI, JionPay_Union];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    if (IsNilOrNull(self.orderId)) {
        self.orderId = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:DLBORDERID]];
    }
    [paramDict setValue:self.orderId forKey:@"orderId"];
    [paramDict setValue:app_Version forKey:@"ver"];
    [paramDict setValue:uuid forKey:@"deviceid"];
    [paramDict setValue:@"2" forKey:@"devtype"];
    [paramDict setValue:@"1" forKey:@"apptype"];
    
    [HttpTool getWithUrl:upPayUrl params:paramDict success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSLog(@"json===%@",json);
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        NSString *codeinfo = [NSString stringWithFormat:@"%@",dict[@"codeinfo"]];
        if (IsNilOrNull(codeinfo)){
            codeinfo = @"";
        }
        if (![code isEqualToString:@"200"]){
            if(codeinfo && codeinfo.length > 0){
//                [self showNoticeView:codeinfo];
                FFWarnAlertView *alertV = [[FFWarnAlertView alloc] init];
                alertV.titleLable.text = codeinfo;
                [alertV showFFWarnAlertView];
            }
            return ;
        }
        NSString *tn = [NSString stringWithFormat:@"%@",dict[@"tn"]];
        
        [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"CKUPay" mode:UnionPayEnvironment viewController:self];
        
    } failure:^(NSError *error){
        NSLog(@"错误===%@",error.localizedDescription);
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 银联支付回调
-(void)UUPay:(NSNotification *)notice{
    
    NSString *code = [NSString stringWithFormat:@"%@",notice.object];
    if([code isEqualToString:@"success"]){
        //支付成功
        [self paySuccess];
    }else if([code isEqualToString:@"fail"]) { //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成
        [self showNoticeView:@"银联支付失败"];
    }else if([code isEqualToString:@"cancel"]) {
        [self showNoticeView:@"用户已取消"];
    }
}

#pragma mark - Apple Pay支付
//-(void)applePayClick {
//
//    NSLog(@"苹果支付");
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
//    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
//    if (IsNilOrNull(self.orderId)) {
//        self.orderId = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:DLBORDERID]];
//    }
//    [paramDict setValue:self.orderId forKey:@"orderId"];
//    [paramDict setValue:app_Version forKey:@"ver"];
//    [paramDict setValue:uuid forKey:@"deviceid"];
//    [paramDict setValue:@"2" forKey:@"devtype"];
//    [paramDict setValue:@"1" forKey:@"apptype"];
//
//    [self.view addSubview:self.viewDataLoading];
//    [self.viewDataLoading startAnimation];
//
//    NSString *upPayUrl= [NSString stringWithFormat:@"%@%@", WebServiceUnitPayAPI, Uionpay_Url];
//
//    [HttpTool postWithUrl:upPayUrl params:paramDict success:^(id json) {
//        [self.viewDataLoading stopAnimation];
//        NSLog(@"json===%@",json);
//        NSDictionary *dict = json;
//        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
//        NSString *codeinfo = [NSString stringWithFormat:@"%@",dict[@"codeinfo"]];
//        if (IsNilOrNull(codeinfo)){
//            codeinfo = @"";
//        }
//        if (![code isEqualToString:@"200"]){
//            if(codeinfo && codeinfo.length > 0){
//                [self showNoticeView:codeinfo];
//            }
//            return ;
//        }
//        NSString *tn = [NSString stringWithFormat:@"%@",dict[@"tn"]];
//        [UPAPayPlugin startPay:tn mode:UnionPayEnvironment viewController:self delegate:self andAPMechantID:@"merchant.com.ckc.CKYSPlatform"];
//
//    } failure:^(NSError *error){
//        NSLog(@"错误===%@",error.localizedDescription);
//        [self.viewDataLoading stopAnimation];
//        if (error.code == -1009) {
//            [self showNoticeView:NetWorkNotReachable];
//        }else{
//            [self showNoticeView:NetWorkTimeout];
//        }
//    }];
//}
//
//#pragma mark - Apple Pay支付结果回调
//-(void)UPAPayPluginResult:(UPPayResult *)payResult {
//
//    NSInteger status = payResult.paymentResultStatus;
//
//    if(status == UPPaymentResultStatusSuccess){//支付成功
//        [self showNoticeView:@"支付成功"];
//        //跳转原来列表
//        [self dismissViewControllerAnimated:YES completion:^{
//
//        }];
//    }else if(status == UPPaymentResultStatusFailure) { //支付失败
//        [self showNoticeView:@"支付失败"];
//    }else if(status == UPPaymentResultStatusCancel) { //支付取消
//        [self showNoticeView:@"支付取消"];
//    }else if(status == UPPaymentResultStatusUnknownCancel) { //支付取消，交易已发起，状态不确定，商户需查询商户后台确认支付状态
//        [self showNoticeView:@"支付取消"];
//    }
//}

#pragma mark - 京东支付
-(void)jdPayClick {

    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];

    NSString *jdpayUrl = [NSString stringWithFormat:@"%@%@", WebServicePayAPI, JionPay_JD];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    if (IsNilOrNull(self.orderId)) {
        self.orderId = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:DLBORDERID]];
    }
    [paramDict setValue:self.orderId forKey:@"orderId"];
    [paramDict setValue:app_Version forKey:@"ver"];
    [paramDict setValue:uuid forKey:@"deviceid"];
    [paramDict setValue:@"2" forKey:@"devtype"];
    [paramDict setValue:@"1" forKey:@"apptype"];

    [HttpTool postWithUrl:jdpayUrl params:paramDict success:^(id json) {
        NSLog(@"json===%@",json);
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        NSString *codeinfo = dict[@"codeinfo"];

        if (![code isEqualToString:@"200"]){
            FFWarnAlertView *alertV = [[FFWarnAlertView alloc] init];
            alertV.titleLable.text = codeinfo;
            [alertV showFFWarnAlertView];
//            [self.viewDataLoading showNoticeView:codeinfo];
        }else{
            NSDictionary *res = dict[@"res"];
            NSString *signdata = [NSString stringWithFormat:@"%@", res[@"signdata"]];
            NSString *orderId = [NSString stringWithFormat:@"%@", res[@"orderId"]];
            [[JDPAuthSDK sharedJDPay] payWithViewController:self orderId:orderId signData:signdata completion:^(NSDictionary *resultDict) {
                NSLog(@"resultDict:%@", resultDict);

                NSString *payStatus = [NSString stringWithFormat:@"%@", resultDict[@"payStatus"]];
                if ([payStatus isEqualToString:@"JDP_PAY_SUCCESS"]) { //成功之后
                    [self paySuccess];
                }else {
                    if ([payStatus isEqualToString:@"JDP_PAY_FAIL"]) {
                        [self showNoticeView:@"支付失败"];
                    }else if ([payStatus isEqualToString:@"JDP_PAY_CANCEL"]) {
                        [self showNoticeView:@"取消支付"];
                    }else{
                        [self showNoticeView:payStatus];
                    }
                }
            }];
        }
    } failure:^(NSError *error) {
        NSLog(@"错误===%@",error.localizedDescription);
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 跳过支付
-(void)skipPayOrder {
    //如果有ckid，跳过支付回首页
    if (!IsNilOrNull(self.ckid)) {
        XWAlterVeiw *alertView = [[XWAlterVeiw alloc]init];
        alertView.delegate = self;
        alertView.titleLable.text = @"订单还未支付，确定跳过支付？";
        [alertView show];
    }else{//如果没有ckid，跳过支付到确认信息页面
        [self goToRegister];
    }
}

-(void)subuttonClicked {
    
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    
    if(!IsNilOrNull(homeLoginStatus)){
        if (!IsNilOrNull(self.cktype)) {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        if (!IsNilOrNull(self.cktype)) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }];
        }else{
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            
        }
    }
}

#pragma mark - 支付成功
-(void)paySuccess {
    //如果有ckid，并且支付成功了，跳回首页，默认登录
    if (!IsNilOrNull(self.ckid)) {
        //给用户默认登录
        [self loginCKAPP];        
    }else{
        //没有就去确认信息页面
        [self goToRegister];
    }
}

#pragma mark - 去填写注册信息
-(void)goToRegister {
    
    CKConfrimRegistMsgViewController *regist = [[CKConfrimRegistMsgViewController alloc] init];
    regist.orderid = self.orderId;
    [self.navigationController pushViewController:regist animated:YES];

}

-(void)loginCKAPP {
    
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
    
    [KUserdefaults setObject:self.ckid forKey:Kckid];
    //注册成功连接融云 并设置token
    [self setupRongTokenDataWithckid:self.ckid andName:weixinNickName andHeadUrl:weixinHeaimageUrl];
    //注册成功刷新首页和个人中心
    [KUserdefaults setObject:@"minelogin" forKey:KMineLoginStatus];
    [KUserdefaults setObject:@"homelogin" forKey:KHomeLoginStatus];
    //推广人不需要注册（推广人是通过后台分配的账号登录） 凡是注册成功的都把sale设置为0
    [KUserdefaults setObject:@"0" forKey:KSales];
    [KUserdefaults synchronize];
    
    //注册成功之后  设置别名和标签   设置userId  昵称 头像
    [JPUSHService setTags:0 alias:self.ckid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"\n[注册成功后设置别名]---[%@]",iAlias);
        if(iResCode != 0){
            [JPUSHService setTags:0 alias:self.ckid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"\n注册失败重置---[%@]",iAlias);
            }];
        }
    }];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setupRongTokenDataWithckid:(NSString *)ckid andName:(NSString *)smallName andHeadUrl:(NSString *)headImageUrl{
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    if(IsNilOrNull(smallName)){
        smallName = ckid;
    }
    if(IsNilOrNull(headImageUrl)){
        headImageUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, DefaultHeadPath];
    }
    NSDictionary *pramaDic = @{@"id":ckid, @"name":smallName, @"pic":headImageUrl, DeviceId:uuid};
    NSString *rongUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI, getRongYunToken];
    
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

-(void)exitPay {
    
    NSArray *vcArray = self.navigationController.viewControllers;
    if (vcArray.count > 1) {
        if ([vcArray objectAtIndex:vcArray.count-1] == self) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

#pragma mark - 更新域名
-(void)updateDomain:(NSDictionary*)dict {
    
    NSString *baseImagestr = [NSString stringWithFormat:@"%@", [dict objectForKey:@"appregeturl"]];
    if (!IsNilOrNull(baseImagestr)) {
        if (![baseImagestr hasSuffix:@"/"]) {
            baseImagestr = [baseImagestr stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:baseImagestr forKey:@"domainImgRegetUrl"];
    }
    
    //    NSString *domainName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"appapiurl"]];
    //    if (!IsNilOrNull(domainName)) {
    //        if (![domainName hasSuffix:@"/"]) {
    //            domainName = [domainName stringByAppendingString:@"/"];
    //        }
    //        [[DefaultValue shareInstance] setDefaultValue:domainName forKey:@"domainName"];
    //    }
    
    NSString *domainNameRes = [NSString stringWithFormat:@"%@", [dict objectForKey:@"appreupurl"]];
    if (!IsNilOrNull(domainNameRes)) {
        if (![domainNameRes hasSuffix:@"/"]) {
            domainNameRes = [domainNameRes stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNameRes forKey:@"domainNameRes"];
    }
    
    NSString *domainNamePay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"apppayurl"]];
    if (!IsNilOrNull(domainNamePay)) {
        if (![domainNamePay hasSuffix:@"/"]) {
            domainNamePay = [domainNamePay stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNamePay forKey:@"domainNamePay"];
    }
    
    NSString *domainSmsMessage = [NSString stringWithFormat:@"%@", [dict objectForKey:@"appmsgurl"]];
    if (!IsNilOrNull(domainSmsMessage)) {
        if (![domainSmsMessage hasSuffix:@"/"]) {
            domainSmsMessage = [domainSmsMessage stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainSmsMessage forKey:@"domainSmsMessage"];
    }
    
    NSString *domainNameUnionPay = [NSString stringWithFormat:@"%@", [dict objectForKey:@"appunionpayurl"]];
    if (!IsNilOrNull(domainNameUnionPay)) {
        if (![domainNameUnionPay hasSuffix:@"/"]) {
            domainNameUnionPay = [domainNameUnionPay stringByAppendingString:@"/"];
        }
        [[DefaultValue shareInstance] setDefaultValue:domainNameUnionPay forKey:@"domainNameUnionPay"];
    }
}

-(void)dealloc{
    [CKCNotificationCenter removeObserver:self name:WeiXinPay_CallBack object:nil];
    [CKCNotificationCenter removeObserver:self name:Alipay_CallBack object:nil];
}

@end
