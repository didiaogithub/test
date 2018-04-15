//
//  CKDLBSealViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/14.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKDLBSealViewController.h"
#import "MyTeamModel.h"
#import "MyTeamListModel.h"
#import "PPNetworkHelper.h"
#import "FinalTeamTableViewCell.h"
#import "TTAttibuteLabel.h"

#import "PresaleShopViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MyTeamTableViewCell.h"
#import "MyTeamSearchViewController.h"
#import "UIButton+XN.h"

static NSString *CellIdentifier = @"FinalTeamTableViewCell";
static NSString *CustomerCellIdentifier = @"MyTeamTableViewCell";

@interface CKDLBSealViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,FinalTeamTableViewCellDelegate,MyTeamTableViewCellDelegate>
{
    UIView *_bankView;
    UIView *_topView;
    UIView *_middleView;
    UIImageView *_headImageView;
    
    TTAttibuteLabel *_ckLable; //创客
    TTAttibuteLabel *_fxLable; //分销
    UIButton *_ckButton;
    UIButton *_fxButton;

    NSString *_myTeamId;
    NSString *_string;
    NSString *_typeString;
    NSString *_ckidString;
    NSString *_isDownloadMore;
    UILabel *_typeLine;
    
}

@property (nonatomic, strong) MyTeamModel *myTeamModel;
@property (nonatomic, strong) MyTeamListModel *myTeamListModel;
@property (nonatomic, strong) UITableView *customerTeamTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *boolArray;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, strong) UIView *naviView;

@end

@implementation CKDLBSealViewController

- (NodataLableView *)nodataLableView {
    if(_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT - 64-AdaptedHeight(160)-145)];
        _nodataLableView.nodataLabel.text = @"暂无记录";
    }
    return _nodataLableView;
}

-(NSMutableArray *)boolArray{
    if (_boolArray == nil) {
        _boolArray = [[NSMutableArray alloc] init];
    }
    return _boolArray;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    [self getMyteamData];
    // 获取网络缓存大小
    NSLog(@"网络缓存大小cache = %fKB",[PPNetworkCache getAllHttpCacheSize]/1024.f);
    
    if (IsNilOrNull(_string)) {
        _string = @"0";
    }
    [self getMyTeamListData];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavViews];
    [self createHeaderView];
    [self refreshData];
    
}

#pragma mark - 创建导航栏上的控件
-(void)createNavViews {
    
    self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NaviHeight)];;
    self.naviView.backgroundColor = CKYS_Color(248, 248, 248);
    [self.view addSubview:self.naviView];
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20+NaviAddHeight-5, 30, 50)];
    [backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"RootNavigationBack"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"RootNavigationBack"] forState:UIControlStateSelected];
    [self.naviView addSubview:backBtn];
    
    
    UILabel *titleL = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13.0]];
    titleL.frame = CGRectMake(35, 20+NaviAddHeight-5+10, 60, 30);
    titleL.text = @"礼包销售";
    [self.naviView addSubview:titleL];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 20+NaviAddHeight-5+10, SCREEN_WIDTH- 150, 30)];
    [btn setImage:[UIImage imageNamed:@"carraynavsearch"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"carraynavsearch"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(clickNavSearchButton) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:btn];
}

- (void)clickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击团队搜索
-(void)clickNavSearchButton{
    
    MyTeamSearchViewController *searchVC = [[MyTeamSearchViewController alloc] init];
    if (_ckButton.selected){
        searchVC.typeStr = @"B";
    }else if (_fxButton.selected){
        searchVC.typeStr = @"D";
    }else{
        searchVC.typeStr = @"C";
    }
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 添加预售店铺
-(void)createPreSaleShopButton {
    
    UIButton *presaleBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 20+NaviAddHeight-5+10, 30, 30)];
    [presaleBtn setImage:[UIImage imageNamed:@"presaleshopicon"] forState:UIControlStateNormal];
    [presaleBtn setImage:[UIImage imageNamed:@"presaleshopicon"] forState:UIControlStateHighlighted];
    [presaleBtn addTarget:self action:@selector(clickpreSaleButton) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:presaleBtn];
    
}

-(void)clickpreSaleButton{
    
    PresaleShopViewController *presale = [[PresaleShopViewController alloc] init];
    [self.navigationController pushViewController:presale animated:YES];
}

