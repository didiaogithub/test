//
//  CKCollegeHeaderView.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CKCollegeHeaderViewDelegate <NSObject>

/**
 跳转到banner详情
 */
-(void)bannerPushToDetail:(NSInteger)index;
/**
 跳转到@"基础课程",@"销售技巧",@"学习天地",@"直播间"
 */
-(void)turnToDetailClassify:(NSInteger)index;

@end

@interface CKCollegeHeaderView : UIView

@property (nonatomic, weak) id<CKCollegeHeaderViewDelegate> delegate;

@end
