//
//  CKSmallTipsViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/12/29.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKSmallTipsViewController.h"
#import "CKSmallTipCell.h"
#import "CKSmallTipModel.h"
#import "CKSmallTipDetailVC.h"

@interface CKSmallTipsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *ckTipBtn;
@property (nonatomic, strong) UIButton *mallTipBtn;
@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UITableView *tipTable;
@property (nonatomic, strong) NSMutableArray *ckTipArray;
@property (nonatomic, strong) NSMutableArray *mallTipArray;
@property (nonatomic, copy)   NSString *tipType;
@property (nonatomic, copy)   NSString *refreshData;

@end

@implementation CKSmallTipsViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (NSMutableArray *)ckTipArray {
    if (!_ckTipArray) {
        _ckTipArray = [NSMutableArray array];
    }
    return _ckTipArray;
}

- (NSMutableArray *)mallTipArray {
    if (!_mallTipArray) {
        _mallTipArray = [NSMutableArray array];
    }
    return _mallTipArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tipType = @"0";
    self.refreshData = @"0";
    
    [self initComponent];
    
    [self requestData];
    
    [self refreshTipData];
}


- (void)initComponent {
    
    UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NaviHeight)];;
    tagView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tagView];
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20+NaviAddHeight-5, 30, 50)];
    [backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"RootNavigationBack"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"RootNavigationBack"] forState:UIControlStateSelected];
    [tagView addSubview:backBtn];
    
    self.ckTipBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 20+NaviAddHeight, (SCREEN_WIDTH-40)*0.5, 42)];
    [self.ckTipBtn setTitle:@"创客App小窍门" forState:UIControlStateNormal];
    if ([UIScreen mainScreen].bounds.size.height < 667) {
        self.ckTipBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }else{
        self.ckTipBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    [self.ckTipBtn setTitleColor:[UIColor colorWithHexString:@"#E2231A"] forState:UIControlStateNormal];
    [self.ckTipBtn addTarget:self action:@selector(clickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tagView addSubview:self.ckTipBtn];
    self.ckTipBtn.tag = 44;
    
    self.mallTipBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-40)*0.5+40, 20+NaviAddHeight, (SCREEN_WIDTH-40)*0.5, 42)];
    [self.mallTipBtn setTitle:@"商城小窍门" forState:UIControlStateNormal];
    [self.mallTipBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    if ([UIScreen mainScreen].bounds.size.height < 667) {
        self.mallTipBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }else{
        self.mallTipBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    [self.mallTipBtn addTarget:self action:@selector(clickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tagView addSubview:self.mallTipBtn];
    self.mallTipBtn.tag = 45;
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"#E2231A"];
    self.lineLabel.frame = CGRectMake(0, NaviHeight, (SCREEN_WIDTH-80)*0.5, 2);
    self.lineLabel.center = CGPointMake(CGRectGetMidX(self.ckTipBtn.frame), NaviHeight);
    [self.view addSubview:self.lineLabel];
    
    self.tipTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tipTable.delegate = self;
    self.tipTable.dataSource = self;
    self.tipTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tipTable.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.tipTable.estimatedSectionHeaderHeight = 10;
        self.tipTable.estimatedSectionFooterHeight = 0.1;
    }
    [self.view addSubview:self.tipTable];
    [self.tipTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(tagView.mas_bottom).offset(2);
        make.bottom.mas_offset(-BOTTOM_BAR_HEIGHT);
    }];
}

