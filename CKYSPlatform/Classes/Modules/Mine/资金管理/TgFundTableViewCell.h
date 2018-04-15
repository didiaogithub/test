//
//  TgFundTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/1/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface TgFundTableViewCell : UITableViewCell

/**左侧图标*/
@property(nonatomic,strong)UIImageView *leftImageView;
/**操作名称 零售*/
@property(nonatomic,strong)UILabel *operateLable;
/**操作价格*/
@property(nonatomic,strong)UILabel *operatePriceLable;
/**订单号*/
@property(nonatomic,strong)UILabel *orderNo_Lable;
/**操作时间*/
@property(nonatomic,strong)UILabel *operateTimeLable;
-(void)refreshFundWithModel:(OrderModel *)orderModel;

@end