#pragma mark-获取我的团队数据
-(void)getMyteamData{
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *getMyTeamUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getMyTeamInfo_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString,DeviceId:uuid};
    
    [PPNetworkHelper POST:getMyTeamUrl parameters:pramaDic responseCache:^(id responseCache) {
        [self getJsonDictWithMyTeam:responseCache andIsLoad:NO];
    } success:^(id responseObject) {
        [self getJsonDictWithMyTeam:responseObject andIsLoad:YES];
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误数据%@",error.localizedDescription);
    }];
}
-(void)getJsonDictWithMyTeam:(NSDictionary *)teamDict andIsLoad:(BOOL)isLoad{
    NSDictionary *dict = teamDict;
    NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
    NSString *noticeString = [NSString stringWithFormat:@"%@",dict[@"codeinfo"]];
    
    if (isLoad == YES){
        //先初始化弹出的框
        MultipleDevicesAlter *deveiceAlert = [MultipleDevicesAlter shareInstance];
        if ([code isEqualToString:MutipDeviceLoginCode]){
            //先弹窗提示被迫下线
            [deveiceAlert showAlert:noticeString];
            [CKCNotificationCenter postNotificationName:@"hudstop" object:nil];
            return;
        }
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:noticeString];
            return ;
        }
        
    }
    self.myTeamModel = [[MyTeamModel alloc] init];
    [self.myTeamModel setValuesForKeysWithDictionary:dict];
    [self refreshWithModel:self.myTeamModel];
    
}
/**刷新 今日新增数据*/
-(void)refreshWithModel:(MyTeamModel *)teamModel{
    
    NSString *ckAdd = [NSString stringWithFormat:@"%@",teamModel.ckAdd];
    NSString *fxAdd = [NSString stringWithFormat:@"%@",teamModel.fxAdd];
    
    NSString *presaleTotal = [NSString stringWithFormat:@"%@",teamModel.presaleTotal];
    if (IsNilOrNull(presaleTotal)) {
        presaleTotal = @"";
    }
    //有预售店  没有0
    if(![presaleTotal isEqualToString:@"0"]){
        [self createPreSaleShopButton];//显示预售店按钮
    }
    //创客
    if (IsNilOrNull(ckAdd)) {
        ckAdd = @"0";
    }
    [_ckLable setTextLeft:ckAdd right:@"套" andLeftColor:[UIColor whiteColor] andRightColor:[UIColor whiteColor] andLeftFont:30 andRightFont:15];
    
    //分销
    if (IsNilOrNull(fxAdd)) {
        fxAdd = @"0";
    }
    [_fxLable setTextLeft:fxAdd right:@"套" andLeftColor:[UIColor whiteColor] andRightColor:[UIColor whiteColor] andLeftFont:30 andRightFont:15];
    
    //刷新按钮
    NSString *customer = [NSString stringWithFormat:@"%@",teamModel.customerTotal];
    if (IsNilOrNull(customer)) {
        customer = @"0";
    }
    
    NSString *CKCount = [NSString stringWithFormat:@"%@",teamModel.ckTotal];
    if (IsNilOrNull(CKCount)) {
        CKCount = @"0";
    }
    [_ckButton setTitle:[NSString stringWithFormat:@"创客礼包%@套",CKCount] forState:UIControlStateNormal];
    
    NSString *FXCount = [NSString stringWithFormat:@"%@",teamModel.fxTotal];
    if (IsNilOrNull(FXCount)) {
        FXCount = @"0";
    }
    [_fxButton setTitle:[NSString stringWithFormat:@"分销礼包%@套",FXCount] forState:UIControlStateNormal];
    
}
/**刷新列表数据*/
-(void)getMyTeamListData{
    _ckButton.userInteractionEnabled = NO;
    _fxButton.userInteractionEnabled = NO;
    
    if (IsNilOrNull(_string)) {
        _string = @"0";
    }
    if (IsNilOrNull(_myTeamId)) {
        _myTeamId = @"0";
    }
    if (![_isDownloadMore isEqualToString:@"2"]) {
        _myTeamId = @"0";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *requestUrl = nil;
    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"pagesize":@"20",@"id":_myTeamId,DeviceId:uuid};
    if ([_string isEqualToString:@"0"]) {
        requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getMyTeamCkList_Url];
    }else if ([_string isEqualToString:@"1"]){
        requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getMyTeamFxList_Url];
    }else{
        requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getCustomerList_Url];
    }
    _nodataLableView.hidden = YES;
    if (IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    [PPNetworkHelper POST:requestUrl parameters:pramaDic responseCache:^(id responseCache) {
        if(![_isDownloadMore isEqualToString:@"2"]){
            [self getDataWithDict:responseCache andIsLoad:NO];
        }
    } success:^(id responseObject) {
        _ckButton.userInteractionEnabled = YES;
        _fxButton.userInteractionEnabled = YES;
        [self.viewDataLoading stopAnimation];
        
        [self getDataWithDict:responseObject andIsLoad:YES];
        
    } failure:^(NSError *error) {
        _ckButton.userInteractionEnabled = YES;
        _fxButton.userInteractionEnabled = YES;
        [self.viewDataLoading stopAnimation];
        [self.customerTeamTableView.mj_footer endRefreshing];
        [self.customerTeamTableView.mj_header endRefreshing];
    }];
}
-(void)getDataWithDict:(id)json andIsLoad:(BOOL)isLoad{
    
    NSDictionary *dict = json;
    NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
    NSString *noticeString = [NSString stringWithFormat:@"%@",dict[@"codeinfo"]];
    if (isLoad == YES){
        //先初始化弹出的框
        MultipleDevicesAlter *deveiceAlert = [MultipleDevicesAlter shareInstance];
        if ([code isEqualToString:MutipDeviceLoginCode]){
            //先弹窗提示被迫下线
            [deveiceAlert showAlert:noticeString];
            [CKCNotificationCenter postNotificationName:@"hudstop" object:nil];
            return;
        }
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:noticeString];
            return ;
        }
    }
    
    if (![_isDownloadMore isEqualToString:@"2"]){
        [self.dataArray removeAllObjects];
    }
    
    NSArray *listArr = dict[@"members"];
    
    if (listArr.count == 0) {
        if ([_isDownloadMore isEqualToString:@"2"]) {
            [self.customerTeamTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
    }
    
    for (NSDictionary *customerDic in listArr){
        self.myTeamListModel = [[MyTeamListModel alloc] init];
        [self.myTeamListModel setValuesForKeysWithDictionary:customerDic];
        [self.dataArray addObject:self.myTeamListModel];
        [self.boolArray addObject:@NO];
    }
    if([listArr count]){
        _myTeamId = [NSString stringWithFormat:@"%zd",self.dataArray.count];
        
    }
    if(isLoad){
        if (![self.dataArray count]){
            _nodataLableView.hidden = NO;
            [self.customerTeamTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArray.count];
        }
    }
    
    NSLog(@"共有%zd行  %@",self.dataArray.count,_myTeamId);
    [self.customerTeamTableView.mj_header endRefreshing];
    [self.customerTeamTableView.mj_footer endRefreshing];
    [self.customerTeamTableView reloadData];
}

-(void)createHeaderView{
    
    _bankView = [[UIView alloc] init];
    [self.view addSubview:_bankView];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64+NaviAddHeight);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(160));
    }];
    
    //顾客人数
    _customerTeamTableView = [[UITableView alloc] init];
    _customerTeamTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_customerTeamTableView];
    [_customerTeamTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(_bankView.mas_bottom);
        make.height.mas_offset(SCREEN_HEIGHT - AdaptedHeight(160)-64);
    }];
    [self.customerTeamTableView registerClass:[FinalTeamTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.customerTeamTableView registerClass:[MyTeamTableViewCell class] forCellReuseIdentifier:CustomerCellIdentifier];
    _customerTeamTableView.backgroundColor = [UIColor tt_grayBgColor];
    _customerTeamTableView.estimatedRowHeight = 44;
    _customerTeamTableView.delegate = self;
    _customerTeamTableView.dataSource = self;
    
    
    //创建头部视图view
    _topView = [[UIView alloc] init];
    [_bankView addSubview:_topView];
    [_topView setBackgroundColor:[UIColor tt_bigRedBgColor]];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(100));
    }];
    
    
    //头像
    _headImageView = [[UIImageView alloc] init];
    _headImageView.contentMode  =UIViewContentModeScaleAspectFit;
    [_topView addSubview:_headImageView];
    [_headImageView setImage:[UIImage imageNamed:@"todayaddpeople"]];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(20));
        make.left.mas_offset(AdaptedWidth(30));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(40),AdaptedHeight(30)));
        
    }];
    
    //今日新增四个字
    UILabel * bottomTextLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [_topView addSubview:bottomTextLable];
    bottomTextLable.text = @"今日销售";
    [bottomTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_bottom).offset(AdaptedHeight(6));
        make.left.mas_offset(0);
        make.width.mas_offset(AdaptedWidth(100));
    }];
    
    
    _ckLable = [[TTAttibuteLabel alloc] init];
    //创客
    [_ckLable setTextLeft:@"0" right:@"套" andLeftColor:[UIColor whiteColor] andRightColor:[UIColor whiteColor] andLeftFont:30 andRightFont:15];
    [_topView addSubview:_ckLable];
    _ckLable.textAlignment = NSTextAlignmentCenter;
    [_ckLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_top);
        make.left.equalTo(_headImageView.mas_right).offset(30);
        make.width.mas_offset((SCREEN_WIDTH-130)/2);
    }];
    
    
    
    UILabel *cktext = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [_topView addSubview:cktext];
    cktext.text = @"创客礼包";
    [cktext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ckLable.mas_bottom);
        make.left.width.equalTo(_ckLable);
    }];
    
    
    //分销
    _fxLable = [[TTAttibuteLabel alloc] init];
    [_fxLable setTextLeft:@"0" right:@"" andLeftColor:[UIColor whiteColor] andRightColor:[UIColor whiteColor] andLeftFont:30 andRightFont:15];
    [_topView addSubview:_fxLable];
    _fxLable.textAlignment = NSTextAlignmentCenter;
    [_fxLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ckLable.mas_top);
        make.right.mas_offset(-30);
        make.left.equalTo(_ckLable.mas_right).offset(5);
    }];
    
    UILabel *fxtext = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [_topView addSubview:fxtext];
    fxtext.text = @"分销礼包";
    [fxtext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fxLable.mas_bottom);
        make.right.width.equalTo(_fxLable);
    }];
    
    //中间的按钮
    _middleView = [[UIView alloc]init];
    [_bankView addSubview:_middleView];
    [_middleView setBackgroundColor:[UIColor whiteColor]];
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.bottom.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(60));
    }];
    
    //中间三个按扭
    CGFloat buttonW = SCREEN_WIDTH*0.5;
    _ckButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ckButton setTitle:@"创客礼包0套" forState:UIControlStateNormal];
    [_ckButton setTitleColor:SubTitleColor forState:UIControlStateNormal];
    [_ckButton setTitleColor:[UIColor tt_bigRedBgColor] forState:UIControlStateSelected];
    _ckButton.titleLabel.font = MAIN_TITLE_FONT;
    _ckButton.tag = 3330;
    [_ckButton addTarget:self action:@selector(clicksButton:) forControlEvents:UIControlEventTouchUpInside];
    [_middleView addSubview:_ckButton];
    _ckButton.selected = YES;
    _ckButton.adjustsImageWhenHighlighted = NO;
    [_ckButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_offset(0);
        make.width.mas_offset(buttonW);
    }];
    
    _typeLine = [[UILabel alloc] init];
    [_middleView addSubview:_typeLine];
    _typeLine.backgroundColor = [UIColor tt_redMoneyColor];
    [_typeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.width.mas_offset(buttonW-20);
        make.bottom.mas_offset(-5);
        make.height.mas_offset(1.5);
    }];
    
    UILabel *ckline = [[UILabel alloc] init];
    [_middleView addSubview:ckline];
    [ckline setBackgroundColor:[UIColor tt_redMoneyColor]];
    [ckline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.bottom.mas_offset(-10);
        make.left.equalTo(_ckButton.mas_right);
        make.width.mas_offset(1);
    }];
    
    _fxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fxButton setTitle:@"分销礼包0套" forState:UIControlStateNormal];
    [_fxButton setTitleColor:SubTitleColor forState:UIControlStateNormal];
    [_fxButton setTitleColor:[UIColor tt_bigRedBgColor] forState:UIControlStateSelected];
    _fxButton.titleLabel.font = MAIN_TITLE_FONT;
    _fxButton.tag = 3331;
    [_fxButton addTarget:self action:@selector(clicksButton:) forControlEvents:UIControlEventTouchUpInside];
    [_middleView addSubview:_fxButton];
    _fxButton.adjustsImageWhenHighlighted = NO;
    [_fxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(_ckButton);
        make.left.equalTo(_ckButton.mas_right).offset(1);
    }];
}

