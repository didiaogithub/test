//
//  BaseViewController.h
//  ShoppingCentre
//
//  Created by 庞宏侠 on 16/7/12.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CKC_CustomProgressView.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) CKC_CustomProgressView *viewDataLoading;
@property (nonatomic, strong) JGProgressHUD *viewNetError;
@property (nonatomic, strong) AppDelegate * appDelegate;
@property (nonatomic, assign) NSTimeInterval startInterval;
@property (nonatomic, assign) NSTimeInterval endInterval;

@property (nonatomic, assign) NSTimeInterval startLoadMoreInterval;
@property (nonatomic, assign) NSTimeInterval endLoadMoreInterval;

//添加提示view
-(void)showNoticeView:(NSString*)title;


@end
