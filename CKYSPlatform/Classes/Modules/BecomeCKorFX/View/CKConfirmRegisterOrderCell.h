//
//  CKConfirmRegisterOrderCell.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKdlbGoodsModel.h"

@interface CKConfirmRegisterOrderCell : UITableViewCell

@property (nonatomic, strong) CKdlbGoodsModel *goodModel;

-(void)refreshUIWithGoodsModel:(CKdlbGoodsModel*)goodsModel;

@end
