//
//  CKOrderViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/11/14.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKOrderViewController.h"
#import "OrderMessageTableViewCell.h"
#import "WxuserOrderTableViewCell.h"
#import "OrderModel.h"
#import "OrderSearchViewController.h"
#import "CKOrderDetailViewController.h"
#import "KKDatePickerView.h"
#import "orderFooterView.h"
#import "DetailLogisticsViewController.h"
#import "WxuserView.h"
#import "CKPayViewController.h"

#import "PayMoneyViewController.h"


#define WIDTH (SCREEN_WIDTH - 160)/2

static NSString *cellIdentifier = @"OrderMessageTableViewCell";
static NSString *wxuserIdentifier = @"WxuserOrderTableViewCell";

@interface CKOrderViewController ()<UITableViewDelegate, UITableViewDataSource, KKDatePickerViewDelegate>

@property (nonatomic, strong) UILabel *bottomLine;
@property (nonatomic, strong) UILabel *statusLine;
@property (nonatomic, strong) UILabel *orderNumberLable;  //订单编号
@property (nonatomic, strong) UILabel *orderStateLable;  //订单状态
@property (nonatomic, strong) Ordersheet *orderDetailModel;
@property (nonatomic, strong) NSString *isDownloadMore;
@property (nonatomic, assign) float leftPadding;

@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) UIButton *searchButton; //搜索按钮
@property (nonatomic, strong) UIButton *myOrderButton; //我的订单
@property (nonatomic, strong) UIButton *salesOrderButton; //消费者订单

@property (nonatomic, strong) UIButton *allOrderButton; //全部订单
@property (nonatomic, strong) UIButton *waitPayMoneyButton; //待付款
@property (nonatomic, strong) UIButton *waitDispatchGoodsButton; //待发货
@property (nonatomic, strong) UIButton *waitConsigneeButton; //待收货
@property (nonatomic, strong) UIButton *afterSalesButton; //售后

@property (nonatomic, strong) OrderModel *orderModel;
@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) NSMutableArray *orderMessageArray;
@property (nonatomic, strong) orderFooterView *footerView;
@property (nonatomic, strong) WxuserView *wxUserView;

@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, assign) NSTimeInterval startInterval;
@property (nonatomic, assign) NSTimeInterval endInterval;
@property (nonatomic, strong) NSArray *statusArr;
@property (nonatomic, strong) NSMutableArray *statusBtnArr;

@property (nonatomic, copy) NSString *ckidString;
@property (nonatomic, copy) NSString *tgidString; //是否推广人登录
@property (nonatomic, copy) NSString *flagStr;
@property (nonatomic, copy) NSString *oidString;
@property (nonatomic, copy) NSString *statuString;//订单状态
@property (nonatomic, copy) NSString *buyertype; //下单类型

@property (nonatomic, copy) NSString *yearStr;
@property (nonatomic, copy) NSString *monthStr;



@end

@implementation CKOrderViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeComponent];
    
    [self loadDBData:nil];
    
    [self setupRefresh];
}

- (NodataLableView *)nodataLableView {
    if(_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64-49-50)];
        _nodataLableView.nodataLabel.text = @"暂无订单";
    }
    return _nodataLableView;
}

-(NSMutableArray *)orderMessageArray {
    if (_orderMessageArray == nil) {
        _orderMessageArray = [NSMutableArray array];
    }
    return _orderMessageArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    //自提商城过来 跳转过来 选中我的订单
    if(IsNilOrNull(_statuString)){
        _statuString = @"99";
    }
    if(![_oidString isEqualToString:@"0"]){
        _oidString = @"0";
    }
    _yearStr = @"";
    _monthStr = @"";
    [self isTgPeople]; //刷新推广人订单界面
    //请求订单列表数据
    [self loadMyOrderData];
}

-(void)isTgPeople{
    //推广人登录 标题为订单 只能看wxuseroder
    _tgidString = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    _tgidString = IsNilOrNull(_tgidString) ? @"0" : _tgidString;
    
    if (![_tgidString isEqualToString:@"0"]){
        self.navigationItem.title = @"订单";
        _myOrderButton.hidden = YES;
        _salesOrderButton.hidden = YES;
        _bottomLine.hidden = YES;
    }else{
        self.navigationItem.title = @"";
        _myOrderButton.hidden = NO;
        _salesOrderButton.hidden = NO;
        _bottomLine.hidden = NO;
    }
}

-(void)selfPickupMallEnterOrder {
    [self refreshStatusWithType:@"1"];
}

-(void)refreshStatusWithType:(NSString *)type{
    
    float leftx = 0;
    if ([type isEqualToString:@"1"]){
        [self orderSelected:YES type:@"MyOrder"];
        
        if ([_tgidString isEqualToString:@"0"]){
            [self lineWidthWith:SCREEN_WIDTH/4.0];
            _buyertype = @"CK";
        }else{
            [self lineWidthWith:SCREEN_WIDTH/5.0];
            _buyertype = @"WXUSER";
        }
        leftx = 35+5;
    }else{
        [self orderSelected:NO type:@"SalesOrder"];
        
        _buyertype = @"WXUSER";
        [self lineWidthWith:SCREEN_WIDTH/5.0];
        leftx = 35+5+20+WIDTH;
    }
    [self navbuttonAnnamationWithLeftx:leftx];
}

