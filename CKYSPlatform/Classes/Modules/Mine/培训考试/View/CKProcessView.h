//
//  CKProcessView.h
//  process
//
//  Created by ForgetFairy on 2018/1/18.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKProcessView : UIView

/**
 进度增加
 */
- (void)progressIncrease;

/**
 进度减少
 */
- (void)progressReduce;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title totalNo:(NSString*)totalNo;

@end
