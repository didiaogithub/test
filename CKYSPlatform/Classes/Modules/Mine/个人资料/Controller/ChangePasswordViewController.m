//
//  ChangePasswordViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/1.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()
{
    UIView *_bottomView;
    UIImageView *_originalImageview; //原密码
    UITextField *_originalTextField;
    UILabel *_originalLineLable;
    //请输入新密码
    UIImageView *_newPassImageView;
    UITextField *_newPasswordTextField;
    UILabel *_newLineLable;
    
    //请再次输入新密码
    UIImageView *_moretimePassImageView;
    UITextField *_moretimeTextField;
    UILabel *_moretimeLineLable;
    UIButton *_sumitButton;

}
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    [self createViews];
}
/**点击提交按钮*/
-(void)clickSubmitButton{
    [self resignFirstResponders];
    if(![_newPasswordTextField.text isEqualToString:_moretimeTextField.text]){
        [self showNoticeView:CheckMsgPwTwiceError];
        return;
    }
    if (IsNilOrNull(_originalTextField.text)) {
        [self showNoticeView:@"请输入旧密码"];
        return;
    }
    if (IsNilOrNull(_newPasswordTextField.text)) {
        [self showNoticeView:@"请输入新密码"];
        return;
    }
    if (IsNilOrNull(_moretimeTextField.text)) {
        [self showNoticeView:@"请输入确认密码"];
        return;
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *changePassword = [NSString stringWithFormat:@"%@%@",WebServiceAPI,modPassword_Url];
    NSDictionary *pramaDic = @{@"ckid":KCKidstring,@"oldpw":_originalTextField.text,@"newpw":_newPasswordTextField.text,DeviceId:uuid};
    
    [HttpTool postWithUrl:changePassword params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        [self showNoticeView:@"密码修改成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangePasswordSuccessNotification" object:nil];

        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];

}
-(void)createViews{
    //最底下放一个view
   _bottomView = [[UIView alloc] init];
    [self.view addSubview:_bottomView];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64+AdaptedHeight(10)+NaviAddHeight);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(330));
    }];
    
    //原来的密码
    _originalImageview = [[UIImageView alloc] init];
    [_bottomView addSubview:_originalImageview];
    [_originalImageview setImage:[UIImage imageNamed:@"lock"]];
    _originalImageview.size = CGSizeMake(35, 21);
    _originalImageview.contentMode= UIViewContentModeCenter;
    
    
    _originalTextField = [[UITextField alloc] init];
    [_bottomView addSubview:_originalTextField];
    [_originalTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(20));
        make.right.mas_offset(-AdaptedWidth(20));
        make.height.mas_offset(AdaptedHeight(50));
    }];
    _originalTextField.placeholder = @"请输入原密码";
    _originalTextField.leftView = _originalImageview;
    _originalTextField.leftViewMode = UITextFieldViewModeAlways;
    _originalTextField.secureTextEntry = YES;
    
    //原密码下面的线
    _originalLineLable =  [UILabel creatLineLable];
    [_bottomView addSubview:_originalLineLable];
    [_originalLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_originalTextField.mas_bottom);
        make.left.equalTo(_originalTextField.mas_left);
        make.width.equalTo(_originalTextField.mas_width);
        make.height.mas_offset(1);
    }];
    //输入新密码
    _newPassImageView = [[UIImageView alloc] init];
    UIImage *moreTimeImage = [UIImage imageNamed:@"lock"];
    [_newPassImageView setImage:[moreTimeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _newPassImageView.frame = CGRectMake(10, 0, 35, 21);
    _newPassImageView.contentMode= UIViewContentModeCenter;
    
    //输入新密码textfiled
    _newPasswordTextField = [[UITextField alloc] init];
    [_bottomView addSubview:_newPasswordTextField];
    [_newPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_originalLineLable.mas_bottom);
        make.left.right.height.equalTo(_originalTextField);
    }];
    _newPasswordTextField.placeholder = @"请输入新密码";
    _newPasswordTextField.leftView = _newPassImageView;
    _newPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    _newPasswordTextField.secureTextEntry = YES;
    
    
    //新密码下面的线
    _newLineLable =  [UILabel creatLineLable];
    [_bottomView addSubview:_newLineLable];
    [_newLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_newPasswordTextField.mas_bottom);
        make.left.equalTo(_newPasswordTextField.mas_left);
        make.width.equalTo(_newPasswordTextField.mas_width);
        make.height.mas_offset(1);
    }];
    //再次输入新密码
    _moretimePassImageView = [[UIImageView alloc] init];
    [_bottomView addSubview:_moretimePassImageView];
    [_moretimePassImageView setImage:moreTimeImage];
    _moretimePassImageView.frame = CGRectMake(10, 0, 35, 21);
    _moretimePassImageView.contentMode= UIViewContentModeCenter;
    
    //再次输入新密码textfiled
    _moretimeTextField = [[UITextField alloc] init];
    [_bottomView addSubview:_moretimeTextField];
    [_moretimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_newLineLable.mas_bottom).offset(AdaptedHeight(20));
        make.left.right.height.equalTo(_newPasswordTextField);
    }];
    _moretimeTextField.placeholder = @"请再次输入新密码";
    _moretimeTextField.leftView = _moretimePassImageView;
    _moretimeTextField.leftViewMode = UITextFieldViewModeAlways;
    _moretimeTextField.secureTextEntry = YES;

    //新密码下面的线
    _moretimeLineLable =  [UILabel creatLineLable];
    [_bottomView addSubview:_moretimeLineLable];
    [_moretimeLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moretimeTextField.mas_bottom);
        make.left.equalTo(_moretimeTextField.mas_left);
        make.width.equalTo(_moretimeTextField.mas_width);
        make.height.mas_offset(1);
    }];

    
    UIImageView *submitBankImageView = [[UIImageView alloc] init];
    [_bottomView addSubview:submitBankImageView];
    [submitBankImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [submitBankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moretimeLineLable.mas_bottom).offset(AdaptedHeight(50));
        make.left.mas_offset(AdaptedWidth(35));
        make.right.mas_offset(-AdaptedWidth(35));
        make.height.mas_offset(AdaptedHeight(40));
    }];
    //提交按钮
    _sumitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomView addSubview:_sumitButton];
    _sumitButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [_sumitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_sumitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sumitButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(submitBankImageView);
        
    }];
    [_sumitButton addTarget:self action:@selector(clickSubmitButton) forControlEvents:UIControlEventTouchUpInside];

}

-(void)resignFirstResponders{
    [_originalTextField resignFirstResponder];
    [_newPasswordTextField resignFirstResponder];
    [_moretimeTextField resignFirstResponder];
}


@end