-(void)orderSelected:(BOOL)selected type:(NSString*)orderType{
    
    _myOrderButton.selected = selected;
    _myOrderButton.userInteractionEnabled = !selected;
    _salesOrderButton.selected = !selected;
    _salesOrderButton.userInteractionEnabled = selected;
    
    if ([orderType isEqualToString:@"MyOrder"]) {
        _myOrderButton.titleLabel.font = CHINESE_SYSTEM(AdaptedHeight(17));
        _salesOrderButton.titleLabel.font = MAIN_TITLE_FONT;
    }else if ([orderType isEqualToString:@"SalesOrder"]){
        _myOrderButton.titleLabel.font = MAIN_TITLE_FONT;
        _salesOrderButton.titleLabel.font = CHINESE_SYSTEM(AdaptedHeight(17));
    }
}

-(void)initializeComponent {
    
    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *tgStr = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    _tgidString = IsNilOrNull(tgStr) ? @"0" : tgStr;
    
    _statusArr = @[@"99", @"1", @"2", @"7", @"4,5"];
    
    _isDownloadMore = @"1";
    
    if (IsNilOrNull( _buyertype)){
        _buyertype = @"WXUSER";
    }
    
    if(IsNilOrNull(_statuString)){
        _statuString = @"99";
    }
    if(![_oidString isEqualToString:@"0"]){
        _oidString = @"0";
    }
    
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(getOrderDataWithoutCache) name:@"RequestMessageData" object:nil];
    
    [CKCNotificationCenter addObserver:self selector:@selector(selfPickupMallEnterOrder) name:@"SelfPickupMallEnterOrderNoti" object:nil];
    
    //注册完成后要刷新界面
    [CKCNotificationCenter addObserver:self selector:@selector(updateUI) name:@"UpdateUIToLoginSuccessNoti" object:nil];
    
    [self refreshStatusWithType:@"0"];
    
    [self createNavButton];
    [self createTopButton];
    [self createTableView];
    
}

#pragma mark - 注册成功后刷新界面
-(void)updateUI {
    
    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    //自提商城过来 跳转过来 选中我的订单
    if(IsNilOrNull(_statuString)){
        _statuString = @"99";
    }
    if(![_oidString isEqualToString:@"0"]){
        _oidString = @"0";
    }
    _yearStr = @"";
    _monthStr = @"";
    [self isTgPeople]; //刷新推广人订单界面
    //请求订单列表数据
    [self loadMyOrderData];
}

#pragma mark - 设置刷新
-(void)setupRefresh {
    __typeof (self) __weak weakSelf = self;
    self.orderTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        
        _isDownloadMore = @"1";
        _yearStr = @"";
        _monthStr = @"";
        _nodataLableView.hidden = YES;
        
        [weakSelf.orderTableView.mj_header beginRefreshing];
        
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
                    [weakSelf loadMyOrderData];
                }else{
                    [weakSelf.orderTableView.mj_header endRefreshing];
                    if (weakSelf.orderTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                        [weakSelf.orderTableView.mj_footer endRefreshing];
                    }
                }
            }
                break;
            default: {
                [self showNoticeView:NetWorkNotReachable];
                [weakSelf.orderTableView.mj_header endRefreshing];
            }
                break;
        }
        
        if (self.orderMessageArray.count == 0) {
            _nodataLableView.hidden = NO;
        }
    }];
    
    
    self.orderTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        _isDownloadMore = @"2";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf loadMoreData];
                [weakSelf.orderTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView:NetWorkNotReachable];
                [weakSelf.orderTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
}

#pragma mark - 创建 我的订单  消费者订单  筛选  搜索按钮
- (void)createNavButton {
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    
    UIView *grayView = [[UILabel alloc] initWithFrame:CGRectMake(0, 4.5, 35, 35)];
    [naviView addSubview:grayView];
    grayView.layer.cornerRadius = 35/2;
    grayView.clipsToBounds = YES;
    grayView.userInteractionEnabled = YES;
    grayView.backgroundColor = [UIColor tt_grayBgColor];
    //搜索按钮
    _searchButton = [self createButtonWithframe:CGRectMake(0, 0, 35, 35) andTag:20000 andAction:@selector(clickNavButton:) andTitle:nil andImageName:@"search" anselected:NO];
    [grayView addSubview:_searchButton];
    
    _myOrderButton = [self createButtonWithframe:CGRectMake(35+5, 0, WIDTH, 44) andTag:20001 andAction:@selector(clickNavButton:) andTitle:@"我的订单" andImageName:nil anselected:NO];
    [naviView addSubview:_myOrderButton];
    
    _salesOrderButton = [self createButtonWithframe:CGRectMake(35+5+20+WIDTH, 0,WIDTH, 44) andTag:20002 andAction:@selector(clickNavButton:) andTitle:@"消费者订单" andImageName:nil anselected:YES];
    [naviView addSubview:_salesOrderButton];
    
    self.navigationItem.titleView = naviView;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"selectconditions"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    right.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = 5;
        self.navigationItem.rightBarButtonItems = @[spaceItem, right];
    }
    
    _bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(35+5+20+WIDTH, 44, WIDTH, 1.5)];
    [naviView addSubview:_bottomLine];
    _bottomLine.backgroundColor = [UIColor tt_redMoneyColor];
    
    //推广人登录显示的界面
    if (![_tgidString isEqualToString:@"0"]){ //推广员登录
        _myOrderButton.hidden = YES;
        _flagStr = @"0";
        _salesOrderButton.hidden = YES;
        _bottomLine.hidden = YES;
        self.navigationItem.title = @"订单";
    }else{
        //普通创客
        _flagStr = @"";
        _salesOrderButton.selected = YES;
        _myOrderButton.hidden = NO;
        _bottomLine.hidden = NO;
        self.navigationItem.title = @"";
    }
}

-(void)clickRightItem {
    KKDatePickerView *pickerView = [[KKDatePickerView alloc]initWithFrame:self.view.bounds];
    pickerView.delegate = self;
    [pickerView show];
}

