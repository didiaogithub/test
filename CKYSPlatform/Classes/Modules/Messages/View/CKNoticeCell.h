//
//  CKNoticeCell.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKNoticeCell : UITableViewCell

/**
 代表任意代理协议，有子类决定
 */
@property(nonatomic,weak) id delegate;

/**
 由子类实现，数据填充方法
 */
-(void)fillNoticeData:(id)data;

/**
 高度计算，由子类完成
 */
+(CGFloat)computeHeight:(id)data;

@end
