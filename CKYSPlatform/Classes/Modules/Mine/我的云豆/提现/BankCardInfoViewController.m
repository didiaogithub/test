//
//  BankCardInfoViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/3.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BankCardInfoViewController.h"
#import "SelectedBankCardViewController.h"
@interface BankCardInfoViewController ()
{
    UITextField *_bankTextField;
    UITextField *_bankDetailTextField;
    UIButton *_submitButton;
    NSString *_ckidString;

}
@end

@implementation BankCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加银行卡";
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    [self createViews];
    
}

-(void)createViews{

    UIView *cardBankView = [[UIView alloc] init];
    [self.view addSubview:cardBankView];
    [cardBankView setBackgroundColor:[UIColor whiteColor]];
    [cardBankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10)+64);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(260));
    }];

    
    //开户银行 lable
    UILabel *textNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    textNameLable.text = @"开户银行";
    [cardBankView addSubview:textNameLable];
    [textNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(30));
        make.left.mas_offset(AdaptedWidth(30));
        make.size.mas_offset(CGSizeMake(70, 15));
    }];
    
    _bankTextField = [[UITextField alloc] init];
    [cardBankView addSubview:_bankTextField];
    _bankTextField.placeholder = @"请输入开户银行";
    [_bankTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.equalTo(textNameLable.mas_right).offset(30);
        make.right.mas_offset(-AdaptedWidth(30));
        make.height.mas_offset(AdaptedHeight(50));
    }];
    UILabel *firstLable = [UILabel creatLineLable];
    [cardBankView addSubview:firstLable];
    [firstLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bankTextField.mas_bottom);
        make.left.mas_offset(AdaptedWidth(20));
        make.right.mas_offset(-AdaptedWidth(20));
        make.height.mas_offset(1);
    }];
    
    UILabel *textCardNumberLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [cardBankView addSubview:textCardNumberLable];
    
    textCardNumberLable.text = @"分行/支行/营业部";
    [textCardNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLable.mas_bottom).offset(AdaptedHeight(30));
        make.left.equalTo(textNameLable.mas_left);
        make.height.equalTo(textNameLable);
        make.width.mas_offset(130);
    }];
    
    _bankDetailTextField = [[UITextField alloc] init];
    [cardBankView addSubview:_bankDetailTextField];
    _bankDetailTextField.placeholder = @"请输入开户支行";
    [_bankDetailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLable.mas_bottom).offset(AdaptedHeight(10));
        make.left.equalTo(textCardNumberLable.mas_right).offset(30);
        make.height.equalTo(_bankTextField.mas_height);
        make.width.mas_offset(SCREEN_WIDTH - 160);
    }];
    
    UILabel *secondLable = [UILabel creatLineLable];
    [cardBankView addSubview:secondLable];
    [secondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bankDetailTextField.mas_bottom);
        make.left.and.width.and.height.equalTo(firstLable);
        
    }];
   
    //下一步
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [cardBankView addSubview:bankImageView];
    [bankImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLable.mas_bottom).offset(AdaptedHeight(50));
        make.left.mas_offset(AdaptedWidth(35));
        make.height.mas_offset(AdaptedHeight(40));
        make.right.mas_offset(-AdaptedWidth(35));
    }];
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cardBankView addSubview:_submitButton];
    _submitButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bankImageView);
    }];
    [_submitButton addTarget:self action:@selector(clickSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    
}
/**点击提交按钮*/
-(void)clickSubmitButton:(UIButton *)button{
    button.userInteractionEnabled = NO;
    [_bankTextField resignFirstResponder];
    [_bankDetailTextField resignFirstResponder];
    
    if (IsNilOrNull(_bankTextField.text)) {
        [self showNoticeView:@"请输入开户银行"];
        return;
    }
    if (IsNilOrNull(_bankDetailTextField.text)) {
        [self showNoticeView:@"请输入开户支行"];
        return;
    }
    if (IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
    if (IsNilOrNull(self.bankCardNo)){
        self.bankCardNo = @"";
    }
    if (IsNilOrNull(self.name)){
        self.name = @"";
    }

    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }

    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,addBankCard_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"bankcardno":self.bankCardNo,@"name":self.name,@"bankname":_bankTextField.text,@"branchname":_bankDetailTextField.text,DeviceId:uuid};
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        //成功之后再可点击
        button.userInteractionEnabled = YES;
        
        NSDictionary *dict= json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        [CKCNotificationCenter postNotificationName:@"addcard" object:@"YES"];
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if([controller isKindOfClass:[SelectedBankCardViewController class]]){
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];

}


@end
