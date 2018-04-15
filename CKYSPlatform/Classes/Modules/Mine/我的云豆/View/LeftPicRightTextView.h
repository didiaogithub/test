//
//  LeftPicRightTextView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LeftPicRightTextViewDelegate <NSObject>
-(void)monthDetailJumpWithTag:(NSInteger)tag;
@end
@interface LeftPicRightTextView : UIView
@property(nonatomic,weak)id<LeftPicRightTextViewDelegate>delegate;
@property(nonatomic,strong)UIImageView *leftImageView;
@property(nonatomic,strong)UILabel *rightLable;
@property(nonatomic,strong)UIButton *detailButton;

@property(nonatomic,strong)UILabel *rightValueLable;
@property(nonatomic,strong)UIImageView *rightImageView;

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andImage:(NSString *)imageStr isShowRight:(BOOL)isShow andTag:(NSInteger)tag;
@end
