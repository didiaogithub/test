//
//  IdentityCardViewController.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/28.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^CerUrlBlock)(NSString *handUrl,NSString *rightUrl,NSString *backUrl);

@interface IdentityCardViewController : BaseViewController
/**手持身份证*/
@property(nonatomic,copy)NSString *handUrlStr;
/**身份证正面*/
@property(nonatomic,copy)NSString *rightUrlStr;
/**身份证反面*/
@property(nonatomic,copy)NSString *bankUrlStr;
/**拼接的域名*/
@property(nonatomic,copy)NSString *domainName;

@property(nonatomic,copy)CerUrlBlock cerBlock;
-(void)setCerBlock:(CerUrlBlock)cerBlock;

@end
