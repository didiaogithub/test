//
//  CKMyProductLibVCOld.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/12.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKMyProductLibVCOld.h"
#import "TakeCashViewController.h"
#import "KKDatePickerView.h"
#import "CKProductLibModel.h"
#import "TopUpPayTypeViewController.h"
#import "CKProductLibCell.h"
#import "CKCouponDetailViewController.h"

@interface CKMyProductLibVCOld ()<UITableViewDelegate, UITableViewDataSource, KKDatePickerViewDelegate>
{
    UIView *_topheaderView;
    UIButton *bgBtn;
    UILabel *stateLabel;
}

@property (nonatomic, strong) UILabel *beanNumberLable;
@property (nonatomic, strong) UILabel *headerNumberLable;
@property (nonatomic, strong) UIButton *takeCashButton;
@property (nonatomic, strong) UILabel *recordNumberLable;//多少笔记录
@property (nonatomic, strong) UIImageView *cloundBeanImageView;
@property (nonatomic, strong) CKProductLibModel *productLibM;
@property (nonatomic, copy) NSString *yearString;
@property (nonatomic, copy) NSString *monthString;
@property (nonatomic, copy) NSString *oidString;
@property (nonatomic, copy) NSString *totalNum;
@property (nonatomic, copy) NSString *glibmoney; //产品库
@property (nonatomic, copy) NSString *ckidString;
@property (nonatomic, copy) NSString *isDownloadMore;
@property (nonatomic, copy) NSString *isPopularizeSales;
@property (nonatomic, copy) NSString *isLock;

@property(nonatomic,strong)UITableView *beanDeatiltableView;
@property(nonatomic,strong) NSMutableArray *data_array;
@property(nonatomic,strong)NodataLableView *nodataLableView;

// mj
@property(nonatomic, copy) NSString *couponNum;
@property(nonatomic, copy) NSString *maxmoney;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, copy) NSString *voucherid;
@property(nonatomic, copy) NSString *totalvouchermoney;


@end

@implementation CKMyProductLibVCOld

- (NodataLableView *)nodataLableView {
    if(_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64-AdaptedHeight(175))];
        _nodataLableView.nodataLabel.text = @"暂无记录";
    }
    return _nodataLableView;
}

-(NSMutableArray *)data_array {
    if (_data_array == nil) {
        _data_array = [[NSMutableArray alloc] init];
    }
    return _data_array;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self.data_array removeAllObjects];
    _oidString = 0;
    [self getMyProductData];
    [self getCurrentMoneyData];
    [self removeCouponsView];

}

- (void)removeCouponsView{
    [stateLabel removeFromSuperview];
    [_nameLabel removeFromSuperview];
    [bgBtn removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    self.navigationItem.title = @"我的产品库";
    
    _isPopularizeSales = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self createSiftButton];
    [self createTableView];
    [self refreshData];
}

