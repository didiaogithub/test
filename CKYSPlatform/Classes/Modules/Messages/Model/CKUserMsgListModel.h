//
//  CKUserMsgListModel.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/19.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <Realm/Realm.h>

@interface CKUserMsgListModel : RLMObject

/**最后一条信息内容*/
@property NSString *lastmsg;
/**最后一条消息时间*/
@property NSString *lastmsgtime;
/**是否未读 0：无 1：有*/
@property NSString *ifread;
/**未读消息数*/
@property NSString *notreadnum;
/**联系人名称*/
@property NSString *name;
/**联系人备注*/
@property NSString *remark;
/**头像*/
@property NSString *head;
/**联系人id*/
@property NSString *meid;
/**主键ckid+meid+msgType*/
@property NSString *msgListKey;
/**金粉，意向，潜水*/
@property NSString *msgType;

@end
