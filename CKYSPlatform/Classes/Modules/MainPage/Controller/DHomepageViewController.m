
//  DHomepageViewController.m
//  CKYSPlatform
//
//  Created by ckys on 16/6/28.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "DHomepageViewController.h"
#import "CKCTheHeadlinesController.h" //创客村头条
#import "MinePersonalInfomationViewController.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import "CKCloudBeanViewController.h" //我的云豆
#import "TGFundMnageViewController.h"
#import "TodaySalesViewController.h"
#import "MyHonourViewController.h"
#import "CKSelfPickUpViewController.h" //自提
#import "BarCodeAlterVeiw.h"
#import "OfflineShopViewController.h"
#import "SourceMaterialViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <ShareSDK/ShareSDK.h> /**分享*/
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "CKMainPageCommon.h"
#import "MediaReportsController.h"
#import "CKMineCommon.h"
#import "CKShowCacheViewController.h"
#import "CKChooseJoinGoodsVC.h" //购买创客分销礼包
#import "CKConfirmRegisterOrderVC.h"

#import "CKdlbGoodsModel.h"
#import "CKOrderinfoModel.h"
#import "CKPayViewController.h"
#import "AddressModel.h"
#import "XWAlterVeiw.h"
#import "WebDetailViewController.h"
#import "FFTipAlertView.h"
#import "CKRealnameIdentifyView.h"
#import "CKConfrimRegistMsgViewController.h"
#import "CKConfrimSharePersonViewController.h"

@interface DHomepageViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, BarCodeAlterVeiwDelegate, OpenShopDelegate, CKMainModuleDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIView *bankHeaderView;
@property (nonatomic, copy)   NSString *tgidstring;
@property (nonatomic, copy)   NSString *typeStr;
@property (nonatomic, copy)   NSString *statusString;
@property (nonatomic, copy)   NSString *checkStatus;
@property (nonatomic, copy)   NSString *qrcodeurl;
@property (nonatomic, strong) BarCodeAlterVeiw *qrcodeView;
@property (nonatomic, copy)   NSString *ckidstr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIViewController *topViewController;
@property (nonatomic, strong) NSMutableArray<SectionModel*> *dataArray;
@property (nonatomic, assign) NSTimeInterval startInterval;
@property (nonatomic, assign) NSTimeInterval endInterval;


@end

@implementation DHomepageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;
    
    if (!IPHONE_X) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self setStatusBarBackgroundColor:[UIColor blackColor]];
    }
    
    //登录成功（密码验证码）注册成功（永久，无风险，分销）分销升级创客 (刷新页面)
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if ([homeLoginStatus isEqualToString:@"homelogin"]) {
        [self loginSuccess:YES];
    }else{
        [self loginSuccess:NO];
    }
    
    //检查店铺状态
    [self checkShopStatus];
    
    
}


//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (!IPHONE_X) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self setStatusBarBackgroundColor:[UIColor clearColor]];
    }
}


//设置状态栏颜色
-(void)setStatusBarBackgroundColor:(UIColor *)color {
    //ios11
//    UIApplication *application = [UIApplication sharedApplication];
//    UIView *statusBar = [application valueForKeyPath:@"_statusBar"];
//    if ([statusBar isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
//        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//            statusBar.backgroundColor = color;
//        }
//    }
    //ios11之前
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeComponent];
    [self refreshData];
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 50, 50)];
//    btn.backgroundColor = [UIColor redColor];
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(testFunc) forControlEvents:UIControlEventTouchUpInside];
    
}

//- (void)testFunc {
//
//}

-(void)updateUI {
    
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if ([homeLoginStatus isEqualToString:@"homelogin"]) {
        [self loginSuccess:YES];
    }else{
        [self loginSuccess:NO];
    }
    
    [self checkShopStatus];
}

-(void)loginSuccess:(BOOL)isLogin {
    
    [self bindMainPageData];
    
    if ([self getMainPageData].count == 0) {
        [self requestData];
    }else{
        [self bindMainPageData];
    }
}

-(void)initializeComponent {
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
    self.startInterval = [nowDate timeIntervalSince1970];
    
    _ckidstr = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    _tgidstring = [KUserdefaults objectForKey:KSales];
    _tgidstring = IsNilOrNull(_tgidstring) ? @"0" : _tgidstring;

    //添加通知
    [CKCNotificationCenter addObserver:self selector:@selector(JumpToJoin) name:WeiXinAuthSuccess object:nil];
    //有网络时的frame
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    //无网络时的frame
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    //没有缓存时请求数据
    [CKCNotificationCenter addObserver:self selector:@selector(requestDataWithoutCache) name:@"RequestHomePageData" object:nil];
    //重新加载banner
    [CKCNotificationCenter addObserver:self selector:@selector(reloadBanner) name:DidReceiveBannerUpdatePushNoti object:nil];
    //注册完成后要刷新界面
    [CKCNotificationCenter addObserver:self selector:@selector(updateUI) name:@"UpdateUIToLoginSuccessNoti" object:nil];

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor tt_grayBgColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)){
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    
    _tableView.estimatedRowHeight = 0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.view.mas_top).offset(20+NaviAddHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49-BOTTOM_BAR_HEIGHT);
    }];
    
    RLMResults *result = [self getMainPageData];
    _dataArray = [NSMutableArray array];
    CKMainPageModel *mainM = result.firstObject;
    NSString *localType = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Ktype]];
    NSString *type = [NSString stringWithFormat:@"%@", mainM.type];
    _typeStr = IsNilOrNull(type) ? localType : type;
    
    NSString *statusStr = [NSString stringWithFormat:@"%@", mainM.status];
    _statusString = IsNilOrNull(statusStr) ? @"" : statusStr;
    
    //第一次启动时就加载缓存
    [self bindMainPageData];
    
    /*辅助测试缓存数据
        NSArray *arr = @[@"辅助测试数据", @"首页数据", @"商学院", @"消息", @"订单", @"域名和支付方式"];
    
        for (NSInteger i = 0; i< arr.count; i++) {
    
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 20 + i* 40, 100, 30)];
            btn.backgroundColor = [UIColor greenColor];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.tag = i + 20;
            [btn addTarget:self action:@selector(showCache:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
        }
     */
    
    
