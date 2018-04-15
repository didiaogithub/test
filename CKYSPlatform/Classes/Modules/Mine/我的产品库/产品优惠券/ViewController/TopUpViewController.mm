//
//  TopUpViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/14.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "TopUpViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "CKMyProductLibVC.h"
#import "CKMyProductLibVCOld.h" //我的产品库3.1.1老模式
//#import <PassKit/PassKit.h>
//#import "UPAPayPlugin.h"
#import "UPPaymentControl.h"
#import "JDPAuthSDK.h"
#import "FFWarnAlertView.h"
#import "CKCouponDetailViewController.h"
//@interface TopUpViewController ()<UITextFieldDelegate, UPAPayPluginDelegate>
@interface TopUpViewController ()<UITextFieldDelegate>
{
    UILabel *_minusMoneyLabel;
    UIImageView *leftImgageView;
    UILabel *lineLable;
}
@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, strong) UIView *topUpView;
@property (nonatomic, strong) UILabel *noticeTextLable;
@property (nonatomic, strong) UIButton *topUpButton;//充值按钮
@property (nonatomic, copy)   NSString *ckidString;
@property (nonatomic, copy)   NSString *moneyStr;
@property (nonatomic, strong) NSMutableArray *summaryItems;
@property (nonatomic, strong) NSMutableArray *shippingMethods;
@property (nonatomic, strong) UILabel *instructionTextLabel;

@end

@implementation TopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我要进货";
    _ckidString = KCKidstring;
    if (self.dataDic) {
        self.couponid = [self.dataDic objectForKey:@"voucherid"];
    }else{
        self.couponid = @"";
    }
     [self createTopUpView];
    // 注册微信支付结果通知
    [CKCNotificationCenter addObserver:self selector:@selector(weixinPay:) name:WeiXinPay_CallBack object:nil];
    // 注册支付宝支付结果通知
    [CKCNotificationCenter addObserver:self selector:@selector(aliPay:) name:Alipay_CallBack object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(UUPay:) name:UnionPay_CallBack object:nil];
    
    
}

-(void)setPayBlock:(PayResultBlock)payBlock{
    _payBlock = payBlock;
    
}

/**充值view*/
-(void)createTopUpView{
    if ([self.num isEqualToString:@"0"]) {
        _topUpView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+AdaptedHeight(10), SCREEN_WIDTH ,AdaptedHeight(180))];
    }else{
        _topUpView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+AdaptedHeight(10), SCREEN_WIDTH ,AdaptedHeight(295))];
    }
    
    [self.view addSubview:_topUpView];
    [_topUpView setBackgroundColor:[UIColor whiteColor]];
    
    leftImgageView = [[UIImageView alloc] init];
    [_topUpView addSubview:leftImgageView];
    [leftImgageView setImage:[UIImage imageNamed:@"recharge"]];
    leftImgageView.frame = CGRectMake(10, 0, 65, 25);
    leftImgageView.contentMode= UIViewContentModeLeft;
    _moneyTextField = [[UITextField alloc] init];
    [_topUpView addSubview:_moneyTextField];
    _moneyTextField.placeholder = @"请输入进货金额";
    _moneyTextField.delegate = self;
    _moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [_moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(15));
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - AdaptedWidth(40),AdaptedHeight(50)));
    }];
    _moneyTextField.leftView = leftImgageView;
    _moneyTextField.leftViewMode = UITextFieldViewModeAlways;
//    _moneyTextField.textAlignment = NSTextAlignmentRight;
    
    //线
    lineLable = [UILabel creatLineLable];
    [_topUpView addSubview:lineLable];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyTextField.mas_bottom);
        make.left.mas_offset(AdaptedWidth(15));
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH -AdaptedWidth(30), 1));
    }];
    //提示文字
    _noticeTextLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_topUpView addSubview:_noticeTextLable];
    [_noticeTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLable.mas_bottom).offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(15));
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - AdaptedWidth(40) , 15));
    }];
    
    // 优惠券
    if (![self.num isEqualToString:@"0"]) {
        [self addCouponView];
    }
    //保存按钮
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [bankImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [self.view addSubview:bankImageView];
    bankImageView.userInteractionEnabled = YES;
    bankImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_topUpView).offset(AdaptedHeight(-25));
        make.left.mas_offset(AdaptedWidth(15));
        make.right.mas_offset(-AdaptedWidth(15));
        make.height.mas_offset(AdaptedHeight(55));
    }];
    
    _topUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankImageView addSubview:_topUpButton];
    [_topUpButton setTitle:@"确认" forState:UIControlStateNormal];
    _topUpButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [_topUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_topUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(bankImageView);
    }];
    [_topUpButton addTarget:self action:@selector(clickTopUpButton) forControlEvents:UIControlEventTouchUpInside];
    [self refreshNoticeText];
}


