//
//  BankCardInfoViewController.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/3.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseViewController.h"

@interface BankCardInfoViewController : BaseViewController
/**银行卡户主*/
@property(nonatomic,copy)NSString *name;
/**银行卡号*/
@property(nonatomic,copy)NSString *bankCardNo;

@end
