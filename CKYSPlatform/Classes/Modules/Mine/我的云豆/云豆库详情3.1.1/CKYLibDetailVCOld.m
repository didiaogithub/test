//
//  CKYLibDetailVCOld.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/12.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKYLibDetailVCOld.h"
#import "TakeCashViewController.h"
#import "CloudRecordTableViewCell.h"
#import "KKDatePickerView.h"
#import "YundouAndProductModel.h"
#import "TopUpPayTypeViewController.h"

static NSString *recordIdentifier = @"CloudRecordTableViewCell";

@interface CKYLibDetailVCOld ()<UITableViewDelegate, UITableViewDataSource, KKDatePickerViewDelegate>
{
    UILabel *_beanNumberLable;
    UILabel *_headerNumberLable;
    UIButton *_takeCashButton;
    UILabel *_recordNumberLable;//多少笔记录
    UIImageView *_cloundBeanImageView;
    NSString *_yearString;
    NSString *_monthString;
    NSString *_oidString;
    NSString *_totalNum;
    NSString *_glibmoney;
    NSString *_ylibMoney;
    NSString *_ckidString;
    NSString *_isDownloadMore;
    YundouAndProductModel *_yunAndProductModel;
    NSString *_isPopularizeSales;
    NSString *_isLock;
}
@property(nonatomic,strong)UITableView *beanDeatiltableView;
@property(nonatomic,strong) NSMutableArray *data_array;
@property(nonatomic,strong)NodataLableView *nodataLableView;

@end

@implementation CKYLibDetailVCOld

- (NodataLableView *)nodataLableView
{
    if(_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64-AdaptedHeight(175))];
        _nodataLableView.nodataLabel.text = @"暂无记录";
    }
    return _nodataLableView;
}
-(NSMutableArray *)data_array{
    if (_data_array == nil) {
        _data_array = [[NSMutableArray alloc] init];
    }
    return _data_array;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.data_array removeAllObjects];
    _oidString = 0;
    [self getMyProductData];
    [self getCurrentMoneyData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    self.navigationItem.title = @"我的云豆库";
    
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
    NSDictionary *pramaDic = @{@"ckid":_ckidString, DeviceId:uuid};
    NSString *gethonourAndCertUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getYlibMoney_Url];
    [HttpTool postWithUrl:gethonourAndCertUrl params:pramaDic success:^(id json) {
        
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        
        _ylibMoney = dict[@"ylibmoney"];
        _glibmoney = dict[@"glibmoney"];
        if (IsNilOrNull(_ylibMoney)){
            _ylibMoney = @"";
        }
        if (IsNilOrNull(_glibmoney)) {
            _glibmoney = @"";
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
    if(IsNilOrNull(_ylibMoney)){
        _ylibMoney = @"0.00";
    }
    _beanNumberLable.text = [NSString stringWithFormat:@"¥%@",_ylibMoney];
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
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ylibrecordRequest_Url];
    
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
            _yunAndProductModel = [[YundouAndProductModel alloc] init];
            [_yunAndProductModel setValuesForKeysWithDictionary:listDic];
            [self.data_array addObject:_yunAndProductModel];
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
    UIView *topheaderView = [[UIView alloc] init];
    [self.view addSubview:topheaderView];
    [topheaderView setBackgroundColor:[UIColor tt_bigRedBgColor]];
    [topheaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, AdaptedHeight(100)));
    }];
    
    
    //芸豆库详情图片
    _cloundBeanImageView = [[UIImageView alloc] init];
    [topheaderView addSubview:_cloundBeanImageView];
    [_cloundBeanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(25));
        make.left.mas_offset(AdaptedWidth(25));
        make.width.mas_offset(AdaptedWidth(50));
        make.bottom.mas_offset(-AdaptedHeight(25));
    }];
    //云豆总值
    _beanNumberLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font: CHINESE_SYSTEM_BOLD(AdaptedWidth(20))];
    [topheaderView addSubview:_beanNumberLable];
    _beanNumberLable.text = @"¥0.00";
    [_beanNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cloundBeanImageView.mas_top);
        make.right.mas_offset(-AdaptedWidth(10));
        make.left.equalTo(_cloundBeanImageView.mas_right).offset(AdaptedWidth(20));
    }];
    
    //我的云豆库
    UILabel *beanLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [topheaderView addSubview:beanLable];
    beanLable.text = @"我的云豆库";
    [_cloundBeanImageView setImage:[UIImage imageNamed:@"yundouwhite"]];
    
    [beanLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_beanNumberLable
                         .mas_bottom).offset(5);
        make.left.equalTo(_beanNumberLable.mas_left);
        make.bottom.equalTo(_cloundBeanImageView.mas_bottom);
    }];
    
    _beanDeatiltableView = [[UITableView alloc] init];
    [self.view addSubview:_beanDeatiltableView];
    [_beanDeatiltableView setBackgroundColor:[UIColor tt_grayBgColor]];
    [_beanDeatiltableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topheaderView.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT-52);
    }];
    [self.beanDeatiltableView registerClass:[CloudRecordTableViewCell class] forCellReuseIdentifier:recordIdentifier];
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
    //我要提现
    _takeCashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankImageView addSubview:_takeCashButton];
    _takeCashButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [_takeCashButton setTitle:@"我要提现" forState:UIControlStateNormal];
    _takeCashButton.tag = 77;
    
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
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.bottom.mas_offset(0);
    }];
    [self refreshBeanNumber];
    [self refreshAllmyYunDouandProduct];
    
}

