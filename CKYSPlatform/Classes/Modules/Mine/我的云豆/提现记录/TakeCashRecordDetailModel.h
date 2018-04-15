//
//  TakeCashRecordDetailModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/5/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakeCashRecordDetailModel : NSObject
/**申请时间*/
@property(nonatomic,copy)NSString *time;
/**提现金额*/
@property(nonatomic,copy)NSString *money;

/**银行卡名称*/
@property(nonatomic,copy)NSString *bankname;
/**银行卡*/
@property(nonatomic,copy)NSString *bankcardno;
/**提现状态*/
@property(nonatomic,copy)NSString *status;
/**失败原因失败时返回失败原因，其他情况返回空*/
@property(nonatomic,copy)NSString *info;

+(TakeCashRecordDetailModel *)getDetailWithdictionary:(NSDictionary*)dict;
@end
