//
//  MyTeamListModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/12/2.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTeamListModel : NSObject
/**顾客id */
@property(nonatomic,copy)NSString *ID;
/**姓名 */
@property(nonatomic,copy)NSString *name;
/** 姓名*/
@property(nonatomic,copy)NSString *realname;
/** 微信昵称*/
@property(nonatomic,copy)NSString *smallname;
/**电话 */
@property(nonatomic,copy)NSString *mobile;

/**顾客电话 */
@property(nonatomic,copy)NSString *gettermobile;

/**总业绩（个人进货+招商） 创客 */
@property(nonatomic,copy)NSString *totalPerf;

/**总业绩（个人进货+招商） 分销 */
@property(nonatomic,copy)NSString *totalperf;


/** SURE:永久   NOTSURE:零风险*/
@property(nonatomic,copy)NSString *jointype;
/**直营团队人数 */
@property(nonatomic,copy)NSString *teamNum;

/**进货 */
@property(nonatomic,copy)NSString *jhPerf;
/**招商 */
@property(nonatomic,copy)NSString *zsPerf;
/*开店时间 */
@property(nonatomic,copy)NSString *jointime;

/*头像 */
@property(nonatomic,copy)NSString *logopath;
/*头像 */
@property(nonatomic,copy)NSString *head;
/*累计消费金额*/
@property(nonatomic,copy)NSString *allm;
/*收件人*/
@property(nonatomic,copy)NSString *gettername;


/**金额*/
@property(nonatomic,copy)NSString *money;

/**时间*/
@property(nonatomic,copy)NSString *time;

//操作（进货、内转）
@property(nonatomic,copy)NSString *operation;
//进货：显示流水号  内转：内转
@property(nonatomic,copy)NSString *paytn;

@end
