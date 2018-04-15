//
//  CKCloudBeanViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/4.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKCloudBeanViewController.h"
#import "TakeCashViewController.h"
#import "CKYLibDetailViewController.h"
#import "CKYLibDetailVCOld.h" //3.1.1之前界面
#import "TakeCashRecordViewController.h"
#import "LeftPicRightTextView.h"
#import "SalesBonusViewController.h"
#import "YundouModel.h"
#import "SaveView.h"
#import "PartnerIncomeViewController.h"
#import "CKMonthStatisticsViewController.h"//3.1.3界面未上
#import "CKMonthStatisticsVCOld.h"//3.1.1之前界面
#import "CKMonthIncomeViewController.h"//3.1.4月结收益界面

@interface CKCloudBeanViewController ()<LeftPicRightTextViewDelegate>

@property (nonatomic, strong) UILabel *todayNumberLable;
@property (nonatomic, strong) UILabel *yesNumberLable;
@property (nonatomic, strong) UIButton *takeCashButton;
@property (nonatomic, strong) YundouModel *yundouModel;
@property (nonatomic, copy)   NSString *ckidString;
@property (nonatomic, copy)   NSString *ylibMoney;
@property (nonatomic, copy)   NSString *maxCash;
@property (nonatomic, copy)   NSString *currentYlibMoney;


@property(nonatomic,strong)LeftPicRightTextView *yundouView;
@property(nonatomic,strong)LeftPicRightTextView *takeCashView;
@property(nonatomic,strong)LeftPicRightTextView *monthView;
@property(nonatomic,strong)LeftPicRightTextView *partnerView;
@property(nonatomic,strong)SaveView *saveView;
@property(nonatomic,strong)UILabel *myBeanNumberLable;

@property(nonatomic,strong)UIView *topValueView;
@property(nonatomic,strong)UIButton *coverButton;

@end

@implementation CKCloudBeanViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getCurrentBeanNumberData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的云豆";
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    [self createYunDouView];
    
    [self getLimitMoney];
}

-(void)getLimitMoney {
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
    }];
}

#pragma mark - 获取当前云豆库数量
- (void)getCurrentBeanNumberData {
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"ckid":_ckidString, DeviceId:uuid};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getYlibMoney_Url];
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        _yundouModel = [[YundouModel alloc] init];
        [_yundouModel setValuesForKeysWithDictionary:dict];
        [self refreshWithlibMoney:_yundouModel];
        NSString *maxCash = [NSString stringWithFormat:@"%@",_yundouModel.maxCash];
        if (IsNilOrNull(maxCash) || [maxCash isEqualToString:@"0"]) {
            maxCash = @"0.00";
        }
        _maxCash = maxCash;
        
        NSString *ylibMoneyStr = [NSString stringWithFormat:@"%@",_yundouModel.ylibmoney];
        if(IsNilOrNull(ylibMoneyStr) || [ylibMoneyStr isEqualToString:@"0"]){
            ylibMoneyStr = @"0.00";
            
        }
        _currentYlibMoney = ylibMoneyStr;
        
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)refreshWithlibMoney:(YundouModel *)yundouModel{
    NSString *ylibMoney = [NSString stringWithFormat:@"%@",yundouModel.ylibmoney];
    NSString *addmoneyYesterday = [NSString stringWithFormat:@"%@",yundouModel.addmoneyYesterday];
    NSString *addmoneyToday = [NSString stringWithFormat:@"%@",yundouModel.addmoneyToday];
    if (IsNilOrNull(ylibMoney)){
        ylibMoney = @"0.00";
    }
    //    //我的云豆
    double myYlibDouble = [ylibMoney doubleValue];
    _myBeanNumberLable.text = [NSString stringWithFormat:@"¥%.2f",myYlibDouble];
    
    if (IsNilOrNull(addmoneyYesterday)){
        addmoneyYesterday = @"0.00";
    }
    double yestodayValueDouble = [addmoneyYesterday doubleValue];
    self.yesNumberLable.text = [NSString stringWithFormat:@"¥%.2f",yestodayValueDouble];
    
    if (IsNilOrNull(addmoneyToday)) {
        addmoneyToday = @"0.00";
    }
    double todayValueDouble = [addmoneyToday doubleValue];
    self.todayNumberLable.text = [NSString stringWithFormat:@"¥%.2f",todayValueDouble];
    
}

