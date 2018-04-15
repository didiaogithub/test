//
//  CKMyProductLibVC.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKMyProductLibVC.h"
#import "KKDatePickerView.h"
#import "CKProductLibModel.h"
#import "TopUpPayTypeViewController.h"
#import "CKProductLibCell.h"
#import "CKCouponDetailViewController.h"
@interface CKMyProductLibVC ()<UITableViewDelegate, UITableViewDataSource, KKDatePickerViewDelegate>
{
    UILabel *stateLabel;
    UIButton *bgBtn;
    
}

@property (nonatomic, strong) UILabel *beanNumberLable;
@property (nonatomic, strong) UIButton *takeCashButton;
//@property (nonatomic, strong) UILabel *recordNumberLable;//多少笔记录
@property (nonatomic, strong) UIImageView *cloundBeanImageView;
@property (nonatomic, strong) CKProductLibModel *productLibM;
@property (nonatomic, copy) NSString *yearString;
@property (nonatomic, copy) NSString *monthString;
@property (nonatomic, copy) NSString *oidString;
@property (nonatomic, copy) NSString *totalNum;
@property (nonatomic, copy) NSString *glibmoney; //产品库
@property (nonatomic, copy) NSString *ckidString;
@property (nonatomic, copy) NSString *isDownloadMore;

@property (nonatomic, strong) UITableView *gLibRecordTable;
@property (nonatomic, strong) NSMutableArray *data_array;
@property (nonatomic, strong) NodataLableView *nodataLableView;

@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, assign) NSInteger selectedTagIndex;

@property(nonatomic, copy) NSString *couponNum;
@property(nonatomic, copy) NSString *maxmoney;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, copy) NSString *totalvouchermoney;

@end

@implementation CKMyProductLibVC

- (NSMutableArray *)tagArray {
    if (!_tagArray) {
        _tagArray = [NSMutableArray array];
    }
    return _tagArray;
}

- (NodataLableView *)nodataLableView {
    if(_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64-AdaptedHeight(175))];
        _nodataLableView.nodataLabel.text = @"暂无记录";
    }
    return _nodataLableView;
}

- (NSMutableArray *)data_array {
    if (_data_array == nil) {
        _data_array = [[NSMutableArray alloc] init];
    }
    return _data_array;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self requestProductLibTotalData];
    [self removeCouponsView];
}

- (void)removeCouponsView{
    [_nameLabel removeFromSuperview];
    [stateLabel removeFromSuperview];
    [bgBtn removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的产品库";
    
    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    
    _oidString = 0;
    
    self.selectedTagIndex = 0;
    //请求分类标签
    [self requestGLibSortData];
    
    [self requestProductLibTotalData];
}



- (void)initComponent {

    [self creatRightNaviItem];
    
    [self creatTopView];
    //操作标签view
    [self createTagView];
    
    [self createTableView];
}

- (void)creatTopView {
    //头部视图
    self.topView = [[UIView alloc] init];
    [self.view addSubview:self.topView];
    [self.topView setBackgroundColor:[UIColor tt_bigRedBgColor]];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 100+50*ceil(self.tagArray.count/3.0)+20));
    }];
    
    //产品库详情图片
    _cloundBeanImageView = [[UIImageView alloc] init];
    [_cloundBeanImageView setImage:[UIImage imageNamed:@"myproductwhite"]];
    [self.topView addSubview:_cloundBeanImageView];
    [_cloundBeanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(25);
        make.left.mas_offset(25);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    //产品库总值
    _beanNumberLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:[UIFont boldSystemFontOfSize:20]];
    [self.topView addSubview:_beanNumberLable];
    _beanNumberLable.text = @"¥0.00";
    [_beanNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cloundBeanImageView.mas_top);
        make.right.mas_offset(-10);
        make.left.equalTo(_cloundBeanImageView.mas_right).offset(20);
    }];
    
    //我的产品库
    UILabel *beanLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.topView addSubview:beanLable];
    beanLable.text = @"我的产品库";
    [beanLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_beanNumberLable.mas_bottom).offset(5);
        make.left.equalTo(_beanNumberLable.mas_left);
        make.bottom.equalTo(_cloundBeanImageView.mas_bottom);
    }];
    
    UILabel *lineL = [UILabel creatLineLable];
    [self.topView addSubview:lineL];
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.topView.mas_top).offset(100);
        make.height.mas_equalTo(2);
    }];

    
}