- (void)clickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickTagBtn:(UIButton*)btn {
    NSLog(@"%@", btn.titleLabel.text);
    if (btn.tag == 44) {
        [self.mallTipBtn setTitleColor:TitleColor forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self.ckTipBtn setTitleColor:[UIColor colorWithHexString:@"#E2231A"] forState:UIControlStateNormal];
            self.lineLabel.center = CGPointMake(CGRectGetMidX(self.ckTipBtn.frame), NaviHeight);
        }];
        self.tipType = @"0";
        if (self.ckTipArray.count == 0) {
            [self requestData];
        }else{
            [self.tipTable reloadData];
        }
        
    }else{
        [self.ckTipBtn setTitleColor:TitleColor forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self.mallTipBtn setTitleColor:[UIColor colorWithHexString:@"#E2231A"] forState:UIControlStateNormal];
            self.lineLabel.center = CGPointMake(CGRectGetMidX(self.mallTipBtn.frame), NaviHeight);
        }];
        self.tipType = @"1";
        
        if (self.mallTipArray.count == 0) {
            [self requestData];
        }else{
            [self.tipTable reloadData];
        }
    }
}

- (void)requestData {
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/CkMonthly/getTips"];
    NSString *row = @"0";
    if ([self.tipType isEqualToString:@"1"]) {
        row = [NSString stringWithFormat:@"%ld", self.mallTipArray.count];
    }else{
        row = [NSString stringWithFormat:@"%ld", self.ckTipArray.count];
    }
    
    NSDictionary *params = @{@"tipstype":self.tipType, @"pagesize":@"20", @"row":row};
    [HttpTool postWithUrl:requestUrl params:params success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            [self.tipTable.mj_footer endRefreshing];
            [self.tipTable.mj_header endRefreshing];
            [self.viewDataLoading stopAnimation];
            return ;
        }
        
        NSArray *tips = dict[@"tips"];
        
        if (tips.count == 0) {
            if ([self.refreshData isEqualToString:@"1"]) {
                [self.tipTable.mj_footer endRefreshingWithNoMoreData];
                [self.viewDataLoading stopAnimation];
                return;
            }
        }
        
        for (NSDictionary *tipDict in tips) {
            CKSmallTipModel *tipM = [[CKSmallTipModel alloc] init];
            [tipM setValuesForKeysWithDictionary:tipDict];
            if ([self.tipType isEqualToString:@"1"]) {
                [self.mallTipArray addObject:tipM];
            }else{
                [self.ckTipArray addObject:tipM];
            }
        }
        
        [self.tipTable reloadData];
        [self.tipTable.mj_footer endRefreshing];
        [self.tipTable.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
    } failure:^(NSError *error) {
        [self.tipTable.mj_footer endRefreshing];
        [self.tipTable.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 刷新
- (void)refreshTipData {
    __weak typeof(self) weakSelf = self;
    self.tipTable.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        self.refreshData = @"0";
        [weakSelf.tipTable.mj_header beginRefreshing];
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
                    if ([self.tipType isEqualToString:@"0"]) {
                        [self.ckTipArray removeAllObjects];
                    }else{
                        [self.mallTipArray removeAllObjects];
                    }
                    [weakSelf requestData];
                }else{
                    [weakSelf.tipTable.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.tipTable.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.tipTable.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        self.refreshData = @"1";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf requestData];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.tipTable.mj_footer endRefreshing];
            }
                break;
        }
    }];
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.tipType isEqualToString:@"1"]) {
        return self.mallTipArray.count;
    }
    return self.ckTipArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CKSmallTipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKSmallTipCell"];
    if (!cell) {
        cell = [[CKSmallTipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKSmallTipCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CKSmallTipModel *tipM = [[CKSmallTipModel alloc] init];
    if ([self.tipType isEqualToString:@"1"]) {
        tipM = self.mallTipArray[indexPath.section];
    }else{
        tipM = self.ckTipArray[indexPath.section];
    }
    
    [cell refreshWithLessons:tipM];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH*0.5+120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CKSmallTipModel *tipM = [[CKSmallTipModel alloc] init];
    if ([self.tipType isEqualToString:@"1"]) {
        tipM = self.mallTipArray[indexPath.section];
    }else{
        tipM = self.ckTipArray[indexPath.section];
    }
    
    CKSmallTipDetailVC *couponDetail = [[CKSmallTipDetailVC alloc] init];
    couponDetail.url = tipM.url;
    [self.navigationController pushViewController:couponDetail animated:YES];
}

@end
