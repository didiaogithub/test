//
//  CKdlbGoodsModel.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKdlbGoodsModel : NSObject

/**选中状态*/
@property (nonatomic, assign) BOOL isSelect;
/**商品id*/
@property (nonatomic, copy) NSString *goodsId;
/**名称*/
@property (nonatomic, copy) NSString *name;
/**图片路径*/
@property (nonatomic, copy) NSString *path;
/**价格*/
@property (nonatomic, copy) NSString * price;
/**礼包类型，1：创客，2：分销，3：零风险*/
@property (nonatomic, copy) NSString *isdlbtype;
/**礼包详情*/
@property (nonatomic, copy) NSString *url;


@end
