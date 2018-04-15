//
//  PayMoneyViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/19.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "PayMoneyViewController.h"
#import "PaymentTableViewCell.h"
#import "MoneyTableViewCell.h"
#import "WXApi.h" //微信SDK头文件
#import <AlipaySDK/AlipaySDK.h> //支付宝头文件
//#import <PassKit/PassKit.h>
#import "UPPaymentControl.h"
//#import "UPAPayPlugin.h"
#import "PushManager.h"
#import "JDPAuthSDK.h"
#import "TopTipView.h"
#import "FFWarnAlertView.h"
#import "WXApiObject.h"


//@interface PayMoneyViewController ()<UITableViewDelegate, UITableViewDataSource, TopTipViewDelegate, UPAPayPluginDelegate>
@interface PayMoneyViewController ()<UITableViewDelegate, UITableViewDataSource, TopTipViewDelegate>


@property (nonatomic, copy) NSString *ckAllPayMoney;
@property (nonatomic, copy) NSString *fxAllPayMoney;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *ckidstring;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *moneystring;
@property (nonatomic, copy) NSString *headImageUrl;
@property (nonatomic, copy) NSString *smallName;
@property (nonatomic, copy) NSString *oidString;
@property (nonatomic, copy) NSString *selectedType;
@property (nonatomic, strong) NSIndexPath *selIndex;//单选，当前选中的行
@property (nonatomic, strong) UITableView *paymentTableView;
@property (nonatomic, strong) NSMutableArray *payMethodArr;
@property (nonatomic, strong) NSMutableArray *summaryItems;
@property (nonatomic, strong) NSMutableArray *shippingMethods;
@property (nonatomic, strong) TopTipView *tipView;

@end

@implementation PayMoneyViewController

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
    
    
    _ckidstring = KCKidstring;
    _openId = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KopenID]];
    if (IsNilOrNull(_openId)) {
        _openId = @"";
    }
    _headImageUrl = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:kheamImageurl]];
    _smallName = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KnickName]];
    
    NSString *typeString = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Ktype]];
    if(self.type){ //创客加盟（永久 无风险）分销加盟 跳转过来 都传了类型 B /D  自提只传金额和订单号
        _payType = self.type;
    }else{ //如果传值为空  则从本地获取
        if (IsNilOrNull(typeString)) {
            _payType = @"";
        }else{
            _payType = typeString;
        }
    }
    
    /**获取加盟需要支付的总金额和可用的支付方式*/
    [self getPayMethod];
    
    // 注册微信支付结果通知
    [CKCNotificationCenter addObserver:self selector:@selector(weixinPayCallBack:) name:WeiXinPay_CallBack object:nil];
    // 注册支付宝支付结果通知
    [CKCNotificationCenter addObserver:self selector:@selector(aliPayCallBack:) name:Alipay_CallBack object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(UUPay:) name:UnionPay_CallBack object:nil];
    
    [self createTableView];
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
        [self.viewDataLoading stopAnimation];

        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            [_payMethodArr removeAllObjects];
            _payMethodArr = [NSMutableArray arrayWithArray:[[DefaultValue shareInstance] getAvailablePaymentMethod]];
            [self.paymentTableView reloadData];
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

        NSString *ckallMoney = [NSString stringWithFormat:@"%@",dict[@"m1"]];
        NSString *fxallMoney = [NSString stringWithFormat:@"%@",dict[@"m2"]];
        if(IsNilOrNull(ckallMoney)) {
            ckallMoney = @"0.00";
        }
        _ckAllPayMoney = ckallMoney;
        if (IsNilOrNull(fxallMoney)) {
            fxallMoney = @"0.00";
        }
        _fxAllPayMoney = fxallMoney;
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];

        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [_payMethodArr removeAllObjects];
        _payMethodArr = [NSMutableArray arrayWithArray:[[DefaultValue shareInstance] getAvailablePaymentMethod]];
        [self.paymentTableView reloadData];
    }];
}

