//
//  LoginView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/19.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginViewDelegate <NSObject>
//mineView代理方法
@optional
-(void)jumpToViewControllerWithTag:(NSInteger)buttonTag;
-(void)getVertifyCodeWithButton:(STCountDownButton *)button;
-(void)loginWithtelphone:(NSString *)telphoneText andPassWord:(NSString *)psaaword;
@end
@interface LoginView : UIView<UITextFieldDelegate>
@property(nonatomic,weak)id<LoginViewDelegate>delegate;
@property(nonatomic,strong)UIImageView *returnImageView;
@property(nonatomic,strong)UITextField *passwordTextField;
@property(nonatomic,strong)UITextField *telphoneTextField;
@property(nonatomic,strong)UIButton *verificationCodeButton;
-(instancetype)initWithFrame:(CGRect)frame andTypeStr:(NSString *)typestr;


@end