//    NSString *status = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KStatus]];
//    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
//    if ([homeLoginStatus isEqualToString:@"homelogin"] && [status isEqualToString:@"PAY"]) {
//        
//    }
}

#pragma mark - 查看缓存-辅助测试功能
-(void)showCache:(UIButton*)sender {
    CKShowCacheViewController *showCache = [[CKShowCacheViewController alloc] init];
    showCache.tag = sender.tag - 20;
    [self.navigationController pushViewController:showCache animated:YES];
}

#pragma mark - 设置刷新
-(void)refreshData {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_header beginRefreshing];
        
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
        strongSelf.endInterval = [nowDate timeIntervalSince1970];
        
        NSTimeInterval value = strongSelf.endInterval - strongSelf.startInterval;
        CGFloat second = [[NSString stringWithFormat:@"%.2f",value] floatValue];//秒
        NSLog(@"间隔------%f秒",second);
        strongSelf.startInterval = strongSelf.endInterval;
        
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                if (value >= Interval) {
                    [self requestData];
                }else{
                    [strongSelf.tableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView:NetWorkNotReachable];
                [strongSelf.tableView.mj_header endRefreshing];
            }
                break;
        }
    }];
}

#pragma mark - 请求参数字典
- (NSDictionary*)createRequestParams {
    _ckidstr = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *tgStr = [KUserdefaults objectForKey:KSales];
    _tgidstring = IsNilOrNull(tgStr) ? @"0" : tgStr;
    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if (![homeLoginStatus isEqualToString:@"homelogin"]) {
        return @{@"ckid":@"", DeviceId:uuid, @"tgid":_tgidstring};
    }else{
        if ([_ckidstr isEqualToString:@"-1"]) {
            return @{@"ckid":@"", DeviceId:uuid, @"tgid":_tgidstring};
        }else{
            return @{@"ckid":_ckidstr, DeviceId:uuid, @"tgid":_tgidstring};
        }
    }
}

#pragma mark - 请求首页数据——绑定数据
- (void)requestData {
    NSString *homeUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI, getMainData_Url];
    NSDictionary *pramaDic = [self createRequestParams];
    
    [HttpTool postWithUrl:homeUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        [self.tableView.mj_header endRefreshing];
        if ([dict[@"code"] integerValue] != 200) {
            return ;
        }
        
        NSDictionary *nonNullDict = [dict deleteAllNullValue];
        [self writeDataToDB:nonNullDict ckid:!IsNilOrNull(_ckidstr) ? _ckidstr : @"-1"];
        
        //类型 B/D 状态close pay
        _typeStr = [NSString stringWithFormat:@"%@", [dict objectForKey:@"type"]];
        if (IsNilOrNull(_typeStr)){
            _typeStr = @"";
        }
        [KUserdefaults setObject:_typeStr forKey:Ktype];
        
        _statusString = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
        if (IsNilOrNull(_statusString)){
            _statusString = @"";
        }
        [KUserdefaults setObject:_statusString forKey:KStatus];
        NSString *jointype = [NSString stringWithFormat:@"%@",[dict objectForKey:@"jointype"]];
        if (IsNilOrNull(jointype)) {
            jointype = @"";
        }
        [KUserdefaults setObject:jointype forKey:KjoinType];
        
        //0未考试 1考试未通过 2 通过 3 超期未通过（无礼包销售权）
        NSString *giftshare = [NSString stringWithFormat:@"%@", [dict objectForKey:@"giftshare"]];
        if (!IsNilOrNull(giftshare)) {
            [KUserdefaults setObject:giftshare forKey:@"giftshare"];
        }
        
        [self bindMainPageData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 将数据写入缓存
- (void)writeDataToDB:(NSDictionary*)dict ckid:(NSString*)ckid {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    NSArray *bannerArr = [dict objectForKey:@"banners"];
    NSArray *topnewsArr = [dict objectForKey:@"topnews"];
    NSArray *mediareportArr = [dict objectForKey:@"mediareport"];
    NSArray *top3ckheaderArr = [dict objectForKey:@"top3ckheaders"];
    NSArray *honorArr = [dict objectForKey:@"honor_list"];
    
    CKMainPageModel *mainM = [[CKMainPageModel alloc] init];
    //    [mainM setValuesForKeysWithDictionary:dict];
    //然而并不想这样写。。。暂时未找到优化的方法
    mainM.helpurl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"helpurl"]];
    mainM.moneytoday = [NSString stringWithFormat:@"%@", [dict objectForKey:@"moneytoday"]];
    mainM.status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
    
    mainM.moneytotal = [NSString stringWithFormat:@"%@", [dict objectForKey:@"moneytotal"]];
    mainM.headurl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"headurl"]];
    mainM.shopurl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"shopurl"]];
    //    mainM.honorArray = mainModel.honorArray;
    mainM.realname = [NSString stringWithFormat:@"%@", [dict objectForKey:@"realname"]];
    mainM.name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
    mainM.type = [NSString stringWithFormat:@"%@", [dict objectForKey:@"type"]];
    //    mainM.bannerArray = mainModel.bannerArray;
    mainM.ckTotal = [NSString stringWithFormat:@"%@", [dict objectForKey:@"ckTotal"]];
    //    mainM.top3ckheaderArray = mainModel.top3ckheaderArray;
    mainM.cknum = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cknum"]];
    mainM.fxTotal = [NSString stringWithFormat:@"%@", [dict objectForKey:@"fxTotal"]];
    //    mainM.topnewsArray = mainModel.topnewsArray;
    //    mainM.mediareportArray = mainModel.mediareportArray;
    mainM.ckcxyurl = [NSString stringWithFormat:@"%@", [dict objectForKey:@"ckcxyurl"]];
    mainM.jointype = [NSString stringWithFormat:@"%@", [dict objectForKey:@"jointype"]];
    mainM.ckid = ckid;
    
    if (bannerArr.count > 0) {
        for (NSDictionary *dic in bannerArr) {
            Banners *bannerM = [[Banners alloc] init];
            [bannerM setValuesForKeysWithDictionary:dic];
            [mainM.bannerArray addObject:bannerM];
        }
    }
    
    if (topnewsArr.count > 0) {
        for (NSDictionary *dic in topnewsArr) {
            Topnews *topnewsM = [[Topnews alloc] init];
            [topnewsM setValuesForKeysWithDictionary:dic];
            [mainM.topnewsArray addObject:topnewsM];
        }
    }
    
    if (mediareportArr.count > 0) {
        for (NSDictionary *dic in mediareportArr) {
            Mediareport *mediaM = [[Mediareport alloc] init];
            [mediaM setValuesForKeysWithDictionary:dic];
            [mainM.mediareportArray addObject:mediaM];
        }
    }
    
    if (top3ckheaderArr.count > 0) {
        for (NSDictionary *dic in top3ckheaderArr) {
            Top3ckheaders *topM = [[Top3ckheaders alloc] init];
            [topM setValuesForKeysWithDictionary:dic];
            [mainM.top3ckheaderArray addObject:topM];
        }
    }
    
    if (honorArr.count > 0) {
        for (NSDictionary *dic in honorArr) {
            Honor_list *honorM = [[Honor_list alloc] init];
            [honorM setValuesForKeysWithDictionary:dic];
            [mainM.honorArray addObject:honorM];
        }
    }
    
    [realm beginWriteTransaction];
    [CKMainPageModel createOrUpdateInRealm:realm withValue:mainM];
    [realm commitWriteTransaction];
}

