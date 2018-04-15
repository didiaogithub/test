//
//  CKCUpdateAlertView.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/12/20.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKCUpdateAlertView : UIView

+(instancetype)shareInstance;

/**
 更新提示框

 @param content 更新内容
 @param force 否强制更新
 */
-(void)showUpdateAlert:(NSString*)content forceUpdate:(BOOL)force;

@end
