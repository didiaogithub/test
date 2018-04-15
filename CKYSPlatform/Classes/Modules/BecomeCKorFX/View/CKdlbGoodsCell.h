//
//  CKdlbGoodsCell.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKdlbGoodsModel.h"

@protocol CKdlbGoodsCellDelegate <NSObject>

-(void)dlbGoodsSelected:(CKdlbGoodsModel *)goodModel anRow:(NSInteger)indexRow andSection:(NSInteger)section;

@end

@interface CKdlbGoodsCell : UITableViewCell

@property (nonatomic, weak)   id<CKdlbGoodsCellDelegate>delegate;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, copy)   NSString *clearString;
@property (nonatomic, assign) NSInteger indexRow;
@property (nonatomic, assign) NSInteger chooseCount;
@property (nonatomic, strong) CKdlbGoodsModel *goodModel;
@property (nonatomic, strong) UIButton * selectedButton;

-(void)refreshUIWithGoodsModel:(CKdlbGoodsModel*)goodsModel;

@end
