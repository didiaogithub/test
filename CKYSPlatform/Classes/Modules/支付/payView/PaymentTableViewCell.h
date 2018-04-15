//
//  PaymentTableViewCell.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/8/14.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>


//选择支付方式的cell
@interface PaymentTableViewCell : UITableViewCell
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)UIImageView *leftIamgeView;

@property(nonatomic,strong)UIButton *rightButton;

@end