#pragma mark - 创建标签View
- (void)createTagView {
    self.tagView = [UIView new];
    self.tagView.backgroundColor = [UIColor whiteColor];
    [self.topView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top).offset(102);
        make.left.equalTo(self.topView.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(self.topView.mas_bottom);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [self.tagView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    
    //创建标签
    CGFloat width = SCREEN_WIDTH/3.0 - 15;
    CGFloat padding = 15*3/4.0;
    for(int i = 0; i<self.tagArray.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(padding+(width+padding)*(i%3), 18+50*(i/3), width, 30)];
        [btn setTitle:self.tagArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
        if ([UIScreen mainScreen].bounds.size.height < 667) {
            btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        }else{
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        }
        btn.tag = 220+i;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        if (0 == i) {
            btn.layer.borderColor = [UIColor colorWithHexString:@"#E53B33"].CGColor;
            [btn setTitleColor:[UIColor colorWithHexString:@"#E53B33"] forState:UIControlStateNormal];
        }else{
            btn.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
            [btn setTitleColor:TitleColor forState:UIControlStateNormal];
        }
        btn.layer.borderWidth = 1;
        [self.tagView addSubview:btn];
    }
}

#pragma mark - 按操作类型请求产品库记录数据
- (void)requestProductLibRecordData:(NSString*)operation {
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
    
    if (IsNilOrNull(operation)) {
        operation = @"";
    }
    
    NSDictionary *pramaDic = @{@"ckid":_ckidString,
                               @"year":_yearString,
                               @"month":_monthString,
                               @"pagesize":@"20",
                               @"id":_oidString,
                               DeviceId:uuid,
                               @"ver":@"301",
                               @"operation":operation
                               };
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Item/glibrecordRequest"];
    
    _nodataLableView.hidden = YES;
//    if(IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
//    }
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            [self.gLibRecordTable.mj_footer endRefreshing];
            [self.gLibRecordTable.mj_header endRefreshing];
            return ;
        }
        
//        NSString *archiveName = [NSString stringWithFormat:@"产品库_%@_%@_%@", operation, _yearString, _monthString];
//        if (IsNilOrNull(_yearString)) {
//            NSString *nowString = [NSDate nowTime:@"yyyy-MM"];
//            NSArray *timeArr = [nowString componentsSeparatedByString:@"-"];
//            archiveName = [NSString stringWithFormat:@"产品库_%@_%@_%@", operation, [timeArr firstObject], [timeArr lastObject]];
//        }
//        [[XNArchiverManager shareInstance] xnArchiverObject:dict archiverName:archiveName];
        
        [self bindRecordData:dict];
        
    } failure:^(NSError *error) {
        [self.gLibRecordTable.mj_footer endRefreshing];
        [self.gLibRecordTable.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 请求产品库总数
- (void)requestProductLibTotalData {
    
    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;

    NSDictionary *pramaDic = @{@"ckid":_ckidString, DeviceId:uuid};
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
        [self refreshAllmyYunDouandProduct];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

- (void)addConponBtn{
    bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgBtn setBackgroundImage:[UIImage imageNamed:@"产品卷"] forState:UIControlStateNormal];
    [bgBtn setTitle:@"" forState:UIControlStateNormal];
    [self.topView addSubview:bgBtn];
    [bgBtn addTarget:self action:@selector(jumpToCKCouponDetailVc) forControlEvents:UIControlEventTouchUpInside];
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(AdaptedWidth(-10));
        make.width.mas_offset(AdaptedWidth(89));
        make.height.mas_offset(AdaptedHeight(34));
        make.top.mas_offset(AdaptedHeight(32));
    }];
    
   _nameLabel  = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:12]];
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