#pragma mark - 获取缓存数据
-(RLMResults*)getMainPageData {
    NSString *ckidStr = IsNilOrNull(KCKidstring) ? @"-1" : KCKidstring;
    NSString *predicate = [NSString stringWithFormat:@"ckid = '%@'", ckidStr];
    RLMResults *result = [[CacheData shareInstance] search:[CKMainPageModel class] predicate:predicate];
    return result;
}

#pragma mark - 绑定首页数据
-(void)bindMainPageData {
    RLMResults *result = [self getMainPageData];
    _dataArray = [NSMutableArray array];
    CKMainPageModel *mainM = result.firstObject;
    
    //轮播
    CellModel *bannerModel = [self createCellModel:[CKBannerCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:mainM.bannerArray,@"data",@"1",@"type", nil] height:185*SCREEN_WIDTH/375.0f];
    SectionModel *section0 = [self createSectionModel:@[bannerModel] headerHeight:0.1 footerHeight:0.1];
    [self.dataArray addObject:section0];
    
    //特性模块
    CellModel *featureModel = [self createCellModel:[CKFeaturesCell class] userInfo:mainM height:80*SCREEN_WIDTH/375.0f];
    SectionModel *section1 = [self createSectionModel:@[featureModel] headerHeight:0.1 footerHeight:10];
    [self.dataArray addObject:section1];
    
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if (![homeLoginStatus isEqualToString:@"homelogin"]){//购买礼包
        CellModel *openShopModel = [self createCellModel:[CKOpenShopCell class] userInfo:mainM height:95*SCREEN_WIDTH/375.0f];
        openShopModel.delegate = self;
        SectionModel *section2 = [self createSectionModel:@[openShopModel] headerHeight:0.1 footerHeight:10];
        [self.dataArray addObject:section2];
    }else{//登录后的功能
        float height = 280;
        CellModel *mainModule = [self createCellModel:[CKMainModuleCell class] userInfo:mainM height:AdaptedWidth(height)];
        mainModule.delegate = self;
        SectionModel *section22 = [self createSectionModel:@[mainModule] headerHeight:0.1 footerHeight:10];
        [self.dataArray addObject:section22];
    }
    
    //创客村头条
    CellModel *newsTitle = [self createCellModel:[CKHeaderTitleCell class] userInfo:@{@"title": @"—— 创客村头条 ——", @"type": @"1"} height:40*SCREEN_WIDTH/375.0f];
    CellModel *newsModel = [self createCellModel:[CKTopNewsCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:mainM.topnewsArray, @"dataArray", @"1", @"type", nil] height:AdaptedWidth(145)];
    SectionModel *section3 = [self createSectionModel:@[newsTitle, newsModel] headerHeight:0.1 footerHeight:10];
    [self.dataArray addObject:section3];
    
    if (IsNilOrNull(homeLoginStatus)) {
        //媒体报道
        CellModel *mediaTitle = [self createCellModel:[CKHeaderTitleCell class] userInfo:@{@"title": @"—— 媒体报道 ——", @"type": @"2"} height:40*SCREEN_WIDTH/375.0f];
        CellModel *mediaModel = [self createCellModel:[CKNewsCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:mainM.mediareportArray, @"dataArray", @"2", @"type", nil] height:145*SCREEN_WIDTH/375.0f];
        SectionModel *section33 = [self createSectionModel:@[mediaTitle, mediaModel] headerHeight:0.1 footerHeight:10];
        [self.dataArray addObject:section33];
        
        //荣誉资质
        CellModel *honorTitle = [self createCellModel:[CKHeaderTitleCell class] userInfo:@{@"title": @"—— 荣誉资质 ——", @"type": @"3"} height:35*SCREEN_WIDTH/375.0f];
        CellModel *honorModel = [self createCellModel:[CKMPHonorCell class] userInfo:mainM.honorArray height:118*SCREEN_WIDTH/375.0f];
        SectionModel *section4 = [self createSectionModel:@[honorTitle, honorModel] headerHeight:0.1 footerHeight:0.1];
        [self.dataArray addObject:section4];
    }
    
    [_tableView reloadData];
}

