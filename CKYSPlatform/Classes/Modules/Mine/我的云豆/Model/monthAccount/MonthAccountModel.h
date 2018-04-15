//
//  MonthAccountModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/12/1.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthAccountModel : NSObject
/**月结总奖励*/
@property(nonatomic,copy)NSString *totalMoney;
/**团队管理费*/
@property(nonatomic,copy)NSString *totalTeam;
/**推荐费*/
@property(nonatomic,copy)NSString *totalInvite;
/**个人业绩*/
@property(nonatomic,copy)NSString *totalPerfCK;
/**个人进货*/
@property(nonatomic,copy)NSString *rechargeCK;
/**个人招商*/
@property(nonatomic,copy)NSString *inviteCK;
/**销售业绩*/
@property(nonatomic,copy)NSString *totalPerfTeam;
/**团队进货*/
@property(nonatomic,copy)NSString *rechargeTeam;
/**团队招商*/
@property(nonatomic,copy)NSString *inviteTeam;
/**奖励系数*/
@property(nonatomic,copy)NSString *modulus;

@end
