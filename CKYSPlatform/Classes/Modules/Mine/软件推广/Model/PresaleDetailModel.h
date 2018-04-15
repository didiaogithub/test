//
//  PresaleDetailModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/1/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PresaleDetailModel : NSObject
/**店铺id*/
@property(nonatomic,copy)NSString *ID;
/**用户头像*/
@property(nonatomic,copy)NSString *headurl;

/**用户昵称*/
@property(nonatomic,copy)NSString *realname;

/**开通 开店时间）*/
@property(nonatomic,copy)NSString *jointime;
/**支付时间*/
@property(nonatomic,copy)NSString *paytime;
/**预售店铺邀请码*/
@property(nonatomic,copy)NSString *preyqcode;
/**加盟风险类型*/
@property(nonatomic,copy)NSString *jointype;



/**状态（未开通、已开通）*/
@property(nonatomic,copy)NSString *status;
+(PresaleDetailModel *)getPresaleDetailWithdictionary:(NSDictionary*)dict;

@end
