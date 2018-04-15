//
//  WxuserOrderTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/7/6.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface WxuserOrderTableViewCell : UITableViewCell

@property(nonatomic,strong)OrderModel *orderModel;

-(void)refreshWithModel:(OrderModel *)model;

@end