- (void)addCouponView{
    
    UIView *couponView = [[UIView alloc]init];
    couponView.backgroundColor = [UIColor whiteColor];
    [_topUpView addSubview:couponView];
    [couponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noticeTextLable.mas_bottom).offset(AdaptedHeight(1));
        make.left.right.equalTo(_topUpView);
        make.height.mas_offset(AdaptedHeight(58));
        make.width.equalTo(_topUpView);
    }];
    
    UILabel *couponLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [couponView addSubview:couponLabel];
    couponLabel.text = @"优惠券:";
    [couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImgageView.mas_left);
        make.top.equalTo(couponView).offset(AdaptedHeight(14));
        make.width.mas_offset(AdaptedWidth(50));
        make.height.mas_offset(AdaptedHeight(30));
    }];
    // 可用张数
    UILabel *ableCouponLabel = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    ableCouponLabel.backgroundColor = [UIColor redColor];
    ableCouponLabel.layer.cornerRadius = 1;
    ableCouponLabel.layer.masksToBounds = YES;
    [couponView addSubview:ableCouponLabel];
    if (!IsNilOrNull(self.num)) {
        ableCouponLabel.text = [NSString stringWithFormat:@"%@张可用",self.num];
    }
    [ableCouponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(couponLabel.mas_right).offset(AdaptedWidth(2));
        make.top.equalTo(couponLabel).offset(AdaptedHeight(8));
        make.bottom.equalTo(couponLabel).offset(AdaptedHeight(-8));
    }];
    
    UIImageView *rightArrow = [[UIImageView alloc]init];
    rightArrow.image = [UIImage imageNamed:@"rightarrow"];
    [couponView addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(couponView).offset(AdaptedWidth(-15));
        make.centerY.mas_offset(couponView.centerY);
        make.width.mas_offset(10);
        make.height.mas_offset(15);
    }];
    // 可以减去金额
    _minusMoneyLabel = [UILabel configureLabelWithTextColor:[UIColor redColor] textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [couponView addSubview:_minusMoneyLabel];
    
    if (self.dataDic) {
        NSString *maxMoney =  [NSString stringWithFormat:@"-%@",[self.dataDic objectForKey:@"maxmoney"]];
        _minusMoneyLabel.text = maxMoney;
    }
    [couponView addSubview:_minusMoneyLabel];
    [_minusMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightArrow.mas_left).offset(AdaptedWidth(-10));
        make.height.mas_offset(AdaptedHeight(30));
        make.centerY.mas_offset(couponView.centerY);
    }];
    
    
    // 线1
    UILabel *lineLable1 = [UILabel creatLineLable];
    [_topUpView addSubview:lineLable1];
    [lineLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLable.mas_bottom).offset(AdaptedHeight(92));
        make.left.mas_offset(AdaptedWidth(15));
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH -AdaptedWidth(30), 1));
    }];
    
    // 说明文字
    _instructionTextLabel = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_topUpView addSubview:_instructionTextLabel];
    _instructionTextLabel.text = @"说明：产品抵用券在产品进货时使用，产品进货支付金额=输入进货金额-产品抵用券金额。";
    _instructionTextLabel.numberOfLines = 0;
    [_instructionTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(AdaptedWidth(15));
        make.top.equalTo(lineLable1.mas_bottom).offset(AdaptedHeight(10));
        make.width.mas_offset(SCREEN_WIDTH - AdaptedWidth(40));
    }];
    
    
    // 透明btn
    
    UIButton *couponButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [couponButton addTarget:self action:@selector(clickCouponButton) forControlEvents:UIControlEventTouchUpInside];
    couponButton.backgroundColor = [UIColor clearColor];
    [couponView addSubview:couponButton];
    [couponButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(couponView);
    }];
    
}
-(void)refreshNoticeText{
    
    
    NSString *type = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:Ktype]];
    if ([type isEqualToString:@"B"]) {
        NSString *str = [NSString stringWithFormat:@"进货金额不能少于¥%@", CKYSmsgchargeCK];
        _noticeTextLable.text = str;
    }else if([type isEqualToString:@"D"]){
        NSString *str = [NSString stringWithFormat:@"进货金额不能少于¥%@", CKYSmsgchargeFX];
        _noticeTextLable.text = str;
    }
}