/**创建订单状态按钮*/
-(void)createTopButton{
    _bankView = [[UIView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, 55)];
    [_bankView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:_bankView];
    
    _statusBtnArr = [NSMutableArray array];
    NSArray *imageArr = @[@"allorder", @"waittopay", @"waittodelivery", @"waittotake", @"orderservice"];
    for (NSInteger i = 0; i < imageArr.count; i++) {
        UIButton *btn = [self createOrderButtonWithTag:90+i andAction:@selector(clickOrderButton:) andNomalImage:[UIImage imageNamed:imageArr[i]]];
        [_bankView addSubview:btn];
        [_statusBtnArr addObject:btn];
    }
    
    _allOrderButton.selected = YES;
    
    CGFloat statusBtnW = SCREEN_WIDTH/5;
    if(![_tgidString isEqualToString:@"0"]){
        statusBtnW = SCREEN_WIDTH/5;
        _afterSalesButton.hidden = NO;
    }else{
        if([_buyertype isEqualToString:@"WXUSER"]){
            statusBtnW = SCREEN_WIDTH/5;
            _afterSalesButton.hidden = NO;
        }else{
            statusBtnW = SCREEN_WIDTH/4;
            _afterSalesButton.hidden = YES;
        }
    }
    
    [self makeStatusConstraints:statusBtnW];

    _statusLine = [[UILabel alloc] init];
    [_bankView addSubview:_statusLine];
    _statusLine.backgroundColor = [UIColor tt_redMoneyColor];
    _statusLine.clipsToBounds = YES;
    [_statusLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1.5);
        make.left.mas_offset(10);
        make.width.mas_equalTo(statusBtnW-20);
        make.bottom.mas_offset(0);
    }];
}

-(void)makeStatusConstraints:(CGFloat)btnW {
    //全部 订单按钮
    [_allOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(2);
        make.height.mas_offset(50);
        make.left.mas_offset(0);
        make.width.mas_offset(btnW);
    }];
    //代付款 按钮
    [_waitPayMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(_allOrderButton);
        make.left.equalTo(_allOrderButton.mas_right);
    }];
    //待发货按钮
    [_waitDispatchGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(_allOrderButton);
        make.left.equalTo(_waitPayMoneyButton.mas_right);
    }];
    //待收货按钮
    [_waitConsigneeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(_allOrderButton);
        make.left.equalTo(_waitDispatchGoodsButton.mas_right);
    }];
    //售后  退货
    [_afterSalesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(_allOrderButton);
        make.left.equalTo(_waitConsigneeButton.mas_right);
    }];
}

#pragma mark-创建tableView
-(void)createTableView{
    
    _orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55+65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-114-55- BOTTOM_BAR_HEIGHT-NaviAddHeight) style:UITableViewStyleGrouped];
    
    _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_orderTableView];
    self.orderTableView.rowHeight = UITableViewAutomaticDimension;
    self.orderTableView.estimatedRowHeight = 44;
    if (@available(iOS 11.0, *)) {
        self.orderTableView.estimatedSectionFooterHeight = 0.001;
        self.orderTableView.estimatedSectionHeaderHeight = 0.001;
    }
    _orderTableView.backgroundColor = [UIColor tt_grayBgColor];
    
    [_orderTableView registerClass:[OrderMessageTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [_orderTableView registerClass:[WxuserOrderTableViewCell class] forCellReuseIdentifier:wxuserIdentifier];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.pagingEnabled = false;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    _orderTableView.tableHeaderView = headerView;
}

-(void)clickNavButton:(UIButton *)button{
    
    if (![_oidString isEqualToString:@"0"]) {
        _oidString = @"0";
    }
    
    switch (button.tag - 20000) {//搜索
        case 0:
        {
            OrderSearchViewController *orderSearch = [[OrderSearchViewController alloc] init];
            orderSearch.statusString = _statuString;
            orderSearch.buyertype = _buyertype;
            [self.navigationController pushViewController:orderSearch animated:NO];
        }
            break;
        case 1:  //我的订单
        {
            _buyertype = @"CK";
            [self lineWidthWith:SCREEN_WIDTH/4];
            _isDownloadMore = @"1";
            [self orderSelected:YES type:@"MyOrder"];
            
            //检查网络，如果有没有就加载缓存，如果有就先显示缓存然后请求数据
            [self loadCacheThenLoadOrderData];
            
            [self navbuttonAnnamationWithLeftx: 35+5];
        }
            break;
        case 2:  //消费者订单
        {
            _buyertype = @"WXUSER";
            [self lineWidthWith:SCREEN_WIDTH/5];
            _isDownloadMore = @"1";
            [self orderSelected:NO type:@"SalesOrder"];
            
            [self loadCacheThenLoadOrderData];
            
            [self navbuttonAnnamationWithLeftx:35+5+20+WIDTH];
        }
            break;
            
        default:
            break;
    }
}

//检查网络，如果有没有就加载缓存，如果有就先显示缓存然后请求数据
-(void)loadCacheThenLoadOrderData {
    
    if ([_buyertype isEqualToString:@"CK"] && [_statuString isEqualToString:@"4,5"]){
        _statuString = @"7";
    }
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    if (status == -1 || status == 0) {
        [self loadDBData:_statuString];
    }else{
        [self loadDBData:_statuString];
        [self loadMyOrderData];
    }
}

-(void)navbuttonAnnamationWithLeftx:(float)leftx{
    [UIView animateWithDuration:0.25 animations:^{
        _bottomLine.frame = CGRectMake(leftx, 44, WIDTH, 1.5);
    }];
}

#pragma mark-底边线左边距离计算
-(void)lineWidthWith:(float)buttonW {
    if ([_statuString isEqualToString:@"99"]) {
        _leftPadding = 10;
    }else if([_statuString isEqualToString:@"1"]){
        _leftPadding = buttonW+10;
    }else if([_statuString isEqualToString:@"2"]){
        _leftPadding = buttonW*2+10;

    }else if([_statuString isEqualToString:@"7"]){
        _leftPadding = buttonW*3+10;

    }else if([_statuString isEqualToString:@"4,5"]){
        if ([_buyertype isEqualToString:@"CK"]) {
            _leftPadding = buttonW*3+10;
        }else if ([_buyertype isEqualToString:@"WXUSER"]){
            _leftPadding = buttonW*4+10;
        }
    }
    [_allOrderButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(buttonW);
    }];

    [_statusLine mas_updateConstraints:^(MASConstraintMaker *make){
        make.width.mas_offset(buttonW-20);
        make.left.mas_offset(_leftPadding);
    }];
}

