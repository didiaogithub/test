//
//  SDAdScrollView.h
//  SDAdScrollView
//
//  Created by DHsong on 16/4/20.
//  Copyright © 2016年 DHsong. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *
 */

@interface TitleScrollView : UIView

@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, assign, readonly) NSInteger currentPage;
@property (nonatomic, assign) NSTimeInterval animationDuration;//自动滚动动画时间，默认2s
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic , copy) void (^tapActionBlock)(TitleScrollView *titleScrollView);
@end