#pragma mark - <UITextFieldDelegate>
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *amountText = self.moneyTextField.text;
    NSString *regStr = @"^([1-9][\\d]{0,100}|0)(\\.[\\d]{0,1})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regStr];
    BOOL match = [predicate evaluateWithObject:amountText];
    if ([string isEqualToString:@""]) return YES;  // 始终允许用户删除
    BOOL result = [amountText isEqualToString:@""] ? YES : (match || [string isEqualToString:@"."]);
    return result;
}

#pragma mark - 充值按钮
-(void)clickTopUpButton{
    [self.moneyTextField resignFirstResponder];
    
    if ([_moneyTextField.text doubleValue] < [self.couponMoney doubleValue]) {
        [self showNoticeView:@"进货金额不能少于优惠券金额"];
        return;
    }
    
//   微信1 支付宝2 银联3 Apple Pay4
    NSString *type = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:Ktype]];
    if(!IsNilOrNull(type)){
        if ([type isEqualToString:@"B"]){
            if([_moneyTextField.text integerValue] < [CKYSmsgchargeCK integerValue]){
                NSString *str = [NSString stringWithFormat:@"进货金额不能少于¥%@", CKYSmsgchargeCK];
                [self showNoticeView:str];
                return ;
            }
        }else if([type isEqualToString:@"D"]){
            NSString *str = [NSString stringWithFormat:@"进货金额不能少于¥%@", CKYSmsgchargeFX];
            if([_moneyTextField.text integerValue] < [CKYSmsgchargeFX integerValue]){
                [self showNoticeView:str];
                return ;
            }
        }
    }
    if(self.paymentType == 1){
        [self wxPayClick];
    }else if(self.paymentType == 2){
        [self clickAlipay];
    }else if(self.paymentType == 3){
        [self UPPayClick];
    }else if(self.paymentType == 4){
//        [self applePayClick];
    }else if(self.paymentType == 5){
         [self jdPayClick];
    }
}


/** 点击优惠券跳转*/

- (void)clickCouponButton{
    NSLog(@"点击了优惠券");
    
    CKCouponDetailViewController *couponDetailVc = [[CKCouponDetailViewController alloc]init];
    [self.navigationController pushViewController:couponDetailVc animated:YES];
}

