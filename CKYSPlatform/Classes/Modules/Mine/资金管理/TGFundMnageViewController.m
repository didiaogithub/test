//
//  TGFundMnageViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/1/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "TGFundMnageViewController.h"
#import "TGFundModel.h"
#import "TGFundDetailModel.h"
#import "OrderModel.h"
#import "TgFundTableViewCell.h"
#import "KKDatePickerView.h"
@interface TGFundMnageViewController ()<UITableViewDelegate,UITableViewDataSource,KKDatePickerViewDelegate>
{
    NSString *_isDownloadMore;
    OrderModel *_tgFundModel;
    Ordersheet *_tgFundDetailModel;
    NSString *_yearStr;
    NSString *_monthStr;
    NSString *_oidString;
    NSString *_tgidString;
    NSString *_ckidString;
    NSString *_flagStr;
}
@property(nonatomic,strong)NSMutableArray *fund_dataArray;
@property(nonatomic,strong)UITableView *tgFundTableView;
@property(nonatomic,strong)NodataLableView *nodataLableView;
@end

@implementation TGFundMnageViewController

-(NSMutableArray *)fund_dataArray{
    if (_fund_dataArray == nil) {
        _fund_dataArray = [[NSMutableArray alloc] init];
    }
    return _fund_dataArray;
}

- (NodataLableView *)nodataLableView
{
    if(_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64)];
        _nodataLableView.nodataLabel.text = @"暂无记录";
    }
    return _nodataLableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资金管理";
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    _tgidString = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    if (IsNilOrNull(_tgidString)) {
        _tgidString = @"0";
    }
    [self createSiftButton];
    [self createTableView];
    [self loadMyFundData];
    [self refreshData];
}
/**创建筛选按钮*/
-(void)createSiftButton{
   
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"selectconditions"] style:UIBarButtonItemStylePlain target:self action:@selector(clickSiftButton)];
    right.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = 10;
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
    _yearStr = yes;
    _monthStr = moth;
    [self.fund_dataArray removeAllObjects];
    [self loadMyFundData];
    NSLog(@"刷新值%@  当前值id%@",_isDownloadMore,_oidString);
    if([self.fund_dataArray count]){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tgFundTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }

}
#pragma mark-请求我的订单页面数据
-(void)loadMyFundData{
    if ([_isDownloadMore isEqualToString:@"1"]) {
        [self.fund_dataArray removeAllObjects];
    }
    if (IsNilOrNull(_oidString)) {
        _oidString = @"0";
    }
    if (IsNilOrNull(_yearStr)) {
        _yearStr = @"";
    }
    if (IsNilOrNull(_monthStr)) {
        _monthStr = @"";
    }
    if (![_isDownloadMore isEqualToString:@"2"]) {
        _oidString = @"0";
        [self.fund_dataArray removeAllObjects];
    }
    if (IsNilOrNull(_tgidString)) {
        _tgidString = @"0";
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    _flagStr = @"1";
    NSDictionary *pramaDic = @{@"ckid":_ckidString
                               ,@"pagesize":@"20",@"tgid":_tgidString,@"oid":_oidString,@"orderstatus":@"99",@"buyertype":@"WXUSER",@"keywords":@"",@"year":_yearStr,@"month":_monthStr,@"flag":_flagStr,DeviceId:uuid};
    NSString *orderListUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getMyOrders_Url];
    
   
    _nodataLableView.hidden = YES;
    if (IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    [HttpTool postWithUrl:orderListUrl params:pramaDic success:^(id json) {
        [self.tgFundTableView.mj_header endRefreshing];
        [self.tgFundTableView.mj_footer endRefreshing];
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        NSArray *listArr = dict[@"list"];
        for (NSDictionary *listOrderDic in listArr) {
            _tgFundModel = [[OrderModel alloc] init];
            [_tgFundModel setValuesForKeysWithDictionary:listOrderDic];
            
            for (NSDictionary *dic in listOrderDic[@"ordersheet"]) {
                _tgFundDetailModel = [[Ordersheet alloc] init];
                [_tgFundDetailModel setValuesForKeysWithDictionary:dic];
                [_tgFundModel.orderArray addObject:_tgFundDetailModel];
            }
            [self.fund_dataArray addObject:_tgFundModel];
        }
        if([listArr count]){
            _oidString = [NSString stringWithFormat:@"%@",_tgFundModel.oid];
        }
        
        if(![self.fund_dataArray count]){
            _nodataLableView.hidden = NO;
            [self.tgFundTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.fund_dataArray.count];
        }
        
        [self.tgFundTableView reloadData];
    } failure:^(NSError *error) {
        [self.tgFundTableView.mj_header endRefreshing];
        [self.tgFundTableView.mj_footer endRefreshing];
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}

#pragma mark-创建tableView
-(void)createTableView{
    _tgFundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
    _tgFundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tgFundTableView];
    self.tgFundTableView.rowHeight = UITableViewAutomaticDimension;
    self.tgFundTableView.estimatedRowHeight = 44;
    _tgFundTableView.backgroundColor = [UIColor tt_grayBgColor];

    _tgFundTableView.delegate = self;
    _tgFundTableView.dataSource = self;
    
}
#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fund_dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TgFundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TgFundTableViewCell"];
    if (cell == nil) {
        cell = [[TgFundTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TgFundTableViewCell"];
    }
    if ([self.fund_dataArray count]) {
        _tgFundModel = self.fund_dataArray[indexPath.row];
        [cell refreshFundWithModel:_tgFundModel];
    }
    
    return cell;
}
-(void)refreshData{
    __typeof (self) __weak weakSelf = self;
    self.tgFundTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
            _yearStr = @"";
            _monthStr = @"";
            _isDownloadMore = @"1";
            [self loadMyFundData];
            [weakSelf.tgFundTableView.mj_header beginRefreshing];
    }];
    
    
    self.tgFundTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
            _isDownloadMore = @"2";
            [self loadMyFundData];
    }];
}




@end
