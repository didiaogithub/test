//
//  CityViewController.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/9/14.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "SelecteAreaModel.h"
@interface CityViewController : BaseViewController
@property(nonatomic,strong)SelecteAreaModel *areaModel;
@property(nonatomic,copy)NSString *typeStr;
@end
