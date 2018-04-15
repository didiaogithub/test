//
//  SCUseCouponViewController.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/15.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCUseCouponViewController.h"
#import "SCCouponCanUseCell.h"
#import "SCCouponDetailViewController.h"
#import "SCCouponModel.h"
#import "SCCouponCannotUseCell.h"

@interface SCUseCouponViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *canUseBtn;
@property (nonatomic, strong) UIButton *canNotUseBtn;
@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UITableView *couponTable;
@property (nonatomic, strong) NSMutableArray *useArray;
@property (nonatomic, strong) NSMutableArray *uselessArray;
@property (nonatomic, copy)   NSString *couponType;
@property (nonatomic, copy)   NSString *coupontMoney;
@property (nonatomic, copy)   NSString *coupontId;
@property (nonatomic, strong) UIImageView *noData;
@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation SCUseCouponViewController

-(NSMutableArray *)useArray {
    if (!_useArray) {
        _useArray = [NSMutableArray array];
    }
    return _useArray;
}

-(NSMutableArray *)uselessArray {
    if (!_uselessArray) {
        _uselessArray = [NSMutableArray array];
    }
    return _uselessArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠券统计";
    
    self.couponType = @"0";
    
    [self initComponents];
    
    [self setupRefresh];
    
    NSArray *couponListArray = [[XNArchiverManager shareInstance] xnUnarchiverObject:[NSString stringWithFormat:@"MyCouponCache_%@", self.couponType]];
    if (couponListArray.count > 0) {
        for (NSDictionary *couponDic in couponListArray) {
            SCCouponModel *couponM = [[SCCouponModel alloc] init];
            couponM.isExpand = NO;
            [couponM setValuesForKeysWithDictionary:couponDic];
            [self.useArray addObject:couponM];
        }
        _noData.hidden = (self.useArray.count > 0) ? YES : NO;
        _noDataLabel.hidden = (self.useArray.count > 0) ? YES : NO;
        [self.couponTable reloadData];
    }
    
    [self resquestCouponData:@"0"];
}

-(void)initComponents {
    
    _noData = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 347*0.5, 339*0.5)];
    _noData.center = self.view.center;
    _noData.image = [UIImage imageNamed:@"noCoupons"];
    [self.view addSubview:_noData];
    _noData.hidden = YES;
    _noDataLabel = [UILabel configureLabelWithTextColor:[UIColor colorWithHexString:@"#333333"] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:14]];
    _noDataLabel.frame = CGRectMake(0, CGRectGetMaxY(_noData.frame), SCREEN_WIDTH, 30);
    [self.view addSubview:_noDataLabel];
    _noDataLabel.text = @"暂无此类优惠券";
    _noDataLabel.hidden = YES;
    
    UIView *tagView = [UIView new];
    tagView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.view.mas_top).offset(NaviAddHeight+64);
        make.height.mas_equalTo(46);
    }];
    
    self.canUseBtn = [[UIButton alloc] init];
    [self.canUseBtn setTitle:@"顾客未使用" forState:UIControlStateNormal];
    [self.canUseBtn setTitleColor:[UIColor colorWithHexString:@"#E2231A"] forState:UIControlStateNormal];
    self.canUseBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.canUseBtn addTarget:self action:@selector(clickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tagView addSubview:self.canUseBtn];
    self.canUseBtn.tag = 44;
    [self.canUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.bottom.mas_offset(-2);
        make.width.mas_equalTo(SCREEN_WIDTH*0.5);
    }];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"#E2231A"];
    self.lineLabel.frame = CGRectMake((SCREEN_WIDTH*0.5-100)*0.5, 44, 100, 2);
    [tagView addSubview:self.lineLabel];
    
    self.canNotUseBtn = [[UIButton alloc] init];
    [self.canNotUseBtn setTitle:@"顾客已使用" forState:UIControlStateNormal];
    [self.canNotUseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    self.canNotUseBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.canNotUseBtn addTarget:self action:@selector(clickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tagView addSubview:self.canNotUseBtn];
    self.canNotUseBtn.tag = 45;
    [self.canNotUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.bottom.mas_offset(-2);
        make.width.mas_equalTo(SCREEN_WIDTH*0.5);
    }];
    
    self.couponTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.couponTable.delegate = self;
    self.couponTable.dataSource = self;
    self.couponTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.couponTable.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.couponTable.estimatedSectionHeaderHeight = 10;
        self.couponTable.estimatedSectionFooterHeight = 0.1;
    }
    [self.view addSubview:self.couponTable];
    [self.couponTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(tagView.mas_bottom).offset(0);
        make.bottom.mas_offset(-BOTTOM_BAR_HEIGHT);
    }];
}

