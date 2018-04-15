//
//  CKPickupMallCell.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/2/26.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKPickupGoodsModel.h"

@class CKPickupMallCell;

@protocol CKPickupMallCellDelegate <NSObject>

-(void)cKPickupMallCell:(CKPickupMallCell *)pickupMallCell didSelectAtIndexPath:(NSIndexPath *)indexPath goodsModel:(CKPickupGoodsModel *)goodsModel;

@end

@interface CKPickupMallCell : UITableViewCell

@property (nonatomic, weak) id<CKPickupMallCellDelegate> delegate;

@property (nonatomic, assign) NSInteger chooseCount;

@property (nonatomic, strong) NSIndexPath *indexPath;


@property (nonatomic, strong) CKPickupGoodsModel *goodsModel;

- (void)updateCellData:(CKPickupGoodsModel *)goodsModel;

@end