-(void)refreshAllmyYunDouandProduct {
    
    if(IsNilOrNull(_glibmoney)){
        _glibmoney = @"0.00";
    }
    
    _beanNumberLable.text = [NSString stringWithFormat:@"¥%@",_glibmoney];
}

#pragma mark - ******筛选*******
-(void)creatRightNaviItem {
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

#pragma mark - 点击筛选
- (void)clickSiftButton {
    KKDatePickerView *pickerView = [[KKDatePickerView alloc]initWithFrame:self.view.bounds];
    pickerView.delegate = self;
    [pickerView show];
}

#pragma mark - pickerview代理方法
- (void)pickView:(NSString *)yes month:(NSString *)moth{
    
    if (![_oidString isEqualToString:@"0"]){
        _oidString = @"0";
    }
    _isDownloadMore = @"";
    _yearString = yes;
    _monthString = moth;
    
    NSString *operation = [NSString stringWithFormat:@"%@", self.tagArray[self.selectedTagIndex]];
    [self requestProductLibRecordData:operation];
    
    if([self.data_array count]){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.gLibRecordTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - 创建我的产品库展示UI
-(void)createTableView {
    
    //保存按钮
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [bankImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [self.view addSubview:bankImageView];
    bankImageView.userInteractionEnabled = YES;
    bankImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT-6);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.height.mas_offset(40);
    }];
    //我要进货
    _takeCashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankImageView addSubview:_takeCashButton];
    _takeCashButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [_takeCashButton setTitle:@"我要进货" forState:UIControlStateNormal];
    [_takeCashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bankImageView);
    }];
    [_takeCashButton addTarget:self action:@selector(clickTakeCashButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _gLibRecordTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_gLibRecordTable];
    [_gLibRecordTable setBackgroundColor:[UIColor tt_grayBgColor]];
    [_gLibRecordTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(_takeCashButton.mas_top).offset(-6);
    }];
    _gLibRecordTable.showsVerticalScrollIndicator = NO;
    _gLibRecordTable.separatorStyle = UITableViewCellSelectionStyleNone;
    _gLibRecordTable.delegate = self;
    _gLibRecordTable.dataSource = self;
    self.gLibRecordTable.rowHeight = UITableViewAutomaticDimension;
    self.gLibRecordTable.estimatedRowHeight = 44;
    
//    UIView *numberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52)];
//    _gLibRecordTable.tableHeaderView = numberView;
//    [numberView setBackgroundColor:[UIColor whiteColor]];
//    UILabel *grayLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
//    [grayLable setBackgroundColor:[UIColor tt_grayBgColor]];
//    [numberView addSubview:grayLable];

//    _recordNumberLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
//    _recordNumberLable.frame = CGRectMake(15, 8, SCREEN_WIDTH, 44);
//    [numberView addSubview:_recordNumberLable];
//    _recordNumberLable.text = @"共计：0笔";
//    [self refreshBeanNumber];
    
    [self refreshAllmyYunDouandProduct];
    
    //如果推广人登录 没有进货按钮
    NSString *sales = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KSales]];
    if ([sales isEqualToString:@"0"]) {
        _takeCashButton.hidden = NO;
        [_gLibRecordTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_takeCashButton.mas_top).offset(-6);
        }];
    }else{
        _takeCashButton.hidden = YES;
        [_gLibRecordTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
        }];
    }
    
    
}

#pragma mark - 请求分类标签
- (void)requestGLibSortData {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *devicetype = [NSString getCurrentVersionAndDeviceType];
    
    NSDictionary *pramaDic = @{@"ckid":_ckidString, DeviceId:uuid, @"devicetype":devicetype};
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/CkMonthly/getGlibSorts"];//@"http://192.168.2.32:90/Ckapp3/CkMonthly/getGlibSorts";
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        [self.tagArray removeAllObjects];
        NSArray *tagArr = dict[@"data"];
        for (NSDictionary *tagDic in tagArr) {
            NSString *tag = [NSString stringWithFormat:@"%@", tagDic[@"operation"]];
            [self.tagArray addObject:tag];
        }
        
        [self initComponent];
        
        if (self.tagArray.count > 0) {
            //有标签是才能刷新
            [self refreshData];
            
            NSString *operation = [NSString stringWithFormat:@"%@", self.tagArray[self.selectedTagIndex]];
            [self requestProductLibRecordData:operation];
        }else{
            [self.gLibRecordTable tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:0];
        }
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
//        [self createTableView];
    }];
}

