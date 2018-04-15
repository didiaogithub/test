//
//  CKCoversationProgressView.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/27.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKCoversationProgressView : UIView

@property (nonatomic,strong) UIImageView *progressView;
@property (nonatomic,strong) UILabel *progressLable;
@property (nonatomic,strong) UIButton * blackBt;
@property (nonatomic, strong) JGProgressHUD * viewNetError;

/**
 *  开始动画
 */
- (void)startAnimation;
/**
 * 结束动画
 */
- (void)stopAnimation;
/**
 * 提示语
 */
- (void)showNoticeView:(NSString*)title;

@end
