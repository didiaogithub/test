//
//  CKYLibDetailViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/4.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKYLibDetailViewController.h"
#import "TakeCashViewController.h"
#import "CloudRecordTableViewCell.h"
#import "KKDatePickerView.h"
#import "YundouAndProductModel.h"

static NSString *recordIdentifier = @"CloudRecordTableViewCell";

@interface CKYLibDetailViewController ()<UITableViewDelegate, UITableViewDataSource, KKDatePickerViewDelegate>
{
    UILabel *_beanNumberLable;
    UILabel *_headerNumberLable;
    UIButton *_takeCashButton;
//    UILabel *_recordNumberLable;//多少笔记录
    UIImageView *_cloundBeanImageView;
    NSString *_yearString;
    NSString *_monthString;
    NSString *_oidString;
    NSString *_totalNum;
    NSString *_ckidString;
    NSString *_isDownloadMore;
    YundouAndProductModel *_yunAndProductModel;
    NSString *_isPopularizeSales;
}
@property (nonatomic, strong) UITableView *yLibTableView;
@property (nonatomic, strong) NSMutableArray *data_array;
@property (nonatomic, strong) NodataLableView *nodataLableView;

@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, assign) NSInteger selectedTagIndex;

@end

@implementation CKYLibDetailViewController

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

-(NSMutableArray *)data_array{
    if (_data_array == nil) {
        _data_array = [[NSMutableArray alloc] init];
    }
    return _data_array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    self.navigationItem.title = @"我的云豆库";
    
    [self createSiftButton];
    
    self.selectedTagIndex = 0;
    
    _oidString = 0;
    
    if (IsNilOrNull(self.currentYlibMoney)) {
        [self getCurrentMoneyData];
    }
    
    //请求分类标签
    [self requestYLibSortData];
    
    
}

#pragma mrak- 创建我的芸豆库展示UI
- (void)initComponent {
    
    //头部视图
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    [topView setBackgroundColor:[UIColor tt_bigRedBgColor]];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
//        }else{
//            make.top.equalTo(self.view.mas_top);
//        }
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 100+50*ceil(self.tagArray.count/3.0)+20));
    }];
    
    //芸豆库详情图片
    _cloundBeanImageView = [[UIImageView alloc] init];
    [_cloundBeanImageView setImage:[UIImage imageNamed:@"yundouwhite"]];
    [topView addSubview:_cloundBeanImageView];
    [_cloundBeanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(25);
        make.left.mas_offset(25);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    //云豆总值
    _beanNumberLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font: CHINESE_SYSTEM_BOLD(AdaptedWidth(20))];
    [topView addSubview:_beanNumberLable];
    [self refreshCloudBeanData];
    [_beanNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cloundBeanImageView.mas_top);
        make.right.mas_offset(-10);
        make.left.equalTo(_cloundBeanImageView.mas_right).offset(20);
    }];
    
    //我的云豆库
    UILabel *beanLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [topView addSubview:beanLable];
    beanLable.text = @"我的云豆库";
    [beanLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_beanNumberLable.mas_bottom).offset(5);
        make.left.equalTo(_beanNumberLable.mas_left);
        make.bottom.equalTo(_cloundBeanImageView.mas_bottom);
    }];
    
    UILabel *lineL = [UILabel creatLineLable];
    [topView addSubview:lineL];
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(topView.mas_top).offset(100);
        make.height.mas_equalTo(2);
    }];
    //操作标签view
    self.tagView = [UIView new];
    self.tagView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(102);
        make.left.equalTo(topView.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(topView.mas_bottom);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [self.tagView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    
    
    CGFloat width = SCREEN_WIDTH/3.0 - 15;
    CGFloat padding = 15*3/4.0;
    for(int i = 0; i < self.tagArray.count; i++) {
        
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
    
    _yLibTableView = [[UITableView alloc] init];
    [self.view addSubview:_yLibTableView];
    [_yLibTableView setBackgroundColor:[UIColor tt_grayBgColor]];
    [_yLibTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT-52);
    }];
    [self.yLibTableView registerClass:[CloudRecordTableViewCell class] forCellReuseIdentifier:recordIdentifier];
    _yLibTableView.showsVerticalScrollIndicator = NO;
    
    _yLibTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _yLibTableView.delegate = self;
    _yLibTableView.dataSource = self;
    self.yLibTableView.rowHeight = UITableViewAutomaticDimension;
    self.yLibTableView.estimatedRowHeight = 44;
    
    //保存按钮
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [bankImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [self.view addSubview:bankImageView];
    bankImageView.userInteractionEnabled = YES;
    bankImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_yLibTableView.mas_bottom).offset(6);
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
    _isPopularizeSales = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    if ([_isPopularizeSales isEqualToString:@"0"]) {
        _takeCashButton.hidden = NO;
        [_yLibTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT-52);
        }];
    }else{
        _takeCashButton.hidden = YES;
        [_yLibTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
        }];
    }
    
