//
//  CKAddressViewController.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/18.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"

typedef void (^AddressBlock)(AddressModel *addressM);

@interface CKAddressViewController : BaseViewController

@property (nonatomic, strong) AddressModel *addressModel;
@property (nonatomic, copy)   AddressBlock addressBlock;

@property (nonatomic, copy)   NSString *pushString;
@property (nonatomic, copy)   NSString *oidString;

//modifyAddress. = @"CKOrderDetail";

@end
