
//  CKC_CustomProgressView.h

//  Created by 庞宏侠 on 16/6/30.
//  Copyright © 2016年 link. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKC_CustomProgressView : UIView

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
