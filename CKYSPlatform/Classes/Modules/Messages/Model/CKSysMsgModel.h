//
//  CKSysMsgModel.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

//进入具体类型的model
@interface CKSysMsgModel : RLMObject
/**消息id*/
@property NSString *ID;
/**标题*/
@property NSString *title;
/**消息内容*/
@property NSString *msg;
/**是否有未读（0：无 1：有）*/
@property NSString *ifRead;
/**时间*/
@property NSString *time;
/**类型与id组成的主键*/
@property NSString *type_id;
/**消息类型（1：订单 2：开店 3：云豆 4：产品 ）*/
@property NSString *type;

@end


//点击系统通知请求的model
/**（1：订单 2：开店 3：云豆 4：产品 ）的列表*/
@interface CKSysMsgListModel : RLMObject

/**消息类型（1：订单 2：开店 3：云豆 4：产品 ）*/
@property NSString *type;
/**标题*/
@property NSString *title;
/**消息内容*/
@property NSString *msg;
/**消息未读数*/
@property long notreadnum;
/**时间*/
@property NSString *msgtime;

@property NSString *ckid;

@end

