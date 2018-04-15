//
//  CKOrderDetailModel.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/22.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

//订单中的商品
@interface CKGoodsDetailModel : BaseEncodeModel

/**商品名称*/
@property (nonatomic, copy) NSString *name;
/**购买数量*/
@property (nonatomic, copy) NSString *num;

@end

@interface CKOldDetailModel : BaseEncodeModel

/**原单单号*/
@property (nonatomic, copy) NSString *orderno;
/**原单金额*/
@property (nonatomic, copy) NSString *ordermoney;
/**原单商品购买详情*/
@property (nonatomic, strong) NSMutableArray<CKGoodsDetailModel*> *goodsArray;

@end

@interface CKChangeDetailModel : BaseEncodeModel

/**原单单号*/
@property (nonatomic, copy) NSString *orderno;
/**原单金额*/
@property (nonatomic, copy) NSString *ordermoney;
/**原单商品购买详情*/
@property (nonatomic, strong) NSMutableArray<CKGoodsDetailModel*> *goodsArray;

@end

@interface CKOrderDetailModel : BaseEncodeModel

/**昵称*/
@property (nonatomic, copy) NSString *smallname;
/**收货人*/
@property (nonatomic, copy) NSString *gettername;
/**收货电话*/
@property (nonatomic, copy) NSString *gettermobile;
/**收货地址*/
@property (nonatomic, copy) NSString *getteraddress;
/**最近更新的一条物流信息*/
@property (nonatomic, copy) NSString *lastlogisticsmsg;
/**最近更新的一条物流信息时间*/
@property (nonatomic, copy) NSString *lastlogisticstime;
/**运费*/
@property (nonatomic, copy) NSString *transfee;
/**物流名称*/
@property (nonatomic, copy) NSString *transname;
/**物流单号*/
@property (nonatomic, copy) NSString *transno;
/**下单时间*/
@property (nonatomic, copy) NSString *ordertime;
/**支付时间*/
@property (nonatomic, copy) NSString *paytime;
/**发货时间*/
@property (nonatomic, copy) NSString *shiptime;
/**总金额*/
@property (nonatomic, copy) NSString *totalmoney;
/**是否可以修改地址时间限制*/
@property (nonatomic, copy) NSString *limittime;
/**系统时间*/
@property (nonatomic, copy) NSString *systime;
/**支付方式*/
@property (nonatomic, copy) NSString *paytype;
/**支付流水号*/
@property (nonatomic, copy) NSString *payno;
/**原订单支付时间*/
@property (nonatomic, copy) NSString *paytimeold;
/**原订单支付方式*/
@property (nonatomic, copy) NSString *paytypeold;
/**原订单支付流水号*/
@property (nonatomic, copy) NSString *paynoold;

/**原单信息*/
@property (nonatomic, strong) NSMutableArray<CKOldDetailModel*> *olddetailArry;
/**新单信息*/
@property (nonatomic, strong) NSMutableArray<CKChangeDetailModel*> *newdetailArry;

@end
