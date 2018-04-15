//
//  OrderMessageTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/7/6.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@protocol OrderMessageTableViewCellDelegate <NSObject>

-(void)clickOrderButtonWithTag:(NSInteger)tag andModel:(Ordersheet *)model;

@end

@interface OrderMessageTableViewCell : UITableViewCell

@property(nonatomic,weak)id<OrderMessageTableViewCellDelegate>delegate;

@property (nonatomic, strong) Ordersheet *detailModel;

-(void)refreshWithModel:(Ordersheet *)model;

@end
