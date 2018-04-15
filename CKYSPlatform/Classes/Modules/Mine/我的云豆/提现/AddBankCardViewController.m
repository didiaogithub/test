//
//  AddBankCardViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/3.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "BankCardInfoViewController.h"
@interface AddBankCardViewController ()<UITextFieldDelegate>
{
    UITextField *_nameTextField; //持卡人
    UITextField *_cardNumberTextField; //卡号
    UITextField *_bankNameTextField; //开户银行
    UIButton *_nextButton;
    NSString *_ckidString;

}
@end

@implementation AddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加银行卡";
    [self createViews];
}
-(void)createViews{

    
    UIView *cardBankView = [[UIView alloc] init];
    [self.view addSubview:cardBankView];
    [cardBankView setBackgroundColor:[UIColor whiteColor]];
    [cardBankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10)+64);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(320));
    }];
    
    //持卡人 lable
    UILabel *textNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    textNameLable.text = @"持卡人";
    [cardBankView addSubview:textNameLable];
    [textNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(30));
        make.left.mas_offset(AdaptedWidth(30));
        make.width.mas_offset(AdaptedWidth(60));
    }];
    
    
    _nameTextField = [[UITextField alloc] init];
    [cardBankView addSubview:_nameTextField];
    _nameTextField.placeholder = @"请输入姓名";
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.equalTo(textNameLable.mas_right).offset(30);
        make.right.mas_offset(-AdaptedWidth(30));
        make.height.mas_offset(AdaptedHeight(50));
    }];
    
    UILabel *firstLable = [UILabel creatLineLable];
    [cardBankView addSubview:firstLable];
    [firstLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameTextField.mas_bottom);
        make.left.mas_offset(AdaptedWidth(20));
        make.right.mas_offset(-AdaptedWidth(20));
        make.height.mas_offset(1);
    }];
    
    UILabel *textAcountNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [cardBankView addSubview:textAcountNameLable];
    
    textAcountNameLable.text = @"开户银行";
    [textAcountNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLable.mas_bottom).offset(AdaptedHeight(30));
        make.left.and.width.and.height.mas_equalTo(textNameLable);
    }];
    
    _bankNameTextField = [[UITextField alloc] init];
    [cardBankView addSubview:_bankNameTextField];
    _bankNameTextField.placeholder = @"请输入开户银行";
    [_bankNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLable.mas_bottom).offset(AdaptedHeight(15));
        make.left.and.width.and.height.equalTo(_nameTextField);
    }];
    
    //开户银行下面的线
    UILabel *secondLineLable = [UILabel creatLineLable];
    [cardBankView addSubview:secondLineLable];
    [secondLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bankNameTextField.mas_bottom);
        make.left.right.height.equalTo(firstLable);
    }];

    
    //卡号
    UILabel *textCard = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [cardBankView addSubview:textCard];
    textCard.text = @"卡号";
    [textCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLineLable.mas_bottom).offset(AdaptedHeight(30));
        make.left.and.width.and.height.mas_equalTo(textNameLable);
    }];
    
    
    _cardNumberTextField = [[UITextField alloc] init];
    [cardBankView addSubview:_cardNumberTextField];
    _cardNumberTextField.placeholder = @"请输入银行卡卡号";
    _cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _cardNumberTextField.delegate = self;
    _cardNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_cardNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLineLable.mas_bottom).offset(AdaptedHeight(15));
        make.left.and.width.and.height.equalTo(_nameTextField);
    }];
    
    UILabel *threenLineLable = [UILabel creatLineLable];
    [cardBankView addSubview:threenLineLable];
    [threenLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cardNumberTextField.mas_bottom);
        make.left.and.width.and.height.equalTo(firstLable);
        
    }];
    //下一步
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [cardBankView addSubview:bankImageView];
    [bankImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threenLineLable.mas_bottom).offset(AdaptedHeight(50));
        make.left.mas_offset(AdaptedWidth(35));
        make.height.mas_offset(AdaptedHeight(40));
        make.right.mas_offset(-AdaptedWidth(35));
    }];
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cardBankView addSubview:_nextButton];
    _nextButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bankImageView);
    }];
    [_nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];

}

//检测是否为纯数字
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//在UITextField的代理方法中
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    //检测是否为纯数字
    if ([self isPureInt:string]) {
        //添加空格，每4位之后，4组之后不加空格，格式为xxxx xxxx xxxx xxxx xxxxxxxxxxxxxx
        if (textField.text.length % 5 == 4 && textField.text.length < 22) {
            textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
        }
        //只要30位数字
        if ([toBeString length] >= 19+4)
        {
            toBeString = [toBeString substringToIndex:19+4];
            textField.text = toBeString;
            [textField resignFirstResponder];
            return NO;
        }
    }
    else if ([string isEqualToString:@""]) { // 删除字符
        if ((textField.text.length - 2) % 5 == 4 && textField.text.length < 22) {
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
        }
        return YES;
    }
    else{
        return NO;
    }
    return YES;
}

/**点击提交按钮*/
-(void)clickNextButton:(UIButton *)button{
    [_nameTextField resignFirstResponder];
    [_cardNumberTextField resignFirstResponder];
    
    void(^stateBlock)(BOOL state) = ^(BOOL state){

       button.userInteractionEnabled = state;
        
    };
    stateBlock(NO);
    if (IsNilOrNull(_nameTextField.text)){
        [self showNoticeView:CheckMsgNameNull];
        stateBlock(YES);
        return;
    }
    if(IsNilOrNull(_bankNameTextField.text)){
        [self showNoticeView:@"请输入开户银行"];
         stateBlock(YES);
        return;
    }
    if(IsNilOrNull(_cardNumberTextField.text)){
        [self showNoticeView:@"请输入银行卡卡号"];
         stateBlock(YES);
        return;
    }

    NSLog(@"卡号%@",_cardNumberTextField.text);
    
    NSArray *noArr = [_cardNumberTextField.text componentsSeparatedByString:@" "];
    NSString *cardNo = [noArr componentsJoinedByString:@""];
    NSLog(@"卡号%@", cardNo);
    
    //检测是否合法的银行卡
    if (![NSString checkCardNo: cardNo]) {
        [self showNoticeView:@"银行卡号输入有误"];
        stateBlock(YES);
        return;
    }
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }

    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,addBankCard_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"bankcardno": cardNo, @"name":_nameTextField.text, @"bankname":_bankNameTextField.text, DeviceId:uuid};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        //成功之后再可点击
        stateBlock(YES);
        NSDictionary *dict= json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        [CKCNotificationCenter postNotificationName:@"addcard" object:@"YES"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        stateBlock(YES);
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];

}

@end