-(void)createYunDouView{
    _topValueView = [[UIView alloc] init];
    [self.view addSubview:_topValueView];
    _topValueView.backgroundColor = [UIColor tt_bigRedBgColor];
    [_topValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64+NaviAddHeight);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH,AdaptedHeight(100)));
    }];
    
    //今日数值
    float lableWidth = (SCREEN_WIDTH - 0.5)/2;
    self.todayNumberLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM_BOLD(AdaptedHeight(21))];
    [_topValueView addSubview:self.todayNumberLable];
    self.todayNumberLable.text = @"¥0.00";
    [self.todayNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(30));
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(lableWidth,AdaptedHeight(21)));
    }];
    
    UILabel *todayLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [_topValueView addSubview:todayLable];
    todayLable.text = @"今日到账";
    [todayLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.todayNumberLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(self.todayNumberLable.mas_left);
        make.width.equalTo(self.todayNumberLable.mas_width);
        make.height.mas_offset(15);
    }];
    
    UILabel *verticalLineLable = [[UILabel alloc] init];
    [verticalLineLable setBackgroundColor:[UIColor whiteColor]];
    [_topValueView addSubview:verticalLineLable];
    [verticalLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.equalTo(self.todayNumberLable.mas_right).offset(1);
        make.size.mas_offset(CGSizeMake(1, AdaptedHeight(80)));
        make.bottom.mas_offset(-AdaptedHeight(10));
    }];
    
    self.yesNumberLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM_BOLD(AdaptedHeight(21))];
    [_topValueView addSubview:self.yesNumberLable];
    self.yesNumberLable.text = @"¥0.00";
    [self.yesNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.todayNumberLable.mas_top);
        make.left.equalTo(verticalLineLable.mas_right);
        make.width.and.height.mas_equalTo(self.todayNumberLable);
    }];
    
    UILabel *yesLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [_topValueView addSubview:yesLable];
    yesLable.text = @"昨日到账";
    [yesLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(todayLable.mas_top);
        make.left.equalTo(self.yesNumberLable.mas_left);
        make.width.and.height.mas_equalTo(todayLable);
    }];
    
    
    UIView *beanView = [[UIView alloc] init];
    [self.view addSubview:beanView];
    [beanView setBackgroundColor:[UIColor whiteColor]];
    [beanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topValueView.mas_bottom).offset(AdaptedHeight(10));
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(65));
    }];
    
    UIImageView *beanleftImageView = [[UIImageView alloc] init];
    [beanView addSubview:beanleftImageView];
    beanleftImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *beanImage = [UIImage imageNamed:@"mineyundou"];
    [beanleftImageView setImage:beanImage];
    [beanleftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(20));
        make.left.mas_offset(AdaptedWidth(32));
        make.size.mas_offset(CGSizeMake(25, 25));
        make.bottom.mas_offset(-AdaptedHeight(20));
    }];
    
    UILabel *beanText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [beanView addSubview:beanText];
    beanText.text = @"云豆库";
    [beanText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(beanleftImageView.mas_top);
        make.left.equalTo(beanleftImageView.mas_right).offset(AdaptedWidth(30));
        make.bottom.equalTo(beanleftImageView.mas_bottom);
        make.width.mas_offset(AdaptedWidth(50));
    }];
    
    
    //提现
    _takeCashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [beanView addSubview:_takeCashButton];
    [_takeCashButton setImage:[UIImage imageNamed:@"takecashbank"] forState:UIControlStateNormal];
    _takeCashButton.adjustsImageWhenHighlighted = NO;
    [_takeCashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if ([UIScreen mainScreen].bounds.size.height < 667) {
            make.width.mas_offset(80);
            make.top.mas_offset(AdaptedHeight(15));
            make.bottom.mas_offset(-AdaptedHeight(15));
        }else{
            make.width.mas_offset(106);
            make.top.mas_offset(AdaptedHeight(10));
            make.bottom.mas_offset(-AdaptedHeight(10));
        }
        make.right.mas_offset(-10);
    }];
    
    [_takeCashButton addTarget:self action:@selector(clickTakeCashButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    //云豆数
    _myBeanNumberLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [beanView addSubview:_myBeanNumberLable];
    _myBeanNumberLable.text = @"¥0.00";
    [_myBeanNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(beanText.mas_right).offset(AdaptedWidth(5));
        make.height.mas_offset(30);
        make.bottom.mas_offset(0);
        make.right.equalTo(_takeCashButton.mas_left).offset(-AdaptedWidth(10));
    }];
    
    //查看芸豆库详情
    UIButton *beanDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [beanView addSubview:beanDetailButton];
    [beanDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.equalTo(_takeCashButton.mas_left);
        make.bottom.mas_offset(0);
    }];
    [beanDetailButton addTarget:self action:@selector(clickBeanDetailButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    //月结
    _monthView = [[LeftPicRightTextView alloc] initWithFrame:CGRectZero andTitle:@"月结收益" andImage:@"littlemonth" isShowRight:YES andTag:2110];
    [self.view addSubview:_monthView];
    _monthView.delegate = self;
    [_monthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(beanView.mas_bottom).offset(AdaptedHeight(10));
        make.left.width.height.equalTo(beanView);
    }];
    
    
    _takeCashView = [[LeftPicRightTextView alloc] initWithFrame:CGRectZero andTitle:@"提现记录" andImage:@"takecashrecord" isShowRight:YES andTag:2111];
    [self.view addSubview:_takeCashView];
    _takeCashView.delegate = self;
    [_takeCashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_monthView.mas_bottom).offset(AdaptedHeight(10));
        make.left.width.height.equalTo(beanView);
    }];
    
    //推广人登录
    NSString *sales = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    if ([sales isEqualToString:@"0"]) {
        _takeCashButton.hidden = NO;
        _monthView.hidden = NO;
    }else{ //非0
        _takeCashButton.hidden = YES;
        _monthView.hidden = YES;
    }
}

