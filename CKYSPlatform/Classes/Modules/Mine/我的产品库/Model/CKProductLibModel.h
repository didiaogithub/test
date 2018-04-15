//
//  CKProductLibModel.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKProductLibModel : NSObject

/**产品库记录id*/
@property (nonatomic, copy) NSString *ID;
/**记录操作（零售、退货、进货、自提、分销进货）*/
@property (nonatomic, copy) NSString *operation;
/**本次记录金额*/
@property (nonatomic, copy) NSString *money;
/**1：进账  -1：出账*/
@property (nonatomic, copy) NSString *dir;
/**自提、零售、退货：订单号，进货：支付流水号or内转，分销进货：分销id*/
@property (nonatomic, copy) NSString *paytn;
/**时间*/
@property (nonatomic, copy) NSString *time;


@end
