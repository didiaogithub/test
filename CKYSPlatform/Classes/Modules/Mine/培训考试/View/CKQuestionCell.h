//
//  CKQuestionCell.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/22.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKExamModel.h"


@interface CKTestCell : UITableViewCell

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


@interface CKQuestionCell : CKTestCell

@end


@class CKAnswerCell;
@protocol CKAnswerCellDelegate <NSObject>

@optional
- (void)didSelectAnswerOption:(CKAnswerCell*)answerCell selectedIndex:(NSInteger)selectedIndex optionModel:(CKOptionModel*)optionModel;

- (void)didSelectAnswerOption:(CKAnswerCell*)answerCell selectedIndex:(NSInteger)selectedIndex;

- (void)dissSelectAnswerOption:(CKAnswerCell*)answerCell selectedIndex:(NSInteger)selectedIndex;



@end

@interface CKAnswerCell : CKTestCell

@end
