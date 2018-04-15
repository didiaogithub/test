//
//  MyTeamModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/12/2.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTeamModel : NSObject

/** 今日新增顾客人数*/
@property(nonatomic,copy)NSString *customerAdd;
/** 今日新增创客人数*/
@property(nonatomic,copy)NSString *ckAdd;
/** 今日新增分销人数*/
@property(nonatomic,copy)NSString *fxAdd;

/** 已绑定所有顾客人数*/
@property(nonatomic,copy)NSString *customerTotal;
/** 下级创客总人数*/
@property(nonatomic,copy)NSString *ckTotal;
/** 下级分销总人数*/
@property(nonatomic,copy)NSString *fxTotal;
/**已开通预售店铺 总数*/
@property(nonatomic,copy)NSString *presaleTotal;

@end
