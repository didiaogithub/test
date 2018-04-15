//
//  FFTextAlertView.m
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/13.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "FFTextAlertView.h"

@interface FFTextAlertView()<UITextFieldDelegate>
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
 竖线
 */
@property (nonatomic, strong) UIView *lineV;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelBtn;
/**
 确认按钮
 */
@property (nonatomic, strong) UIButton *sureBtn;

/**
 提示标签
 */
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation FFTextAlertView



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
    contentViewHeight = M_RATIO_SIZE(160);
    _contentView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-contentViewWidth)/2, -contentViewHeight, contentViewWidth, contentViewHeight)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = M_RATIO_SIZE(10);
    _contentView.layer.masksToBounds = YES;
    [self addSubview:_contentView];
    //标题
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, M_RATIO_SIZE(10), _contentView.frame.size.width, M_RATIO_SIZE(40))];
    _titleLabel.text = _title;
    _titleLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_titleLabel];
    
    //输入框
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(M_RATIO_SIZE(10),CGRectGetMaxY(_titleLabel.frame)+M_RATIO_SIZE(4), CGRectGetWidth(_contentView.frame)-M_RATIO_SIZE(20), M_RATIO_SIZE(36))];
    _textField.text = _textFieldInitialValue;
    _textField.borderStyle =UITextBorderStyleLine;
    _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.layer.cornerRadius = M_RATIO_SIZE(2);
    _textField.layer.masksToBounds = YES;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.delegate = self;
    [_contentView addSubview:_textField];
    
    //提示标签
    _hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(M_RATIO_SIZE(10), CGRectGetMaxY(_textField.frame)+M_RATIO_SIZE(4), CGRectGetWidth(_contentView.frame)-M_RATIO_SIZE(20), M_RATIO_SIZE(24))];
    _hintLabel.font = [UIFont systemFontOfSize:M_RATIO_SIZE(10)];
    
    _hintLabel.textColor = [UIColor lightGrayColor];
    [_contentView addSubview:_hintLabel];
    
    //添加通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textFieldTextDidChange:)
     name:UITextFieldTextDidChangeNotification
     object:_textField];
    //键盘相关通知
    
    //    //键盘即将显示
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    //    //键盘即将消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    CGFloat  _lineV_H = 44;
    
    //设置横线 竖线
    _lineH = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_contentView.frame)-_lineV_H, _contentView.frame.size.width, 1)];
    _lineH.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:_lineH];
    _lineV = [[UIView alloc]initWithFrame:CGRectMake((CGRectGetWidth(_contentView.frame)-1)/2, CGRectGetMaxY(_lineH.frame), 1, _lineV_H)];
    _lineV.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:_lineV];
    
    //设置按钮
    //取消按钮
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setTitle:@"取消" forState:0];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:0];
    [_cancelBtn setTitleColor:[UIColor lightGrayColor] forState:1];
    _cancelBtn.frame = CGRectMake(0, CGRectGetHeight(_contentView.frame)-_lineV_H, (CGRectGetWidth(_contentView.frame)-1)/2, _lineV_H);
    [_contentView addSubview:_cancelBtn];
    //确定按钮
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn addTarget:self action:@selector(onClickSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_sureBtn setTitle:@"确定" forState:0];
    [_sureBtn setTitleColor:[UIColor blackColor] forState:0];
    [_sureBtn setTitleColor:[UIColor lightGrayColor] forState:1];
    _sureBtn.frame = CGRectMake(CGRectGetWidth(_cancelBtn.frame), CGRectGetHeight(_contentView.frame)-_lineV_H, (CGRectGetWidth(_contentView.frame)-1)/2, _lineV_H);
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
//textField 内容发生变化的通知
-(void)textFieldTextDidChange:(NSNotification *)notification
{
    UITextField *textField=[notification object];
    if(textField == _textField)
    {
        NSLog(@"textField%@",textField.text);
        _hintLabel.text = [NSString stringWithFormat:@"你还能输入%ld个字",(long)(_textFieldTextMaxLength - textField.text.length)];
        _hintLabel.textColor = [UIColor lightGrayColor];
        
        if (textField.text.length == _textFieldTextMaxLength) {
            //长度与 限制长度相等时
            _hintLabel.textColor = [UIColor redColor];
        }
    }
}
#pragma mark ------------------UITextFieldDelegate------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField == _textField)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        
        NSInteger selectedLength = range.length;
        
        NSInteger replaceLength = string.length;
        
        NSLog(@"existedLength:%ld selectedLength:%ld replaceLength:%ld ",(long)existedLength,(long)selectedLength,(long)replaceLength);
        
        if (existedLength - selectedLength + replaceLength > _textFieldTextMaxLength) {
            
            return NO;
        }
    }
    return YES;
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
