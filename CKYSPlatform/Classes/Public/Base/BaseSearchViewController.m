//
//  BaseSearchViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/2/24.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseSearchViewController.h"

@interface BaseSearchViewController ()

@end

@implementation BaseSearchViewController

- (NodataImageView *)nodataImageView{
    if(_nodataImageView == nil) {
        _nodataImageView = [[NodataImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64-49)];
    }
    return _nodataImageView;
}

-(NSMutableArray *)searchSourceArray{
    if (_searchSourceArray == nil) {
        _searchSourceArray = [[NSMutableArray alloc] init];
    }
    return _searchSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initComponents];
    
}

- (void)initComponents {
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    
    [self initSearchView];
    [self initTableView];
}

- (void)initSearchView {
    if (@available(iOS 11.0, *)) {
        _searchNavView = [[SearchNavView alloc] init];
        [self.view addSubview:_searchNavView];
        [_searchNavView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_offset(0);
            make.height.mas_offset(44);
        }];
    }else{
        _searchNavView = [[SearchNavView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        
    }
    _searchNavView.delegate = self;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = _searchNavView;
}

- (void)initTableView {
    if (@available(iOS 11.0, *)) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-65-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    }else{
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1,SCREEN_WIDTH, SCREEN_HEIGHT-1) style:UITableViewStylePlain];
    }
    
    [self.view addSubview:_searchTableView];
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_searchTableView setBackgroundColor:[UIColor tt_grayBgColor]];
}

#pragma mark - 返回上一级
-(void)poptoLastPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
