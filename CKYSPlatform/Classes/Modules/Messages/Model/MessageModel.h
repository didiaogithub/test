//
//  MessageModel.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/23.
//  Copyright © 2016年 ckys. All rights reserved.
//

@interface MessageModel : RLMObject
/**联系人头像url*/
@property NSString *headurl;
/**会话id或者顾客id，后台自行决定 id = 273542;*/
@property NSString *ID;
/**未读消息数*/
@property long notreadcount;
/**最后一条消息内容*/
@property NSString *lastmsg;
/**最后一条消息时间*/
@property NSString *lastmsgtime;
/**昵称*/
@property NSString *smallname;
/**顾客id*/  /**主键*/
@property NSString *meid;
/**时间*/
@property NSString *time;
/**标题*/
@property NSString *title;
/**系统内容*/
@property NSString *msg;

@property NSString *ckid;

@end
