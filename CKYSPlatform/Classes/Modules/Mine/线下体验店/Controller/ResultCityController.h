//
//  ResultCityController.h
//  MySelectCityDemo
//
//  Created by 李阳 on 15/9/2.
//  Copyright (c) 2015年 WXDL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelecteAreaModel.h"
@protocol ResultCityControllerDelegate <NSObject>
@optional
-(void)didScroll;
-(void)didSelectedProVinceString:(NSString *)provinceString andCityStr:(NSString *)cityStr;

@end

@interface ResultCityController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)SelecteAreaModel *provinceModel;
@property (nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic,retain)UITableView *tableView;
@property(nonatomic,copy)NSString *provinceStr;
@property (nonatomic,assign) id <ResultCityControllerDelegate>delegate;
@end