#pragma mark - 筛选代理方法
- (void)pickView:(NSString *)yes month:(NSString *)moth{
    _yearStr = yes;
    _monthStr = moth;
    [self loadMyOrderData];
}

- (void)allowClickNaivBtn {
    if ([_buyertype isEqualToString:@"CK"]) {
        _myOrderButton.userInteractionEnabled = NO;
        _salesOrderButton.userInteractionEnabled = YES;
    }else{
        _myOrderButton.userInteractionEnabled = YES;
        _salesOrderButton.userInteractionEnabled = NO;
    }
}

#pragma mark-请求订单列表数据
- (void)loadMyOrderData {
    
    _myOrderButton.userInteractionEnabled = NO;
    _salesOrderButton.userInteractionEnabled = NO;
    
    NSString *orderListUrl = [self generateRequestUrl];
    
    NSDictionary *paramDic = [self generateRequestParams];
    //    NSDictionary *paramDic = @{@"buyertype":@"CK", @"ckid":@"58935", @"oid":@"0", @"orderstatus":@"99", @"pagesize":@"20", @"tgid":@"0", @"deviceid":@"4363908A-F946-4515-9920-8FD37DD9BAC0"};
    _nodataLableView.hidden = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    
    [HttpTool postWithUrl:orderListUrl params:paramDic success:^(id json) {
        NSDictionary *listDic = json;
        NSString *code = [NSString stringWithFormat:@"%@",listDic[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:listDic[@"codeinfo"]];
            [self.orderTableView.mj_header endRefreshing];
            //请求结束后可以让点击
            [self allowClickNaivBtn];
            
            [self.viewDataLoading stopAnimation];
            return ;
        }
        
        NSArray *listArr = listDic[@"list"];
        if (self.orderTableView.mj_footer.state == MJRefreshStateNoMoreData) {
            [self.orderTableView.mj_footer endRefreshing];
        }
        
        for (NSDictionary *listOrderDic in listArr) {
            OrderModel *orderModel = [[OrderModel alloc] init];
            [orderModel setValuesForKeysWithDictionary:listOrderDic];
            orderModel.favormoney = [NSString stringWithFormat:@"%@", listOrderDic[@"favormoney"]];
            orderModel.money = [NSString stringWithFormat:@"%@", listOrderDic[@"money"]];
            orderModel.ckid = _ckidString;
            orderModel.buyerType = _buyertype;
            NSArray *ordersheetArr = listOrderDic[@"ordersheet"];
            if (ordersheetArr.count > 0) {
                for (NSInteger i = 0; i<ordersheetArr.count; i++) {
                    Ordersheet *orderSheet = [[Ordersheet alloc] init];
                    NSDictionary *dic = ordersheetArr[i];
                    [orderSheet setValuesForKeysWithDictionary:dic];
                    orderSheet.sheetKey = [NSString stringWithFormat:@"%@_%@_%ld",orderSheet.oid, orderSheet.itemid, i];
                    [orderModel.orderArray addObject:orderSheet];
                }
            }
            
            [self.orderMessageArray addObject:orderModel];
        }
        
        RLMResults *orderArr = [self getDBData];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObjects:orderArr];
        [realm commitWriteTransaction];
        
        for (OrderModel *orderM in self.orderMessageArray) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [OrderModel createOrUpdateInRealm:realm withValue:orderM];
            [realm commitWriteTransaction];
        }
        
        [self loadDBData:_statuString];
        
        //请求结束后可以让点击
        [self allowClickNaivBtn];
        
        [self.viewDataLoading stopAnimation];
        
    } failure:^(NSError *error) {
        [self.orderTableView.mj_header endRefreshing];
        [self.orderTableView.mj_footer endRefreshing];
        
        //请求结束后可以让点击
        [self allowClickNaivBtn];
        
        [self.viewDataLoading stopAnimation];
        
        if(self.orderMessageArray.count == 0){
            _nodataLableView.hidden = NO;
            [self.orderTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.orderMessageArray.count];
        }
    }];
}

#pragma mark - 绑定数据
-(void)loadDBData:(NSString*)statusStr {
    
    [self.orderMessageArray removeAllObjects];
    
    RLMResults *orderArr = [self getDBData];
    if (orderArr.count > 0) {
        for (OrderModel *orderM in orderArr) {
            [self.orderMessageArray addObject:orderM];
        }
        OrderModel *orderModel = orderArr.lastObject;
        _oidString = [NSString stringWithFormat:@"%@", orderModel.oid];
    }else{
        _nodataLableView.hidden = NO;
        [self.orderTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.orderMessageArray.count];
    }
    
    [self.orderTableView.mj_header endRefreshing];
    [self.orderTableView.mj_footer endRefreshing];
    [self.orderTableView reloadData];
}

