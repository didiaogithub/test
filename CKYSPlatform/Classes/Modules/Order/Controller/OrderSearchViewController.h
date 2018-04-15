//
//  SearchViewController.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/24.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderSearchViewController : BaseViewController
/**订单状态*/
@property(nonatomic,copy)NSString *statusString;
/**ck or wxuser*/
@property(nonatomic,copy)NSString *buyertype;

@end