-(CellModel*)createCellModel:(Class)cls userInfo:(id)userInfo height:(CGFloat)height {
    CellModel *model = [[CellModel alloc] init];
    model.selectionStyle = UITableViewCellSelectionStyleNone;
    model.userInfo = userInfo;
    model.height = height;
    model.className = NSStringFromClass(cls);
    return model;
}

-(SectionModel*)createSectionModel:(NSArray<CellModel*>*)items headerHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight {
    SectionModel *model = [SectionModel sectionModelWithTitle:nil cells:items];
    model.headerhHeight = headerHeight;
    model.footerHeight = footerHeight;
    return model;
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_dataArray){
        return _dataArray.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SectionModel *s = _dataArray[section];
    if(s.cells) {
        return s.cells.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModel *s = _dataArray[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    CKMainPageCell *cell = [tableView dequeueReusableCellWithIdentifier:item.reuseIdentifier];
    if(!cell) {
        cell = [[NSClassFromString(item.className) alloc] initWithStyle:item.style reuseIdentifier:item.reuseIdentifier];
    }
    cell.selectionStyle = item.selectionStyle;
    cell.accessoryType = item.accessoryType;
    cell.delegate = item.delegate;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModel *s = _dataArray[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    
    if(item.title) {
        cell.textLabel.text = item.title;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithRed:0.294 green:0.298 blue:0.302 alpha:1.00];
    }
    if(item.subTitle) {
        cell.detailTextLabel.text = item.subTitle;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.294 green:0.298 blue:0.302 alpha:1.00];
    }
    
    SEL selector = NSSelectorFromString(@"fillData:");
    if([cell respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
        [cell performSelector:selector withObject:item.userInfo];
#pragma clang diagnostic pop
    }
}

#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionModel *s = _dataArray[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    return item.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SectionModel *s = _dataArray[section];
    return s.headerhHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SectionModel *s = _dataArray[section];
    return s.footerHeight;
}

#pragma mark - 展示二维码
- (void)showQRCode {
    
    [[[CKMineCommon alloc] init] requestQRcode:^(NSString *qrcodeUrl, NSString *localQr, BOOL qrtype) {
        NSLog(@"传过来的链接%@",qrcodeUrl);
        _qrcodeurl = qrcodeUrl;
        if (qrtype == YES) {
            [self popQrView];
        }else{
            self.qrcodeView = [[BarCodeAlterVeiw alloc] init];
            self.qrcodeView.delegate = self;
            self.qrcodeView.titleLable.text = @"扫一扫二维码，进入我的店铺";
            NSString *qrUrl = [NSString loadImagePathWithString:qrcodeUrl];
            [self.qrcodeView.titleImageView sd_setImageWithURL:[NSURL URLWithString:qrUrl] placeholderImage:[UIImage imageNamed:@"waitgoods"] options:SDWebImageRefreshCached];
            [self.qrcodeView show];
        }
    }];
}

#pragma mark - 弹出二维码
-(void)popQrView {
    [[XLImageViewer shareInstanse] showNetImages:@[_qrcodeurl] index:0 from:self.view];
}

#pragma mark - 点击二维码弹出框
-(void)saveToPhotobuttonClicked{
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:_qrcodeurl];
    if (image == nil) {
        [self showNoticeView:CheckMsgQRNotLoad];
        image = [UIImage imageNamed:@"waitgoods"];
        return;
    }
    /**
     *  将图片保存到iPhone本地相册
     *  UIImage *image            图片对象
     *  id completionTarget       响应方法对象
     *  SEL completionSelector    方法
     *  void *contextInfo
     */
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        [self showNoticeView:@"已保存"];
    }else{
        [self showNoticeView:@"图片保存失败"];
    }
}

#pragma mark - 点击开店按钮
-(void)clickOpenShop{
    if(![WXApi isWXAppInstalled]){//未安装微信的客户
        LoginViewController *login = [[LoginViewController alloc] init];
        [self  presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{

        }];
    }else{
        //安装了微信的客户
        SendAuthReq *req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"26789ww";
        [WXApi sendReq:req];
    }
}

