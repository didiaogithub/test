//
//  YunDouToProductViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/14.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "YunDouToProductViewController.h"
#import "CKMyProductLibVC.h"
#import "CKMyProductLibVCOld.h" //我的产品库3.1.1老模式
#import "CKCouponDetailViewController.h"
@interface YunDouToProductViewController ()<UITextFieldDelegate>
{
    UILabel *_beanNumberLable;
    UILabel *_leftBeansLable;
    UIView *_changeView;
    UIButton *_yundouToProductButton;
    NSString *_ckidString;
    NSString *_tackCashMaxMoney;
    UILabel *_minusMoneyLabel;
    UILabel *lineLable1;
    UIImageView *leftImgageView;
}
@property(nonatomic,strong)UITextField *moneyTextField;
@property (nonatomic, strong) UILabel *instructionTextLabel;
@end

@implementation YunDouToProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"云转产";
    _ckidString = KCKidstring;
    if (self.dataDic) {
        self.couponid = [self.dataDic objectForKey:@"voucherid"];
    }else{
        self.couponid = @"";
    }
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    [self createViews];
    [self getMaxYtoGMoney];
}

#pragma mark - 获取云转产最大金额
-(void)getMaxYtoGMoney {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"ckid":_ckidString, DeviceId:uuid};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getYlibtoGlibMoney_Url];
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        _tackCashMaxMoney = [NSString stringWithFormat:@"%@",dict[@"maxmoney"]];
        if (IsNilOrNull(_tackCashMaxMoney)) {
            _tackCashMaxMoney = @"";
        }
        _beanNumberLable.text = _tackCashMaxMoney;
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)createViews{

    if ([self.num isEqualToString:@"0"]) {
        _changeView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+15, SCREEN_WIDTH,AdaptedHeight(230))];
    }else{
       _changeView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+15, SCREEN_WIDTH,AdaptedHeight(330))];
    }
    [self.view addSubview:_changeView];
    _changeView.backgroundColor = [UIColor whiteColor];
    
    //剩余芸豆数量
    UIImageView *yundouImageView = [[UIImageView alloc] init];
    [_changeView addSubview:yundouImageView];
    [yundouImageView setImage:[UIImage imageNamed:@"mineyundou"]];
    [yundouImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(30));
        make.left.mas_offset(AdaptedWidth(15));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(25), AdaptedHeight(25)));
    }];
    
    //线
    UILabel *lineLable = [UILabel creatLineLable];
    [_changeView addSubview:lineLable];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yundouImageView.mas_bottom).offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(15));
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH -AdaptedWidth(30), 1));
    }];
    
    _leftBeansLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_changeView addSubview:_leftBeansLable];
    _leftBeansLable.text = @"可用云豆为：";
    [_leftBeansLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yundouImageView.mas_right).offset(AdaptedWidth(5));
        make.top.equalTo(yundouImageView.mas_top);
        make.bottom.equalTo(yundouImageView.mas_bottom);
        make.width.mas_offset(AdaptedWidth(100));
    }];
    //云豆数量
    _beanNumberLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_changeView addSubview:_beanNumberLable];
    _beanNumberLable.text = @"¥0";
    [_beanNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftBeansLable.mas_top);
        make.left.equalTo(_leftBeansLable.mas_right);
        make.bottom.equalTo(_leftBeansLable.mas_bottom);
    }];
    
 

    
    //金额图标
    leftImgageView = [[UIImageView alloc] init];
    [_changeView addSubview:leftImgageView];
    [leftImgageView setImage:[UIImage imageNamed:@"recharge"]];
    [leftImgageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yundouImageView.mas_bottom).offset(AdaptedHeight(30));
        make.left.equalTo(yundouImageView.mas_left);
        make.size.mas_offset(CGSizeMake(AdaptedHeight(25),AdaptedHeight(25)));
    }];
    //线1
    lineLable1 = [UILabel creatLineLable];
    [_changeView addSubview:lineLable1];
    [lineLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftImgageView.mas_bottom).offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(15));
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH -AdaptedWidth(30), 1));
    }];
    
    UILabel *showText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_changeView addSubview:showText];
    showText.text = @"金额：";
    [showText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftImgageView.mas_top);
        make.left.equalTo(leftImgageView.mas_right).offset(AdaptedWidth(5));
        make.width.mas_offset(AdaptedWidth(50));
        make.bottom.equalTo(leftImgageView.mas_bottom);
    }];

    _moneyTextField = [[UITextField alloc] init];
    [_changeView addSubview:_moneyTextField];
    _moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _moneyTextField.delegate = self;
    _moneyTextField.font = MAIN_TITLE_FONT;
    _moneyTextField.contentMode = UIViewContentModeTopLeft;
    [_moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_beanNumberLable.mas_bottom).offset(AdaptedHeight(18));
        make.left.equalTo(showText.mas_right);
        make.right.mas_offset(-AdaptedWidth(15));
        make.height.mas_offset(AdaptedHeight(50));
    }];
    _moneyTextField.leftViewMode = UITextFieldViewModeAlways;
    _moneyTextField.textAlignment = NSTextAlignmentLeft;
    NSString *type = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Ktype]];
    if ([type isEqualToString:@"B"]) {
        NSString *str = [NSString stringWithFormat:@"进货金额不能少于¥%@", CKYSmsgBeanToMoneyCK];
       _moneyTextField.placeholder = str;
    }else if([type isEqualToString:@"D"]){
        NSString *str = [NSString stringWithFormat:@"进货金额不能少于¥%@", CKYSmsgBeanToMoneyFX];
       _moneyTextField.placeholder = str;
    }
    
    // 优惠券
    
    if (![self.num isEqualToString:@"0"]) {
       [self addcouponView];
    }
    
    
    UIImageView *bottomImageView = [[UIImageView alloc] init];
    [_changeView addSubview:bottomImageView];
    [bottomImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_changeView.mas_bottom).offset(-20);
        make.left.mas_offset(AdaptedWidth(35));
        make.right.mas_offset(-AdaptedWidth(35));
        make.height.mas_offset(40);
    }];

    //转化按钮
    _yundouToProductButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_changeView addSubview:_yundouToProductButton];
    _yundouToProductButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [_yundouToProductButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bottomImageView);
    }];
    [_yundouToProductButton setTitle:@"确认" forState:UIControlStateNormal];
    [_yundouToProductButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yundouToProductButton addTarget:self action:@selector(clickTopUpButton) forControlEvents:UIControlEventTouchUpInside];


}

