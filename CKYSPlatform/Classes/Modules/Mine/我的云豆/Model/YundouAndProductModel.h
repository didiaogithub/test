//
//  YundouAndProductModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/12/9.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YundouAndProductModel : NSObject

@property(nonatomic,copy)NSString *ID;

/**记录操作（零售、退货、进货、自提、分销进货）*/
@property(nonatomic,copy)NSString *operation;
/**本次记录金额*/
@property(nonatomic,copy)NSString *money;
/**1：进账  -1：出账*/
@property(nonatomic,copy)NSString *dir;
/**自提、零售、退货：订单号，进货：支付流水号or内转，分销进货：分销id*/
@property(nonatomic,copy)NSString *paytn;
/**时间*/
@property(nonatomic,copy)NSString *time;
/**当前产品库存*/
@property(nonatomic,copy)NSString *glibmoney;
/**当前芸豆库存*/
@property(nonatomic,copy)NSString *ylibmoney;
/**如果是金凤  并且 进账  +收入  并且是云豆记录 islock为1三行  否则 2行*/
@property(nonatomic,copy)NSString *islock;


@end