- (void)createTableView {
    
    //创建底部的支付按钮
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [bankImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [self.view addSubview:bankImageView];
    bankImageView.userInteractionEnabled = YES;
    bankImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(AdaptedWidth(35));
        make.right.mas_offset(-AdaptedWidth(35));
        make.bottom.mas_offset(-AdaptedHeight(20));
        make.height.mas_offset(AdaptedHeight(40));
    }];
    //我要提现
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankImageView addSubview:payButton];
    [payButton setTitle:@"去支付" forState:UIControlStateNormal];
    payButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(bankImageView);
        
    }];
    [payButton addTarget:self action:@selector(clickPayButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString *payalertmsg = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"payalertmsg"]];
    CGSize s = [payalertmsg boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 87, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    _tipView = [[TopTipView alloc] initWithFrame:CGRectMake(0, 5+64+NaviAddHeight, SCREEN_WIDTH, s.height>=30 ? 14+s.height : 44)];
    _tipView.delegate = self;
    [self.view addSubview:_tipView];
    
    
    //    if (@available(iOS 11.0, *)) {
    //        _paymentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+AdaptedHeight(20)+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-AdaptedHeight(20)) style:UITableViewStyleGrouped];
    //    }else{
    _paymentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    //    }
    
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
            make.top.equalTo(self.view.mas_top).offset(20+64+NaviAddHeight);
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
        make.top.equalTo(self.view.mas_top).offset(20+64+NaviAddHeight);
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
        //如果是创客  或者是分销转创客都是12000
        if ([_payType isEqualToString:@"B"] || [_payType isEqualToString:@"DtoB"]) {
            if(IsNilOrNull(_ckAllPayMoney)){
                _ckAllPayMoney = @"0.00";
            }
            cell.moneyLable.text = [NSString stringWithFormat:@"¥%@",_ckAllPayMoney];
        }else if([_payType isEqualToString:@"D"]){ //是分销
            if(IsNilOrNull(_fxAllPayMoney)){
                _fxAllPayMoney = @"0.00";
            }
            cell.moneyLable.text = [NSString stringWithFormat:@"¥%@",_fxAllPayMoney];
        }else if([_payType isEqualToString:@"ziti"]){ //自提中可以购买的需要支付商品
            if(IsNilOrNull(self.payfeeStr)) {
              self.payfeeStr = @"";
            }
          cell.moneyLable.text = [NSString stringWithFormat:@"¥%@",self.payfeeStr];
        }else{
            if(IsNilOrNull(self.payfeeStr)) {
                self.payfeeStr = @"0.00";
            }
            cell.moneyLable.text = [NSString stringWithFormat:@"¥%@", self.payfeeStr];
        }
        
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
        return 0;
    }
}

#pragma mark - 点击去支付
-(void)clickPayButton{
    if([_selectedType isEqualToString:@"alipay"]){  //支付宝
        [self clickAlipay];
    }else if ([_selectedType isEqualToString:@"wxpay"]){  //微信
        [self wxPayClick];
    }else if ([_selectedType isEqualToString:@"unionpay"]){  //银联
        [self UPPayClick];
    }else if ([_selectedType isEqualToString:@"jdpay"]){  //applePay
        [self jdPayClick];
    }else if ([_selectedType isEqualToString:@"applepay"]){  //applePay
//        [self applePayClick];
    }
    
    NSLog(@"支付方式%@ ", _selectedType);
    if (IsNilOrNull(_selectedType)) {
        [self showNoticeView:@"请选择支付方式"];
    }
}