-(RLMResults *)getDBData {
    
    NSString *predicate = @"";
    if ([_statuString isEqualToString:@"99"]) {
        if (!IsNilOrNull(_yearStr) && !IsNilOrNull(_monthStr)) {
            predicate = [NSString stringWithFormat:@"ckid = '%@' AND buyerType = '%@' AND time BEGINSWITH '%@-%@'", _ckidString, _buyertype, _yearStr, _monthStr];
        }else{
            predicate = [NSString stringWithFormat:@"ckid = '%@' AND buyerType = '%@'", _ckidString, _buyertype];
        }
    }else{
        if (!IsNilOrNull(_yearStr) && !IsNilOrNull(_monthStr)){
            if ([_statuString isEqualToString:@"4,5"]) {
                predicate = [NSString stringWithFormat:@"ckid = '%@' AND buyerType = '%@' AND (orderstatus = '4' OR orderstatus = '5') AND time BEGINSWITH '%@-%@'", _ckidString, _buyertype, _yearStr, _monthStr];
            }else{
                predicate = [NSString stringWithFormat:@"ckid = '%@' AND buyerType = '%@' AND orderstatus = '%@' AND time BEGINSWITH '%@-%@'", _ckidString, _buyertype, _statuString, _yearStr, _monthStr];
            }
        }else{
            if ([_statuString isEqualToString:@"4,5"]) {
                predicate = [NSString stringWithFormat:@"ckid = '%@' AND buyerType = '%@' AND (orderstatus = '4' OR orderstatus = '5')", _ckidString, _buyertype];
            }else{
                predicate = [NSString stringWithFormat:@"ckid = '%@' AND buyerType = '%@' AND orderstatus = '%@'", _ckidString, _buyertype, _statuString];
            }
        }
    }
    RLMResults *results = [[CacheData shareInstance] search:[OrderModel class] predicate:predicate sorted:@"time" ascending:NO];
    return results;
}

-(NSString*)generateRequestUrl {
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if(!IsNilOrNull(homeLoginStatus)){
        NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getMyOrders_Url];
        return requestUrl;
    }else{
        NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Regist/getOrders"];
        return requestUrl;
    }
}

-(NSDictionary*)generateRequestParams {
    
    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    //    下单类型（CK：创客自提订单  WXUSER：商城订单）
    //    订单状态（99：全部0：已取消 1：未付款；2：已付款；4：正在退货，5：退货成功，6：已完成，7：已发货 ）
    _statuString = IsNilOrNull(_statuString) ? @"99" : _statuString;
    _oidString = IsNilOrNull(_oidString) ? @"0" : _oidString;
    _buyertype = IsNilOrNull(_buyertype) ? @"WXUSER" : _buyertype;
    _yearStr = IsNilOrNull(_yearStr) ? @"" : _yearStr;
    _monthStr = IsNilOrNull(_monthStr) ? @"" : _monthStr;
    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
    
    if ([_buyertype isEqualToString:@"CK"] && [_statuString isEqualToString:@"4,5"]){
        _statuString = @"7";
    }
    
    if (![_isDownloadMore isEqualToString:@"2"]) {
        _oidString = @"0";
    }
    //flag 0:查询推广人订单，1:查询推广人资金
    //tgid 0:普通创客，1:推广人登录
    NSString *tgStr = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    _tgidString = IsNilOrNull(tgStr) ? @"0" : tgStr;
    if (![_tgidString isEqualToString:@"0"]){//推广员登录 只能查看消费者订单
        _flagStr = @"0";
        _buyertype = @"WXUSER";
    }else{
        _flagStr = @"";
    }
    
    
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if(!IsNilOrNull(homeLoginStatus)){
        NSDictionary *parmaDic = @{@"ckid":_ckidString
                                   ,@"pagesize":@"20",@"tgid":_tgidString,@"oid":_oidString,@"orderstatus":_statuString,@"buyertype":_buyertype,@"keywords":@"",@"year":_yearStr,@"month":_monthStr,@"flag":_flagStr,DeviceId:uuid};
        return parmaDic;
    }else{
        NSString *unionid = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:Kunionid]];
        NSDictionary *parmaDic = @{@"unionid":unionid
                                   ,@"pagesize":@"20",@"tgid":_tgidString,@"oid":_oidString,@"orderstatus":_statuString,@"buyertype":_buyertype,@"keywords":@"",@"year":_yearStr,@"month":_monthStr,@"flag":_flagStr,DeviceId:uuid};
        return parmaDic;
    }
}

