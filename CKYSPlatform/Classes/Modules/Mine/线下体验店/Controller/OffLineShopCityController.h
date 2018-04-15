//
//  CityViewController.h
//  MySelectCityDemo
//
//  Created by 李阳 on 15/9/1.
//  Copyright (c) 2015年 WXDL. All rights reserved.
//

#import "BaseViewController.h"
#import "SelecteAreaModel.h"
@interface OffLineShopCityController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)SelecteAreaModel *cityModel;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSString *provinceStr;
@property(nonatomic,copy)NSString *typeStr;


@end