-(void)getCurrentMoneyData{
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"ckid":_ckidString,DeviceId:uuid};
    NSString *gethonourAndCertUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getGlibMoney_Url];
    [HttpTool postWithUrl:gethonourAndCertUrl params:pramaDic success:^(id json) {
        
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        _glibmoney = dict[@"glibmoney"];
        if (IsNilOrNull(_glibmoney)) {
            _glibmoney = @"";
        }
        _couponNum = [NSString stringWithFormat:@"%@",dict[@"num"]];
        if (IsNilOrNull(_couponNum)) {
            _couponNum = @"0";
        }
        
        if (![_couponNum isEqualToString:@"0"]) {
            [self addConponBtn];
        }
        
        _maxmoney = dict[@"maxmoney"];
        if (IsNilOrNull(_maxmoney)) {
            _maxmoney = @"";
        }
        
        _totalvouchermoney = [NSString stringWithFormat:@"%@", dict[@"totalvouchermoney"]];
        if (IsNilOrNull(_totalvouchermoney)) {
            _totalvouchermoney = @"";
            _nameLabel.hidden = YES;
        }else{
            _nameLabel.hidden = NO;
            _nameLabel.text = [NSString stringWithFormat:@"%@元产品卷", _totalvouchermoney];
            _nameLabel.adjustsFontSizeToFitWidth = YES;
        }
        
        _voucherid = dict[@"voucherid"];
        if (IsNilOrNull(_voucherid)) {
            _voucherid = @"";
        }
        [self.beanDeatiltableView reloadData];
        [self refreshAllmyYunDouandProduct];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
-(void)refreshAllmyYunDouandProduct{
    
    if(IsNilOrNull(_glibmoney)){
        _glibmoney = @"0.00";
    }
    
    _beanNumberLable.text = [NSString stringWithFormat:@"¥%@",_glibmoney];
}

-(void)getMyProductData{
    //请求参数年、月为空时，默认从当前年月查询，
    //   pagesize  展示多少行 10行  id  产品库最后一条记录id（刷新时要传最后一条操作记录的id）
    
    if (IsNilOrNull(_yearString)) {
        _yearString = @"";
    }
    if (IsNilOrNull(_monthString)) {
        _monthString = @"";
    }
    if (IsNilOrNull(_oidString)){
        _oidString = @"0";
    }
    if (![_isDownloadMore isEqualToString:@"2"]) {
        _oidString = @"0";
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"year":_yearString,@"month":_monthString,@"pagesize":@"20",@"id":_oidString,DeviceId:uuid,@"ver":@"301"};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI, glibrecordRequest_Url];
    
    _nodataLableView.hidden = YES;
    if(IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            [self.beanDeatiltableView.mj_footer endRefreshing];
            [self.beanDeatiltableView.mj_header endRefreshing];
            return ;
        }
        if (IsNilOrNull(dict[@"totalNum"])) {
            _totalNum = @"";
        }else{
            _totalNum = [NSString stringWithFormat:@"%@",dict[@"totalNum"]];
        }
        
        if (![_isDownloadMore isEqualToString:@"2"]) {
            [self.data_array removeAllObjects];
        }
        
        NSArray *recorrdArr = dict[@"records"];
        
        if (recorrdArr.count == 0) {
            if ([_isDownloadMore isEqualToString:@"2"]) {
                [self.beanDeatiltableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        
        
        for (NSDictionary *listDic in recorrdArr) {
            self.productLibM = [[CKProductLibModel alloc] init];
            [self.productLibM setValuesForKeysWithDictionary:listDic];
            [self.data_array addObject:self.productLibM];
        }
        _oidString =  [NSString stringWithFormat:@"%zd",self.data_array.count];
        
        if(![self.data_array count]){
            _nodataLableView.hidden = NO;
            [self.beanDeatiltableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.data_array.count];
        }
        
        [self.beanDeatiltableView.mj_footer endRefreshing];
        [self.beanDeatiltableView.mj_header endRefreshing];
        
        [self.beanDeatiltableView reloadData];
        [self refreshBeanNumber];
        
    } failure:^(NSError *error) {
        [self.beanDeatiltableView.mj_footer endRefreshing];
        [self.beanDeatiltableView.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
/**创建筛选按钮*/
-(void)createSiftButton{
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"selectconditions"] style:UIBarButtonItemStylePlain target:self action:@selector(clickSiftButton)];
    right.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10;
        self.navigationItem.rightBarButtonItems = @[spaceItem, right];
    }
}
/**点击筛选按钮*/
-(void)clickSiftButton{
    KKDatePickerView *pickerView = [[KKDatePickerView alloc]initWithFrame:self.view.bounds];
    pickerView.delegate = self;
    [pickerView show];
}
/**点击pickerview代理方法*/
- (void)pickView:(NSString *)yes month:(NSString *)moth{
    
    if (![_oidString isEqualToString:@"0"]){
        _oidString = @"0";
    }
    _isDownloadMore = @"";
    _yearString = yes;
    _monthString = moth;
    
    [self getMyProductData];
    
    if([self.data_array count]){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.beanDeatiltableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mrak- 创建我的芸豆库展示UI
-(void)createTableView{
    //头部视图
    _topheaderView = [[UIView alloc] init];
    [self.view addSubview:_topheaderView];
    [_topheaderView setBackgroundColor:[UIColor tt_bigRedBgColor]];
    [_topheaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, AdaptedHeight(100)));
    }];
    
    
    //芸豆库详情图片
    _cloundBeanImageView = [[UIImageView alloc] init];
    [_topheaderView addSubview:_cloundBeanImageView];
    [_cloundBeanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(25));
        make.left.mas_offset(AdaptedWidth(25));
        make.width.mas_offset(AdaptedWidth(50));
        make.bottom.mas_offset(-AdaptedHeight(25));
    }];
    //云豆总值
    _beanNumberLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font: CHINESE_SYSTEM_BOLD(AdaptedWidth(20))];
    [_topheaderView addSubview:_beanNumberLable];
    _beanNumberLable.text = @"¥0.00";
    [_beanNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cloundBeanImageView.mas_top);
        make.right.mas_offset(-AdaptedWidth(10));
        make.left.equalTo(_cloundBeanImageView.mas_right).offset(AdaptedWidth(20));
    }];
    
    //我的产品库
    UILabel *beanLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [_topheaderView addSubview:beanLable];
    beanLable.text = @"我的产品库";
    [_cloundBeanImageView setImage:[UIImage imageNamed:@"myproductwhite"]];
    
    [beanLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_beanNumberLable.mas_bottom).offset(5);
        make.left.equalTo(_beanNumberLable.mas_left);
        make.bottom.equalTo(_cloundBeanImageView.mas_bottom);
    }];
    
    
    _beanDeatiltableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_beanDeatiltableView];
    [_beanDeatiltableView setBackgroundColor:[UIColor tt_grayBgColor]];
    [_beanDeatiltableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topheaderView.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT-52);
    }];
    _beanDeatiltableView.showsVerticalScrollIndicator = NO;
    _beanDeatiltableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _beanDeatiltableView.delegate = self;
    _beanDeatiltableView.dataSource = self;
    self.beanDeatiltableView.rowHeight = UITableViewAutomaticDimension;
    self.beanDeatiltableView.estimatedRowHeight = 44;
    
    //保存按钮
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [bankImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [self.view addSubview:bankImageView];
    bankImageView.userInteractionEnabled = YES;
    bankImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_beanDeatiltableView.mas_bottom).offset(6);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.height.mas_offset(40);
    }];
    
    
    //我要充值->进货
    _takeCashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankImageView addSubview:_takeCashButton];
    _takeCashButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [_takeCashButton setTitle:@"我要进货" forState:UIControlStateNormal];
    [_takeCashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bankImageView);
    }];
    [_takeCashButton addTarget:self action:@selector(clickTakeCashButton:) forControlEvents:UIControlEventTouchUpInside];
    //如果推广人登录  没有提现按钮
    if ([_isPopularizeSales isEqualToString:@"0"]) {
        _takeCashButton.hidden = NO;
        [_beanDeatiltableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT-52);
        }];
    }else{
        _takeCashButton.hidden = YES;
        [_beanDeatiltableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
        }];
    }
    
    UIView *numberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,AdaptedHeight(53))];
    _beanDeatiltableView.tableHeaderView = numberView;
    [numberView setBackgroundColor:[UIColor whiteColor]];
    UILabel *grayLable = [[UILabel alloc] init];
    [grayLable setBackgroundColor:[UIColor tt_grayBgColor]];
    [numberView addSubview:grayLable];
    [grayLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(8));
    }];
    _recordNumberLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [numberView addSubview:_recordNumberLable];
    _recordNumberLable.text = @"共计：0笔";
    [_recordNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(grayLable.mas_bottom);
        make.left.equalTo(numberView.mas_left).offset(15);
        make.right.equalTo(numberView.mas_right).offset(-15);
        make.bottom.mas_offset(0);
    }];
    [self refreshBeanNumber];
    [self refreshAllmyYunDouandProduct];
    
}

