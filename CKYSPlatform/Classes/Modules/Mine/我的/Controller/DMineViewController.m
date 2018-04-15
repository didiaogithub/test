//
//  DMineViewController.m
//  CKYSPlatform
//
//  Created by ckys on 16/6/28.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "DMineViewController.h"
#import "LoginViewController.h"
#import "BarCodeAlterVeiw.h"
#import "InvitationAlterVeiw.h"
#import "CKDLBSealViewController.h"
#import "CKCloudBeanViewController.h" //我的云豆
#import "CKMyProductLibVC.h" //我的产品库
#import "CKMyProductLibVCOld.h" //我的产品库3.1.1老模式
#import "CKSelfPickUpViewController.h"
#import "CKGoodsManagerViewController.h"
#import "ChangeMyAddressViewController.h"
#import "SourceMaterialViewController.h"
#import "OfflineShopViewController.h"
#import "CKHaveStockViewController.h"
#import "MyResultsViewController.h"
#import <SobotKit/SobotKit.h> //智齿客服
#import "WebDetailViewController.h"
#import "CKSettingsViewController.h"
#import "MinePersonalInfomationViewController.h"
#import "TGFundMnageViewController.h"
#import "MineTableViewCell.h"
#import "MineHeaderView.h"
#import "CKMyLevelViewController.h"
#import "CKMapManager.h"
#import "CKMineCommon.h"
#import "CKChooseJoinGoodsVC.h"
#import "CKPayViewController.h"
#import "CKConfirmRegisterOrderVC.h"
#import "CKOrderinfoModel.h"
#import "MineModel.h"
#import "CacheManager.h"
#import "SCUseCouponViewController.h"//优惠券统计
#import "XWAlterVeiw.h"
#import "WXApi.h"
#import "CKSmallTipsViewController.h" //小窍门
#import "CKTrainsExamViewController.h" //培训考试
#import "FFWarnAlertView.h"
#import "CKMainPageModel.h"
#import "CKNotificationCenterViewController.h"
#import "CKConfrimRegistMsgViewController.h"
#import "CKMineTableViewCell.h"
#import "CKConfrimSharePersonViewController.h"
#import "CKLeaderInfoModel.h"
#define HeaderHeight AdaptedHeight(160)

static NSString *firstCellIdentifier = @"ShareCodeTableViewCell";
static NSString *secondCellIdentifier = @"MineTableViewCell";

@interface DMineViewController ()<BarCodeAlterVeiwDelegate, InvitationAlterVeiwDelegate, MineHeaderViewDelagate, UITableViewDelegate,  UITableViewDataSource, XWAlterVeiwDelegate, CKSchemeToolTableViewCellDelegate, CKUsefulToolTableViewCellDelegate, CKMineSPCellDelegate, CKNewerDLBTestCellDelegate>

@property (nonatomic, strong) InvitationAlterVeiw *inviteAlert;
@property (nonatomic, strong) UIImageView *topBankmageView;
@property (nonatomic, copy)   NSString *ckidString;
@property (nonatomic, copy)   NSString *statusString;
@property (nonatomic, copy)   NSString *checkStatus;
@property (nonatomic, copy)   NSString *qrcodeurl; //店铺二维码
@property (nonatomic, copy)   NSString *invitecode; //邀请码
@property (nonatomic, copy)   NSString *shopUrl; //店铺链接
@property (nonatomic, copy)   NSString *tgidString; //推广员id
@property (nonatomic, copy)   NSString *joinTypeString;
@property (nonatomic, copy)   NSString *isShowStock;
@property (nonatomic, copy)   NSString *stockNum;
@property (nonatomic, strong) UITableView *mineTableView;
@property (nonatomic, strong) BarCodeAlterVeiw *barCodeView;
@property (nonatomic, strong) MineModel *mineModel;
@property (nonatomic, strong) NSArray *mustIconArray;//必备工具图标
@property (nonatomic, strong) NSArray *titleArray;//必备工具标题
@property (nonatomic, strong) NSArray *tgIconArray;//推广工具图标
@property (nonatomic, strong) NSArray *tgTitleArray;//推广工具标题
@property (nonatomic, copy)   NSString *typeString; //创客类型

@property (nonatomic, strong) MineHeaderView *mineHeaderView;

@property (nonatomic, strong) NSMutableArray *tableDataArr;

@end

@implementation DMineViewController

-(NSMutableArray *)tableDataArr {
    if (_tableDataArr == nil) {
        _tableDataArr = [NSMutableArray array];
    }
    return _tableDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate.isToothVc = @"NO";
    [self initalizeComponent];
    
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 初始化界面
-(void)initalizeComponent {
    _tgidString = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    if (IsNilOrNull(_tgidString)){
        _tgidString = @"0";
    }
    
    self.mineModel = [[MineModel alloc] init];
    
    _ckidString = KCKidstring;
    if(!IsNilOrNull(_ckidString)){
        NSString *mineId = [NSString stringWithFormat:@"mine_%@",_ckidString];
        NSData *mineData = [KUserdefaults objectForKey:mineId];
        MineModel *mineM = [NSKeyedUnarchiver unarchiveObjectWithData:mineData];
        self.mineModel = mineM;
    }
    [self createTableView];
    
    [self bindData];
        
    //更改个人资料成功后要刷新个人中心数据
    [CKCNotificationCenter addObserver:self selector:@selector(requestMineData) name:@"ChangeProfileSuccessNotification" object:nil];
    //更改个人头像成功后要刷新个人中心数据
    [CKCNotificationCenter addObserver:self selector:@selector(requestMineData) name:@"ChangeHeadIconSuccessNotification" object:nil];
    //更改密码成功后要刷新个人中心数据
    [CKCNotificationCenter addObserver:self selector:@selector(requestMineData) name:@"ChangePasswordSuccessNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    //调用接口失败 重新请求
    [CKCNotificationCenter addObserver:self selector:@selector(requestMineData) name:@"RequestFail" object:nil];
    //注册完成后要刷新界面
    [CKCNotificationCenter addObserver:self selector:@selector(updateUI) name:@"UpdateUIToLoginSuccessNoti" object:nil];
    
}

#pragma mark - 更新UI
-(void)updateUI {
    [self updateMineUI];
}

-(void)updateMineUI {
    
    _ckidString = KCKidstring;
    
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if([homeLoginStatus isEqualToString:@"homelogin"]){ //登录
        [self refreshUI];
        //每次页面出现就刷新个人中心数据
        [self requestMineData];
        //只要登录成功就刷新status值
        [self requestShopStatus];
    }else{
        //如果没有登录则显示默认界面
        _typeString = nil;
        _mineHeaderView.headImageView.image = [UIImage imageNamed:@"name"];
        _mineHeaderView.btn.hidden = YES;
        _mineHeaderView.myLevelBtn.hidden = YES;
        _mineHeaderView.typeLable.hidden = YES;
        _mineHeaderView.gradeButton.hidden = YES;
        _mineHeaderView.shopNameLable.text = @"您的账户还未登录";
        [_mineHeaderView.shopNameLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_mineHeaderView.headImageView.mas_centerY).offset(AdaptedHeight(10));
        }];

        
        [self bindData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self updateMineUI];
}

#pragma mark - 初始化tableView
- (void)createTableView {
    if (self.mineTableView == nil) {
        self.mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviAddHeight-49-BOTTOM_BAR_HEIGHT) style:UITableViewStyleGrouped];
        self.mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mineTableView.rowHeight = UITableViewAutomaticDimension;
        self.mineTableView.estimatedRowHeight = 44;
        if (@available(iOS 11.0, *)){
            self.mineTableView.estimatedSectionHeaderHeight = 0;
            self.mineTableView.estimatedSectionFooterHeight = 0;
        }
        
        self.mineTableView.delegate = self;
        self.mineTableView.dataSource = self;
        self.mineTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:self.mineTableView];
        [self.mineTableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:secondCellIdentifier];

        _topBankmageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderHeight)];
        _topBankmageView.image = [UIImage imageNamed:@"mineBankImage"];
        _topBankmageView.userInteractionEnabled = YES;
        _mineHeaderView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderHeight)];
        _mineHeaderView.backgroundColor = [UIColor clearColor];
        _mineHeaderView.delegate = self;
        _mineHeaderView.btn.hidden = YES;
        _mineHeaderView.myLevelBtn.hidden = YES;
        [_topBankmageView addSubview:_mineHeaderView];
        self.mineTableView.tableHeaderView = _topBankmageView;
    }
}

