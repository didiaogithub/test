//
//  TodaySalesViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "TodaySalesViewController.h"
#import "TodaySaleModel.h"
#import "TodaySaleView.h"
#import "TodaySalesRecordTableViewCell.h"
#import "SalelistModel.h"

static NSString *todaySaleCell = @"TodaySalesRecordTableViewCell";

@interface TodaySalesViewController ()<UITableViewDelegate,UITableViewDataSource,TodaySaleViewDelegate>
{
    NSString *_ckidString;
    NSString *_isDownloadMore;
    NSString *_recordId;
  
    NSString *_totalNum;
    NSString *_typeString;
    NSString *_tgidString;
    TodaySaleView *_todaySaleView;
}

@property (nonatomic, strong) SalelistModel *listModel;
@property (nonatomic, strong) TodaySaleModel *todaySaleModel;
@property (nonatomic, strong) UITableView *beanDeatiltableView;
@property (nonatomic, strong) NSMutableArray *data_array;
@property (nonatomic, strong) NodataLableView *nodataLableView;

@end

@implementation TodaySalesViewController

- (NodataLableView *)nodataLableView {
    if(_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64-AdaptedHeight(150)-AdaptedHeight(100))];
        _nodataLableView.nodataLabel.text = @"暂无记录";
    }
    return _nodataLableView;
}

-(NSMutableArray *)data_array{
    if (_data_array == nil) {
        _data_array = [NSMutableArray array];
    }
    return _data_array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"今日销售";
    
    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    
    [self createRightButton];
    [self createTableView];
    //请求数据 默认请求混合数据
    if (IsNilOrNull(_typeString)){
        _typeString = @"3";
    }
    [self getMyTodayProductDataWithType:_typeString];
    //刷新数据
    [self refreshData];
}
/**查看我的订单*/
-(void)createRightButton{

    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navorder"] style:UIBarButtonItemStylePlain target:self action:@selector(clickMyorderButton)];
    right.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = 10;
        self.navigationItem.rightBarButtonItems = @[spaceItem, right];
    }
}

-(void)clickMyorderButton{
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)getMyTodayProductDataWithType:(NSString *)typeString{
    
    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    
    NSString *tgStr = [KUserdefaults objectForKey:KSales];
    _tgidString = IsNilOrNull(tgStr) ? @"0" : tgStr;
    
    NSString *uuid = IsNilOrNull(DeviceId_UUID_Value) ? @"" : DeviceId_UUID_Value;

    if (IsNilOrNull(_recordId)) {
        _recordId = @"0";
    }
    if (IsNilOrNull(typeString)) {
        typeString = @"3";
    }
    if (![_isDownloadMore isEqualToString:@"2"]) {
         _recordId = @"0";
    }

    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"pagesize":@"20",@"id":_recordId,@"type":typeString,DeviceId:uuid,@"tgid":_tgidString};
   
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getTodayOrders_Url];

    _nodataLableView.hidden = YES;
    
    if (IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.beanDeatiltableView.mj_header endRefreshing];
        [self.beanDeatiltableView.mj_footer endRefreshing];
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        self.todaySaleModel = [[TodaySaleModel alloc] init];
        [self.todaySaleModel setValuesForKeysWithDictionary:dict];
        if(![_isDownloadMore isEqualToString:@"2"]){
            [self.data_array removeAllObjects];
        }
        
        NSArray *listArr = dict[@"list"];
        for (NSDictionary *listDic in listArr) {
            self.listModel = [[SalelistModel alloc] init];
            [self.listModel setValuesForKeysWithDictionary:listDic];
            [self.data_array addObject: self.listModel];
        }
        [self refreshWithModel:self.todaySaleModel andArray:self.data_array];
        if ([listArr count]) {
            _recordId =  [NSString stringWithFormat:@"%@",self.listModel.ID];
        }
        if(![self.data_array count]){
            _nodataLableView.hidden = NO;
            [self.beanDeatiltableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.data_array.count];
        }
        [self.beanDeatiltableView reloadData];
        
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

