//
//  UserModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/25.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property(nonatomic,copy)NSString *IDNo;
@property(nonatomic,copy)NSString *IDimgHand;
@property(nonatomic,copy)NSString *IDimgFront;
@property(nonatomic,copy)NSString *IDimgBack;
/**微信账号*/
@property(nonatomic,copy)NSString *WXAccount;
/**收货地址*/
@property(nonatomic,copy)NSString *address;
/**店铺头像*/
@property(nonatomic,copy)NSString *headfile;
/**手机号*/
@property(nonatomic,copy)NSString *mobile;
/**真实姓名*/
@property(nonatomic,copy)NSString *realname;
/**性别*/
@property(nonatomic,copy)NSString *sex;
/**店铺名称*/
@property(nonatomic,copy)NSString *shopname;
/**显示资质证书*/
@property(nonatomic,copy)NSString *showCertificates;
/**显示手机号码*/
@property(nonatomic,copy)NSString *showMobile;
/**显示微信号码*/
@property(nonatomic,copy)NSString *showWX;
/**店铺昵称*/
@property(nonatomic,copy)NSString *smallname;
/**手机号码*/
@property(nonatomic,copy)NSString *telephone;
/**身份证的域名*/
@property(nonatomic,copy)NSString *photodomain;
@end


@interface ClearAllCache : RLMObject

@property NSString *isClear;

@end
