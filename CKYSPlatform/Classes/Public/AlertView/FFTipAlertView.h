//
//  FFTipAlertView.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/14.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFTipAlertView : UIView

/**标题字体大小，默认16*/
@property (nonatomic, strong) UIFont *titleFont;
/**标题字体颜色，默认#333333*/
@property (nonatomic, strong) UIColor *titleColor;
/**标题字体对齐方式，默认NSTextAlignmentCenter*/
@property (nonatomic, assign) NSTextAlignment titleTextAlignment;
/**内容字体大小，默认14*/
@property (nonatomic, strong) UIFont *contentFont;
/**内容字体颜色，默认#666666*/
@property (nonatomic, strong) UIColor *contentColor;

+(instancetype)shareInstance;

/**
 弹窗通知
 
 @param title 通知标题
 @param content 通知内容
 */
-(void)showAlert:(NSString *)title content:(NSString*)content;

@end