#pragma mark - 绑定数据
- (void)bindData {
    [self.tableDataArr removeAllObjects];
    
    //ckappcoupon  我的优惠券 显示开关  1：开启   其它： 关闭
    NSString *ckappcoupon = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_ckappcoupon"]];
    BOOL showCoupon = NO;
    if ([ckappcoupon isEqualToString:@"1"]){
        showCoupon = YES;
    }
    
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if ([homeLoginStatus isEqualToString:@"homelogin"]) {
        
        _tgidString = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KSales]];
        if (IsNilOrNull(_tgidString)) {
            _tgidString = @"0";
        }
        if (![_tgidString isEqualToString:@"0"]){//推广员登录
            CellModel *userfulToolM = [self createCellModel:[CKUsefulToolTableViewCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[CKMineCommon userUsefulToolTitleArray:@"TG" showCoupon:NO], @"titleArr", [CKMineCommon userUsefulToolIconArray:@"TG" showCoupon:NO], @"imgArr", nil] height:[CKUsefulToolTableViewCell computeHeight:[CKMineCommon userUsefulToolTitleArray:@"TG" showCoupon:NO]]];
            userfulToolM.delegate = self;
            SectionModel *section2 = [self createSectionModel:@[userfulToolM] headerHeight:10.0 footerHeight:10.0];
            [self.tableDataArr addObject:section2];
        }else{
            
            NSString *status = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KStatus]];
            if ([homeLoginStatus isEqualToString:@"homelogin"] && [status isEqualToString:@"PAY"]) {
                
                // ckappleader 我的管理者显示开关 ：1：开启  其他：关闭
                NSString *ckappleader = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:@"CKYS_ckappleader"]];
                if ([ckappleader isEqualToString:@"1"]) {
                    NSString *url = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getLeaderInfo_Url];
                    NSDictionary *params = @{@"ckid":_ckidString};
                     CKLeaderInfoModel *leaderInfoModel = [[CKLeaderInfoModel alloc]init];
                    [HttpTool getWithUrl:url params:params success:^(id json) {
                        NSDictionary *dict = json;
                        if ([dict[@"isvisible"] integerValue] == 1){
    
                            [leaderInfoModel setValuesForKeysWithDictionary:dict];
                            
                        }else{
                            [self.tableDataArr removeObjectAtIndex:0];
                        }
                        [self.mineTableView reloadData];
                    } failure:^(NSError *error) {
                        
                    }];
                    
                    CellModel *MyGovernorModel = [self createCellModel:[CKMyGovernorCell class] userInfo:leaderInfoModel height:[CKMyGovernorCell computeHeight:leaderInfoModel]];
                    SectionModel *sectionMg =  [self createSectionModel:@[MyGovernorModel] headerHeight:0.1 footerHeight:0.1];
                    [self.tableDataArr addObject:sectionMg];
                }
                
                //ckappgift  考试显示开关：  1：开启   其它：关闭
                NSString *ckappgift = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_ckappgift"]];
                if ([ckappgift isEqualToString:@"1"]) {
                    //0未考试 1考试未通过 2 通过 3 超期未通过（无礼包销售权）
                    NSString *giftshare = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"giftshare"]];
                    if (![giftshare isEqualToString:@"2"]) {
                        NSString *typeStr = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Ktype]];
                        if ([typeStr isEqualToString:@"B"]) {
                            CellModel *testModel;
                            if (IPHONE_X) {
                                testModel = [self createCellModel:[CKNewerDLBTestCell class] userInfo:nil height:AdaptedHeight(50)];
                            }else{
                                testModel = [self createCellModel:[CKNewerDLBTestCell class] userInfo:nil height:AdaptedHeight(60)];
                            }
                            testModel.delegate = self;
                            SectionModel *sectionT = [self createSectionModel:@[testModel] headerHeight:10 footerHeight:10];
                            [self.tableDataArr addObject:sectionT];
                        }
                    }
                }
            }
            
            NSString *serviceprovider = [NSString stringWithFormat:@"%@", self.mineModel.serviceprovider];
            
            if (![serviceprovider isEqualToString:@"0"] && !IsNilOrNull(serviceprovider)) {
                CellModel *SPModel;
                if (IPHONE_X) {
                    SPModel = [self createCellModel:[CKMineSPCell class] userInfo:nil height:AdaptedHeight(50)];
                }else{
                    SPModel = [self createCellModel:[CKMineSPCell class] userInfo:nil height:AdaptedHeight(60)];
                }
                SPModel.delegate = self;
                SectionModel *section0 = [self createSectionModel:@[SPModel] headerHeight:10.0 footerHeight:10.0];
                [self.tableDataArr addObject:section0];
            }
            
            
           
            [self addToolSection:showCoupon];
        }
        
    }else{
        [self addToolSection:showCoupon];
    }
    
    [self.mineTableView reloadData];
}

