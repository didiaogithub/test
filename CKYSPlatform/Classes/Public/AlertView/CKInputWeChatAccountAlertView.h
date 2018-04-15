//
//  CKInputWeChatAccountAlertView.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/21.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

#define M_RATIO_SIZE(s) SCREEN_WIDTH/(320.0/s)

@interface CKInputWeChatAccountAlertView : UIView

/**
 标题
 */
@property (nonatomic, strong) NSString *title;

/**
 输入框初始值
 */
@property (nonatomic, strong) NSString *textFieldInitialValue;

/**
 限制输入长度
 */
@property (nonatomic, assign) NSInteger textFieldTextMaxLength;

/**
 输入框确定之后的block回调
 */
@property (nonatomic, copy) void(^textFieldTextBlock)(NSString *string);


/**
 初始化
 @param title 标题
 @param textFieldInitialValue 输入框初始值
 @param textFieldTextMaxLength 输入框文字最大长度
 @param textFieldText 输入框确定返回的内容
 @return 初始化一个弹出输入框
 */
-(instancetype)initWithTitle:(NSString *)title  textFieldInitialValue:(NSString *)textFieldInitialValue textFieldTextMaxLength:(NSInteger )textFieldTextMaxLength textFieldText:(void(^)(NSString * textFieldText)) textFieldText;
/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)hide;

@end
