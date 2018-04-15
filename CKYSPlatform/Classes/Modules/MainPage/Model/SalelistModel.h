//
//  SalelistModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalelistModel : NSObject

/**金额*/
@property(nonatomic,copy)NSString *money;
/**订单号*/
@property(nonatomic,copy)NSString *no;
/**时间*/
@property(nonatomic,copy)NSString *time;
/**记录id*/
@property(nonatomic,copy)NSString *ID;
/**记录状态*/
@property(nonatomic,copy)NSString *status;
//操作（进货、内转）
@property(nonatomic,copy)NSString *operation;
//进货：显示流水号  内转：内转
@property(nonatomic,copy)NSString *paytn;
@end