- (void)addToolSection:(BOOL)showCoupon {
    CellModel *schemeToolM = [self createCellModel:[CKSchemeToolTableViewCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[CKMineCommon userSchemeToolTitleArray:_typeString], @"titleArr", [CKMineCommon userSchemeToolIconArray:_typeString], @"imgArr", nil] height:[CKSchemeToolTableViewCell computeHeight:[CKMineCommon userSchemeToolTitleArray:_typeString]]];
    schemeToolM.delegate = self;
    SectionModel *section1 = [self createSectionModel:@[schemeToolM] headerHeight:30.0 footerHeight:10.0];
    [self.tableDataArr addObject:section1];
    
    CellModel *userfulToolM = [self createCellModel:[CKUsefulToolTableViewCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[CKMineCommon userUsefulToolTitleArray:_typeString showCoupon:showCoupon], @"titleArr", [CKMineCommon userUsefulToolIconArray:_typeString showCoupon:showCoupon], @"imgArr", nil] height:[CKUsefulToolTableViewCell computeHeight:[CKMineCommon userUsefulToolTitleArray:_typeString showCoupon:showCoupon]]];
    userfulToolM.delegate = self;
    SectionModel *section2 = [self createSectionModel:@[userfulToolM] headerHeight:30.0 footerHeight:10.0];
    [self.tableDataArr addObject:section2];
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

#pragma mark - UITableViewDataSourceDelegate
#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_tableDataArr){
        return _tableDataArr.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SectionModel *s = _tableDataArr[section];
    if(s.cells) {
        return s.cells.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModel *s = _tableDataArr[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    
    CKMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item.reuseIdentifier];
    if(!cell) {
        cell = [[NSClassFromString(item.className) alloc] initWithStyle:item.style reuseIdentifier:item.reuseIdentifier];
    }
    cell.selectionStyle = item.selectionStyle;
    cell.accessoryType = item.accessoryType;
    cell.delegate = item.delegate;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModel *s = _tableDataArr[indexPath.section];
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
    SectionModel *s = _tableDataArr[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    return item.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SectionModel *s = _tableDataArr[section];
    return s.headerhHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SectionModel *s = _tableDataArr[section];
    return s.footerHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    UILabel *headerLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [headerView addSubview:headerLable];
    [headerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(AdaptedWidth(10));
    }];
    UILabel *headerLine = [UILabel creatLineLable];
    [headerView addSubview:headerLine];
    [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerLable.mas_bottom);
        make.left.mas_offset(AdaptedWidth(10));
        make.right.mas_offset(-AdaptedWidth(10));
        make.bottom.mas_offset(0);
        make.height.mas_offset(1);
    }];
  
    if (self.tableDataArr.count >=2) {
        if (section == self.tableDataArr.count - 1){
            headerLable.text = @"必备工具";
        }else if(section == self.tableDataArr.count - 2){
            headerLable.text = @"推广工具";
        }else{
            return nil;
        }
    }else{
        headerLable.text = @"必备工具";
    }
    return headerView;
}

#pragma mark -请求店铺状态，是否锁定，未支付，待完善资料
-(void)requestShopStatus {
    _ckidString = KCKidstring;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, checkStatus_Url];
    if (IsNilOrNull(_ckidString) || [_ckidString isEqualToString:@"-1"]){
        _ckidString = @"";
        return;
    }
    NSDictionary *pramaDic = @{@"ckid":_ckidString};
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
        }else{
            //status 店铺状态  CLOSE、PAY
            _checkStatus = [NSString stringWithFormat:@"%@",dict[@"status"]];
            [KUserdefaults setObject:_checkStatus forKey:KCheckStatus];
            [KUserdefaults synchronize];
        }
    } failure:^(NSError *error) {
        NSLog(@"检验是否可点击失败:%@", error);
    }];
}

-(void)defaultTableViewFrame {
    _mineTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- NaviAddHeight-49-BOTTOM_BAR_HEIGHT);
}

-(void)changeTableViewFrame {
    _mineTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT- 64 - 49 - BOTTOM_BAR_HEIGHT);
}

#pragma mark - 请求个人中心数据
- (void)requestMineData {
    
    NSLog(@"****************++++++++个人中心请求数据++++++*************");
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString) || [_ckidString isEqualToString:@"-1"]) {
        _ckidString = @"";
        return;
    }
    if (IsNilOrNull(_tgidString)){
        _tgidString = @"0";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    // 请求服务端数据
    NSString *getMineUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getMyZoneData_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString, @"tgid":_tgidString, DeviceId:uuid};
    [HttpTool postWithUrl:getMineUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        //0未考试 1考试未通过 2 通过 3 超期未通过（无礼包销售权）
        NSString *giftshare = [NSString stringWithFormat:@"%@", [dict objectForKey:@"giftshare"]];
        if (!IsNilOrNull(giftshare)) {
            [KUserdefaults setObject:giftshare forKey:@"giftshare"];
        }
        
        [self processMineData:dict];
        //刷新数据
        [self refreshUI];
        
        [self bindData];
        
        
    } failure:^(NSError *error) {
        NSLog(@"错误%@",error.localizedDescription);
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [CKCNotificationCenter postNotificationName:@"RequestFail" object:nil];
            }
                break;
            default: {
                NSLog(@"请检查网络设置");
            }
                break;
        }
    }];
}

-(void)processMineData:(NSDictionary*)dict {
    
    self.mineModel = [[MineModel alloc] init];
    [self.mineModel setValuesForKeysWithDictionary:dict];
    
    //保存用户头像
    NSString *headurl = [NSString stringWithFormat:@"%@", dict[@"headurl"]];
    if (!IsNilOrNull(headurl)) {
        [KUserdefaults setValue:headurl forKey:@"CKYS_USER_HEAD"];
        [KUserdefaults setObject:headurl forKey:kheamImageurl];
        [KUserdefaults synchronize];
    }
    
    
    //更新本地status状态 type状态
    NSString *statusString = [NSString stringWithFormat:@"%@", self.mineModel.status];
    if (IsNilOrNull(statusString)) {
        statusString = @"";
    }
    [KUserdefaults setObject:statusString forKey:KStatus];
    _statusString = statusString;

    NSString *type = [NSString stringWithFormat:@"%@",self.mineModel.type];
    if (IsNilOrNull(type)) {
        type = @"";
    }
    [KUserdefaults setObject:type forKey:Ktype];
    _typeString = type;

    NSString *jointype = [NSString stringWithFormat:@"%@",self.mineModel.jointype];
    if (IsNilOrNull(jointype)) {
        jointype = @"";
    }
    [KUserdefaults setObject:jointype forKey:KjoinType];
    _joinTypeString = jointype;

    NSData *modelToData = [NSKeyedArchiver archivedDataWithRootObject:self.mineModel];
    NSString *mineId = [NSString stringWithFormat:@"mine_%@",_ckidString];
    [KUserdefaults setObject:modelToData forKey:mineId];
    [KUserdefaults synchronize];
    
    _invitecode = [NSString stringWithFormat:@"%@",self.mineModel.invitecode];
    if (IsNilOrNull(_typeString)){
        _typeString = @"";
    }
    _tgidString = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    //股权只有创客显示 分销不显示   推广员登录不显示股权 incomeorstock=2表示显示股权，1不显示股权
    _isShowStock = [NSString stringWithFormat:@"%@", self.mineModel.incomeorstock];
    _stockNum = [NSString stringWithFormat:@"%@", self.mineModel.stocknum];
    _shopUrl =  [NSString stringWithFormat:@"%@", self.mineModel.shopurl];
    if (IsNilOrNull(_tgidString)){
        _tgidString = @"0";
    }
    if (IsNilOrNull(_isShowStock)){
        _isShowStock = @"2";
    }
    if (IsNilOrNull(_stockNum)){
        _stockNum = @"";
    }
    if(IsNilOrNull(_shopUrl)){
        _shopUrl = @"";
    }
}

