//
//  MJChiBaoZiHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/12.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJGearHeader.h"

@implementation MJGearHeader
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"car%zd", i]];
        [idleImages addObject:image];
        
    }
    
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"car%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.stateLabel.font = CHINESE_SYSTEM(AdaptedWidth(13));
    self.stateLabel.textColor = TitleColor;
    self.stateLabel.textAlignment = NSTextAlignmentLeft;
    
    self.lastUpdatedTimeLabel.font = CHINESE_SYSTEM(AdaptedWidth(10));
    self.lastUpdatedTimeLabel.textColor = SubTitleColor;
    self.lastUpdatedTimeLabel.textAlignment = NSTextAlignmentLeft;
    //头部
    if (self.stateLabel.hidden) return;
    
    if (self.lastUpdatedTimeLabel.hidden) {
        // 状态
        self.stateLabel.frame = self.bounds;
    } else {
        // 状态
        self.stateLabel.mj_x = AdaptedWidth(155);
        self.stateLabel.mj_y = 0;
        self.stateLabel.mj_w = self.mj_w-AdaptedWidth(155);
        self.stateLabel.mj_h = self.mj_h * 0.5;
        
        // 更新时间
        self.lastUpdatedTimeLabel.mj_x = AdaptedWidth(155);
        self.lastUpdatedTimeLabel.mj_y = self.stateLabel.mj_h;
        self.lastUpdatedTimeLabel.mj_w = self.mj_w-AdaptedWidth(155);
        self.lastUpdatedTimeLabel.mj_h = self.mj_h - self.lastUpdatedTimeLabel.mj_y;
    }
    self.gifView.mj_w = AdaptedWidth(150);
}

@end
