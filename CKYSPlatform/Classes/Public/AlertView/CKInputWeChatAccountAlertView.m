//
//  CKInputWeChatAccountAlertView.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/21.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKInputWeChatAccountAlertView.h"

@interface CKInputWeChatAccountAlertView()<UITextFieldDelegate>
{
    CGFloat contentViewWidth;
    CGFloat contentViewHeight;
}
/**
 背景
 */
@property (nonatomic, strong) UIView *backgroundView;
/**
 容器
 */
@property (strong, nonatomic) UIView *contentView;
/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 输入框
 */
@property (nonatomic, strong) UITextField *textField;
/**
 横线
 */
@property (nonatomic, strong) UIView *lineH;
/**
 确认按钮
 */
@property (nonatomic, strong) UIButton *sureBtn;

/**
 提示标签
 */
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation CKInputWeChatAccountAlertView

- (instancetype)initWithTitle:(NSString *)title textFieldInitialValue:(NSString *)textFieldInitialValue textFieldTextMaxLength:(NSInteger)textFieldTextMaxLength textFieldText:(void (^)(NSString *))textFieldText{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _title = title;
        _textFieldInitialValue = textFieldInitialValue;
        _textFieldTextMaxLength = textFieldTextMaxLength;
        self.textFieldTextBlock = textFieldText;
        [self setUI];
    }
    return self;
    
}



-(void)setUI{
    //初始化背景
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    _backgroundView = [[UIView alloc] initWithFrame:self.frame];
    _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    //添加点击事件
    [_backgroundView addGestureRecognizer:tapGestureRecognizer];
    [self addSubview:_backgroundView];
    
    contentViewWidth = M_RATIO_SIZE(260);
    contentViewHeight = M_RATIO_SIZE(200);
    _contentView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-contentViewWidth)/2, -contentViewHeight, contentViewWidth, contentViewHeight)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = M_RATIO_SIZE(10);
    _contentView.layer.masksToBounds = YES;
    [self addSubview:_contentView];
    //标题
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, _contentView.frame.size.width, 30)];
    _titleLabel.text = _title;
    _titleLabel.textColor = SubTitleColor;
    _titleLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_titleLabel];
    
    //提示标签
    _hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame)+M_RATIO_SIZE(4), CGRectGetWidth(_contentView.frame)-20, M_RATIO_SIZE(50))];
    _hintLabel.font = [UIFont systemFontOfSize:M_RATIO_SIZE(12)];
    _hintLabel.numberOfLines = 0;
    _hintLabel.text = @"您还没有完善微信号，请完善微信号后才能使用改功能";
    _hintLabel.textColor = SubTitleColor;
    [_contentView addSubview:_hintLabel];
    
    //输入框
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(_hintLabel.frame)+M_RATIO_SIZE(4), CGRectGetWidth(_contentView.frame)-20, M_RATIO_SIZE(36))];
    _textField.text = _textFieldInitialValue;
    _textField.placeholder = @"请输入微信号";
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.delegate = self;
    _textField.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_textField];
    
    UILabel *lineL = [UILabel creatLineLable];
    lineL.frame = CGRectMake(10,CGRectGetMaxY(_textField.frame)+2, CGRectGetWidth(_contentView.frame)-20, 1);
    [_contentView addSubview:lineL];
    
    //键盘相关通知
    
    //    //键盘即将显示
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    //    //键盘即将消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
    //确定按钮
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn addTarget:self action:@selector(onClickSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_sureBtn setTitle:@"提交" forState:0];
    [_sureBtn setTitleColor:[UIColor tt_redMoneyColor] forState:0];
    _sureBtn.layer.borderColor = [UIColor tt_redMoneyColor].CGColor;
    _sureBtn.layer.borderWidth = 1;
    _sureBtn.frame = CGRectMake(10, CGRectGetHeight(_contentView.frame)-44-10, CGRectGetWidth(_contentView.frame)-20, 44);
    [_contentView addSubview:_sureBtn];
    
}




//键盘即将显示
-(void)keyboardWillShow:(NSNotification *)note{
    // 获得通知信息
    NSDictionary *userInfo = note.userInfo;
    // 获得键盘执行动画的时间
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, (self.frame.size.height - _contentView.frame.size.height)/2-M_RATIO_SIZE(80), _contentView.frame.size.width, _contentView.frame.size.height);
    } completion:nil];
}
//键盘即将消失
-(void)keyboardWillHide:(NSNotification *)note{
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, (self.frame.size.height - _contentView.frame.size.height)/2, _contentView.frame.size.width, _contentView.frame.size.height);
    }];
}

#pragma mark 点击确定按钮
-(void)onClickSureBtn:(UIButton *)sender{
    //判断与初始值是否一致
    if( ! [_textFieldInitialValue isEqualToString:_textField.text]){
        self.textFieldTextBlock(_textField.text);
        
    }
    
    [self hide];
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:self];
    [self addAnimation];
}

-(void)hideKeyboard{
    [_textField resignFirstResponder];
}

- (void)hide {
    [_textField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeAnimation];
}
- (void)addAnimation {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, (self.frame.size.height - _contentView.frame.size.height)/2, _contentView.frame.size.width, _contentView.frame.size.height);
        //        _backgroundView.alpha = 0.5;
    } completion:^(BOOL finished) {
    }];
}

- (void)removeAnimation {
    
    [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, self.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height);
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