- (void)refreshUI {
    NSString *headurl = [NSString stringWithFormat:@"%@", self.mineModel.headurl];
    NSString *picUrl = [NSString loadImagePathWithString:headurl];
    
    [_mineHeaderView.headImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"name"]];

    NSString *shopName = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KshopName]];
    NSString *nickName = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KnickName]];
    if (IsNilOrNull(nickName)) {
        nickName = @"";
    }
    if (IsNilOrNull(shopName)) {
        shopName = nickName;
    }
    _mineHeaderView.shopNameLable.text = shopName;
    
    _isShowStock = @"2";  //请求失败显示股权
    if (IsNilOrNull(_isShowStock)) {
        _isShowStock = @"";
    }
    if (IsNilOrNull(_stockNum)) {
        _stockNum = @"";
    }
    
    NSString *typeStr = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Ktype]];
    
    if (IsNilOrNull(_ckidString)){
        _mineHeaderView.btn.hidden = YES;
        _mineHeaderView.myLevelBtn.hidden = YES;
        _mineHeaderView.typeLable.hidden = YES;
        _mineHeaderView.gradeButton.hidden = YES;
    }else{
        _mineHeaderView.btn.hidden = NO;
        _mineHeaderView.myLevelBtn.hidden = NO;
    }
    
    if ([typeStr isEqualToString:@"B"]) {
        _mineHeaderView.gradeButton.hidden = YES;
        if ([_tgidString isEqualToString:@"0"]){  //普通创客
            [_mineHeaderView.shopNameLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_mineHeaderView.headImageView.mas_centerY).offset(-3);
            }];
            _mineHeaderView.typeLable.hidden = NO;
            _mineHeaderView.typeLable.text = @"创客";
        }else{ //推广员登录
            [_mineHeaderView.shopNameLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_mineHeaderView.headImageView.mas_centerY).offset(AdaptedHeight(10));
            }];
            _mineHeaderView.btn.hidden = YES;
            _mineHeaderView.myLevelBtn.hidden = YES;
            _mineHeaderView.typeLable.hidden = YES;
        }
        
    }else if([typeStr isEqualToString:@"D"]){
        [_mineHeaderView.shopNameLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_mineHeaderView.headImageView.mas_centerY).offset(-3);
        }];
        _mineHeaderView.gradeButton.hidden = NO;
        _mineHeaderView.typeLable.hidden = YES;
        
    }
    if (![_statusString isEqualToString:@"PAY"]) {
        _mineHeaderView.gradeButton.hidden = YES;
    }
}

#pragma mark - 推广工具代理方法

-(void)extendCell:(CKSchemeToolTableViewCell *)extendCell didSelectItem:(NSString *)item {
    
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if(![homeLoginStatus isEqualToString:@"homelogin"]){
        
        NSString *unionid = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:Kunionid]];
        NSString *exitRegisterState = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KexitRegister]];
        if(!IsNilOrNull(unionid) && [exitRegisterState isEqualToString:@"1"]){
            if (IsNilOrNull(_ckidString)) {
//                CKConfrimRegistMsgViewController *regist = [[CKConfrimRegistMsgViewController alloc] init];
//                RootNavigationController *navi = [[RootNavigationController alloc] initWithRootViewController:regist];
//                [self presentViewController:navi animated:YES completion:^{
//                }];
                [self checkUpgradeOrder];
            }else{
                LoginViewController *login = [[LoginViewController alloc] init];
                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                }];
            }
        }else{
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
            }];
        }
    }else{
        [self enterItemWithName:item andTypeStr:_checkStatus];
    }
}

#pragma mark - 点击必备工具
- (void)didSelectedItem:(CKUsefulToolTableViewCell *)cell itemName:(NSString *)itemName {
    NSString *exitRegisterState = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KexitRegister]];
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if(![homeLoginStatus isEqualToString:@"homelogin"]){
        
        if([itemName isEqualToString:@"帮助"]){
            [self comeToHelpVC];
        }else if([itemName isEqualToString:@"设置"]){
            [self comeToSetUpVc];
        }else{
            NSString *unionid = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:Kunionid]];
            if ([itemName isEqualToString:@"在线客服"]){
                if(!IsNilOrNull(unionid)){
                    [self comeToWisdomTootchVC];
                }else{
                    LoginViewController *login = [[LoginViewController alloc] init];
                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                    }];
                }
            }else if ([itemName isEqualToString:@"通知"]){
                                 if(!IsNilOrNull(unionid) && [exitRegisterState isEqualToString:@"1"]){
                    if (!IsNilOrNull(_ckidString)){
                        [self comeToNotificationCenter];
                    }else{
                        LoginViewController *login = [[LoginViewController alloc] init];
                        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                        }];
                    }
                }else{
                    LoginViewController *login = [[LoginViewController alloc] init];
                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                    }];
                }
            }else{//缺少是否存在订单的判断
                if(!IsNilOrNull(unionid)&& [exitRegisterState isEqualToString:@"1"]){
                    if (IsNilOrNull(_ckidString)) {
//                        CKConfrimRegistMsgViewController *regist = [[CKConfrimRegistMsgViewController alloc] init];
//                        RootNavigationController *navi = [[RootNavigationController alloc] initWithRootViewController:regist];
//                        [self presentViewController:navi animated:YES completion:^{
//                        }];
                        [self checkUpgradeOrder];
                    }else{
                        LoginViewController *login = [[LoginViewController alloc] init];
                        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                        }];
                    }
                }else{
                    LoginViewController *login = [[LoginViewController alloc] init];
                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                    }];
                }
            }
        }
    }else{ //跳过支付注册的创客或者分销的type为购买的礼包type，换手机登录会返回type
        [self enterItemWithName:itemName andTypeStr:_checkStatus];
    }
}

#pragma mark - 点击推广和必备工具item
-(void)enterItemWithName:(NSString*)itemName andTypeStr:(NSString*)status {
    
    if ([itemName isEqualToString:@"帮助"]){
        [self comeToHelpVC];
    }else if ([itemName isEqualToString:@"设置"]){
        [self comeToSetUpVc];
    }else if ([itemName isEqualToString:@"通知"]){
        [self comeToNotificationCenter];
    }else if ([itemName isEqualToString:@"在线客服"]){
        [self comeToWisdomTootchVC];
    }else{
        if ([self checkStatusWithCheckStatus:status]) {
            if ([itemName isEqualToString:@"礼包销售"]) {//我的团队->礼包销售
                [self comeToMyTeamVC];
            }else if ([itemName isEqualToString:@"我的云豆"]){ //我的云豆
                [self comeToMyYunDou];
            }else if ([itemName isEqualToString:@"我的产品库"]){ //我的产品库
                [self comeToMyProductVC];
            }else if ([itemName isEqualToString:@"我要自提"]){ //我要自提
                [self comeToCarryBySelfVC];
            }else if ([itemName isEqualToString:@"商品管理"]){ //商品管理
                [self comeToShopManageVC];
            }else if ([itemName isEqualToString:@"小窍门"]){ //小窍门
                [self comeToSmallTipsVC];
            }else if ([itemName isEqualToString:@"地址管理"]){ //地址管理
                [self comeToMyAddressVC];
            }else if ([itemName isEqualToString:@"素材中心"]){ //素材中心
                [self comeToMySourceVC];
            }else if([itemName isEqualToString:@"线下体验店"]){ //线下体验店
                [self comeToAllOfflineShopVC];
            }else if ([itemName isEqualToString:@"股权激励"]){ //股权激励
//                [self getMyStockUrlData];
            }else if ([itemName isEqualToString:@"我的业绩"]){ //我的业绩
                [self comeToMyResultsVC];
            }else if ([itemName isEqualToString:@"优惠券统计"]){ //优惠券统计
                [self comeToCoupons];
            }else if([itemName isEqualToString:@"资金管理"]){ //资金管理
                TGFundMnageViewController *tgFundVC = [[TGFundMnageViewController alloc] init];
                [self.navigationController pushViewController:tgFundVC animated:YES];
            }else if ([itemName isEqualToString:@"基础培训"]){
//                [self comeToBaseTrain];
            }else if ([itemName isEqualToString:@"二维码"]){
                [self showQRCode];
            }else if ([itemName isEqualToString:@"邀请码"]){
                [self invitationCode];
            }else if ([itemName isEqualToString:@"店铺链接"]){
                [self copyMyShopUrl];
            }else if ([itemName isEqualToString:@"分享"]){
                [self shareToYourFriends];
            }
        }
    }
}