#pragma mark - AliPay支付
-(void)clickAlipay{
    
    self.paymentType = 2;
    self.appDelegate.paymentType = self.paymentType;

    NSDictionary *pramaDic = [self generalPayParams];
  
    NSString *alipayUrl = [NSString stringWithFormat:@"%@%@",WebServicePayAPI,payForJoinByAli_Url];
    
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
            [CKCNotificationCenter postNotificationName:Alipay_CallBack object:self userInfo:resultDic];
        
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

#pragma mark - 监听支付宝支付完成跳转页面
-(void)aliPay:(NSNotification *)notification {
    self.paymentType = 2;
    self.appDelegate.paymentType = self.paymentType;
    
    NSDictionary *userInfo = notification.userInfo;
    NSInteger errCode = [[userInfo objectForKey:@"resultStatus"]integerValue];
    if (errCode == 9000) {
        //返回我的产品库并刷新
        for (UIViewController *controller in self.navigationController.viewControllers) {
            NSString *monthcalmode = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_monthcalmode"]];
            if ([monthcalmode isEqualToString:@"1"]) {
                if([controller isKindOfClass:[CKMyProductLibVC class]]){
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }else{
                if([controller isKindOfClass:[CKMyProductLibVCOld class]]){
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }
    }else if(errCode == 6001){
        [self showNoticeView:@"用户中途取消"];
        [self recoverVoucher];
    }else if(errCode == 8000){
        [self showNoticeView:@"正在处理中，支付结果未知"];
        [self recoverVoucher];
    }else if(errCode == 4000){
        [self showNoticeView:@"支付失败"];
        [self recoverVoucher];
    }else if(errCode == 5000){
        [self showNoticeView:@"重复请求"];
        [self recoverVoucher];
    }else if(errCode == 6002){
        [self showNoticeView:@"网络连接出错"];
        [self recoverVoucher];
    }else if(errCode == 6004){
        [self showNoticeView:@"支付结果未知"];
        [self recoverVoucher];
    }else{
        [self showNoticeView:@"其他错误"];
        [self recoverVoucher];
    }
}

-(void)paySucceed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果：" message:@"支付成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)payFailed {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果：" message:@"支付失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - 微信支付处理
-(void)wxPayClick {
    self.paymentType = 1;
    self.appDelegate.paymentType = self.paymentType;
    
    NSDictionary *pramaDic = [self generalPayParams];
    
    NSString *weixinUrl = [NSString stringWithFormat:@"%@%@",WebServicePayAPI,payForJoinByWX_Url];
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:weixinUrl params:pramaDic success:^(id json) {
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
        NSLog(@"错误===%@",error.localizedDescription);
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 监听微信支付完成跳转页面
-(void)weixinPay:(NSNotification *)notification {
    self.paymentType = 1;
    self.appDelegate.paymentType = self.paymentType;
    NSString *object= [NSString stringWithFormat:@"%@",notification.object];
    if ([object isEqualToString:@"0"]) {
        //返回我的产品库并刷新
        for (UIViewController *controller in self.navigationController.viewControllers) {
            NSString *monthcalmode = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_monthcalmode"]];
            if ([monthcalmode isEqualToString:@"1"]) {
                if([controller isKindOfClass:[CKMyProductLibVC class]]){
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }else{
                if([controller isKindOfClass:[CKMyProductLibVCOld class]]){
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }
        
    }else if ([object isEqualToString:@"-1"]){
        [self showNoticeView:@"支付失败"];
        [self recoverVoucher];
    }else if ([object isEqualToString:@"-2"]){
        [self showNoticeView:@"用户中途取消"];
        [self recoverVoucher];
    }else if ([object isEqualToString:@"-3"]){
        [self showNoticeView:@"发送失败"];
        [self recoverVoucher];
    }else if ([object isEqualToString:@"-4"]){
        [self showNoticeView:@"授权失败"];
        [self recoverVoucher];
    }else if ([object isEqualToString:@"-5"]){
        [self showNoticeView:@"微信不支持"];
        [self recoverVoucher];
    }else{
        [self showNoticeView:@"其他错误"];
        [self recoverVoucher];
    }
}

#pragma mark - 银联支付
-(void)UPPayClick {
    NSLog(@"银联支付");
    self.paymentType = 3;
    self.appDelegate.paymentType = self.paymentType;
    
    NSDictionary *pramaDic = [self generalPayParams];
    
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

#pragma mark-银联支付回调
-(void)UUPay:(NSNotification *)notice{
    
    NSString *code = [NSString stringWithFormat:@"%@",notice.object];
    if([code isEqualToString:@"success"]){
        //返回我的产品库并刷新
        for (UIViewController *controller in self.navigationController.viewControllers) {
            NSString *monthcalmode = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_monthcalmode"]];
            if ([monthcalmode isEqualToString:@"1"]) {
                if([controller isKindOfClass:[CKMyProductLibVC class]]){
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }else{
                if([controller isKindOfClass:[CKMyProductLibVCOld class]]){
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }
    }else if([code isEqualToString:@"fail"]) { //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成
        [self showNoticeView:@"银联支付失败"];
        [self recoverVoucher];
    }else if([code isEqualToString:@"cancel"]) {
        [self showNoticeView:@"用户已取消"];
        [self recoverVoucher];
    }
}

#pragma mark - Apple Pay
//-(void)applePayClick {
//    
//    NSLog(@"苹果支付");
//    NSDictionary *pramaDic = [self generalPayParams];
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
//    
//}
//
//-(void)UPAPayPluginResult:(UPPayResult *)payResult {
//    
//    NSInteger status = payResult.paymentResultStatus;
//    if(status == UPPaymentResultStatusSuccess){//支付成功
//        [self showNoticeView:@"支付成功"];
//        //返回我的产品库并刷新
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//NSString *monthcalmode = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_monthcalmode"]];
//if ([monthcalmode isEqualToString:@"1"]) {
//    if([controller isKindOfClass:[CKMyProductLibVC class]]){
//        [self.navigationController popToViewController:controller animated:YES];
//    }
//}else{
//    if([controller isKindOfClass:[CKMyProductLibVCOld class]]){
//        [self.navigationController popToViewController:controller animated:YES];
//    }
//}
//        }
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
            NSString *signdata = [NSString stringWithFormat:@"%@", res[@"signdata"]];
            NSString *orderId = [NSString stringWithFormat:@"%@", res[@"orderId"]];
            
            [[JDPAuthSDK sharedJDPay] payWithViewController:self orderId:orderId signData:signdata completion:^(NSDictionary *resultDict) {
                NSLog(@"resultDict:%@", resultDict);
                NSString *payStatus = [NSString stringWithFormat:@"%@", resultDict[@"payStatus"]];
                if ([payStatus isEqualToString:@"JDP_PAY_SUCCESS"]) { //成功之后
                    //跳转原来列表
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }else {
                    if ([payStatus isEqualToString:@"JDP_PAY_FAIL"]) {
                        [self showNoticeView:@"支付失败"];
                        [self recoverVoucher];
                    }else if ([payStatus isEqualToString:@"JDP_PAY_CANCEL"]) {
                        [self showNoticeView:@"取消支付"];
                        [self recoverVoucher];
                    }else{
                       [self showNoticeView:payStatus];
                        [self recoverVoucher];
                    }
                }
//                [KUserdefaults setObject:@"minelogin" forKey:KMineLoginStatus];
//                [KUserdefaults setObject:@"homelogin" forKey:KHomeLoginStatus];
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

#pragma mark - 恢复抵用券
- (void)recoverVoucher {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/CkInfo/recoverVoucher"];
    if (IsNilOrNull(self.couponid)) {
        return;
    }
    NSDictionary *pramaDic = @{@"ckid":_ckidString, @"voucherid":self.couponid};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            return ;
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

-(NSDictionary*)generalPayParams {
    //type  创客加盟joinB 分销加盟joinD 分销转创客transUpToB 充值addGlib
    if (IsNilOrNull(_moneyTextField.text)) {
        _moneyTextField.text = @"";
    }
    if (IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSDictionary *appDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [appDic objectForKey:@"CFBundleShortVersionString"];
    
    
    
    if (IsNilOrNull(self.couponMoney)) {
        self.couponMoney = @"0";
    }
    if (IsNilOrNull(self.couponid)) {
        self.couponid = @"";
    }
    
    
    return @{@"ckid":_ckidString, @"type":@"addGlib", @"money":_moneyTextField.text, DeviceId:uuid, @"devicetype":@"ios", @"ver":version, @"voucherid":self.couponid};
}

#pragma mark - 优惠券金额
- (void)returnMoney:(NSString *)money couponId:(NSString *)couponId {
    NSLog(@"传回抵用券的money%@", money);
    if (IsNilOrNull(money)) {
        self.couponMoney = @"0";
        self.couponid = @"";
        _minusMoneyLabel.text = @"";
    }else{
        self.couponMoney = money;
        self.couponid = couponId;
        _minusMoneyLabel.text = [NSString stringWithFormat:@"-%@",_couponMoney];
    }
}
-(void)dealloc{
    [CKCNotificationCenter removeObserver:self name:WeiXinPay_CallBack object:nil];
    [CKCNotificationCenter removeObserver:self name:Alipay_CallBack object:nil];
}

@end
