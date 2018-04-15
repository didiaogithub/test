//
//  CKMainPageModel.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/5/24.
//  Copyright © 2017年 ForgetFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Honor_list : RLMObject
/**荣誉证书*/
@property NSString *path;

@end
RLM_ARRAY_TYPE(Honor_list)

@interface Banners : RLMObject
/**活动路径*/
@property NSString *path;
@property NSString *bannerID;
@property NSString *urlshare;
@property NSString *url;

@end
RLM_ARRAY_TYPE(Banners)


@interface Top3ckheaders : RLMObject
/**创客id*/
@property NSString *top3ckID;
/**手机号码*/
@property NSString *mobile;
/**头像*/
@property NSString *url;
/**真实姓名*/
@property NSString *realname;

@end
RLM_ARRAY_TYPE(Top3ckheaders)


@interface Topnews : RLMObject
/**行号*/
@property NSString *lineID;
/**详情标题*/
@property NSString *title;
/**分享的描述*/
@property NSString *info;
/**详情url*/
@property NSString *detailurl;
/**图片url*/
@property NSString *url;
/**分享url*/
@property NSString *urlshare;

@end
RLM_ARRAY_TYPE(Topnews)


@interface Mediareport : RLMObject
/**行号*/
@property NSString *lineId;
/**详情标题*/
@property NSString *title;
/**分享的描述*/
@property NSString *info;
/**详情url*/
@property NSString *url;
/**类型*/
@property NSString *typecode;
/**图片url*/
@property NSString *path;
/**分享url*/
@property NSString *urlshare;

@end
RLM_ARRAY_TYPE(Mediareport)


@interface CKMainPageModel : RLMObject
/** 帮助页面url*/
@property NSString *helpurl;
/** 本日收益*/
@property NSString *moneytoday;
/** 支付状态PAY*/
@property NSString *status;
/** 销售总收入*/
@property NSString *moneytotal;
/** 微信头像*/
@property NSString *headurl;
/** 店铺连接*/
@property NSString *shopurl;
/** 荣誉*/
@property RLMArray<Honor_list*><Honor_list> *honorArray;
/** 微信名称*/
@property NSString *realname;
/**店铺名称*/
@property NSString *name;
/** 有风险  或者 无风险*/
@property NSString *type;
/** 轮播*/
@property RLMArray<Banners*><Banners> *bannerArray;
/**直营创客人数*/
@property NSString *ckTotal;
/** 直营创客前三名*/
@property RLMArray<Top3ckheaders*><Top3ckheaders> *top3ckheaderArray;
/** 创客人数*/
@property NSString *cknum;
/**直营分销人数*/
@property NSString *fxTotal;
/**头条消息*/
@property RLMArray<Topnews*><Topnews> *topnewsArray;
/**媒体报道*/
@property RLMArray<Mediareport*><Mediareport> *mediareportArray;
/** 协议url*/
@property NSString *ckcxyurl;
/**创客类型 */
@property NSString *jointype;
/**创客id */
@property NSString *ckid;

/**3.1.3  0未考试 1考试未通过 2 通过 3 超期未通过（无礼包销售权） */
@property NSString *giftshare;


@end
RLM_ARRAY_TYPE(CKMainPageModel)