#pragma mark - 我的团队（软件推广-礼包销售）
-(void)comeToMyTeamVC {
    CKDLBSealViewController *myTeamVC = [[CKDLBSealViewController alloc] init];
    myTeamVC.type = self.mineModel.type;
    myTeamVC.joinType = self.mineModel.jointype;
    myTeamVC.headImageUrl = self.mineModel.headurl;
    [self.navigationController pushViewController:myTeamVC animated:YES];
}

#pragma mark - 我的云豆
-(void)comeToMyYunDou {
    CKCloudBeanViewController *beanVC = [[CKCloudBeanViewController alloc] init];
    beanVC.joinType = _joinTypeString;
    beanVC.type = _typeString;
    [self.navigationController pushViewController:beanVC animated:YES];
}

#pragma mark - 我的产品库
-(void)comeToMyProductVC {
    NSString *monthcalmode = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_monthcalmode"]];
    //1：新的  0：老的
    if ([monthcalmode isEqualToString:@"1"]) {
        CKMyProductLibVC *pLibVC = [[CKMyProductLibVC alloc] init];
        [self.navigationController pushViewController:pLibVC animated:YES];
    }else{
        CKMyProductLibVCOld *pLibVC = [[CKMyProductLibVCOld alloc] init];
        [self.navigationController pushViewController:pLibVC animated:YES];
    }
}

#pragma mark - 我要自提
-(void)comeToCarryBySelfVC {
    CKSelfPickUpViewController *carrySelf = [[CKSelfPickUpViewController alloc] init];
    [self.navigationController pushViewController:carrySelf animated:YES];
}

#pragma mark - 商品管理
-(void)comeToShopManageVC {
    CKGoodsManagerViewController *shopManager = [[CKGoodsManagerViewController alloc] init];
    [self.navigationController pushViewController:shopManager animated:YES];
}

#pragma mark - 小窍门
- (void)comeToSmallTipsVC {
    CKSmallTipsViewController *samllTips = [[CKSmallTipsViewController alloc] init];
    [self.navigationController pushViewController:samllTips animated:YES];
}

#pragma mark - 地址管理
-(void)comeToMyAddressVC {
    //地址管理
    ChangeMyAddressViewController *address = [[ChangeMyAddressViewController alloc] init];
    address.pushString = @"0";  //从我的页面跳过去
    [self.navigationController pushViewController:address animated:YES];
}

#pragma mark - 素材中心
-(void)comeToMySourceVC{
    SourceMaterialViewController *source = [[SourceMaterialViewController alloc] init];
    [self.navigationController pushViewController:source animated:YES];
}

#pragma mark - 线下体验店
-(void)comeToAllOfflineShopVC {
    NSString *cityString = [KUserdefaults objectForKey:@"currentCityStr"];
    NSString *provinceString = [KUserdefaults objectForKey:@"currentProvinceStr"];
    
    if (IsNilOrNull(provinceString)){
        provinceString = @"陕西省";
    }
    if (IsNilOrNull(cityString)) {
        cityString = @"西安市";
    }
    
    CKMapManager *manager = [CKMapManager manager];
    OfflineShopViewController *offline = [[OfflineShopViewController alloc] init];
    offline.provinceString = provinceString;
    offline.cityString = cityString;
    offline.shopListArray = manager.annotationsArray;
    [self.navigationController pushViewController:offline animated:YES];
}

#pragma mark - 查看股权
-(void)getMyStockUrlData {
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    if(_ckidString && _ckidString.length > 0){
        
        CKHaveStockViewController *ckhaveStock = [[CKHaveStockViewController alloc] init];
        [self.navigationController pushViewController:ckhaveStock animated:YES];
    }
}

#pragma mark - 我的业绩
-(void)comeToMyResultsVC {
    MyResultsViewController *myResultsVC = [[MyResultsViewController alloc] init];
    [self.navigationController pushViewController:myResultsVC animated:YES];
}

#pragma mark - 优惠券统计
-(void)comeToCoupons {
    SCUseCouponViewController *coupons = [[SCUseCouponViewController alloc] init];
    [self.navigationController pushViewController:coupons animated:YES];
}

#pragma mark - 基础培训
-(void)comeToBaseTrain {
    WebDetailViewController *helpVC = [[WebDetailViewController alloc] init];
    helpVC.typeString = @"baseTrain";
    NSString *lightUrl = @"http://c.eqxiu.com/s/aa2thFve";
    helpVC.detailUrl = lightUrl;
    [self.navigationController pushViewController:helpVC animated:YES];
}

#pragma mark - 通知中心
- (void)comeToNotificationCenter {
    CKNotificationCenterViewController *notiCenter = [[CKNotificationCenterViewController alloc] init];
    [self.navigationController pushViewController:notiCenter animated:YES];
}

#pragma mark - 帮助
-(void)comeToHelpVC {
    NSString *helpUrl = @"";
    RLMResults *result = [[CacheData shareInstance] search:[CKMainPageModel class]];
    if (result.count > 0) {
        CKMainPageModel *mainM = result.firstObject;
        helpUrl = [NSString stringWithFormat:@"%@", mainM.helpurl];
    }
    WebDetailViewController *helpVC = [[WebDetailViewController alloc] init];
    helpVC.typeString = @"help";
    helpVC.detailUrl = helpUrl;
    [self.navigationController pushViewController:helpVC animated:YES];
}

#pragma mark - 设置界面
-(void)comeToSetUpVc {
    CKSettingsViewController *setUp = [[CKSettingsViewController alloc] init];
    [self.navigationController pushViewController:setUp animated:YES];
}

#pragma mark - XWAletViewDelegate --- 培训考试
-(void)subuttonClicked {
    CKTrainsExamViewController *exam = [[CKTrainsExamViewController alloc] init];
    [self.navigationController pushViewController:exam animated:YES];
}