#pragma mark - 上拉加载更多列表数据
- (void)loadMoreData {
    
    _myOrderButton.userInteractionEnabled = NO;
    _salesOrderButton.userInteractionEnabled = NO;
    
    NSString *orderListUrl = [self generateRequestUrl];
    NSDictionary *pramaDic = [self generateRequestParams];
    
    _nodataLableView.hidden = YES;
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:orderListUrl params:pramaDic success:^(id json) {
        
        NSDictionary *listDic = json;
        NSString *code = [NSString stringWithFormat:@"%@",listDic[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:listDic[@"codeinfo"]];
            [self.orderTableView.mj_footer endRefreshing];
            
            //请求结束后可以让点击
            [self allowClickNaivBtn];
            
            [self.viewDataLoading stopAnimation];
            return ;
        }
        
        NSArray *listArr = listDic[@"list"];
        if (listArr.count == 0) {
            [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
            if (self.orderMessageArray.count == 0) {
                _nodataLableView.hidden = NO;
                [self.orderTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.orderMessageArray.count];
            }
        }else{
            for (NSDictionary *listOrderDic in listArr) {
                OrderModel *orderModel = [[OrderModel alloc] init];
                [orderModel setValuesForKeysWithDictionary:listOrderDic];
                orderModel.favormoney = [NSString stringWithFormat:@"%@", listOrderDic[@"favormoney"]];
                orderModel.money = [NSString stringWithFormat:@"%@", listOrderDic[@"money"]];
                orderModel.ckid = _ckidString;
                orderModel.buyerType = _buyertype;
                NSArray *ordersheetArr = listOrderDic[@"ordersheet"];
                if (ordersheetArr.count > 0) {
                    for (NSInteger i = 0; i<ordersheetArr.count; i++) {
                        Ordersheet *orderSheet = [[Ordersheet alloc] init];
                        NSDictionary *dic = ordersheetArr[i];
                        [orderSheet setValuesForKeysWithDictionary:dic];
                        orderSheet.sheetKey = [NSString stringWithFormat:@"%@_%@_%ld",orderSheet.oid, orderSheet.itemid, i];
                        [orderModel.orderArray addObject:orderSheet];
                    }
                }
                
                [self.orderMessageArray addObject:orderModel];
            }
            
            OrderModel *orderModel = self.orderMessageArray.lastObject;
            _oidString = [NSString stringWithFormat:@"%@", orderModel.oid];
            [self.orderTableView.mj_header endRefreshing];
            [self.orderTableView.mj_footer endRefreshing];
            [self.orderTableView reloadData];
            
        }
        
        //请求结束后可以让点击
        [self allowClickNaivBtn];
        
        [self.viewDataLoading stopAnimation];
    } failure:^(NSError *error) {
        [self.orderTableView.mj_footer endRefreshing];
        
        //请求结束后可以让点击
        [self allowClickNaivBtn];
        
        [self.viewDataLoading stopAnimation];
    }];
}



#pragma mark-点击全部 待付款 待发货  待收货  售后/退货
-(void)clickOrderButton:(UIButton *)button{
    
    //点击的时候清空
    if (![_oidString isEqualToString:@"0"]) {
        _oidString = @"0";
    }
    _isDownloadMore = @"";
    _yearStr = @"";
    _monthStr = @"";
    
    [self updateBtnSelectedState:button];
    //移动订单状态底部红线
    [self statusLineMoveWithX:button.frame.origin.x];
    
    [self loadCacheThenLoadOrderData];
}

-(void)updateBtnSelectedState:(UIButton*)button {
    for (NSInteger i = 0; i < _statusBtnArr.count; i++) {
        UIButton *btn = _statusBtnArr[i];
        btn.selected = NO;
        btn.userInteractionEnabled = YES;
    }
    
    _statuString = _statusArr[button.tag - 90];
    button.selected = YES;
    if (button.tag == 94) {
        [button setUserInteractionEnabled:YES];
    }else{
        [button setUserInteractionEnabled:NO];
    }
}

-(void)statusLineMoveWithX:(float)lablex{
    [_statusLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(lablex+10);
    }];
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderMessageArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([_buyertype isEqualToString:@"CK"]){
        _orderModel = self.orderMessageArray[section];
        return _orderModel.orderArray.count;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([_buyertype isEqualToString:@"CK"]){
        OrderMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if ([self.orderMessageArray count]){
            _orderModel = self.orderMessageArray[indexPath.section];
            if(self.orderModel.orderArray.count > 0){
                _orderDetailModel = self.orderModel.orderArray[indexPath.row];
                [cell refreshWithModel:_orderDetailModel];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        WxuserOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:wxuserIdentifier];
        if ([self.orderMessageArray count]){
            self.orderModel = self.orderMessageArray[indexPath.section];
            [cell refreshWithModel:self.orderModel];
        }
        cell.backgroundColor = [UIColor tt_grayBgColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - tableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if([_buyertype isEqualToString:@"CK"]){
        return 40;
    }else{
        return 0.0001;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [headerView setBackgroundColor:[UIColor whiteColor]];

    _orderNumberLable = [UILabel configureLabelWithTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [headerView addSubview:_orderNumberLable];
    _orderNumberLable.text = @"订单编号：";
    [_orderNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(AdaptedWidth(10));
        make.width.mas_offset(SCREEN_WIDTH*2/3);
        make.bottom.mas_offset(-10);
    }];


    _orderStateLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(15)];
    [headerView addSubview:_orderStateLable];
    [_orderStateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_orderNumberLable);
        make.right.mas_offset(-20);
    }];

    if ([self.orderMessageArray count]) {
        _orderModel = self.orderMessageArray[section];
        [self refreshWithStatusLableWithorderModel:_orderModel];
    }
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self.orderMessageArray count]) {
        _orderModel = self.orderMessageArray[section];
    }
    
    NSString *statustr = [NSString stringWithFormat:@"%@",_orderModel.orderstatus];
    
    NSLog(@"选中状态段尾%@",_buyertype);
    if ([_buyertype isEqualToString:@"CK"]){
        if ([statustr isEqualToString:@"0"] || [statustr isEqualToString:@"2"]){
            _wxUserView = [[WxuserView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,AdaptedHeight(55)) andTypeStr:_buyertype];
        }else{
            _footerView = [[orderFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,AdaptedHeight(110)) andType:statustr andTypeStr:_buyertype];
            _footerView.rightButton.tag = 170+section;
        }
    }else{
        _wxUserView = [[WxuserView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,AdaptedHeight(40)) andTypeStr:_buyertype];
    }
    [_footerView.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self refreshFooterData:_orderModel];
    
    if ([_buyertype isEqualToString:@"CK"]){
        if ([statustr isEqualToString:@"0"] || [statustr isEqualToString:@"2"]) {
            return _wxUserView;
        }else{
            return _footerView;
        }
    }else{
        return _wxUserView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if ([self.orderMessageArray count]) {
        _orderModel = self.orderMessageArray[section];
    }
    NSString *statustr = [NSString stringWithFormat:@"%@",_orderModel.orderstatus];
    if ([_buyertype isEqualToString:@"CK"]){
        if([statustr isEqualToString:@"0"] || [statustr isEqualToString:@"2"]){
            return  AdaptedHeight(55);
        }else{
            return  AdaptedHeight(110);
        }
    }else{
        return  AdaptedHeight(40);
    }
}