#pragma mark-点击按钮
-(void)clicksButton:(UIButton *)button{
    [_customerTeamTableView.mj_footer endRefreshing];
    //点击的时候把刷新清空
    if(![_myTeamId isEqualToString:@"0"]){
        _myTeamId = @"0";
    }
    _isDownloadMore = @"";
    switch (button.tag - 3330) {
        case 0://创客
        {
            _ckButton.selected = YES;
            _fxButton.selected = NO;
            [_ckButton setUserInteractionEnabled:NO];
            [_fxButton setUserInteractionEnabled:YES];
            _string = @"0";
            [self anamationWithLeftx:10];
        }
            break;
        case 1: //分销
        {
            _ckButton.selected = NO;
            _fxButton.selected = YES;
            [_ckButton setUserInteractionEnabled:YES];
            [_fxButton setUserInteractionEnabled:NO];
            _string = @"1";
            [self anamationWithLeftx:SCREEN_WIDTH*0.5+10];
        }
            break;
        default:
            break;
    }
    [self getMyTeamListData];
}
-(void)anamationWithLeftx:(float)leftx{
    [_typeLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(leftx);
    }];
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_ckButton.selected){
        BOOL isOpen = [self.boolArray[indexPath.row] boolValue];
        FinalTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.index = indexPath.row;
        cell.typeString = _string;
        if ([self.dataArray count]) {
            [cell refreshWithListModel:self.dataArray[indexPath.row] andOpen:isOpen];
        }
        cell.backgroundColor = [UIColor tt_grayBgColor];
        // cell 行高
        cell.fd_enforceFrameLayout = NO;
        return cell;
    }else{
        //分销  和  顾客
        MyTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomerCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor tt_grayBgColor];
        cell.delegate = self;
        cell.index = indexPath.row;
        cell.typeString = _string;
        
        if ([self.dataArray count]) {
            [cell refreshWithListModel:self.dataArray[indexPath.row]];
        }
        return cell;
    }
    
}

