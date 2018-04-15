//
//  RechargeAndAttactiveModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/12/1.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RechargeAndAttactiveModel : NSObject

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *money;

/**创客类型（SURE：正式  NOTSURE：零风险*/
@property(nonatomic,copy)NSString *jointype;
/**个人招商用 realname*/
@property(nonatomic,copy)NSString *realname;
@property(nonatomic,copy)NSString *mobile;
/**个人招商  开店时间*/
@property(nonatomic,copy)NSString *jointime;

/**团队进货 用name*/
@property(nonatomic,copy)NSString *name;
//没有时分秒 团队进货
@property(nonatomic,copy)NSString *time;
/** 团队招商人数*/
@property(nonatomic,copy)NSString *num;

//支付方式
@property(nonatomic,copy)NSString *paytype;


@end
