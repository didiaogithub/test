//
//  CKGoodsManagerCell.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/9.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"

@class CKGoodsManagerCell;

typedef void(^CarryBySelfBlock)(GoodModel *model,NSInteger row);

@protocol CKGoodsManagerCellDelegate <NSObject>

-(void)singleClickCell:(CKGoodsManagerCell*)ckGoodsManagerCell goodsModel:(GoodModel *)goodsModel;

@end

@interface CKGoodsManagerCell : UITableViewCell

@property(nonatomic,weak)id<CKGoodsManagerCellDelegate>delegate;


@property (nonatomic, copy) CarryBySelfBlock block;

-(void)setBlock:(CarryBySelfBlock)block;

-(void)setModel:(GoodModel *)model;


@end