#pragma mark - 复制店铺链接
-(void)copyMyShopUrl {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (IsNilOrNull(_shopUrl)){
        _shopUrl = @"";
    }
    [pasteboard setString:_shopUrl];
    NSLog(@"好不容易找到你-----复制的内容：%@",pasteboard.string);
    if(pasteboard == nil){
        [self showNoticeView:@"复制失败"];
    }else{
        [self showNoticeView:@"复制成功"];
    }
}

#pragma mark - 展示二维码
-(void)showQRCode{
    [[[CKMineCommon alloc]init] requestQRcode:^(NSString *qrcodeUrl, NSString *localQr, BOOL qrtype) {
        _qrcodeurl = qrcodeUrl;
        NSLog(@"传过来的链接%@",qrcodeUrl);
        
        if (qrtype == YES) {
            [self popQrView];
        }else{
            self.barCodeView = [[BarCodeAlterVeiw alloc] init];
            self.barCodeView.delegate = self;
            self.barCodeView.titleLable.text = @"扫一扫二维码，进入我的店铺";
            [self.barCodeView.titleImageView sd_setImageWithURL:[NSURL URLWithString:qrcodeUrl] placeholderImage:[UIImage imageNamed:@"waitgoods"] options:SDWebImageRefreshCached];
            [self.barCodeView show];
        }
    }];
}

-(void)popQrView {
    [[XLImageViewer shareInstanse] showNetImages:@[_qrcodeurl] index:0 from:self.view];
}

#pragma mark - 邀请码
- (void)invitationCode {
    
    //ckappgift  考试显示开关：  1：开启   其它：关闭
    NSString *ckappgift = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_ckappgift"]];
    if ([ckappgift isEqualToString:@"1"]) {
        //如果没有通过考试则提示
        NSString *giftshare = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"giftshare"]];
        if (![giftshare isEqualToString:@"2"]) {
            XWAlterVeiw *alert = [[XWAlterVeiw alloc] init];
            alert.delegate = self;
            alert.titleLable.text = @"您还未参与新人入门考试，无法查看邀请码，赶紧参与考试吧！";
            [alert.sureBut setTitle:@"去考试" forState:UIControlStateNormal];
            [alert show];
        }else{
            self.inviteAlert = [[InvitationAlterVeiw alloc]init];
            self.inviteAlert.delegate = self;
            if (IsNilOrNull(_invitecode)) {
                _invitecode = @"";
                self.inviteAlert.titleLable.text = @"邀请码为空";
            }else{
                self.inviteAlert.titleLable.text = _invitecode;
            }
            [self.inviteAlert show];
        }
    }else{
        self.inviteAlert = [[InvitationAlterVeiw alloc]init];
        self.inviteAlert.delegate = self;
        if (IsNilOrNull(_invitecode)) {
            _invitecode = @"";
            self.inviteAlert.titleLable.text = @"邀请码为空";
        }else{
            self.inviteAlert.titleLable.text = _invitecode;
        }
        [self.inviteAlert show];
    }
    
}

#pragma mark - 分享店铺给朋友
-(void)shareToYourFriends {
    NSString *shopName = [NSString stringWithFormat:@"%@",self.mineModel.shopname];
    if(IsNilOrNull(shopName)){
        shopName = @"创客店铺";
    }
    NSString *shopHeadUrl = [NSString stringWithFormat:@"%@",self.mineModel.headurl];
    NSString *picUrl = [NSString loadImagePathWithString:shopHeadUrl];
    if (IsNilOrNull(picUrl)) {
        picUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, DefaultHeadPath];
    }
    if (IsNilOrNull(_shopUrl)) {
        _shopUrl = @"";
    }
    [CKShareManager shareToFriendWithName:shopName andHeadImages:picUrl andUrl:[NSURL URLWithString:_shopUrl] andTitle:@"创客云商"];
}

#pragma mark - 点击邀请码点击复制代理方法
-(void)copyInvitationCode {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.inviteAlert.titleLable.text;
    if(pasteboard == nil){
        [self showNoticeView:@"复制失败"];
    }else{
        [self showNoticeView:@"复制成功"];
    }
}

#pragma mark - 启动智齿客服
-(void)comeToWisdomTootchVC {
    [IQKeyboardManager sharedManager].enable = NO;
    self.appDelegate.isToothVc = @"YES";  //判断是否是智齿界面
    // 启动
    ZCLibInitInfo *initInfo = [ZCLibInitInfo new];
    // 企业编号 必填
    initInfo.appKey = WisdomTooth_AppKey;
    // 用户id，用于标识用户，建议填写
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if([homeLoginStatus isEqualToString:@"homelogin"]){
        NSString *mobile = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Kmobile]];
        if (!IsNilOrNull(mobile)) {
            initInfo.userId = [NSString stringWithFormat:@"创客APP%@", mobile];
        }
    }else{
        NSString *unionid = [KUserdefaults objectForKey:Kunionid];
        if (!IsNilOrNull(unionid)) {
            initInfo.userId = [NSString stringWithFormat:@"创客APP%@", unionid];
        }
    }
    
    //自定义用户参数
    [self customUserInformationWith:initInfo];
    
    ZCKitInfo *uiInfo=[ZCKitInfo new];
    // 自定义用户参数
    [self customerUI:uiInfo];
    
    [[ZCLibClient getZCLibClient] setLibInitInfo:initInfo];
    
    [ZCSobot startZCChatView:uiInfo with:self target:nil pageBlock:^(ZCUIChatController *object, ZCPageBlockType type) {
        // 点击返回
        if(type==ZCPageBlockGoBack){ // 点击返回
            self.appDelegate.isToothVc = @"NO";
            NSLog(@"点击了返回按钮");
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
            [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
            [IQKeyboardManager sharedManager].enable = YES;
            //返回以后关闭本次会话
//            [ZCLibClient closeAndoutZCServer:YES];
            [IQKeyboardManager sharedManager].enable = NO;
        }else if (type==ZCPageBlockLoadFinish){
            self.appDelegate.isToothVc = @"YES";
            // 加载界面完成，可对UI进行修改，此处不设置键盘弹起的高度不对
            [IQKeyboardManager sharedManager].enable = NO;
            [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        }
    } messageLinkClick:nil];
}
// 智齿SDK自定义UI示例
-(void)customerUI:(ZCKitInfo *)kitInfo{
    // 点击返回是否触发满意度评价
    kitInfo.isOpenEvaluation = YES;
    // 评价完人工是否关闭会话（人工满意度评价后释放会话）
    kitInfo.isCloseAfterEvaluation = YES;
    
    // 机器人优先模式，是否直接显示转人工按钮，默认YES
    kitInfo.isShowTansfer= YES;
}
// 自定义用户信息参数
- (void)customUserInformationWith:(ZCLibInitInfo*)initInfo{
    
    NSString *mobile = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Kmobile]];
    if (!IsNilOrNull(mobile)) {
        initInfo.phone = mobile;
    }
    NSString *realName = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Krealname]];
    if (!IsNilOrNull(realName)) {
        initInfo.realName = [NSString stringWithFormat:@"创客%@", realName];
    }
    NSString *headUrl = [NSString stringWithFormat:@"%@", self.mineModel.headurl];
    if (IsNilOrNull(headUrl)) {
        headUrl = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:kheamImageurl]];
    }
    
    // 用户头像url
    initInfo.avatarUrl = headUrl;
}

