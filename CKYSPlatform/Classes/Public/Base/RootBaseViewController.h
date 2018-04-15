//
//  RootBaseViewController.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/15.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CKC_CustomProgressView.h"

@interface RootBaseViewController : UIViewController

@property (nonatomic, strong) AppDelegate * appDelegate;
@property (nonatomic, strong) CKC_CustomProgressView *viewDataLoading;
@property (nonatomic, strong) JGProgressHUD *viewNetError;
@property (nonatomic, strong) UIView *netTip;

//添加提示view
-(void)showNoticeView:(NSString*)title;

@end
