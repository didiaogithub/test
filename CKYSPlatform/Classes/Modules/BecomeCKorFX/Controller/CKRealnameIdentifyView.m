//
//  CKRealnameIdentifyView.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/14.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKRealnameIdentifyView.h"
#import "FFTipAlertView.h"
#import "MessageAlert.h"
@interface CKRealnameIdentifyView()<UITextFieldDelegate,MLEmojiLabelDelegate>

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *idTextField;

@end

@implementation CKRealnameIdentifyView

- (instancetype)init {
    self = [super init];
    if(self) {
        [self initComponent];
    }
    return self;
}

+(instancetype)shareInstance {
    static CKRealnameIdentifyView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CKRealnameIdentifyView alloc] initPrivate];
    });
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        [self initComponent];
    }
    return self;
}

-(void)initComponent {
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    //最外层view
    self.bigView = [[UIView alloc]init];
    [self addSubview:self.bigView];
    self.bigView.backgroundColor = [UIColor whiteColor];
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(275);
    }];
    
    UILabel *topLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15]];
    topLabel.text = @"实名认证";
    [self.bigView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.top.mas_offset(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(100);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bigView addSubview:self.closeBtn];
    [self.closeBtn setImage:[UIImage imageNamed:@"deleteImg"] forState:UIControlStateNormal];
    [self.closeBtn setImage:[UIImage imageNamed:@"deleteImg"] forState:UIControlStateSelected];
    [self.closeBtn addTarget:self action:@selector(closeAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(12);
        make.right.mas_offset(-10);
        make.width.height.mas_equalTo(20);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [self.bigView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(1);
        make.top.equalTo(topLabel.mas_bottom);
    }];

    
    UILabel *tipLabel = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"  海关要求购买跨境产品需提供实名信息哦"];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"提醒"];
    attch.bounds = CGRectMake(0, -1, 15, 12);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    tipLabel.attributedText = attri;
    [self.bigView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(12);
        make.top.equalTo(lineLabel.mas_bottom);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(44);
    }];
    
    
    //姓名
    self.nameTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    self.nameTextField.placeholder = @"姓名";
    self.nameTextField.backgroundColor = [UIColor tt_lineBgColor];
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTextField.delegate = self;
    [self.bigView addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.left.mas_offset(10);
        make.height.mas_equalTo(44);
        make.top.equalTo(tipLabel.mas_bottom);
    }];
    
    //身份证
    self.idTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    self.idTextField.placeholder = @"身份证号码";
    self.idTextField.backgroundColor = [UIColor tt_lineBgColor];
    self.idTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.idTextField.delegate = self;
    [self.bigView addSubview:self.idTextField];
    [self.idTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.left.mas_offset(10);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.nameTextField.mas_bottom).offset(10);
    }];
    
    //键盘相关通知
    //    //键盘即将显示
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    //    //键盘即将消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    

    UILabel *learnLabel = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    learnLabel.userInteractionEnabled = YES;
    NSMutableAttributedString *attri1 = [[NSMutableAttributedString alloc] initWithString:@" 了解实名认证"];
    NSTextAttachment *attch1 = [[NSTextAttachment alloc] init];
    attch1.image = [UIImage imageNamed:@"问号"];
    attch1.bounds = CGRectMake(0, -3, 15, 15);
    NSAttributedString *string1 = [NSAttributedString attributedStringWithAttachment:attch1];
    [attri1 insertAttributedString:string1 atIndex:0];
    learnLabel.attributedText = attri1;
    [self.bigView addSubview:learnLabel];
    [learnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.idTextField.mas_bottom);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTipView)];
    [learnLabel addGestureRecognizer:tap];
    
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmBtn.backgroundColor = [UIColor redColor];
    [self.confirmBtn addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.bigView addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.bigView.mas_bottom);
        make.height.mas_equalTo(44);
    }];
    
}

//键盘即将显示
-(void)keyboardWillShow:(NSNotification *)note{
    // 获得通知信息
    NSDictionary *userInfo = note.userInfo;
    // 获得键盘执行动画的时间
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        [self.bigView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.mas_offset(100);
            make.height.mas_equalTo(275);
        }];
    } completion:nil];
}
//键盘即将消失
-(void)keyboardWillHide:(NSNotification *)note{
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.bigView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_offset(0);
            make.height.mas_equalTo(275);
        }];
    }];
}

#pragma mark ------------------UITextFieldDelegate------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == self.nameTextField){
        NSLog(@"name:%@-%@-%@",textField.text, string, self.nameTextField.text);
        
    }else if (textField == self.idTextField){
        NSLog(@"id:%@-%@-%@",textField.text, string, self.idTextField.text);
    }
    
    if (string.length > 20) {
        return NO;
    }
    return YES;
}

-(void)hideKeyboard{
    [self.nameTextField resignFirstResponder];
    [self.idTextField resignFirstResponder];
}

- (void)showTipView {
    
    [self.nameTextField resignFirstResponder];
    [self.idTextField resignFirstResponder];
    [[FFTipAlertView shareInstance] showAlert:@"为什么需要实名认证？" content:@"·根据海关要求，购买部分跨境商品需对收货人进行实名认证，错误信息可能导致无法正常清关。\n·你的身份证信息将加密保管，创客村保证信息安全，绝不对外泄露！\n·任何身份认证问题可联系我们 400-777-1516 (08:30-21:20)"];
}

- (void)closeAlertView {
    [self.nameTextField resignFirstResponder];
    [self.idTextField resignFirstResponder];
    
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissAlertView {
    
    [self.nameTextField resignFirstResponder];
    [self.idTextField resignFirstResponder];
    
    NSLog(@"name:%@-id:%@", self.nameTextField.text, self.idTextField.text);
    
    self.textFieldTextBlock(self.nameTextField.text, self.idTextField.text);
    if (IsNilOrNull(self.nameTextField.text) || IsNilOrNull(self.idTextField.text)) {
        return;
    }
    
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showAlert:(NSString *)name idNo:(NSString*)idNo textFieldText:(void(^)(NSString *name, NSString *idNo))textFieldText {
    
    [self.confirmBtn setTitle:self.operationName forState:UIControlStateNormal];

    self.nameTextField.text = name;
    if (!IsNilOrNull(idNo)) {
        self.idTextField.text = idNo;
    }else{
        self.idTextField.placeholder = [NSString stringWithFormat:@"%@的身份证号码（将加密处理）", name];
    }
    
    self.textFieldTextBlock = textFieldText;
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        self.alpha = 1;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

@end
