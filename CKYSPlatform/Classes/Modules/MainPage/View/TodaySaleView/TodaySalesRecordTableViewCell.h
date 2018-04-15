//
//  CloudRecordTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/7.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalelistModel.h"
@interface TodaySalesRecordTableViewCell : UITableViewCell
{
    UIView *bankView;
}
@property(nonatomic,copy)NSString *typeString;

/**左侧图标*/
@property(nonatomic,strong)UIImageView *leftImageView;
/**操作名称*/
@property(nonatomic,strong)UILabel *operateLable;
/**操作价格*/
@property(nonatomic,strong)UILabel *operatePriceLable;

/**操作时间*/
@property(nonatomic,strong)UILabel *operateTimeLable;

/**自提、零售、退货：订单号，进货：支付流水号or内转，分销进货：分销姓名	*/

@property(nonatomic,strong)UILabel *leftLable;

- (void)refreshWithModel:(SalelistModel *)model;


@end
