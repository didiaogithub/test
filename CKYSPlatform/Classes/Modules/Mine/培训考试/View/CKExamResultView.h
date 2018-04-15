//
//  CKExamResultView.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/25.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKExamResultView;
@protocol CKExamResultVieDelegate <NSObject>

- (void)exitExam:(CKExamResultView*)examResultView;

@end

@interface CKExamResultView : UIView

@property (nonatomic, weak) id<CKExamResultVieDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame score:(NSString*)score passOrNot:(BOOL)passOrNot;

@end