#pragma mark - 点击操作标签
-(void)clickTagBtn:(UIButton*)btn {
    NSLog(@"%@:%ld", btn.titleLabel.text, btn.tag-220);
    
    _isDownloadMore = @"1";
    //同一个标签再次点击不再请求数据
    if (self.selectedTagIndex == btn.tag-220) {
        return;
    }else{
        self.selectedTagIndex = btn.tag-220;
    }
    
    for (UIButton *button in self.tagView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (btn.tag == button.tag) {
                button.layer.borderColor = [UIColor colorWithHexString:@"#E53B33"].CGColor;
                [button setTitleColor:[UIColor colorWithHexString:@"#E53B33"] forState:UIControlStateNormal];
            }else{
                button.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
                [button setTitleColor:TitleColor forState:UIControlStateNormal];
            }
        }
    }
    
    NSString *operation = btn.titleLabel.text;
    //判断有没有缓存
//    NSString *archiveName = [NSString stringWithFormat:@"产品库_%@_%@_%@", operation, _yearString, _monthString];
//    if (IsNilOrNull(_yearString)) {
//        NSString *nowString = [NSDate nowTime:@"yyyy-MM"];
//        NSArray *timeArr = [nowString componentsSeparatedByString:@"-"];
//        archiveName = [NSString stringWithFormat:@"产品库_%@_%@_%@", operation, [timeArr firstObject], [timeArr lastObject]];
//    }
//    NSDictionary *dict = [[XNArchiverManager shareInstance] xnUnarchiverObject:archiveName];
//
//    if (dict) {
//        [self bindRecordData:dict];
//    }else{
        [self requestProductLibRecordData:operation];
//    }
}

- (void)bindRecordData:(NSDictionary*)dict {
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
            [self.gLibRecordTable.mj_footer endRefreshingWithNoMoreData];
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
        [self.gLibRecordTable tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.data_array.count];
    }
    
    [self.gLibRecordTable.mj_footer endRefreshing];
    [self.gLibRecordTable.mj_header endRefreshing];
    
    [self.gLibRecordTable reloadData];
//    [self refreshBeanNumber];
}

#pragma mark - 点击进货按钮
-(void)clickTakeCashButton:(UIButton *)button{
    TopUpPayTypeViewController *topUp = [[TopUpPayTypeViewController alloc] init];
    topUp.num = _couponNum;
    [self.navigationController pushViewController:topUp animated:YES];
}

//-(void)refreshBeanNumber {
//    if (IsNilOrNull(_totalNum)) {
//        _totalNum = @"0";
//    }
//    _recordNumberLable.text = [NSString stringWithFormat:@"共计：%@笔",_totalNum];
//}

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
#pragma mark - 刷新
- (void)refreshData {
    __weak typeof(self) weakSelf = self;
    self.gLibRecordTable.mj_header = [MJGearHeader headerWithRefreshingBlock:^{

        [weakSelf.gLibRecordTable.mj_header endRefreshing];
        if (self.tagArray.count == 0) {
            return;
        }
        
        _isDownloadMore = @"1";
        _yearString = @"";
        _monthString = @"";
        [weakSelf.gLibRecordTable.mj_header beginRefreshing];
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
                    NSString *operation = [NSString stringWithFormat:@"%@", weakSelf.tagArray[weakSelf.selectedTagIndex]];
                    [weakSelf requestProductLibRecordData:operation];
                }else{
                    [weakSelf.gLibRecordTable.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.gLibRecordTable.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.gLibRecordTable.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        if (self.tagArray.count == 0) {
            return;
        }
        _isDownloadMore = @"2";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                NSString *operation = [NSString stringWithFormat:@"%@", weakSelf.tagArray[weakSelf.selectedTagIndex]];
                [weakSelf requestProductLibRecordData:operation];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.gLibRecordTable.mj_footer endRefreshing];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
