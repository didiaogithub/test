//
//  CKOrderinfoModel.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

@interface CKOrderinfoModel : BaseEncodeModel

/**订单id*/
@property (nonatomic, copy) NSString *orderid;
/**收货地址id*/
@property (nonatomic, copy) NSString *addressid;
/**收货人姓名*/
@property (nonatomic, copy) NSString *gettername;
/**收货人电话*/
@property (nonatomic, copy) NSString *gettermobile;
/**收货地址*/
@property (nonatomic, copy) NSString *getteraddress;
/**是否默认地址*/
@property (nonatomic, copy) NSString *isdefaultaddress;
/**商品id*/
@property (nonatomic, copy) NSString *itemid;
/**商品图片url*/
@property (nonatomic, copy) NSString *path;
/**商品名称*/
@property (nonatomic, copy) NSString *name;
/**商品价格*/
@property (nonatomic, copy) NSString *price;

@end