// 此处主要用第三方工具解决tableView自动布局下 进行编辑的时候定位不准确
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //高度计算并且缓存
    if (_ckButton.selected) {
        if ([self.dataArray count]) {
            _myTeamListModel = self.dataArray[indexPath.row];
        }
        BOOL isOpen = [self.boolArray[indexPath.row] boolValue];
        CGFloat height = [tableView fd_heightForCellWithIdentifier:CellIdentifier cacheByIndexPath:indexPath configuration:^(FinalTeamTableViewCell *cell) {
            [cell refreshWithListModel:_myTeamListModel andOpen:isOpen];
        }];
        return height;
    }else{
        return AdaptedHeight(120);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 起初想把标识放在cell里面。，但刷新会重置
    // XQTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    [cell setOpen:!cell.isOpen];
    
    // 改变数据标识，刷新
    if (_ckButton.selected){
        BOOL isOpen = [self.boolArray[indexPath.row] boolValue];
        [self.boolArray replaceObjectAtIndex:indexPath.row withObject:@(!isOpen)];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

/**电话按钮*/
-(void)clickMyTeamButtonWithIndex:(NSInteger)index{
    
    if ([self.dataArray count]) {
        self.myTeamListModel = self.dataArray[index];
    }
    NSString *mobile = [NSString stringWithFormat:@"%@",self.myTeamListModel.mobile];
    NSString *gettermobile = [NSString stringWithFormat:@"%@",self.myTeamListModel.gettermobile];
    
    if (IsNilOrNull(gettermobile)){
        gettermobile = @"";
    }
    if (IsNilOrNull(mobile)){
        mobile = @"";
    }
    NSString *contentStr = @"";
    if ([_string isEqualToString:@"0"] || [_string isEqualToString:@"1"]){ //创客 和分销
        if (IsNilOrNull(mobile)){
            [self showNoticeView:@"电话为空"];
            return;
        }
        contentStr = [NSString stringWithFormat:@"是否拨打电话%@？",mobile];
    }else{
        if (IsNilOrNull(gettermobile)){
            [self showNoticeView:@"电话为空"];
            return;
        }
        contentStr = [NSString stringWithFormat:@"是否拨打电话%@？",gettermobile];
    }
    [MessageAlert shareInstance].isDealInBlock = YES;
    [[MessageAlert shareInstance] hiddenCancelBtn:NO];
    [[MessageAlert shareInstance] showCommonAlert:contentStr btnClick:^{
        if (contentStr.length == 18 || contentStr.length > 18) {
            NSRange range = {6,11};
            NSString *string = [contentStr substringWithRange:range];
            NSString *num = [NSString stringWithFormat:@"tel:%@",string];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //
        }
    }];
    
}
-(void)refreshData{
    __typeof (self) __weak weakSelf = self;
    self.customerTeamTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"1";
        [weakSelf.customerTeamTableView.mj_header beginRefreshing];
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
                    [weakSelf getMyTeamListData];
                    [weakSelf getMyteamData];
                }else{
                    [weakSelf.customerTeamTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.customerTeamTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.customerTeamTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"2";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf getMyTeamListData];
                [weakSelf getMyteamData];
                //                [weakSelf.customerTeamTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.customerTeamTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
}
-(UIButton *)createMessageButtonWithNomalImage:(UIImage *)nomalImage andTitle:(NSString *)title andTag:(NSInteger)tag andAction:(SEL)action {
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:nomalImage forState:UIControlStateNormal];
    [button setTitleColor:SubTitleColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor tt_bigRedBgColor] forState:UIControlStateSelected];
    button.titleLabel.font = MAIN_TITLE_FONT;
    button.tag = tag;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