#pragma mark - 微信授权成功按照注册流程跳转到对于页面
-(void)JumpToJoin {
    
    if (!IPHONE_X) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self setStatusBarBackgroundColor:[UIColor blackColor]];
    }
    
    /*
    操作：用户点击购买礼包
    // invitecode 新增字段
    根据用户unoinid查询ck表和大礼包订单，
    返回
    a：有未支付订单，已确认信息（已注册）
    orderstatus     0
    dlbtype        B/D
    ckid          12345
    orderinfo[]   不为空
    b：无订单，已确认信息（已注册分销）
    orderstatus     0
    dlbtype        空
    ckid        12345（分销）
    orderinfo[]    空
    c：有未支付订单，未确认信息（未注册）
    orderstatus     0
    dlbtype        B/D
    ckid            空
    orderinfo[]   不为空
    d：无订单，未确认信息（未注册）
    orderstatus     0
    dlbtype         空
    ckid            空
    orderinfo[]     空
    e：已支付，未确认信息（未注册）
    orderstatus     1
    dlbtype        B/D
    ckid           空
    orderinfo[]    空
    
    f：有未支付订单（已注册分销）分销升级创客未支付
    orderstatus     0
    dlbtype        空
    ckid        12345（分销）
    orderinfo[]    不为空
    
    g：无订单，已确认信息
    orderstatus     0
    dlbtype        B/D
    ckid        12345
    orderinfo     空
    */
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetRegistStatus];
    NSString *unionid = [KUserdefaults objectForKey:Kunionid];
    if (IsNilOrNull(unionid)) {
        return;
    }
    NSDictionary *params = @{@"unionid": unionid};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:requestUrl params:params success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
       
        NSString *dlbtype = [NSString stringWithFormat:@"%@", dict[@"dlbtype"]];
        NSString *invitecode = [NSString stringWithFormat:@"%@",dict[@"invitecode"]];
        
        if (!IsNilOrNull(invitecode)){
            [KUserdefaults setObject:invitecode forKey:@"invitecode"];
        }
        [KUserdefaults synchronize];
        if ([dict[@"code"] integerValue] != 200) {
            if ([dict[@"code"] integerValue] == 2002 || [dict[@"code"] integerValue] == 2005) {
                
                [KUserdefaults setObject:@"-1" forKey:Kckid];
                [KUserdefaults setObject:@"" forKey:KMineLoginStatus];
                [KUserdefaults setObject:@"" forKey:KHomeLoginStatus];
                
                LoginViewController *login = [[LoginViewController alloc] init];
                [self  presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                }];
            }else{
                [self showNoticeView:[NSString stringWithFormat:@"%@", dict[@"codeinfo"]]];
                return;
            }
        }else{
            NSString *orderstatus = [NSString stringWithFormat:@"%@", dict[@"orderstatus"]];
            NSString *ckid = [NSString stringWithFormat:@"%@", dict[@"ckid"]];
           
            if (IsNilOrNull(ckid)) {
                ckid = @"";
            }
            [KUserdefaults setObject:ckid forKey:Kckid];
            
            //orderinfo有值是返回的是字典，没有值是返回的是空串
            NSDictionary *orderinfoDic = [[NSDictionary alloc] init];
            NSMutableArray *orderinfo = [NSMutableArray array];
            id orderinfoC = dict[@"orderinfo"];
            if ([orderinfoC isKindOfClass:[NSString class]]) {
                NSLog(@"WTF");
            }else if ([orderinfoC isKindOfClass:[NSDictionary class]]){
                orderinfoDic = dict[@"orderinfo"];
                if (orderinfoDic != nil) {
                    
                    [orderinfo addObject:orderinfoDic];
                    
                    AddressModel *addressModel = [[AddressModel alloc] init];
                    addressModel.gettername = [NSString stringWithFormat:@"%@", orderinfoDic[@"gettername"]];
                    addressModel.gettermobile = [NSString stringWithFormat:@"%@", orderinfoDic[@"gettermobile"]];
                    if (!IsNilOrNull(addressModel.gettermobile)) {
                        [KUserdefaults setObject:addressModel.gettermobile forKey:@"Kgettermobile"];
                    }
                    
                    NSString *address = [NSString stringWithFormat:@"%@", orderinfoDic[@"getteraddress"]];
                    NSArray *arr = [address componentsSeparatedByString:@" "];
                    NSRange range = [address rangeOfString:arr.lastObject];
                    addressModel.address = [address substringToIndex:range.location];
                    addressModel.homeaddress = arr.lastObject;
                    NSString *unionid = [KUserdefaults objectForKey:Kunionid];
                    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
                    NSString *filePath = [path stringByAppendingPathComponent:unionid];
                    [NSKeyedArchiver archiveRootObject:addressModel toFile:filePath];
                }
            }
            
            if([orderstatus isEqualToString:@"1"]){//e
                // 包装分享邀请人所需数据
                NSDictionary *dic = @{@"head":dict[@"head"],
                                      @"introduceurl":dict[@"introduceurl"],
                                      @"mobile":dict[@"mobile"],
                                      @"supername":dict[@"supername"],
                                      @"invitecode":dict[@"invitecode"], @"superid":dict[@"superid"]
                                      };
                CKConfrimSharePersonViewController *confrimSharePersonVc = [[CKConfrimSharePersonViewController alloc]init];
                if (IsNilOrNull(invitecode)) {
                    invitecode = @"";
                }
                confrimSharePersonVc.dict = dic;
                [self.navigationController pushViewController:confrimSharePersonVc animated:YES];
                
            }else{
                if (IsNilOrNull(dlbtype)) {
                    if (!IsNilOrNull(ckid)) {
                        if (orderinfo.count == 0) {//b
                            //创客升级，礼包列表只显示创客礼包
                            CKChooseJoinGoodsVC *chooseDLB = [[CKChooseJoinGoodsVC alloc] init];
                            chooseDLB.ckid = ckid;
                            chooseDLB.showAllTypeDLB = @"NO";
                            [self.navigationController pushViewController:chooseDLB animated:YES];
                        }else{//f
                            //创客升级,有未支付订单，进入确认订单页面，更换商品只显示创客礼包，不显示分销和零风险礼包
                            CKConfirmRegisterOrderVC *confirmOrder = [[CKConfirmRegisterOrderVC alloc]init];
                            CKOrderinfoModel *orderM = [[CKOrderinfoModel alloc] init];
                            for (NSDictionary *dict in orderinfo) {
                                [orderM setValuesForKeysWithDictionary:dict];
                            }
                            confirmOrder.totalMoney = [NSString stringWithFormat:@"%.2f", [orderM.price doubleValue]];
                            confirmOrder.orderinfoArray = orderinfo;
                            confirmOrder.fromVC = @"MainPageVC";
                            confirmOrder.ckid = ckid;
                            confirmOrder.showAllTypeDLB = @"NO";
                            [self.navigationController pushViewController:confirmOrder animated:YES];
                        }
                    }else{//d 新用户购买
                        // 包装分享邀请人所需数据
                        NSDictionary *dic = @{@"head":dict[@"head"], @"introduceurl":dict[@"introduceurl"], @"mobile":dict[@"mobile"], @"supername":dict[@"supername"], @"invitecode":dict[@"invitecode"], @"superid":dict[@"superid"] };
                        // 跳转到确认分享人
                        CKConfrimSharePersonViewController *confrimSharePersonVc = [[CKConfrimSharePersonViewController alloc]init];
                        confrimSharePersonVc.dict = dic;
                        [self.navigationController pushViewController:confrimSharePersonVc animated:YES];
                    }
                }else{
                    if (!IsNilOrNull(ckid)) {
                        if ([orderinfo count] == 0) {//g
                            CKChooseJoinGoodsVC *chooseDLB = [[CKChooseJoinGoodsVC alloc] init];
                            chooseDLB.showAllTypeDLB = @"YES";
                            chooseDLB.ckid = ckid;
                            [self.navigationController pushViewController:chooseDLB animated:YES];
                        }else{
                            CKConfirmRegisterOrderVC *confirmOrder = [[CKConfirmRegisterOrderVC alloc]init];
                            CKOrderinfoModel *orderM = [[CKOrderinfoModel alloc] init];
                            for (NSDictionary *dict in orderinfo) {
                                [orderM setValuesForKeysWithDictionary:dict];
                            }
                            confirmOrder.totalMoney = [NSString stringWithFormat:@"%.2f", [orderM.price doubleValue]];
                            confirmOrder.orderinfoArray = orderinfo;
                            confirmOrder.fromVC = @"MainPageVC";
                            //有未支付订单，有ck信息，支付完成不跳确认信息页面
                            confirmOrder.ckid = ckid;
                            confirmOrder.showAllTypeDLB = @"YES";
                            [self.navigationController pushViewController:confirmOrder animated:YES];
                        }
                    }else{
                        // 包装分享邀请人所需数据
                        NSDictionary *dic = @{@"head":dict[@"head"], @"introduceurl":dict[@"introduceurl"], @"mobile":dict[@"mobile"], @"supername":dict[@"supername"], @"invitecode":dict[@"invitecode"], @"superid":dict[@"superid"]};
                        // 跳转到确认分享人
                        CKConfrimSharePersonViewController *confrimSharePersonVc = [[CKConfrimSharePersonViewController alloc]init];
                        confrimSharePersonVc.dict = dic;
                        [self.navigationController pushViewController:confrimSharePersonVc animated:YES];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        NSLog(@"%@", error);
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - ************登录成功后功能模块的事件**************************
#pragma mark - 代理方法点击今日销售 我的云豆
-(void)seeSaleDeatilWithTag:(NSInteger)currentTag andButton:(UIButton *)button{
   
    [self jumpSaleAndBean:currentTag andTypeStr:_checkStatus];
}

#pragma mark - 代理方法-点击公司荣誉 ck软件推广(fx店铺分享) 我要自提 二维码
-(void)dealModuleWithTag:(NSInteger)currentTag andButton:(UIButton *)button{
    
    if (currentTag == 0) {//荣誉资质
        [self jumpToMyHonour];
    }else if (currentTag == 2){ //媒体报导
        MediaReportsController *mediaVC = [[MediaReportsController alloc] init];
        [self.navigationController pushViewController:mediaVC animated:YES];
    }else{
        [self jumpQrAndCarry:currentTag andTypeStr:_checkStatus];
    }
}

#pragma mark - 查看荣誉和资质
-(void)jumpToMyHonour{
    MyHonourViewController *honour = [[MyHonourViewController alloc] init];
    [self.navigationController pushViewController:honour animated:YES];
}

#pragma mark - 检查店铺状态   type:从哪里跳转 1:我的云豆/今日销售/资金管理  2:自提/素材/二维码/
- (void)checkShopStatus {
    
    NSString *ckid = KCKidstring;
    if(IsNilOrNull(ckid) || [ckid isEqualToString:@"-1"]){
        return;
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI, checkStatus_Url];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if (![homeLoginStatus isEqualToString:@"homelogin"]) {
        return;
    }else{
        [params setObject:ckid forKey:@"ckid"];
    }
    
    [HttpTool postWithUrl:requestUrl params:params success:^(id json) {
        NSDictionary *dict = json;
        
        NSLog(@"获取成功时间%@",[NSDate dateNow]);
        //status 店铺状态  CLOSE、PAY
        _checkStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
        
        NSLog(@"%@", dict);
        [KUserdefaults setObject:_checkStatus forKey:KCheckStatus];
        [KUserdefaults synchronize];
    } failure:^(NSError *error) {
        NSLog(@"检验是否可点击失败");
    }];
}

- (void)jumpQrAndCarry:(NSInteger)currentTag andTypeStr:(NSString *)checkStatus {
    _tgidstring = [KUserdefaults objectForKey:KSales];
    _tgidstring = IsNilOrNull(_tgidstring) ? @"0" : _tgidstring;
    if([self checkStatus:checkStatus]){
        if (currentTag == 1){ //  推广人是素材中心
            if(![_tgidstring isEqualToString:@"0"]){
                SourceMaterialViewController *mysource = [[SourceMaterialViewController alloc] init];
                [self.navigationController pushViewController:mysource animated:YES];
                
            }else{ //ck和fx 我要自提
                CKSelfPickUpViewController *selfPickup = [[CKSelfPickUpViewController alloc] init];
                [self.navigationController pushViewController:selfPickup animated:YES];
            }
        }else if (currentTag == 3){ //二维码
            if(![_tgidstring isEqualToString:@"0"]){
                [self showQRCode];
            }else{
                SourceMaterialViewController *mysource = [[SourceMaterialViewController alloc] init];
                [self.navigationController pushViewController:mysource animated:YES];
            }
        }
    }
}

-(void)jumpSaleAndBean:(NSInteger)currentTag andTypeStr:(NSString *)checkStatus{
    _tgidstring = [KUserdefaults objectForKey:KSales];
    _tgidstring = IsNilOrNull(_tgidstring) ? @"0" : _tgidstring;
    if([self checkStatus:checkStatus]){
        if (currentTag == 0){
            TodaySalesViewController *todayIncomeVC = [[TodaySalesViewController alloc] init];
            [self.navigationController pushViewController:todayIncomeVC animated:YES];
        }else{
            if (![_tgidstring isEqualToString:@"0"]) { //推广员登录
                TGFundMnageViewController *tgFundVC = [[TGFundMnageViewController alloc] init];
                [self.navigationController pushViewController:tgFundVC animated:YES];
            }else{ //创客登录
                CKCloudBeanViewController *myYunDou = [[CKCloudBeanViewController alloc]init];
                myYunDou.type = _typeStr;
                [self.navigationController pushViewController:myYunDou animated:YES];
            }
        }
    }
}

#pragma mark-跳转到头条列表
- (void)seeBestNewsDetail {
    CKCTheHeadlinesController *theHead = [[CKCTheHeadlinesController alloc]init];
    [self.navigationController pushViewController:theHead animated:YES];
}

#pragma mark-点击查看全部资质与荣誉
- (void)seeAllCompanyHonorDetail {
    MyHonourViewController *honour = [[MyHonourViewController alloc] init];
    [self.navigationController pushViewController:honour animated:YES];
}

#pragma mark-登陆成功以后 点击重要模块校验方法
-(BOOL)checkStatus:(NSString *)checkStatus{
    
    if(IsNilOrNull(checkStatus)){
        checkStatus = @"";
    }
    _ckidstr = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    //  check店铺状态（未支付：NOTPAY，未开通：NOOPEN，已开通：PAY，关闭：CLOSE）
    NSString *localStatus = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KStatus]];
    if (IsNilOrNull(localStatus)) {
        localStatus = @"";
    }
    //  local店铺状态（未支付：NOTPAY，未审核：NOTREVIEW，未完善个人资料：NOINFO，已开通：PAY，关闭：CLOSE）
    if(IsNilOrNull(_ckidstr)){  //未登录 跳转登录
        LoginViewController *login = [[LoginViewController alloc] init];
        [self  presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
            
        }];
        return NO;
        
    }else{
        if (checkStatus && checkStatus.length > 0){
            //已登录 未支付  跳转支付页面
            if ([checkStatus isEqualToString:@"NOTPAY"]) {  //未付款
                
                NSString *unionid = [KUserdefaults objectForKey:Kunionid];
                if (IsNilOrNull(unionid)) {
                    if(![WXApi isWXAppInstalled]){//未安装微信的客户
                        XWAlterVeiw *alert = [[XWAlterVeiw alloc] init];
                        alert.titleLable.text = @"请下载安装微信";
                        [alert show];
                        
                    }else{
                        //安装了微信的客户
                        SendAuthReq *req =[[SendAuthReq alloc ] init];
                        req.scope = @"snsapi_userinfo";
                        req.state = @"26789ww";
                        [WXApi sendReq:req];
                    }
                }else{
//                    [self sharePerson];
                    [self JumpToJoin];
                }
                
                return NO;
            }else  if ([checkStatus isEqualToString:@"CLOSE"]){
                //已登录并且 已经付款 资料完善 店铺关闭  NOINFO/NOTREVIEW
                if ([localStatus isEqualToString:@"NOINFO"]){
                    //跳转完善信息
                    [self showNoticeView:CKYSmsgshopstatusUpdatePersonalInfo];
                    MinePersonalInfomationViewController *mineInfo = [[MinePersonalInfomationViewController alloc] init];
                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:mineInfo] animated:YES completion:^{}];
                    return NO;
                }else{
                    //提示店铺审核中
                    [self showNoticeView:CKYSmsgshopstatusPending];
                    return NO;
                }
                
            }else  if ([checkStatus isEqualToString:@"NOOPEN"]){//预售店待开通
                if ([localStatus isEqualToString:@"NOINFO"]) { //未完善资料
                    //跳转完善信息
                    [self showNoticeView:CKYSmsgshopstatusUpdatePersonalInfo];
                    MinePersonalInfomationViewController *mineInfo = [[MinePersonalInfomationViewController alloc] init];
                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:mineInfo] animated:YES completion:^{}];
                    return NO;
                }else  if([localStatus isEqualToString:@"NOOPEN"]){//预售店待开通
                    
                    [self showNoticeView:CKYSmsgshopstatusConnectCKOpen];
                    return NO;
                    
                }else{
                    //提示店铺审核中
                    [self showNoticeView:CKYSmsgshopstatusPending];
                    return NO;
                }
                
            }else if ([checkStatus isEqualToString:@"PAY"]){
                //正常情况
                
                return YES;
            }else{
//                [KUserdefaults setObject:@"" forKey:Kckid];
//                [KUserdefaults setObject:@"" forKey:KSales];
//                [KUserdefaults setObject:@"" forKey:KStatus];
//                [KUserdefaults setObject:@"" forKey:KCheckStatus];
                [self displayTableView];
                return NO;
            }
            
        }else{
            //已登录 未支付  跳转支付页面
            if ([localStatus isEqualToString:@"NOTPAY"]) {  //未付款
                NSString *unionid = [KUserdefaults objectForKey:Kunionid];
                if (IsNilOrNull(unionid)) {
                    if(![WXApi isWXAppInstalled]){//未安装微信的客户
                        XWAlterVeiw *alert = [[XWAlterVeiw alloc] init];
                        alert.titleLable.text = @"请下载安装微信";
                        [alert show];
                        
                    }else{
                        //安装了微信的客户
                        SendAuthReq *req =[[SendAuthReq alloc ] init];
                        req.scope = @"snsapi_userinfo";
                        req.state = @"26789ww";
                        [WXApi sendReq:req];
                    }
                }else{
//                    [self sharePerson];
                    [self JumpToJoin];
                }
                return NO;
            }else  if ([localStatus isEqualToString:@"NOINFO"]){
                //已登录并且 已经付款 资料完善 店铺关闭  NOINFO/NOTREVIEW
                [self showNoticeView:CKYSmsgshopstatusUpdatePersonalInfo];
                MinePersonalInfomationViewController *mineInfo = [[MinePersonalInfomationViewController alloc] init];
                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:mineInfo] animated:YES completion:^{}];
                return NO;
                
            }else if ([localStatus isEqualToString:@"NOTREVIEW"]){
                //跳转完善信息
                [self showNoticeView:CKYSmsgshopstatusPending];
                return NO;
            }else  if([localStatus isEqualToString:@"NOOPEN"]){//预售店待开通
                
                [self showNoticeView:CKYSmsgshopstatusConnectCKOpen];
                return NO;
                
            }else if ([localStatus isEqualToString:@"PAY"]){
                //正常情况
                
                return YES;
            }else if ([localStatus isEqualToString:@"CLOSE"]){  //店铺关闭
                //正常情况
                [self showNoticeView:CKYSmsgshopstatusPending];
                return NO;
            }else{
//                [KUserdefaults setObject:@"" forKey:Kckid];
//                [KUserdefaults setObject:@"" forKey:KSales];
//                [KUserdefaults setObject:@"" forKey:KStatus];
//                [KUserdefaults setObject:@"" forKey:KCheckStatus];
                [self displayTableView];
                return NO;
            }
        }
        return NO;
    }
}

