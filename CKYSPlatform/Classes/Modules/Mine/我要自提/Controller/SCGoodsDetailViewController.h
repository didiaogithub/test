//
//  SCGoodsDetailViewController.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseViewController.h"

@interface SCGoodsDetailViewController : BaseViewController

@property (nonatomic, copy)   NSString *goodsId;
@property (nonatomic, copy)   NSString *allMoneyString;
@property (nonatomic, strong) NSMutableArray *tempArray;

@end
