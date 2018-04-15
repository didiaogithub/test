//
//  BirthplaceViewController.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/3.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^TransBlock)(NSString *addressString,NSString *defaultIdStr);
@interface BirthplaceViewController : BaseViewController


@property(nonatomic,copy)NSString *addressIdString;
/**联系人*/
@property(nonatomic,copy)NSString *getterName;
/**联系电话*/
@property(nonatomic,copy)NSString *getterMobile;

@property(nonatomic,copy)NSString *areaNameStr;
@property(nonatomic,copy)TransBlock placeBlock;

@property(nonatomic,copy)NSString *placeString;
-(void)setPlaceBlock:(TransBlock)placeBlock;
@end