#pragma mark ******** 点击头部视图代理方法start ********
#pragma mark - 分销升级创客
-(void)fxToCKClick {
    //点击升级按钮 走升级的代理方法
    [MessageAlert shareInstance].isDealInBlock = YES;
    [[MessageAlert shareInstance] hiddenCancelBtn:NO];
    [[MessageAlert shareInstance] showCommonAlert:CKYSmsgtransup btnClick:^{
        _ckidString = KCKidstring;
        if (IsNilOrNull(_ckidString)){
            _ckidString = @"";
        }
        NSString *type = [NSString stringWithFormat:@"%@",self.mineModel.type];
        NSString *jointype = [NSString stringWithFormat:@"%@",self.mineModel.jointype];
        if ([type isEqualToString:@"B"]){
            if([jointype isEqualToString:@"NOTSURE"]){
                if ([self checkStatusWithCheckStatus:_statusString]) {
                    //零风险转正式创客
                    [self zeroRiskCKToForeverCK:_ckidString];
                }
            }
        }else if ([type isEqualToString:@"D"]) {
            if(IsNilOrNull(_ckidString)){  //未登录 跳转登录
                LoginViewController *login = [[LoginViewController alloc] init];
                [self  presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                }];
            }else{
                //分销升级创客，检查是否有订单
                [self checkUpgradeOrder];
            }
        }
    }];
}

//零风险转正式创客
-(void)zeroRiskCKToForeverCK:(NSString*)ckidStr {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, updateToSure_Url];
    NSDictionary *pramaDic = @{@"ckid":ckidStr, DeviceId:uuid};
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 完善个人资料代理方法
-(void)comeToEditMyInfoWith:(UIButton *)button{
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if(![homeLoginStatus isEqualToString:@"homelogin"]){  //未登录
        LoginViewController *login = [[LoginViewController alloc] init];
        [self  presentViewController:[[RootNavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
        }];
    }else{
        if([self checkIsCustomerCK]){ //普通创客
            //已登录
            //其他状态都直接跳转我的信息  只有 NOINFO 先提示再跳转
            if([_statusString isEqualToString:@"NOINFO"]){
                [self showNoticeView:CKYSmsgshopstatusUpdatePersonalInfo];
            }
            MinePersonalInfomationViewController *mineInfo =[[MinePersonalInfomationViewController alloc] init];
            
            [self.navigationController pushViewController:mineInfo animated:YES];
        }
    }
}
//暂时不用
-(void)checkMyLevel:(UIButton *)button {
    CKMyLevelViewController *myLevel = [[CKMyLevelViewController alloc] init];
    [self.navigationController pushViewController:myLevel animated:YES];
}
#pragma mark ******** 点击头部视图代理方法end ********

#pragma mark-点击保存二维码
-(void)saveToPhotobuttonClicked{
    //保存二维码到相册
    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_qrcodeurl]];//没有网的时候不能保存
    //    UIImage *image = [UIImage imageWithData:data];
    
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
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error == nil){
        [self showNoticeView:@"已保存"];
    }else{
        [self showNoticeView:@"图片保存失败"];
    }
}

#pragma mark - 比对本地缓存店铺状态与实时请求的店铺状态
-(BOOL)checkStatusWithCheckStatus:(NSString *)cheCKstatus {
    _ckidString = KCKidstring;
    if (IsNilOrNull(cheCKstatus)){
        cheCKstatus = @"";
    }
    NSLog(@"初始的状态是%@  最新状态%@",_statusString, cheCKstatus);
    NSString *localStatus = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KStatus]];
    if (IsNilOrNull(localStatus)) {
        localStatus = @"";
    }
    //  店铺状态（未支付：NOTPAY，未审核：NOTREVIEW，未完善个人资料：NOINFO，已开通：PAY，关闭：CLOSE）
    if(IsNilOrNull(_ckidString)){  //未登录 跳转登录
        LoginViewController *login = [[LoginViewController alloc] init];
        [self  presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
            
        }];
        return NO;
        
    }else{
        
        if(cheCKstatus && cheCKstatus.length > 0){
            //已登录 未支付  跳转支付页面
            if ([cheCKstatus isEqualToString:@"NOTPAY"]) {  //未付款
                [self checkUpgradeOrder];
                return NO;
            }else  if ([cheCKstatus isEqualToString:@"CLOSE"]){
                //已登录并且 已经付款 资料完善 店铺关闭  NOINFO/NOTREVIEW
                if ([localStatus isEqualToString:@"NOINFO"]) {
                    //跳转完善信息
                    [self showNoticeView:CKYSmsgshopstatusUpdatePersonalInfo];
                    MinePersonalInfomationViewController *mineInfo = [[MinePersonalInfomationViewController alloc] init];
                    [self presentViewController:[[RootNavigationController alloc] initWithRootViewController:mineInfo] animated:YES completion:^{}];
                    return NO;
                }else{
                    //提示店铺审核中
                    [self showNoticeView:CKYSmsgshopstatusPending];
                    return NO;
                }
                
            }else  if ([cheCKstatus isEqualToString:@"NOOPEN"]){//预售店待开通
                if ([localStatus isEqualToString:@"NOINFO"]) { //未完善资料
                    //跳转完善信息
                    MinePersonalInfomationViewController *mineInfo = [[MinePersonalInfomationViewController alloc] init];
                    [self presentViewController:[[RootNavigationController alloc] initWithRootViewController:mineInfo] animated:YES completion:^{}];
                    return NO;
                }else if([localStatus isEqualToString:@"NOOPEN"]){
                    //提示店铺审核中
                    [self showNoticeView:CKYSmsgshopstatusConnectCKOpen];
                    return NO;
                }else{
                    [self showNoticeView:CKYSmsgshopstatusPending];
                    return NO;
                }
                
            }else if ([cheCKstatus isEqualToString:@"PAY"]){
                //正常情况
                
                return YES;
            }else{
                //创客数据被删除 status不存在
                [[CacheManager shareInstance] cleanLoginStatusData];
                return NO;
            }
            
        }else{  //如果获取最新的checkStatus为空
            //已登录 未支付  跳转支付页面
            if ([localStatus isEqualToString:@"NOTPAY"]) {  //未付款
                [self checkUpgradeOrder];
                return NO;
            }else  if ([localStatus isEqualToString:@"NOINFO"]){
                //已登录并且 已经付款 资料完善 店铺关闭  NOINFO/NOTREVIEW
                [self showNoticeView:CKYSmsgshopstatusUpdatePersonalInfo];
                MinePersonalInfomationViewController *mineInfo = [[MinePersonalInfomationViewController alloc] init];
                [self presentViewController:[[RootNavigationController alloc] initWithRootViewController:mineInfo] animated:YES completion:^{}];
                return NO;
                
            }else if ([localStatus isEqualToString:@"NOTREVIEW"]){
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
                //创客数据被删除 status不存在
                [[CacheManager shareInstance] cleanLoginStatusData];
                return NO;
                
            }
        }
        return NO;
    }
}