#pragma mark - 点击提现或者充值按钮
-(void)clickTakeCashButton:(UIButton *)button{
    if(button.tag == 77){ //提现
        if(IsNilOrNull(_ckidString)){
            _ckidString = @"";
        }
        //提现前确认是否提现金额为0
        NSString *uuid = DeviceId_UUID_Value;
        if (IsNilOrNull(uuid)){
            uuid = @"";
        }
        NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,withDrawCash_Url];
        NSDictionary *pramaDic = @{@"ckid":_ckidString,@"money":@"",DeviceId:uuid};
        
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
        [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
            [self.beanDeatiltableView.mj_header endRefreshing];
            [self.viewDataLoading stopAnimation];
            NSDictionary *dict= json;
            if([dict[@"code"] integerValue] != 200){  //提现验证不通过
                [self showNoticeView:dict[@"codeinfo"]];
                return ;
            }
            TakeCashViewController *takeCashVC = [[TakeCashViewController alloc] init];
            takeCashVC.maxCash = self.maxCash;
            takeCashVC.curretYylibMoney = self.currentYlibMoney;
            takeCashVC.isLock = self.islock;
            [self.navigationController pushViewController:takeCashVC animated:YES];
            
        } failure:^(NSError *error) {
            [self.beanDeatiltableView.mj_header endRefreshing];
            [self.viewDataLoading stopAnimation];
            if (error.code == -1009) {
                [self showNoticeView:NetWorkNotReachable];
            }else{
                [self showNoticeView:NetWorkTimeout];
            }
        }];
        
    }else{ //充值
        
        TopUpPayTypeViewController *topUp = [[TopUpPayTypeViewController alloc] init];
        [self.navigationController pushViewController:topUp animated:YES];
    }
    
}

-(void)refreshBeanNumber{
    if (IsNilOrNull(_totalNum)) {
        _totalNum = @"0";
    }
    _recordNumberLable.text = [NSString stringWithFormat:@"共计：%@笔",_totalNum];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CloudRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor tt_grayBgColor]];
    if ([self.data_array count]) {
        _yunAndProductModel = self.data_array[indexPath.row];
        [cell refreshWithModel:_yunAndProductModel];
    }
    
    return cell;
}
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell的时候 展开一个view  点击view上的按钮 收起view
    // 正常情况下打开关闭
    
}


@end