#pragma mark—刷新头部值
-(void)refreshWithModel:(TodaySaleModel *)todaySaleModel andArray:(NSMutableArray *)array{
    NSString *moneyTotal = [NSString stringWithFormat:@"%@",todaySaleModel.moneytotal];
    if (IsNilOrNull(moneyTotal)){
        moneyTotal = @"0.00";
    }
    float moneyTotalfloat = [moneyTotal floatValue];
    _todaySaleView.moneyTotalLable.text = [NSString stringWithFormat:@"¥%.2f",moneyTotalfloat];
    
    //混合收入
    NSString *moneysales = [NSString stringWithFormat:@"%@",todaySaleModel.moneysales];
    if (IsNilOrNull(moneysales)) {
        moneysales = @"0.00";
    }
    
    float moneysalesfloat = [moneysales floatValue];
    _todaySaleView.moneySalesLable.text = [NSString stringWithFormat:@"¥%.2f",moneysalesfloat];
    
    
    NSString *moneyorderback = [NSString stringWithFormat:@"%@",todaySaleModel.moneyorderback];
    if (IsNilOrNull(moneyorderback)) {
        moneyorderback = @"0.00";
    }
    float moneyorderbackfloat = [moneyorderback floatValue];
    _todaySaleView.moneyOrderBackLable.text = [NSString stringWithFormat:@"¥%.2f",moneyorderbackfloat];
    
    _totalNum = [NSString stringWithFormat:@"%@",self.todaySaleModel.totalNum];
    if (IsNilOrNull(_totalNum)) {
        _totalNum = @"0";
    }
    _todaySaleView.allNumLable.text = [NSString stringWithFormat:@"共计：%@笔",_totalNum];
}

#pragma mrak- 创建我的芸豆库展示UI
-(void)createTableView{
    //最上面的view
     _todaySaleView = [[TodaySaleView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, AdaptedHeight(200)) andTypeStr:@"1"];
    [self.view addSubview:_todaySaleView];
    _todaySaleView.delegate = self;

    _beanDeatiltableView = [[UITableView alloc] init];
    [self.view addSubview:_beanDeatiltableView];
    [_beanDeatiltableView setBackgroundColor:[UIColor tt_grayBgColor]];
    [_beanDeatiltableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_todaySaleView.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
    }];
    
    [self.beanDeatiltableView registerClass:[TodaySalesRecordTableViewCell class] forCellReuseIdentifier:todaySaleCell];
    _beanDeatiltableView.showsVerticalScrollIndicator = NO;
    _beanDeatiltableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _beanDeatiltableView.delegate = self;
    _beanDeatiltableView.dataSource = self;
    self.beanDeatiltableView.rowHeight = UITableViewAutomaticDimension;
    self.beanDeatiltableView.estimatedRowHeight = 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.data_array count]){
        return self.data_array.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        TodaySalesRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todaySaleCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.typeString = _typeString;
        [cell setBackgroundColor:[UIColor tt_grayBgColor]];
        if ([self.data_array count]) {
            self.listModel = self.data_array[indexPath.row];
            [cell refreshWithModel:self.listModel];
         }
        return cell;
}
/**点击销售总额130  和退货总额按钮131*/
-(void)refreshSalesButton:(UIButton *)saleButton{
    NSInteger tag = saleButton.tag -130;
    if(tag == 0){  //实际销售收入
        _typeString = @"1";
    }else if(tag == 1){ //混合收入
        _typeString = @"3";
    }else{ //退货
       _typeString = @"2";
    }
    _isDownloadMore = @"";
    if (![_recordId isEqualToString:@"0"]) {
        _recordId = @"";
    }
    _todaySaleView.allNumLable.text = @"共计：0笔";
    [self.data_array removeAllObjects];
    [self.beanDeatiltableView reloadData];
    [self getMyTodayProductDataWithType:_typeString];
}

-(void)refreshData{
    __typeof (self) __weak weakSelf = self;
    self.beanDeatiltableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
            _isDownloadMore = @"1";
            [weakSelf getMyTodayProductDataWithType:_typeString];
            [weakSelf.beanDeatiltableView.mj_header beginRefreshing];
    }];
    
    self.beanDeatiltableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
            _isDownloadMore = @"2";
            [weakSelf getMyTodayProductDataWithType:_typeString];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell的时候 展开一个view  点击view上的按钮 收起view
    // 正常情况下打开关闭
}

@end