/**点击进入详情*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    RLMResults *orderArr = [self getDBData];
//    if (orderArr.count > 0) {
//        _orderModel = orderArr[indexPath.section];
//        _orderDetailModel = _orderModel.orderArray[indexPath.row];
//    }else{
//        return;
//    }
    
    if (self.orderMessageArray.count >indexPath.section) {
        _orderModel = self.orderMessageArray[indexPath.section];
        _orderDetailModel = _orderModel.orderArray[indexPath.row];
    }else{
        return;
    }
    
    CKOrderDetailViewController *checkOrder = [[CKOrderDetailViewController alloc] init];
    checkOrder.orderModel = _orderModel;
    checkOrder.dataArray = _orderModel.orderArray;
    checkOrder.orderstatusString = _orderModel.orderstatus;
    checkOrder.typeString = _buyertype;
    [self.navigationController pushViewController:checkOrder animated:YES];
}

/**刷新段头上订单状态*/
-(void)refreshWithStatusLableWithorderModel:(OrderModel *)ordeModel{
    //    订单状态（99：全部0：已取消 1：未付款；2：已付款，3：已收货；4：正在退货，5：退货成功，6：已完成，7：已发货 ） 3456有删除按钮
    _orderNumberLable.text = [NSString stringWithFormat:@"订单编号：%@",ordeModel.no];
    
    if([ordeModel.orderstatus isEqualToString:@"0"]){//已取消
        _orderStateLable.text = @"已取消";
    }else if ([ordeModel.orderstatus isEqualToString:@"1"]) {//未付款
        _orderStateLable.text = @"待付款";
    }else if([ordeModel.orderstatus isEqualToString:@"2"]){//待发货
        _orderStateLable.text = @"待发货";
    }else if([ordeModel.orderstatus isEqualToString:@"3"]){//已收货
        _orderStateLable.text = @"已收货";
    }else if ([ordeModel.orderstatus isEqualToString:@"4"]||[ordeModel.orderstatus isEqualToString:@"5"]){//正在退货  和  退货成功
        if([ordeModel.orderstatus isEqualToString:@"4"]){
            _orderStateLable.text = @"正在退货";
        }else{
            _orderStateLable.text = @"退货成功";
        }
    }else if ([ordeModel.orderstatus isEqualToString:@"6"]){//已完成
        _orderStateLable.text = @"已完成";
    }else if ([ordeModel.orderstatus isEqualToString:@"7"]){//已发货
        _orderStateLable.text = @"已发货";
    }
}

-(void)refreshFooterData:(OrderModel *)orderModel {
    NSString *allMoney = [NSString stringWithFormat:@"%@", orderModel.ordermoney];
    
    NSString *timeStr = [NSString stringWithFormat:@"%@", orderModel.time];
    if (IsNilOrNull(timeStr)){
        timeStr = @"下单时间:";
    }
    double moneyfloat = [allMoney doubleValue];
    NSString *status = [NSString stringWithFormat:@"%@",orderModel.orderstatus];
    if (IsNilOrNull(status)){
        status = @"";
    }
    
    NSLog(@"footer赋值%@",_buyertype);
    if ([_buyertype isEqualToString:@"WXUSER"]){
        //微信用户除了7的状态下
        _wxUserView.orderTimeLable.text = [NSString stringWithFormat:@"下单时间:%@",timeStr];
    }else{
        if ([status isEqualToString:@"0"] || [status isEqualToString:@"2"]) {
            _wxUserView.priceLable.text = [NSString stringWithFormat:@"合计：¥%.2f(含运费¥%@)",moneyfloat,@"0.00"];
            _wxUserView.orderTimeLable.text = [NSString stringWithFormat:@"下单时间:%@",timeStr];
        }else{
            _footerView.priceLable.text = [NSString stringWithFormat:@"合计：¥%.2f(含运费¥%@)",moneyfloat,@"0.00"];
            _footerView.orderTimeLable.text = [NSString stringWithFormat:@"下单时间:%@",timeStr];
            
        }
    }
}