#pragma mark - 支付宝支付处理
-(void)clickAlipay{
    self.paymentType = 2;
    self.appDelegate.paymentType = self.paymentType;
    [self nullValueProcess];
    
    NSString *alipayUrl= [NSString stringWithFormat:@"%@%@", WebServicePayAPI, payForJoinByAli_Url];
    
    NSDictionary *pramaDic = [self generalPayParams];
    if (pramaDic == nil) {
        [self showNoticeView:@"账户信息异常，请退出账号重新登录或注册。"];
        return;
    }
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
   
    [HttpTool postWithUrl:alipayUrl params:pramaDic success:^(id json) {
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
             *  支付结果回调，支付宝会返回支付结果信息，一般是走这个方法。
             */
            NSLog(@"reslut = %@",resultDic);
            NSDictionary *userInfo = resultDic;
            NSInteger errCode = [[userInfo objectForKey:@"resultStatus"]integerValue];
            if (errCode == 9000) {
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
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

#pragma mark - 监听支付宝支付完成跳转页面
- (void)aliPayCallBack:(NSNotification *)notification{
    
    self.paymentType = 2;
    self.appDelegate.paymentType = self.paymentType;
    NSDictionary *userInfo = notification.userInfo;
    NSInteger errCode = [[userInfo objectForKey:@"resultStatus"]integerValue];
    if (errCode == 9000) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
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
    [self nullValueProcess];
    NSDictionary *pramaDic = [self generalPayParams];
    if (pramaDic == nil) {
        [self showNoticeView:@"账户信息异常，请退出账号重新登录或注册。"];
        return;
    }
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
   
    NSString *WeixinUrl = [NSString stringWithFormat:@"%@%@", WebServicePayAPI, payForJoinByWX_Url];
    [HttpTool postWithUrl:WeixinUrl params:pramaDic success:^(id json) {
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
        if ([self.fromVC isEqualToString:@"OrderStatusNotPay"]) {
            
        }
        
        //跳转原来列表
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
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
    [self nullValueProcess];
    
    NSDictionary *pramaDic = [self generalPayParams];
    if (pramaDic == nil) {
        [self showNoticeView:@"账户信息异常，请退出账号重新登录或注册。"];
        return;
    }
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    NSString *upPayUrl= [NSString stringWithFormat:@"%@%@", WebServiceUnitPayAPI, Uionpay_Url];
    
    [HttpTool postWithUrl:upPayUrl params:pramaDic success:^(id json) {
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
        //跳转原来列表
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
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
//    
//    [self nullValueProcess];
//
//    NSDictionary *pramaDic = [self generalPayParams];
//    if (pramaDic == nil) {
//        [self showNoticeView:@"账户信息异常，请退出账号重新登录或注册。"];
//        return;
//    }
//    
//    [self.view addSubview:self.viewDataLoading];
//    [self.viewDataLoading startAnimation];
//    
//    NSString *upPayUrl= [NSString stringWithFormat:@"%@%@", WebServiceUnitPayAPI, Uionpay_Url];
//    
//    [HttpTool postWithUrl:upPayUrl params:pramaDic success:^(id json) {
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
//    
//}

#pragma mark - 京东支付
-(void)jdPayClick {
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    NSString *jdpayUrl = [NSString stringWithFormat:@"%@%@", WebServicePayAPI, JDPay_Url];
    NSDictionary *pramaDic = [self generalPayParams];
    
    [HttpTool postWithUrl:jdpayUrl params:pramaDic success:^(id json) {
        NSLog(@"json===%@",json);
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        NSString *codeinfo = dict[@"codeinfo"];
        
        if (![code isEqualToString:@"200"]){
//            [self.viewDataLoading showNoticeView:codeinfo];
            FFWarnAlertView *alertV = [[FFWarnAlertView alloc] init];
            alertV.titleLable.text = codeinfo;
            [alertV showFFWarnAlertView];
        }else{
            NSDictionary *res = dict[@"res"];
            NSString *orderId = [NSString stringWithFormat:@"%@", res[@"orderId"]];
            NSString *signdata = [NSString stringWithFormat:@"%@", res[@"signdata"]];
            
            [[JDPAuthSDK sharedJDPay] payWithViewController:self orderId:orderId signData:signdata completion:^(NSDictionary *resultDict) {
                NSLog(@"resultDict:%@", resultDict);
                NSString *payStatus = [NSString stringWithFormat:@"%@", resultDict[@"payStatus"]];
                if ([payStatus isEqualToString:@"JDP_PAY_SUCCESS"]) { //成功之后
                    if ([self.fromVC isEqualToString:@"OrderStatusNotPay"]) {
                        
                    }
                    //跳转原来列表
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
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


-(void)exitPay {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)nullValueProcess {
    if (IsNilOrNull(_ckidstring)) {
        _ckidstring = @"";
    }
    if (IsNilOrNull(_openId)) {
        _openId = @"";
    }
    if (IsNilOrNull(_joinTypeStr)){
        _joinTypeStr = @"";
    }
    if (IsNilOrNull(self.addressId)){
        self.addressId = @"";
    }
    if (IsNilOrNull(_moneystring)){
        _moneystring = @"";
    }
    if (IsNilOrNull(_oidString)){
        _oidString = @"";
    }
    if (IsNilOrNull(self.itemid)){
        self.itemid = @"";
    }
}

-(NSDictionary*)generalPayParams {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSDictionary *appDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [appDic objectForKey:@"CFBundleShortVersionString"];
    NSString *devicetype = [NSString stringWithFormat:@"ios%@", version];

    NSDictionary *pramaDic = nil;
    //   type  创客加盟joinB 分销加盟joinD 分销转创客transUpToB 充值addGlib
    if ([_payType isEqualToString:@"DtoB"] && [self.joinTypeStr isEqualToString:@"transUpToB"]) {
        //分销升级创客
        _joinTypeStr = @"transUpToB";
        _moneystring = _ckAllPayMoney;
        _oidString = @"";
        pramaDic = @{@"ckid":_ckidstring,@"type":_joinTypeStr,@"addressid":self.addressId,@"money":_moneystring,@"itemid":self.itemid,DeviceId:uuid, @"devicetype":devicetype};
    }else if ([_payType isEqualToString:@"B"]){
        _joinTypeStr = @"joinB";
        _moneystring = _ckAllPayMoney;
        _oidString = @"";
        pramaDic = @{@"ckid":_ckidstring,@"type":_joinTypeStr,@"money":_moneystring,@"oid":_oidString,DeviceId:uuid, @"devicetype":devicetype};
    }else if ([_payType isEqualToString:@"D"]){
        _joinTypeStr = @"joinD";
        _moneystring = _fxAllPayMoney;
        _oidString = @"";
        pramaDic = @{@"ckid":_ckidstring,@"type":_joinTypeStr,@"money":_moneystring,@"oid":_oidString,DeviceId:uuid, @"devicetype":devicetype};
    }else if([_payType isEqualToString:@"ziti"]){  //自提商城中可购买商品
        _joinTypeStr = @"ckp";
        _moneystring = self.payfeeStr;
        _oidString = self.oidStr;
        pramaDic = @{@"ckid":_ckidstring,@"type":_joinTypeStr,@"money":_moneystring,@"oid":_oidString,DeviceId:uuid, @"devicetype":devicetype};
    }else{
        [self showNoticeView:@"账户信息异常，请退出账号重新登录或注册。"];
    }
    return pramaDic;
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