-(BOOL)checkIsCustomerCK{
    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    _tgidString = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    if (IsNilOrNull(_tgidString)) {
        _tgidString = @"0";
    }
    if (![_tgidString isEqualToString:@"0"]){
        [self showNoticeView:CKYSmsgshopstatusNoRight];
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - 检查分销升级创客，是否有订单
-(void)checkUpgradeOrder {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetRegistStatus];
    NSString *unionid = [KUserdefaults objectForKey:Kunionid];
    if (IsNilOrNull(unionid)) {
        self.tabBarController.selectedIndex = 0;
        if(![WXApi isWXAppInstalled]){//未安装微信的客户
            FFWarnAlertView *alert = [[FFWarnAlertView alloc] init];
            alert.titleLable.text = @"请下载安装微信";
            [alert showFFWarnAlertView];
        }else{
            //安装了微信的客户
            SendAuthReq *req =[[SendAuthReq alloc ] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"26789ww";
            [WXApi sendReq:req];
        }
    }else{
        
        NSDictionary *params = @{@"unionid": unionid};
        
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
        
        [HttpTool postWithUrl:requestUrl params:params success:^(id json) {
            [self.viewDataLoading stopAnimation];
            NSDictionary *dict = json;
            if ([dict[@"code"] integerValue] != 200) {
                [self showNoticeView:[NSString stringWithFormat:@"%@", dict[@"codeinfo"]]];
                return;
            }else{
                NSString *ckid = [NSString stringWithFormat:@"%@", dict[@"ckid"]];
                NSString *dlbtype = [NSString stringWithFormat:@"%@", dict[@"dlbtype"]];
                NSString *orderstatus = [NSString stringWithFormat:@"%@", dict[@"orderstatus"]];
                NSString *invitecode = [NSString stringWithFormat:@"%@",dict[@"invitecode"]];

                //orderinfo有值时返回的是字典，没有值时返回的是空串
                NSDictionary *orderinfoDic = [[NSDictionary alloc] init];
                NSMutableArray *orderinfo = [NSMutableArray array];
                id orderinfoC = dict[@"orderinfo"];
                if ([orderinfoC isKindOfClass:[NSString class]]) {
                    NSLog(@"orderinfoC");
                }else if ([orderinfoC isKindOfClass:[NSDictionary class]]){
                    orderinfoDic = dict[@"orderinfo"];
                    if (orderinfoC != nil) {
                        [orderinfo addObject:orderinfoDic];
                    }
                }
                
                
                if([orderstatus isEqualToString:@"1"]){//e
                    self.tabBarController.selectedIndex = 0;
                    // 包装分享邀请人所需数据
                    NSDictionary *dic = @{@"head":dict[@"head"], @"introduceurl":dict[@"introduceurl"], @"mobile":dict[@"mobile"], @"supername":dict[@"supername"], @"invitecode":dict[@"invitecode"], @"superid":dict[@"superid"]};
                    CKConfrimSharePersonViewController *confrimSharePersonVc = [[CKConfrimSharePersonViewController alloc]init];
                    if (IsNilOrNull(invitecode)) {
                        invitecode = @"";
                    }
                    confrimSharePersonVc.dict = dic;
                    [KUserdefaults setObject:invitecode forKey:@"invitecode"];
                    [KUserdefaults synchronize];
                    RootNavigationController *navi = [[RootNavigationController alloc] initWithRootViewController:confrimSharePersonVc];
                    [self presentViewController:navi animated:YES completion:^{
                    }];
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
                        }else{//d
//                            //新用户购买
//                            CKChooseJoinGoodsVC *chooseDLB = [[CKChooseJoinGoodsVC alloc] init];
//                            chooseDLB.showAllTypeDLB = @"YES";
//                            [self.navigationController pushViewController:chooseDLB animated:YES];
                            // 包装分享邀请人所需数据
                            NSDictionary *dic = @{@"head":dict[@"head"], @"introduceurl":dict[@"introduceurl"], @"mobile":dict[@"mobile"], @"supername":dict[@"supername"], @"invitecode":dict[@"invitecode"], @"superid":dict[@"superid"]};
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
                            
//                            CKConfirmRegisterOrderVC *confirmOrder = [[CKConfirmRegisterOrderVC alloc]init];
//                            CKOrderinfoModel *orderM = [[CKOrderinfoModel alloc] init];
//                            for (NSDictionary *dict in orderinfo) {
//                                [orderM setValuesForKeysWithDictionary:dict];
//                            }
//                            confirmOrder.totalMoney = [NSString stringWithFormat:@"%.2f", [orderM.price doubleValue]];
//                            confirmOrder.orderinfoArray = orderinfo;
//                            confirmOrder.fromVC = @"MainPageVC";
//                            //有未支付订单，没有ck信息，支付完成进入确认信息页面
//                            confirmOrder.showAllTypeDLB = @"YES";
//                            [self.navigationController pushViewController:confirmOrder animated:YES];
                        }
                    }
                }
            }
        } failure:^(NSError *error) {
            [self.viewDataLoading stopAnimation];
            //创客升级，礼包列表只显示创客礼包，支付完成，登录状态
            CKChooseJoinGoodsVC *becomeMeber = [[CKChooseJoinGoodsVC alloc] init];
            becomeMeber.ckid = _ckidString;
            becomeMeber.showAllTypeDLB = @"NO";
            [self.navigationController pushViewController:becomeMeber animated:YES];
        }];
    }
}

#pragma mark - 申请或者升级服务商
- (void)applyServiceProvider:(CKMineSPCell *)cell {
    WebDetailViewController *helpVC = [[WebDetailViewController alloc] init];
    NSString *serviceprovider = [NSString stringWithFormat:@"%@", self.mineModel.serviceprovider];
    if ([serviceprovider isEqualToString:@"4"]) {
        helpVC.typeString = @"upgradeSP";
        helpVC.detailUrl = [NSString stringWithFormat:@"%@", self.mineModel.upgradeurl];
    }else{
        helpVC.typeString = @"applySP";
        helpVC.detailUrl = [NSString stringWithFormat:@"%@?ckid=%@", self.mineModel.applyurl, KCKidstring];
    }
    
    [self.navigationController pushViewController:helpVC animated:YES];
}

#pragma mark - 进入考试
- (void)beginDLBTest:(CKNewerDLBTestCell *)cell {
    CKTrainsExamViewController *exam = [[CKTrainsExamViewController alloc] init];
    [self.navigationController pushViewController:exam animated:YES];
}

-(void)dealloc {
    [CKCNotificationCenter removeObserver:self name:@"ChangeProfileSuccessNotification" object:nil];
    [CKCNotificationCenter removeObserver:self name:@"ChangeHeadIconSuccessNotification" object:nil];
    [CKCNotificationCenter removeObserver:self name:@"ChangePasswordSuccessNotification" object:nil];
    [CKCNotificationCenter removeObserver:self name:@"RequestFail" object:nil];
}

@end
