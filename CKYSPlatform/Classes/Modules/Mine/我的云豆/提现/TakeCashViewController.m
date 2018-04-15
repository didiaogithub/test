//
//  TakeCashViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/2.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "TakeCashViewController.h"
#import "SelectedBankCardViewController.h"
#import "CardModel.h"
#import "FFAlertView.h"

@interface TakeCashViewController ()<UITextFieldDelegate>
{
    UIButton *_selectedBankCardButton;
    UILabel *_currentBeanLable;
    UIButton *_takecashButton;
    UILabel *_maxTakeCashLable; //最大可提现金额
    NSString *_ckidString;
    CardModel *_cardModel;
    CardModel *_transModel;
    NSString *_maxCash;
    NSString *_ylibMoneyStr;
    NSString *_idString;
    NSString *_tranIdStr;
}

@property (nonatomic, strong) UITextField *moneyTextField;

@end

@implementation TakeCashViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDefautBankCardData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    
    if (IsNilOrNull(self.curretYylibMoney) || IsNilOrNull(self.maxCash)){
        [self getCurrentBeanNumberData];
    }
    
    //提现提示
    [self showAler];
    [self createTakeCashViews];
    [self refreshLable];
}

/**获取当前云豆库数量*/
-(void)getCurrentBeanNumberData{
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"ckid":_ckidString,DeviceId:uuid};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getYlibMoney_Url];

    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }

        _maxCash = [NSString stringWithFormat:@"%@",dict[@"maxCash"]];
        if (IsNilOrNull(_maxCash)) {
            _maxCash = @"0.00";
        }
        _ylibMoneyStr = [NSString stringWithFormat:@"%@",dict[@"ylibmoney"]];
        if(IsNilOrNull(_ylibMoneyStr)){
            _ylibMoneyStr = @"0.00";
        }
        [self refreshWithCurrentYlib:_ylibMoneyStr andMaxCash:_maxCash];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}
-(void)refreshWithCurrentYlib:(NSString *)ylibmoney andMaxCash:(NSString *)maxCash{
    if (IsNilOrNull(ylibmoney) || [ylibmoney isEqualToString:@"0"]){
        ylibmoney = @"0.00";
    }
    if (IsNilOrNull(maxCash) || [maxCash isEqualToString:@"0"]){
        maxCash = @"0.00";
    }
    double ylibMoneyDouble = [ylibmoney doubleValue];
    double maxCashDouble = [maxCash doubleValue];
    _currentBeanLable.text = [NSString stringWithFormat:@"当前云豆库余额¥%.2f",ylibMoneyDouble];
    _maxTakeCashLable.text = [NSString stringWithFormat:@"您当前最大可提现额度为¥%.2f",maxCashDouble];
}

