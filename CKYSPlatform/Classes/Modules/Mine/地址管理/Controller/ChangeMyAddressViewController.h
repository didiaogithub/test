//
//  ChangeMyAddressViewController.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/17.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"

typedef void (^TransBlockaddress)(AddressModel *addressModel);
typedef void (^AddressBackBlock)(NSString *deleteDefaultAddressId);

@interface ChangeMyAddressViewController : BaseViewController

@property (nonatomic, copy) TransBlockaddress addressBlock;
@property (nonatomic, copy) NSString *pushString;
//解决删除地址后 传过去的bug
@property (nonatomic, copy) AddressBackBlock backBlock;

-(void)setAddressBlock:(TransBlockaddress)addressBlock;

-(void)setDeleteAddressIdWithBlock:(AddressBackBlock)deleteBlock;

@property (nonatomic, copy) NSString *oidString;
@property (nonatomic, copy) NSString *isOversea;

@end