-(void)defaultTableViewFrame {
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.view.mas_top).offset(20+NaviAddHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49-BOTTOM_BAR_HEIGHT);
    }];
}

-(void)changeTableViewFrame {
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49-BOTTOM_BAR_HEIGHT);
    }];
}

-(void)requestDataWithoutCache {
    //    if ([self getMainPageData].count == 0) {
    [self requestData];
    [CKCNotificationCenter postNotificationName:@"RequestLessonsData" object:nil];
    //    }
}

-(void)reloadBanner {
    CKMainPageModel *mainModel = [self getMainPageData].firstObject;
    
    CellModel *bannerModel = [self createCellModel:[CKBannerCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:mainModel.bannerArray,@"data",@"1",@"type", nil] height:[CKBannerCell computeHeight:mainModel.bannerArray]];
    
    SectionModel *section0 = [self createSectionModel:@[bannerModel] headerHeight:0.1 footerHeight:0.1];
    
    [self.dataArray replaceObjectAtIndex:0 withObject:section0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)displayTableView {
    [self bindMainPageData];
}

-(void)dealloc {
    //移除通知
    [CKCNotificationCenter removeObserver:self name:WeiXinAuthSuccess object:nil];
    [CKCNotificationCenter removeObserver:self name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter removeObserver:self name:@"NoNetNotification" object:nil];
    [CKCNotificationCenter removeObserver:self name:@"RequestHomePageData" object:nil];
    [CKCNotificationCenter removeObserver:self name:DidReceiveBannerUpdatePushNoti object:nil];
}

@end

