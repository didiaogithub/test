//
//  CKOfficialMsgModel.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

@interface CKOfficialMsgModel : RLMObject

/**消息id*/
@property NSString *ID;
/**标题*/
@property NSString *title;
/**消息类型 news:头条 course:课程 plat:官方通知*/
@property NSString *type;
/**阅览量（type=course时，课程详情页 有阅览量）*/
@property NSString *viewed;
/**详情页面url（type!=plat时，课程、头条有详情跳转）*/
@property NSString *url;
/**分享图片url（type=news时，头条有imgurl地址）*/
@property NSString *imgurl;
/**消息内容*/
@property NSString *msg;
/**时间*/
@property NSString *time;

@property NSString *ckid;

@end
