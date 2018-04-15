//
//  SureMySelfOrderViewController.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/16.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "CKPickupGoodsModel.h"

@interface SureMySelfOrderViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CKPickupGoodsModel *goodOrderModel;
@property (nonatomic, copy)   NSString *allMoneyString;
@property (nonatomic, copy)   NSString *typeString;
@property (nonatomic, copy)   NSString *clearString;
@property (nonatomic, assign) BOOL showCount;

@end