#pragma mark-查看物流  去支付
-(void)clickRightButton:(UIButton *)button{
    NSInteger index = button.tag - 170;
    
//    RLMResults *orderArr = [self getDBData];
//    if (orderArr.count > 0) {
//        _orderModel = orderArr[index];
//    }else{
//        return;
//    }
    
    if ([self.orderMessageArray count]) {
        _orderModel = self.orderMessageArray[index];
    }else{
        return;
    }

    NSString *status = [NSString stringWithFormat:@"%@",_orderModel.orderstatus];
    
    NSString *no = [NSString stringWithFormat:@"%@", _orderModel.no];

    NSLog(@"当前选择的状态%@*********",status);
    if ([status isEqualToString:@"1"]) { //未付款
        //成功之后  生成 总金额 和订单 去支付
        NSString *payfeeStr = [NSString stringWithFormat:@"%@",_orderModel.money];
        NSString *oidStr = [NSString stringWithFormat:@"%@",_orderModel.oid];
        if (IsNilOrNull(payfeeStr)) {
            payfeeStr = @"";
        }
        if (IsNilOrNull(oidStr)) {
            oidStr = @"";
        }
        
        if ([no containsString:@"dlb"]) {
            CKPayViewController *payMoney = [[CKPayViewController alloc] init];
            payMoney.payfee = payfeeStr;
            payMoney.orderId = oidStr;
            payMoney.ckid = self.ckidString;
            payMoney.fromVC = @"CKOrderList";
            [self.navigationController pushViewController:payMoney animated:YES];
        }else{
            PayMoneyViewController *payMoney = [[PayMoneyViewController alloc] init];
            payMoney.payfeeStr = payfeeStr;
            payMoney.oidStr = oidStr;
            payMoney.type = @"ziti";
            [self presentViewController:[[RootNavigationController alloc] initWithRootViewController:payMoney] animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }else if ([status isEqualToString:@"7"]){  //已发货查看物流
        NSString *oidString = [NSString stringWithFormat:@"%@",_orderModel.oid];
        //点击进入物流详情
        DetailLogisticsViewController *detailLogist = [[DetailLogisticsViewController alloc] init];
        detailLogist.oidString = oidString;
        [self.navigationController pushViewController:detailLogist animated:YES];
    }else{
        //只有我的订单显示 删除订单
        [self deleteMyorderByModel:_orderModel andIndex:index];
    }
}

#pragma mark-删除订单
-(void)deleteMyorderByModel:(OrderModel *)orderModel andIndex:(NSInteger)index{
    
    [MessageAlert shareInstance].isDealInBlock = YES;
    [[MessageAlert shareInstance] hiddenCancelBtn:NO];
    [[MessageAlert shareInstance] showCommonAlert:@"确定要删除该订单？" btnClick:^{
        
        NSString *deleteStr = [NSString stringWithFormat:@"%@",orderModel.oid];
        if (IsNilOrNull(deleteStr)){
            deleteStr = @"";
        }
        NSString *uuid = DeviceId_UUID_Value;
        if (IsNilOrNull(uuid)){
            uuid = @"";
        }
        NSDictionary * pramaDic = @{@"ckid":_ckidString, @"orderid":deleteStr, DeviceId:uuid};
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
        if(!IsNilOrNull(homeLoginStatus)){
            [params setValue:_ckidString forKey:@"ckid"];
            [params setValue:deleteStr forKey:@"orderid"];
            [params setValue:uuid forKey:DeviceId];
        }else{
            [params setValue:deleteStr forKey:@"orderid"];
            [params setValue:uuid forKey:DeviceId];
        }
        
        NSString *deleteUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI, deleteOrder_Url];
        [HttpTool postWithUrl:deleteUrl params:pramaDic success:^(id json) {
            //删除成功之后删除数组数据
            NSDictionary *dict = json;
            if ([dict[@"code"] integerValue] != 200) {
                [self showNoticeView:dict[@"codeinfo"]];
                return ;
            }
            
            if ([self.orderMessageArray count]) {
                [self.orderMessageArray removeObjectAtIndex:index];
                [self.orderTableView reloadData];
            }
        } failure:^(NSError *error) {
            if (error.code == -1009) {
                [self showNoticeView:NetWorkNotReachable];
            }else{
                [self showNoticeView:NetWorkTimeout];
            }
        }];
        
    }];
    
}

#pragma mark-删除的代理方法
-(void)subuttonClicked{
    
}


/**创建 统一 button*/
-(UIButton *)createOrderButtonWithTag:(NSInteger)tag andAction:(SEL)action andNomalImage:(UIImage *)nomalImage{
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:nomalImage forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    button.tag = tag;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    switch (tag-90) {
        case 0:
            _allOrderButton = button;
            break;
        case 1:
            _waitPayMoneyButton = button;
            break;
        case 2:
            _waitDispatchGoodsButton = button;
            break;
        case 3:
            _waitConsigneeButton = button;
            break;
        case 4:
            _afterSalesButton = button;
            break;
            
        default:
            break;
    }
    return button;
}

-(UIButton *)createButtonWithframe:(CGRect)frame andTag:(NSInteger)tag andAction:(SEL)action andTitle:(NSString *)title andImageName:(NSString*)imageName anselected:(BOOL)selected{
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.adjustsImageWhenHighlighted = NO;
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:SubTitleColor forState:UIControlStateNormal];
        [button setTitleColor:TitleColor forState:UIControlStateSelected];
    }
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    button.tag = tag;
    button.selected = selected;
    if(selected){
        button.titleLabel.font = CHINESE_SYSTEM(AdaptedHeight(17));
    }else{
        button.titleLabel.font = MAIN_TITLE_FONT;
    }
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - 网络切换后提示view的位置更改
-(void)defaultTableViewFrame {
    self.netTip.frame = CGRectMake(0, 20, SCREEN_WIDTH, 64);
    _bankView.frame = CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, 55);
    _orderTableView.frame = CGRectMake(0, 55+65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-114-55- BOTTOM_BAR_HEIGHT-NaviAddHeight);
}

-(void)changeTableViewFrame {
    self.netTip.frame = CGRectMake(0, 20+44+NaviAddHeight, SCREEN_WIDTH, 44);
    _bankView.frame = CGRectMake(0, 65+44+NaviAddHeight, SCREEN_WIDTH, 55);
    _orderTableView.frame = CGRectMake(0, 55+65+44+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-114-55- BOTTOM_BAR_HEIGHT-NaviAddHeight);
}

-(void)getOrderDataWithoutCache {
    RLMResults *orderArr = [self getDBData];
    if (orderArr.count == 0) {
        [self loadMyOrderData];
    }
}

-(void)dealloc {
    [CKCNotificationCenter removeObserver:self name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter removeObserver:self name:@"NoNetNotification" object:nil];
}

@end