-(void)clickTagBtn:(UIButton*)btn {
    NSLog(@"%@", btn.titleLabel.text);
    if (btn.tag == 44) {
        [self.canNotUseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self.canUseBtn setTitleColor:[UIColor colorWithHexString:@"#E2231A"] forState:UIControlStateNormal];
            self.lineLabel.frame = CGRectMake((SCREEN_WIDTH*0.5-100)*0.5, 44, 100, 2);
        }];
        self.couponType = @"0";
        
        if (self.useArray.count > 0) {
            _noData.hidden = (self.useArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.useArray.count > 0) ? YES : NO;
            [self.couponTable reloadData];
        }else{
            //如果有值切换时不再请求
            [self resquestCouponData:@"0"];
        }
    }else{
        [self.canUseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self.canNotUseBtn setTitleColor:[UIColor colorWithHexString:@"#E2231A"] forState:UIControlStateNormal];
            self.lineLabel.frame = CGRectMake(SCREEN_WIDTH*0.5+(SCREEN_WIDTH*0.5-100)*0.5, 44, 100, 2);
        }];
        self.couponType = @"1";
        if (self.uselessArray.count > 0) {
            _noData.hidden = (self.uselessArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.uselessArray.count > 0) ? YES : NO;
            [self.couponTable reloadData];
        }else{
            //如果有值切换时不再请求
            [self resquestCouponData:@"0"];
        }
    }
}

#pragma mark - 设置刷新
-(void)setupRefresh {
    __typeof (self) __weak weakSelf = self;
    self.couponTable.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        
        [weakSelf.couponTable.mj_header beginRefreshing];
        
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
        weakSelf.endInterval = [nowDate timeIntervalSince1970];
        NSTimeInterval value = weakSelf.endInterval - weakSelf.startInterval;
        CGFloat second = [[NSString stringWithFormat:@"%.2f",value] floatValue];//秒
        NSLog(@"间隔------%f秒",second);
        weakSelf.startInterval = weakSelf.endInterval;
        
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                if (value >= Interval) {
                    [weakSelf resquestCouponData:@"0"];
                }else{
                    [weakSelf.couponTable.mj_header endRefreshing];
                    if (weakSelf.couponTable.mj_footer.state == MJRefreshStateNoMoreData) {
                        [weakSelf.couponTable.mj_footer endRefreshing];
                    }
                }
            }
                break;
            default: {
                [self showNoticeView:NetWorkNotReachable];
                [weakSelf.couponTable.mj_header endRefreshing];
            }
                break;
        }
        
    }];
    
    
    self.couponTable.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                if ([self.couponType isEqualToString:@"0"]) {
                    [weakSelf resquestCouponData:[NSString stringWithFormat:@"%ld", self.useArray.count]];
                }else{
                    [weakSelf resquestCouponData:[NSString stringWithFormat:@"%ld", self.useArray.count]];
                }
                
                [weakSelf.couponTable.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView:NetWorkNotReachable];
                [weakSelf.couponTable.mj_footer endRefreshing];
            }
                break;
        }
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.couponType isEqualToString:@"0"]) {
        self.couponTable.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    }
    
}

