//
//  AddAddressViewController.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/8/5.
//  Copyright © 2016年 ckys. All rights reserved.
//
//添加收货地址
#import "BaseViewController.h"
#import "AddressModel.h"

typedef void (^TransBlock)(NSString *addressString,NSString *defaultIdStr);

@interface AddAddressViewController : BaseViewController

@property (nonatomic, strong) AddressModel *addressModel;
@property (nonatomic, copy)   NSString *areaNameStr;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *telephone;
@property (nonatomic, copy)   NSString *addressIdString;
@property (nonatomic, copy)   NSString *pushString;
@property (nonatomic, copy)   NSString *oidString;
@property (nonatomic, assign) NSInteger pushTag;
@property (nonatomic, copy)   TransBlock placeBlock;

-(void)setPlaceBlock:(TransBlock)placeBlock;

@end