//    UIView *numberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52)];
//    _yLibTableView.tableHeaderView = numberView;
//    [numberView setBackgroundColor:[UIColor whiteColor]];
//    UILabel *grayLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
//    [grayLable setBackgroundColor:[UIColor tt_grayBgColor]];
//    [numberView addSubview:grayLable];
//
//    _recordNumberLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
//    _recordNumberLable.frame = CGRectMake(15, 8, SCREEN_WIDTH, 44);
//    [numberView addSubview:_recordNumberLable];
//    _recordNumberLable.text = @"共计：0笔";
//    [self updateRecordNumber];
    
    
//    [self refreshData];
}

#pragma mark - 请求云豆库总数
- (void)getCurrentMoneyData {
    
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
        
        self.currentYlibMoney = dict[@"ylibmoney"];
        if (IsNilOrNull(self.currentYlibMoney)){
            self.currentYlibMoney = @"";
        }
        [self refreshCloudBeanData];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

- (void)refreshCloudBeanData {
    if(IsNilOrNull(self.currentYlibMoney)){
        self.currentYlibMoney = @"0";
    }
    _beanNumberLable.text = [NSString stringWithFormat:@"¥%@", self.currentYlibMoney];
}

#pragma mark - *****筛选******
/**创建筛选按钮*/
-(void)createSiftButton {
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
    
    NSString *operation = [NSString stringWithFormat:@"%@", self.tagArray[self.selectedTagIndex]];
    [self requestCloudBeanRecordData:operation];
    
    if([self.data_array count]){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.yLibTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - 请求分类标签
- (void)requestYLibSortData {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *devicetype = [NSString getCurrentVersionAndDeviceType];
    
    NSDictionary *pramaDic = @{@"ckid":_ckidString, DeviceId:uuid, @"devicetype":devicetype};
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/CkMonthly/getYlibSorts"];//@"http://192.168.2.32:90/Ckapp3/CkMonthly/getYlibSorts";
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
            //有标签时再增加刷新功能
            [self refreshData];
            
            
            NSString *operation = [NSString stringWithFormat:@"%@", self.tagArray[self.selectedTagIndex]];
            [self requestCloudBeanRecordData:operation];
        }else{
            [self.yLibTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:0];
        }
        
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 点击操作标签
-(void)clickTagBtn:(UIButton*)btn {

    
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
//    //判断有没有缓存
//    NSString *archiveName = [NSString stringWithFormat:@"云豆库_%@_%@_%@", operation, _yearString, _monthString];
//    if (IsNilOrNull(_yearString)) {
//        NSString *nowString = [NSDate nowTime:@"yyyy-MM"];
//        NSArray *timeArr = [nowString componentsSeparatedByString:@"-"];
//        archiveName = [NSString stringWithFormat:@"云豆库_%@_%@_%@", operation, [timeArr firstObject], [timeArr lastObject]];
//    }
//    NSDictionary *dict = [[XNArchiverManager shareInstance] xnUnarchiverObject:archiveName];
//
//    if (dict) {
//        [self bindRecordData:dict];
//    }else{
        [self requestCloudBeanRecordData:operation];
//    }
}

#pragma mark - 请求云豆库记录列表
- (void)requestCloudBeanRecordData:(NSString*)operation {
    //请求参数年、月为空时，默认从当前年月查询，
    //pagesize  展示多少行 20行  id  产品库最后一条记录id（刷新时要传最后一条操作记录的id）
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
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Item/ylibrecordRequest"];//@"http://192.168.2.32:90/Ckapp3/Item/ylibrecordRequest";
    
    _nodataLableView.hidden = YES;
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            [self.viewDataLoading stopAnimation];
            [self.yLibTableView.mj_footer endRefreshing];
            [self.yLibTableView.mj_header endRefreshing];
            return ;
        }
        
//        NSString *archiveName = [NSString stringWithFormat:@"云豆库_%@_%@_%@", operation, _yearString, _monthString];
//        if (IsNilOrNull(_yearString)) {
//            NSString *nowString = [NSDate nowTime:@"yyyy-MM"];
//            NSArray *timeArr = [nowString componentsSeparatedByString:@"-"];
//            archiveName = [NSString stringWithFormat:@"云豆库_%@_%@_%@", operation, [timeArr firstObject], [timeArr lastObject]];
//        }
//        [[XNArchiverManager shareInstance] xnArchiverObject:dict archiverName:archiveName];
        
        [self bindRecordData:dict];
    } failure:^(NSError *error) {
        [self.yLibTableView.mj_footer endRefreshing];
        [self.yLibTableView.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

- (void)bindRecordData:(NSDictionary*)dict {
    if (IsNilOrNull(dict[@"totalNum"])) {
        _totalNum = @"";
    }else{
        _totalNum = [NSString stringWithFormat:@"%@", dict[@"totalNum"]];
    }
    
    if (![_isDownloadMore isEqualToString:@"2"]) {
        [self.data_array removeAllObjects];
    }
    
    NSArray *recorrdArr = dict[@"records"];
    
    if (recorrdArr.count == 0) {
        if ([_isDownloadMore isEqualToString:@"2"]) {
            [self.yLibTableView.mj_footer endRefreshingWithNoMoreData];
            [self.viewDataLoading stopAnimation];
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
        [self.yLibTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.data_array.count];
    }
    
    [self.yLibTableView.mj_footer endRefreshing];
    [self.yLibTableView.mj_header endRefreshing];
    [self.yLibTableView reloadData];
    [self.viewDataLoading stopAnimation];
    
//    [self updateRecordNumber];
}

#pragma mark - 点击提现或者充值按钮
-(void)clickTakeCashButton:(UIButton *)button{
    
    if (!IsNilOrNull(self.currentYlibMoney) && [self.currentYlibMoney doubleValue] <= 0) {
        MessageAlert *alert = [[MessageAlert alloc] init];
        alert.isDealInBlock = NO;
        [alert hiddenCancelBtn:YES];
        [alert showAlert:@"您的云豆库余额不足，暂不能提现" btnClick:^{
            
        }];
        return;
    }
    
    if (!IsNilOrNull(self.currentGlibMoney) && [self.currentGlibMoney doubleValue] < 0) {
        MessageAlert *alert = [[MessageAlert alloc] init];
        alert.isDealInBlock = NO;
        [alert hiddenCancelBtn:YES];
        [alert showAlert:@"您的产品库存小于0，暂不能提现，请先完成进货再来提现吧！" btnClick:^{
            
        }];
        return;
    }
    
    if(IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
    //提现前确认是否提现金额为0
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, withDrawCash_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"money":@"",DeviceId:uuid};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.yLibTableView.mj_header endRefreshing];
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
        [self.yLibTableView.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

//#pragma mark - 记录条数
//- (void)updateRecordNumber {
//    if (IsNilOrNull(_totalNum)) {
//        _totalNum = @"0";
//    }
//    _recordNumberLable.text = [NSString stringWithFormat:@"共计：%@笔", _totalNum];
//}

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

- (void)refreshData {
    __weak typeof(self) weakSelf = self;
    self.yLibTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        
        [weakSelf.yLibTableView.mj_header endRefreshing];
        if (self.tagArray.count == 0) {
            return;
        }
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"1";
        _yearString = @"";
        _monthString = @"";
        [weakSelf.yLibTableView.mj_header beginRefreshing];
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
                    [weakSelf requestCloudBeanRecordData:operation];
                }else{
                    [weakSelf.yLibTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.yLibTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.yLibTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
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
                [weakSelf requestCloudBeanRecordData:operation];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.yLibTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