#pragma mark - 请求优惠券数据
-(void)resquestCouponData:(NSString*)lineNumber {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetMyCoupons];
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *params = @{@"ckid":KCKidstring, @"type":self.couponType, @"deviceid":uuid, @"id":lineNumber, @"pagesize":@"50"};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:params success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self.viewDataLoading stopAnimation];
            [self.couponTable.mj_header endRefreshing];
            [self.couponTable.mj_footer endRefreshing];
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        NSArray *list = dict[@"coupons"];
        
        if ([self.couponType isEqualToString:@"0"]) {
            if ([lineNumber isEqualToString:@"0"]) {
                [self.useArray removeAllObjects];
                
                [[XNArchiverManager shareInstance] xnArchiverObject:list archiverName:[NSString stringWithFormat:@"MyCouponCache_%@", self.couponType]];
            }
            for (NSDictionary *couponDic in list) {
                SCCouponModel *couponM = [[SCCouponModel alloc] init];
                couponM.isExpand = NO;
                [couponM setValuesForKeysWithDictionary:couponDic];
                [self.useArray addObject:couponM];
            }
            _noData.hidden = (self.useArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.useArray.count > 0) ? YES : NO;
        }else{
            if ([lineNumber isEqualToString:@"0"]) {
                [self.uselessArray removeAllObjects];
                [[XNArchiverManager shareInstance] xnArchiverObject:list archiverName:[NSString stringWithFormat:@"MyCouponCache_%@", self.couponType]];
            }
            for (NSDictionary *couponDic in list) {
                SCCouponModel *couponM = [[SCCouponModel alloc] init];
                couponM.isExpand = NO;
                [couponM setValuesForKeysWithDictionary:couponDic];
                [self.uselessArray addObject:couponM];
            }
            _noData.hidden = (self.uselessArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.uselessArray.count > 0) ? YES : NO;
        }
        
        [self.couponTable reloadData];
        [self.couponTable.mj_header endRefreshing];
        if (list.count > 0) {
            [self.couponTable.mj_footer endRefreshing];
        }else{
            [self.couponTable.mj_footer endRefreshingWithNoMoreData];
        }
        [self.viewDataLoading stopAnimation];
    } failure:^(NSError *error) {
        [self.couponTable.mj_header endRefreshing];
        [self.couponTable.mj_footer endRefreshing];
        [self.viewDataLoading stopAnimation];
        if ([self.couponType isEqualToString:@"0"]){
            _noData.hidden = (self.useArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.useArray.count > 0) ? YES : NO;
            [self.couponTable reloadData];
        }else{
            _noData.hidden = (self.uselessArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.uselessArray.count > 0) ? YES : NO;
            [self.couponTable reloadData];
        }
    }];
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.couponType isEqualToString:@"0"]) {
        return self.useArray.count;
    }
    return self.uselessArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.couponType isEqualToString:@"0"]) {
        SCCouponCanUseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponCanUseCell"];
        if (!cell) {
            cell = [[SCCouponCanUseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCCouponCanUseCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SCCouponModel *couponM = self.useArray[indexPath.section];
        [cell refreshCouponWithCouponModel:couponM];
        
        return cell;
    }else{
        SCCouponCannotUseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponCannotUseCell"];
        if (!cell) {
            cell = [[SCCouponCannotUseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCCouponCannotUseCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        SCCouponModel *couponM = self.uselessArray[indexPath.section];
        [cell refreshCouponWithCouponModel:couponM];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //因为后一个页面要更改模型的值，直接赋值会影响此页面的值
    SCCouponDetailViewController *couponDetail = [[SCCouponDetailViewController alloc] init];
    SCCouponModel *couponM = [[SCCouponModel alloc] init];
    if ([self.couponType isEqualToString:@"0"]) {
        couponM = self.useArray[indexPath.section];
    }else{
        couponM = self.uselessArray[indexPath.section];
    }
    couponDetail.couponM = [[SCCouponModel alloc] init];
    couponDetail.couponM.isExpand = couponM.isExpand;
    couponDetail.couponM.couponid = couponM.couponid;
    couponDetail.couponM.money = couponM.money;
    couponDetail.couponM.name = couponM.name;
    couponDetail.couponM.userange = couponM.userange;
    couponDetail.couponM.scope = couponM.scope;
    couponDetail.couponM.details = couponM.details;
    couponDetail.couponM.timelimit = couponM.timelimit;
    couponDetail.couponM.imgurl = couponM.imgurl;
    
    [self.navigationController pushViewController:couponDetail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