#pragma mark - 提现提示
-(void)showAler{
    
    FFAlertView *alertView = [FFAlertView shareInstance];
    alertView.titleColor = [UIColor tt_redMoneyColor];
    alertView.titleFont = MAIN_TITLE_FONT;
    alertView.titleTextAlignment = NSTextAlignmentLeft;
    alertView.contentFont = MAIN_TITLE_FONT;
    alertView.contentColor = TitleColor;
    
    NSString *noticeText = @"";
    if([self.isLock isEqualToString:@"1"]){ //有锁定
       noticeText = @"产品库<0:最大提现金额=云豆库总额+产品库金额-锁定金额\n产品库>=0:最大提现金额=云豆库总额-锁定金额";
    }else{ //无锁定
       noticeText = @"产品库<0:最大提现金额=云豆库总额+产品库金额\n产品库>=0:最大提现金额=云豆库总额";
    }
    [alertView showAlert:noticeText content:@"温馨提示:\n1、为了保障您的账户安全,创客家人们在提现时输入的银行卡的开户人姓名必须和创客姓名一致;\n2、目前提现支持所有带银联标志的储蓄卡,开户行名称为XX银行;\n3、您的提现申请提交成功后,正常情况下提现金额在1-3个工作日内到账。"];

}
/**获取默认的银行卡*/
-(void)getDefautBankCardData{
    if (IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getDefaultBankCard_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString,DeviceId:uuid};
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict= json;
        if([dict[@"code"] integerValue] != 200){
            NSLog(@"%@",dict[@"codeinfo"]);
            return ;
        }
        _cardModel = [[CardModel alloc] init];
        [_cardModel setValuesForKeysWithDictionary:dict];
        [self refreshWithModel:_cardModel];

    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
-(void)refreshWithModel:(CardModel *)cardModel{
    NSString *bankName = [NSString stringWithFormat:@"%@",cardModel.bankname];
    NSString *bankCardNo = [NSString stringWithFormat:@"%@",cardModel.bankcardno];
    if (IsNilOrNull(bankCardNo)) {
        bankCardNo = @"";
    }
    if (IsNilOrNull(bankName)) {
        bankName = @"请先选择银行卡";
    }
    if (!_transModel){
        [_selectedBankCardButton setTitle:[NSString stringWithFormat:@"%@(尾号%@)",bankName,bankCardNo] forState:UIControlStateNormal];
    }
    
}
#pragma mark-创建view
-(void)createTakeCashViews{
    
    UIView *bankView = [[UIView alloc] init];
    [self.view addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64+AdaptedHeight(10));
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH,AdaptedHeight(300)));
    }];
    
    UILabel *cardText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:cardText];
    cardText.text = @"银行卡";
    [cardText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(20);
        make.size.mas_offset(CGSizeMake(50, 20));
    }];

    //使用的银行卡
    _selectedBankCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_selectedBankCardButton];
    [_selectedBankCardButton setTitleColor:[UIColor tt_blueColor] forState:UIControlStateNormal];
    [_selectedBankCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(cardText.mas_right).offset(5);
        make.height.mas_offset(50*SCREEN_HEIGHT_SCALE);
        make.right.mas_offset(-20);
    }];
    _selectedBankCardButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_selectedBankCardButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_selectedBankCardButton setTitle:@"点击添加银行卡" forState:UIControlStateNormal];
    [_selectedBankCardButton addTarget:self action:@selector(clickSelectedBankCardButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *firstLine = [UILabel creatLineLable];
    [bankView addSubview:firstLine];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_selectedBankCardButton.mas_bottom);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - 30, 1));
    }];
    
    UILabel *moneyText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:moneyText];
    moneyText.text = @"提现金额";
    [moneyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLine.mas_bottom).offset(15);
        make.left.equalTo(cardText.mas_left);
        make.size.mas_offset(CGSizeMake(80, 15));
    }];
    
    UIImageView *leftImgageView = [[UIImageView alloc] init];
    [bankView addSubview:leftImgageView];
    [leftImgageView setImage:[UIImage imageNamed:@"recharge"]];
    leftImgageView.frame = CGRectMake(10, 0, 85, 25);
    leftImgageView.contentMode= UIViewContentModeLeft;
    _moneyTextField = [[UITextField alloc] init];
    [bankView addSubview:_moneyTextField];
    _moneyTextField.placeholder = @"请输入金额";
    _moneyTextField.delegate = self;
    
    [_moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyText.mas_bottom).offset(5);
        make.left.equalTo(moneyText.mas_left);
        make.height.mas_offset(50*SCREEN_HEIGHT_SCALE);
        make.right.equalTo(_selectedBankCardButton.mas_right);
    }];
    _moneyTextField.textAlignment = NSTextAlignmentRight;
    _moneyTextField.leftView = leftImgageView;
    _moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _moneyTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //第二条线
    UILabel *secondLineLable = [UILabel creatLineLable];
    [bankView addSubview:secondLineLable];
    [secondLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyTextField.mas_bottom);
        make.left.equalTo(firstLine.mas_left);
        make.width.and.height.mas_equalTo(firstLine);
    }];
    //剩余芸豆数量
    _currentBeanLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_currentBeanLable];
    [_currentBeanLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLineLable.mas_bottom).offset(8);
        make.left.equalTo(leftImgageView.mas_left);
        make.right.mas_offset(-30);
    }];
    
    //最大提现金额
    _maxTakeCashLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_maxTakeCashLable];
    _maxTakeCashLable.text = @"您当前最大可提现额度为¥0.00";
    [_maxTakeCashLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_currentBeanLable.mas_bottom).offset(8);
        make.left.equalTo(_currentBeanLable.mas_left);
        make.right.equalTo(_currentBeanLable.mas_right);
    }];
    
    
    //确认按钮
    UIImageView *pinkbankImageView = [[UIImageView alloc] init];
    [bankView addSubview:pinkbankImageView];
    [pinkbankImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [pinkbankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_maxTakeCashLable.mas_bottom).offset(AdaptedHeight(15));
        make.left.mas_offset(AdaptedWidth(35));
        make.right.mas_offset(-AdaptedWidth(35));
        make.height.mas_offset(40);
    }];

    _takecashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_takecashButton];
    _takecashButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [_takecashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(pinkbankImageView);
    }];
    [_takecashButton setTitle:@"确认" forState:UIControlStateNormal];
    [_takecashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_takecashButton addTarget:self action:@selector(clickTakeCashButton) forControlEvents:UIControlEventTouchUpInside];
}
-(void)refreshLable{
    if(IsNilOrNull(self.maxCash) || [self.maxCash isEqualToString:@"0"]){
       self.maxCash = @"0.00";
    }
    double maxCashDouble = [self.maxCash doubleValue];
    _maxTakeCashLable.text = [NSString stringWithFormat:@"您当前最大可提现额度为¥%.2f",maxCashDouble];
    
    if (IsNilOrNull(self.curretYylibMoney) || [self.curretYylibMoney isEqualToString:@"0"]) {
        self.curretYylibMoney = @"0.00";
    }
    double ylibDouble = [self.curretYylibMoney doubleValue];
    _currentBeanLable.text = [NSString stringWithFormat:@"当前云豆库余额¥%.2f",ylibDouble];
    
}
#pragma mark-点击提现申请 按钮
-(void)clickTakeCashButton{
    
    [_moneyTextField resignFirstResponder];
    if(IsNilOrNull(_moneyTextField.text)){
        [self showNoticeView:@"请输入提现金额"];
        return;
    }
    if([_moneyTextField.text integerValue] < [CKYSmsggetmoney integerValue]){
        NSString *str = [NSString stringWithFormat:@"提现金额不得少于%@元", CKYSmsggetmoney];
        [self showNoticeView:str];
        return;
    }
    float maxCash = 0;
    if (self.maxCash){
        maxCash = [self.maxCash floatValue];
    }else{
        maxCash = [_maxCash floatValue];
    }
 
    float takeMoney = [_moneyTextField.text floatValue];
    if (takeMoney > maxCash) {
        [self showNoticeView:@"超过最大可提现金额"];
        return;
    }
    NSString *title = _selectedBankCardButton.titleLabel.text;
    if([title isEqualToString:@"点击添加银行卡"]){
        [self showNoticeView:@"请先添加银行卡"];
        return;
    }
    
    [_moneyTextField resignFirstResponder];
    //点击提现按钮 弹出选择框
    [MessageAlert shareInstance].isDealInBlock = YES;
    [[MessageAlert shareInstance] hiddenCancelBtn:NO];
    
    NSString *content = [NSString stringWithFormat:@"确认提现到%@中？",title];
    [[MessageAlert shareInstance] showCommonAlert:content btnClick:^{
        
        if (IsNilOrNull(_ckidString)){
            _ckidString = @"";
        }
        if (IsNilOrNull(_moneyTextField.text)) {
            _moneyTextField.text = @"";
        }
        NSString *cardId = [NSString stringWithFormat:@"%@",_cardModel.ID];
        if (IsNilOrNull(cardId)) {
            cardId = @"";
        }
        NSString *uuid = DeviceId_UUID_Value;
        if (IsNilOrNull(uuid)){
            uuid = @"";
        }
        NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,withDrawCash_Url];
        NSDictionary *pramaDic = @{@"ckid":_ckidString,@"money":_moneyTextField.text,@"bankcardId":cardId,DeviceId:uuid};
        
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
        [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
            [self.viewDataLoading stopAnimation];
            NSDictionary *dict= json;
            if([dict[@"code"] integerValue] != 200){
                [self showNoticeView:dict[@"codeinfo"]];
                return ;
            }
            [self showNoticeView:@"您的提现申请已提交"];
            [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark-点击选择银行卡按钮
-(void)clickSelectedBankCardButton{
     __typeof (self) __weak weakSelf = self;
    
    SelectedBankCardViewController *selectedBankCard = [[SelectedBankCardViewController alloc]init];
    [selectedBankCard setBankcardBlock:^(CardModel *bankCardModel) {
        _transModel = bankCardModel;
        NSString *bankName = [NSString stringWithFormat:@"%@",_transModel.bankname];
        NSString *bankcardNo = [NSString stringWithFormat:@"%@",_transModel.bankcardno];
        NSString *bankcardStr = [NSString stringWithFormat:@"%@(尾号%@)",bankName,bankcardNo];
        [_selectedBankCardButton setTitle:bankcardStr forState:UIControlStateNormal];
        _tranIdStr = [NSString stringWithFormat:@"%@",_transModel.ID];
        
    }];
    [selectedBankCard setBackBlock:^(NSString *deleteBankCardId){
        if (_transModel){
            _transModel = nil;
        }
        if ([_tranIdStr isEqualToString:deleteBankCardId]){
            [weakSelf getDefautBankCardData];
        }
    }];
    [self.navigationController pushViewController:selectedBankCard animated:YES];
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
