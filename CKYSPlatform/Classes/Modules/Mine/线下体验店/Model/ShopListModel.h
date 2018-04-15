//
//  ShopListModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/17.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopListModel : NSObject
/**体验店id*/
@property(nonatomic,copy)NSString *ID;
/**创客手机号码*/
@property(nonatomic,copy)NSString *ckmobile;
/**创客姓名*/
@property(nonatomic,copy)NSString *ckname;
/**体验店名称*/
@property(nonatomic,copy)NSString *expname;
/**体验店电话*/
@property(nonatomic,copy)NSString *exptel;
/**体验店状态*/
@property(nonatomic,copy)NSString *status;
/**体验店开通时间*/
@property(nonatomic,copy)NSString *opentime;
/**省*/
@property(nonatomic,copy)NSString *province;
/**市*/
@property(nonatomic,copy)NSString *city;
/**详细地址*/
@property(nonatomic,copy)NSString *address;
/**证书url（完整的url）*/
@property(nonatomic,copy)NSString *credentialpath;
/**描述*/
@property(nonatomic,copy)NSString *descrip;

@end
