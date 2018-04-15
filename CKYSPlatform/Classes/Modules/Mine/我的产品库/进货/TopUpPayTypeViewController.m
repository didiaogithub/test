//
//  TopUpPayTypeViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/14.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "TopUpPayTypeViewController.h"
#import "YunDouToProductViewController.h"
#import "TopUpViewController.h"
#import "PaymentTableViewCell.h"
#import "YZCTableViewCell.h"
//#import <PassKit/PassKit.h>
#import "PushManager.h"

static NSString *customerPayCell = @"PaymentTableViewCell";
static NSString *yzcPayCell = @"YZCTableViewCell";

@interface TopUpPayTypeViewController ()< UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *payMethodArr;
@property (nonatomic, strong) UITableView *paymentTableView;
@property (nonatomic, strong) NSIndexPath *selIndex;//单选，当前选中的行
@property (nonatomic, copy)   NSString *selectedType;

@end

@implementation TopUpPayTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我要进货";
    
    [self getPayMethod];
    
    [self createviews];
}

-(void)getPayMethod {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{DeviceId:uuid};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getSomePath_Url];
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
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

        
        NSString *ckrechargelow = [NSString stringWithFormat:@"%@",dict[@"ckrechargelow"]];
        NSString *fxrechargelow = [NSString stringWithFormat:@"%@",dict[@"fxrechargelow"]];
        NSString *withdrawlow = [NSString stringWithFormat:@"%@",dict[@"withdrawlow"]];

        if(!IsNilOrNull(ckrechargelow)) {//CK充值金额不能少于¥
            SetObjectForKey(ckrechargelow, @"CKYSmsgchargeCK");
            SetObjectForKey(ckrechargelow, @"CKYSmsgBeanToMoneyCK");
        }
        if (!IsNilOrNull(fxrechargelow)) {//FX充值金额不能少于¥
            SetObjectForKey(fxrechargelow, @"CKYSmsgchargeFX");
            SetObjectForKey(fxrechargelow, @"CKYSmsgBeanToMoneyFX");
        }
        if (!IsNilOrNull(withdrawlow)) { //提现金额不得少于x元
            SetObjectForKey(withdrawlow, @"CKYSmsggetmoney");
        }
    } failure:^(NSError *error) {
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

-(void)createviews{
    
    if (@available(iOS 11.0, *)) {
        _paymentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    }else{
        _paymentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    }
    
    _paymentTableView.delegate  = self;
    _paymentTableView.dataSource = self;
    _paymentTableView.backgroundColor = [UIColor tt_grayBgColor];
    _paymentTableView.rowHeight = UITableViewAutomaticDimension;
    _paymentTableView.estimatedRowHeight = 44;
    _paymentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_paymentTableView];
    
    self.selIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.paymentTableView didSelectRowAtIndexPath:self.selIndex ];
    YZCTableViewCell *cell = [_paymentTableView cellForRowAtIndexPath:self.selIndex ];
    cell.rightButton.selected = YES;
    //创建底部的支付按钮
    
    //保存按钮
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [bankImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [self.view addSubview:bankImageView];
    bankImageView.userInteractionEnabled = YES;
    bankImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(AdaptedWidth(35));
        make.right.mas_offset(-AdaptedWidth(35));
        make.bottom.mas_offset(-AdaptedHeight(20));
        make.height.mas_offset(AdaptedHeight(55));
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
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if ([_payMethodArr containsObject:@"applepay"]) {
//        if (![PKPaymentAuthorizationViewController class]) {
//            //PKPaymentAuthorizationViewController需iOS8.0以上支持
//            NSLog(@"操作系统不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
//            return 1 + _payMethodArr.count - 1;
//        }
//        //检查当前设备是否可以支付
//        if (![PKPaymentAuthorizationViewController canMakePayments]) {
//            //支付需iOS9.0以上支持
//            NSLog(@"设备不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
//            return 1 + _payMethodArr.count - 1;
//        }
//        //检查用户是否可进行某种卡的支付，是否支持Amex、MasterCard、Visa与银联四种卡，根据自己项目的需要进行检测
//        NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
//        if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
//            NSLog(@"没有绑定支付卡");
//            return 1 + _payMethodArr.count - 1;
//        }
//        return 1 + _payMethodArr.count;
//    }
    return 1 + _payMethodArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        YZCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:yzcPayCell];
        if (cell==nil) {
            cell = [[YZCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yzcPayCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor tt_grayBgColor]];
        NSInteger row = [indexPath row];
        NSInteger oldRow = [_selIndex row];
        if (row == oldRow && self.selIndex != nil){
            cell.rightButton.selected = YES;
        }else{
            cell.rightButton.selected = NO;
        }

        return cell;
    }else{
        PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customerPayCell];
        if (cell==nil) {
            cell = [[PaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customerPayCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor tt_grayBgColor]];
        
        NSString *paymentType = _payMethodArr[indexPath.row - 1];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = self.selIndex.row;
    if (newRow != oldRow){
        PaymentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.rightButton.selected = YES;
        PaymentTableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.selIndex];
        oldCell.rightButton.selected = NO;
        self.selIndex = indexPath;
    }
    if(indexPath.row == 0){
        _selectedType = [NSString stringWithFormat:@"%zd",newRow];
    }else{
        _selectedType = [NSString stringWithFormat:@"%@", _payMethodArr[indexPath.row - 1]];
    }
    NSLog(@"选择的行%zd type====%@", newRow, _selectedType);
}

