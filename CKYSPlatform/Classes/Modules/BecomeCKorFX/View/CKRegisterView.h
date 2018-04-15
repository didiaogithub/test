//
//  CKRegisterView.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CKRegisterViewDelegate <NSObject>

-(void)getVertifyCode:(STCountDownButton *)button;
-(void)selectedInviteCode:(UIButton *)button;
-(void)rigisterCKorFX:(NSInteger)tag;

@end

@interface CKRegisterView : UIView

@property (nonatomic, weak)   id<CKRegisterViewDelegate>delegate;
@property (nonatomic, copy)   NSString *typestr;
@property (nonatomic, strong) UITextField *telphoneTextField;
@property (nonatomic, strong) UITextField *verifyCodeTextField;
@property (nonatomic, strong) UITextField *invitationTextField;
@property (nonatomic, strong) UITextField *setupPassWordTextField;
@property (nonatomic, strong) UITextField *morePassWordTextField;
@property (nonatomic, strong) UIButton *agreenmentButton;
@property (nonatomic, strong) UIButton *inviteSeletedButton;
@property (nonatomic, strong) STCountDownButton *countDownCode;

@end
