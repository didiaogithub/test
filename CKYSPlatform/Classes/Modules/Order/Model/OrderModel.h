//
//  OrderModel.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/8/10.
//  Copyright © 2016年 ckys. All rights reserved.
//
//  订单列表页商品模型
#import <Foundation/Foundation.h>

@interface Ordersheet : RLMObject
/**订单id*/
@property NSString *oid;
/** 商品id*/
@property NSString *itemid;
/**名称*/
@property NSString *name;
/**数量*/
@property NSString *count;
/**价格*/
@property NSString *price;
/**路径*/
@property NSString *url;
/**主键*/
@property NSString *sheetKey;
/**规格*/
@property NSString *spec;
/**0：非海外购订单 1：海外购订单*/
@property NSString *isoversea;

@end
RLM_ARRAY_TYPE(Ordersheet)

@interface OrderModel : RLMObject

/**订单id*/
@property NSString *oid;
/**订单号*/
@property NSString *no;
/**订单状态 订单状态（99：全部 1：未付款；2：已付款；4：正在退货，5：退货成功，7：已发货 ）*/
@property NSString *orderstatus;
/**订单 明细*/
@property RLMArray<Ordersheet*><Ordersheet> *orderArray;
/**下单时间*/
@property NSString *time;
/**实付金额*/
@property NSString *money;
/**下单用户*/
@property NSString *buyername;
/**收件人*/
@property NSString *gettername;
/**创客id*/
@property NSString *ckid;
/**订单类型：CK:我的订单，WXUSER：消费者*/
@property NSString *buyerType;
/**优惠金额*/
@property NSString *favormoney;
/**总金额*/
@property NSString *ordermoney;
/**原订单总金额*/
@property NSString *ordermoneyold;
/**原订单实付金额*/
@property NSString *moneyold;
/**原订单优惠券金额*/
@property NSString *favormoneyold;
/**orderfrom 3表示换货订单*/
@property NSString *orderfrom;
/**聊天id*/
@property (nonatomic, copy) NSString *meid;

@end
RLM_ARRAY_TYPE(OrderModel)

