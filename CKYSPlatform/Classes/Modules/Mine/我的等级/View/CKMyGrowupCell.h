//
//  CKMyGrowupCell.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKMyGrowupCell : UITableViewCell
/**
 代表任意代理协议，有子类决定
 */
@property(nonatomic,weak) id delegate;

/**
 由子类实现，数据填充方法
 */
-(void)fillData:(id)data;

/**
 由子类实现，由子类决定此方法用途
 */
-(void)callWithParameter:(id)parameter;

/**
 高度计算，由子类完成
 */
+(CGFloat)computeHeight:(id)data;

@end


@interface CKMyGrowupTitleCell : CKMyGrowupCell

@end



@interface CKMyGrowupContentCell : CKMyGrowupCell

@end



@interface CKMyGrowupUpdateCell : CKMyGrowupCell

@end