#pragma mark - 点击cell上的按钮选择支付方式代理
-(void)clickPayButton{
    if (IsNilOrNull(_selectedType)){
        _selectedType = @"0";
    }
    if ([_selectedType isEqualToString:@"0"]){
        //芸豆库 转 产品库
        YunDouToProductViewController *changeVC = [[YunDouToProductViewController alloc]init];
        changeVC.dataDic = self.dataDic;
        changeVC.num = self.num;
        [self.navigationController pushViewController:changeVC animated:YES];
    }else if ([_selectedType isEqualToString:@"alipay"]){
        NSLog(@"支付宝");
        TopUpViewController *aliPay = [[TopUpViewController alloc] init];
        aliPay.paymentType = 2;
        aliPay.num = self.num;
        aliPay.dataDic = self.dataDic;
        [self.navigationController pushViewController:aliPay animated:YES];
    }else if([_selectedType isEqualToString:@"wxpay"]){
        NSLog(@"微信");
        TopUpViewController *weixinPay = [[TopUpViewController alloc] init];
        weixinPay.paymentType = 1;
        weixinPay.num = self.num;
        weixinPay.dataDic = self.dataDic;
        [self.navigationController pushViewController:weixinPay animated:YES];
    }else if([_selectedType isEqualToString:@"unionpay"]){
        NSLog(@"银联");
        TopUpViewController *upPay = [[TopUpViewController alloc] init];
        upPay.paymentType = 3;
        upPay.num = self.num;
        upPay.dataDic = self.dataDic;
        [self.navigationController pushViewController:upPay animated:YES];
    }else if([_selectedType isEqualToString:@"applepay"]){
        NSLog(@"applePay");
        TopUpViewController *applePay = [[TopUpViewController alloc] init];
        applePay.paymentType = 4;
        applePay.num = self.num;
        applePay.dataDic = self.dataDic;
        [self.navigationController pushViewController:applePay animated:YES];
    }else if([_selectedType isEqualToString:@"jdpay"]){
        NSLog(@"jdpay");
        TopUpViewController *jdpay = [[TopUpViewController alloc] init];
        jdpay.paymentType = 5;
        jdpay.num = self.num;
        jdpay.dataDic = self.dataDic;
        [self.navigationController pushViewController:jdpay animated:YES];
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

@end
