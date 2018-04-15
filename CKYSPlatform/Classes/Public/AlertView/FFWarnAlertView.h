//
//  FFWarnAlertView.h
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2018/1/10.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FFWarnAlertView;
@protocol FFWarnAlertViewDelegate<NSObject>

@optional
-(void)didClickWarnAlertView:(FFWarnAlertView*)warnAlertView;

@end

@interface FFWarnAlertView : UIView

@property (nonatomic, weak)   id<FFWarnAlertViewDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLable;

- (void)showFFWarnAlertView;

@end