// 添加优惠券
- (void)addcouponView{
    UIView *couponView = [[UIView alloc]init];
    couponView.backgroundColor = [UIColor whiteColor];
    [_changeView addSubview:couponView];
    [couponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLable1.mas_bottom).offset(AdaptedHeight(1));
        make.left.right.equalTo(_changeView);
        make.height.mas_offset(AdaptedHeight(58));
        make.width.equalTo(_changeView);
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
    
    // 透明btn
    
    UIButton *couponButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [couponButton addTarget:self action:@selector(clickCouponButton) forControlEvents:UIControlEventTouchUpInside];
    couponButton.backgroundColor = [UIColor clearColor];
    [couponView addSubview:couponButton];
    [couponButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(couponView);
    }];
    
    
    
    // 线2
    UILabel *lineLable2 = [UILabel creatLineLable];
    [_changeView addSubview:lineLable2];
    [lineLable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLable1.mas_bottom).offset(AdaptedHeight(60));
        make.left.mas_offset(AdaptedWidth(15));
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH -AdaptedWidth(30), 1));
    }];
    
    // 说明文字
    _instructionTextLabel = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_changeView addSubview:_instructionTextLabel];
    _instructionTextLabel.text = @"说明：产品抵用券在产品进货时使用，产品进货支付金额=输入进货金额-产品抵用券金额。";
    _instructionTextLabel.numberOfLines = 0;
    [_instructionTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(AdaptedWidth(15));
        make.top.equalTo(lineLable2.mas_bottom).offset(AdaptedHeight(10));
        make.width.mas_offset(SCREEN_WIDTH - AdaptedWidth(40));
    }];
    
}
/**点击充值转换按钮*/
-(void)clickTopUpButton{
    [self.moneyTextField resignFirstResponder];
    NSString *type = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Ktype]];
    if ([type isEqualToString:@"B"]) {//创客
        if ([_moneyTextField.text integerValue] < [CKYSmsgBeanToMoneyCK integerValue]) {
            NSString *str = [NSString stringWithFormat:@"转出金额不得低于%@", CKYSmsgBeanToMoneyCK];
            [self showNoticeView:str];
            return;
        }
    }else if([type isEqualToString:@"D"]){
        if ([_moneyTextField.text integerValue] < [CKYSmsgBeanToMoneyFX integerValue]) {
            NSString *str = [NSString stringWithFormat:@"转出金额不得低于%@", CKYSmsgBeanToMoneyFX];
            [self showNoticeView:str];
            return;
        }
    }
    if ([_moneyTextField.text integerValue] > [_tackCashMaxMoney integerValue]) {
        [self showNoticeView:@"超过当前最大可转金额"];
        return;
    }
  
    //点击提现按钮 弹出选择框
    [MessageAlert shareInstance].isDealInBlock = YES;
    [[MessageAlert shareInstance] hiddenCancelBtn:NO];
    
    
    NSString *content = [NSString stringWithFormat:@"您确认要转入%@到产品库吗?",_moneyTextField.text];
    [[MessageAlert shareInstance] showCommonAlert:content btnClick:^{

        if (IsNilOrNull(_ckidString)){
            _ckidString = @"";
        }
        NSString *uuid = DeviceId_UUID_Value;
        if (IsNilOrNull(uuid)){
            uuid = @"";
        }
        
        if (IsNilOrNull(self.couponMoney)) {
            self.couponMoney = @"0";
        }
        if (IsNilOrNull(self.couponid)) {
            self.couponid = @"";
        }
        
        NSDictionary *pramaDic = @{@"ckid":_ckidString, @"money":_moneyTextField.text, DeviceId:uuid, @"voucherid":self.couponid};
        
//        NSDictionary *pramaDic = @{@"ckid":_ckidString,@"money":_moneyTextField.text,DeviceId:uuid};
        NSString *addGlibByYlibUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI, addGlibByYlib_Url];
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
        [HttpTool postWithUrl:addGlibByYlibUrl params:pramaDic success:^(id json) {
            [self.viewDataLoading stopAnimation];
            NSDictionary *dict = json;
            if ([dict[@"code"] integerValue] != 200){
                [self showNoticeView:dict[@"codeinfo"]];
                return ;
            }
            [self showNoticeView:[NSString stringWithFormat:@"您成功充值%@",_moneyTextField.text]];
            
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
        } failure:^(NSError *error) {
            [self.viewDataLoading stopAnimation];
            if (error.code == -1009) {
                [self showNoticeView:NetWorkNotReachable];
            }else{
                [self showNoticeView:NetWorkTimeout];
            }
        }];
    }];
}

/** 点击优惠券跳转*/

- (void)clickCouponButton{
    NSLog(@"点击了优惠券");
    CKCouponDetailViewController *couponDetailVc = [[CKCouponDetailViewController alloc]init];
    [self.navigationController pushViewController:couponDetailVc animated:YES];
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

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *amountText = self.moneyTextField.text;
    NSString *regStr = @"^([1-9][\\d]{0,100}|0)(\\.[\\d]{0,1})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regStr];
    BOOL match = [predicate evaluateWithObject:amountText];
    if ([string isEqualToString:@""]) return YES;  // 始终允许用户删除
    BOOL result = [amountText isEqualToString:@""] ? YES : (match || [string isEqualToString:@"."]);
    return result;
}

@end
