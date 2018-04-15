//
//  BaseSearchViewController.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/2/24.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchNavView.h"

@interface BaseSearchViewController : BaseViewController<SearchNavViewDelegate>

@property (nonatomic, strong) SearchNavView *searchNavView;
@property (nonatomic, strong) NodataImageView *nodataImageView;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *searchSourceArray;

@end