#pragma mark-点击提现按钮
-(void)clickTakeCashButton {
    
    NSString *ylibmoney = [NSString stringWithFormat:@"%@", _yundouModel.ylibmoney];
    if (!IsNilOrNull(ylibmoney) && [ylibmoney doubleValue] <= 0) {
        MessageAlert *alert = [[MessageAlert alloc] init];
        alert.isDealInBlock = NO;
        [alert hiddenCancelBtn:YES];
        [alert showAlert:@"您的云豆库余额不足，暂不能提现" btnClick:^{
            
        }];
        return;
    }
    
    NSString *glibmoney = [NSString stringWithFormat:@"%@", _yundouModel.glibmoney];
    if (!IsNilOrNull(glibmoney) && [glibmoney doubleValue] < 0) {
        MessageAlert *alert = [[MessageAlert alloc] init];
        alert.isDealInBlock = NO;
        [alert hiddenCancelBtn:YES];
        [alert showAlert:@"您的产品库存小于0，暂不能提现，请先完成进货再来提现吧！" btnClick:^{

        }];
        return;
    }
    
    if(IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
    NSString *uid = DeviceId_UUID_Value;
    if (IsNilOrNull(uid)){
        uid = @"";
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, withDrawCash_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString, @"money":@"", DeviceId:uid};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict= json;
        if([dict[@"code"] integerValue] != 200){  //提现验证不通过
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        NSString *islock = [NSString stringWithFormat:@"%@",_yundouModel.islock];
        TakeCashViewController *takeCash = [[TakeCashViewController alloc] init];
        takeCash.maxCash = _maxCash;
        takeCash.curretYylibMoney = _currentYlibMoney;
        takeCash.joinType = self.joinType;
        takeCash.isLock = islock;
        [self.navigationController pushViewController:takeCash animated:YES];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 点击查看芸豆库详情
- (void)clickBeanDetailButton {
    
    NSString *glibmoney = [NSString stringWithFormat:@"%@", _yundouModel.glibmoney];
    NSString *islock = [NSString stringWithFormat:@"%@",_yundouModel.islock];
    
    NSString *monthcalmode = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_monthcalmode"]];
    if ([monthcalmode isEqualToString:@"1"]) {
        CKYLibDetailViewController *beanDetail = [[CKYLibDetailViewController alloc] init];
        beanDetail.joinType = self.joinType;
        beanDetail.maxCash = _maxCash;
        beanDetail.currentYlibMoney = _currentYlibMoney;
        beanDetail.currentGlibMoney = glibmoney;
        beanDetail.islock = islock;
        [self.navigationController pushViewController:beanDetail animated:YES];
    }else{
        CKYLibDetailVCOld *beanDetail = [[CKYLibDetailVCOld alloc] init];
        beanDetail.joinType = self.joinType;
        beanDetail.maxCash = _maxCash;
        beanDetail.currentYlibMoney = _currentYlibMoney;
        beanDetail.currentGlibMoney = glibmoney;
        beanDetail.islock = islock;
        [self.navigationController pushViewController:beanDetail animated:YES];
    }
}

#pragma mark-代理方法
-(void)monthDetailJumpWithTag:(NSInteger)tag{
    if (tag == 0) {
        if ([self.type isEqualToString:@"D"]){
            [self showNoticeView:CKYSmsgshopstatusNoRight];
            return;
        }
        
        NSString *monthcalmode = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_monthcalmode"]];
        //0：显示老月结页面，1：新月结页面
        if ([monthcalmode isEqualToString:@"1"]) {
            //3.1.4月结页面
            CKMonthIncomeViewController *monthvc = [[CKMonthIncomeViewController alloc] init];
            //3.1.3版本月结，暂时不用
//            CKMonthStatisticsViewController *monthvc = [[CKMonthStatisticsViewController alloc] init];
            [self.navigationController pushViewController:monthvc animated:YES];
        }else{
            CKMonthStatisticsVCOld *monthvc = [[CKMonthStatisticsVCOld alloc] init];
            [self.navigationController pushViewController:monthvc animated:YES];
        }
    }else{ //提现记录
        
        TakeCashRecordViewController *takecashVc = [[TakeCashRecordViewController alloc] init];
        [self.navigationController pushViewController:takecashVc animated:YES];
    }
}

@end