#pragma mark - 点击充值->进货按钮
-(void)clickTakeCashButton:(UIButton *)button{
    TopUpPayTypeViewController *topUp = [[TopUpPayTypeViewController alloc] init];
    topUp.num = _couponNum;
    topUp.dataDic = @{@"voucherid":_voucherid,
                      @"maxmoney":_maxmoney
                      };
    [self.navigationController pushViewController:topUp animated:YES];
}

-(void)refreshBeanNumber{
    if (IsNilOrNull(_totalNum)) {
        _totalNum = @"0";
    }
    _recordNumberLable.text = [NSString stringWithFormat:@"共计：%@笔",_totalNum];
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CKProductLibCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKProductLibCell"];
    if (cell == nil) {
        cell = [[CKProductLibCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKProductLibCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.data_array count]) {
        self.productLibM = self.data_array[indexPath.row];
        [cell refreshWithModel:self.productLibM];
    }
    
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 65;
//}

-(void)refreshData{
    __typeof (self) __weak weakSelf = self;
    self.beanDeatiltableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"1";
        _yearString = @"";
        _monthString = @"";
        [weakSelf.beanDeatiltableView.mj_header beginRefreshing];
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
                    [weakSelf getCurrentMoneyData];
                    [weakSelf getMyProductData];
                }else{
                    [weakSelf.beanDeatiltableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.beanDeatiltableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.beanDeatiltableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"2";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf getCurrentMoneyData];
                [weakSelf getMyProductData];
                //                [weakSelf.beanDeatiltableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.beanDeatiltableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
    
}


// 跳转到优惠券详情
- (void)jumpToCKCouponDetailVc{
    CKCouponDetailViewController *couponDetailVc = [[CKCouponDetailViewController alloc]init];
    couponDetailVc.isMyProductLib = YES;
    [self.navigationController pushViewController:couponDetailVc animated:YES];
}

- (void)addConponBtn{
    bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgBtn setBackgroundImage:[UIImage imageNamed:@"产品卷"] forState:UIControlStateNormal];
    [bgBtn setTitle:@"" forState:UIControlStateNormal];
    [_topheaderView addSubview:bgBtn];
    [bgBtn addTarget:self action:@selector(jumpToCKCouponDetailVc) forControlEvents:UIControlEventTouchUpInside];
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(AdaptedWidth(-10));
        make.width.mas_offset(AdaptedWidth(89));
        make.height.mas_offset(AdaptedHeight(34));
        make.centerY.equalTo(_topheaderView);
    }];
    
    _nameLabel = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:12]];
    [bgBtn addSubview:_nameLabel];
    
   
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgBtn).offset(AdaptedHeight(2));
        make.left.equalTo(bgBtn).offset(AdaptedWidth(2));
        make.right.equalTo(bgBtn).offset(AdaptedWidth(-2));
        make.height.mas_offset(AdaptedHeight(15));
    }];
    stateLabel = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:12]];
    [bgBtn addSubview:stateLabel];
    stateLabel.text = @"(未使用)";
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(AdaptedHeight(-2));
        make.left.equalTo(bgBtn).offset(AdaptedWidth(2));
        make.right.equalTo(bgBtn).offset(AdaptedWidth(-2));
        make.height.mas_offset(AdaptedHeight(15));
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
