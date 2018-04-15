//
//  TodaySalesViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "MyResultsViewController.h"
#import "MyResultsRecordTableViewCell.h"
#import "MyTeamTableViewCell.h"
#import "TodaySaleView.h"
#import "MyTeamListModel.h"
#import "TodaySaleModel.h"

static NSString *myResultsCell = @"MyResultsRecordTableViewCell";
static NSString *zsPerfCell = @"MyTeamTableViewCell";
@interface MyResultsViewController ()<UITableViewDelegate,UITableViewDataSource,TodaySaleViewDelegate,MyTeamTableViewCellDelegate>
{
    NSString *_ckidString;
    NSString *_isDownloadMore;
    NSString *_recordId;

    NSString *_typeString;
    TodaySaleView *_todaySaleView;
    TodaySaleModel *_totalModel;  //显示上面三个数值
}
@property(nonatomic,strong)MyTeamListModel *myPerfModel;
@property(nonatomic,strong)UITableView *myPerfTableView;

@property(nonatomic,strong) NSMutableArray *data_array;
@property(nonatomic,strong)NodataLableView *nodataLableView;
@end

@implementation MyResultsViewController
- (NodataLableView *)nodataLableView
{
    if(_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64-AdaptedHeight(150)-AdaptedHeight(100))];
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
    self.navigationItem.title = @"我的业绩";
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }

    [self createTableView];
    //请求数据 默认请求混合数据
    if (IsNilOrNull(_typeString)){
        _typeString  = @"1";
    }
    [self getMyRechargeDataWithType:_typeString];
    //刷新数据
    [self refreshData];
}
#pragma mark-获取进货总计数据
-(void)getMyRechargeDataWithType:(NSString *)typeStr{  //行号

    if(IsNilOrNull(_ckidString)){
      _ckidString = @"";
    }
    if (IsNilOrNull(_recordId)) {
        _recordId = @"0";
    }
    if (![_isDownloadMore isEqualToString:@"2"]) {
         _recordId = @"0";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *requestUrl = nil;
    if ([typeStr isEqualToString:@"1"]){
        requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getMyRechargeRecord_Url];
    }else{
        requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getMyInviteRecord_Url];
    }

    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"pagesize":@"20",@"id":_recordId,DeviceId:uuid};
    _nodataLableView.hidden = YES;
    
    if (IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.myPerfTableView.mj_header endRefreshing];
        [self.myPerfTableView.mj_footer endRefreshing];
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        _totalModel = [[TodaySaleModel alloc] init];
        [_totalModel setValuesForKeysWithDictionary:dict];
      
        if(![_isDownloadMore isEqualToString:@"2"]){
            [self.data_array removeAllObjects];
        }
        
        NSArray *listArr = dict[@"list"];
        if (listArr.count == 0) {
            if ([_isDownloadMore isEqualToString:@"2"]) {
                [self.myPerfTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        for (NSDictionary *listDic in listArr) {
            self.myPerfModel = [[MyTeamListModel alloc] init];
            [self.myPerfModel setValuesForKeysWithDictionary:listDic];
            [self.data_array addObject: self.myPerfModel];
        }
        
        [self refreshWithModel:_totalModel andArray:self.data_array];
        _recordId =  [NSString stringWithFormat:@"%zd",self.data_array.count];
        if(![self.data_array count]){
            _nodataLableView.hidden = NO;
            [self.myPerfTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.data_array.count];
        }
        [self.myPerfTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.myPerfTableView.mj_footer endRefreshing];
        [self.myPerfTableView.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
#pragma mark—刷新头部值
-(void)refreshWithModel:(TodaySaleModel *)totalModel andArray:(NSMutableArray *)array{
    //我的业绩
    NSString *myPerf = [NSString stringWithFormat:@"%@",totalModel.myperf];
    if (IsNilOrNull(myPerf)){
        myPerf = @"0.00";
    }
    double myPerfFloat = [myPerf doubleValue];
    _todaySaleView.moneyTotalLable.text = [NSString stringWithFormat:@"¥%.2f",myPerfFloat];
    
    //进货总计
    NSString *jhperf = [NSString stringWithFormat:@"%@",totalModel.jhperf];
    if (IsNilOrNull(jhperf)) {
        jhperf = @"0.00";
    }
    
    double jhperfFloat = [jhperf doubleValue];
    _todaySaleView.moneySalesLable.text = [NSString stringWithFormat:@"¥%.2f",jhperfFloat];
    
    
    //推广总计
    NSString *zsperf = [NSString stringWithFormat:@"%@",totalModel.zsperf];
    if (IsNilOrNull(zsperf)) {
        zsperf = @"0.00";
    }
    double zsperfFloat = [zsperf doubleValue];
    _todaySaleView.moneyOrderBackLable.text = [NSString stringWithFormat:@"¥%.2f",zsperfFloat];
    //总笔数
    NSString *recordsize = [NSString stringWithFormat:@"%@",totalModel.recordssize];
    if (IsNilOrNull(recordsize)) {
        recordsize = @"0";
    }
    _todaySaleView.allNumLable.text = [NSString stringWithFormat:@"共计：%@笔",recordsize];
}
#pragma mrak- 创建我的业绩展示UI
-(void)createTableView{
    //最上面的view
   _todaySaleView =  [[TodaySaleView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, AdaptedHeight(200)) andTypeStr:@"2"];
    [self.view addSubview:_todaySaleView];
    _todaySaleView.delegate = self;

    _myPerfTableView = [[UITableView alloc] init];
    [self.view addSubview:_myPerfTableView];
    [_myPerfTableView setBackgroundColor:[UIColor tt_grayBgColor]];
    [_myPerfTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_todaySaleView.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
    }];
    
    [self.myPerfTableView registerClass:[MyResultsRecordTableViewCell class] forCellReuseIdentifier:myResultsCell];
    [self.myPerfTableView registerClass:[MyTeamTableViewCell class] forCellReuseIdentifier:zsPerfCell];
    _myPerfTableView.showsVerticalScrollIndicator = NO;
    _myPerfTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _myPerfTableView.delegate = self;
    _myPerfTableView.dataSource = self;
    self.myPerfTableView.rowHeight = UITableViewAutomaticDimension;
    self.myPerfTableView.estimatedRowHeight = 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.data_array count]){
        return self.data_array.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([_typeString isEqualToString:@"1"]){//进货总计
        MyResultsRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myResultsCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.typeString = _typeString;
        [cell setBackgroundColor:[UIColor tt_grayBgColor]];
        if ([self.data_array count]) {
            self.myPerfModel = self.data_array[indexPath.row];
            [cell refreshWithModel:self.myPerfModel];
        }
        return cell;
    }else{
        MyTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zsPerfCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor tt_grayBgColor];
        cell.delegate = self;
        cell.index = indexPath.row;
        cell.typeString = @"3";
        if ([self.data_array count]) {
            [cell refreshWithListModel:self.data_array[indexPath.row]];
        }
        return cell;
    
    }
    
}
#pragma mark-/**点击我的业绩  进货总计  推广总计按钮*/
-(void)refreshSalesButton:(UIButton *)saleButton{
    NSInteger tag = saleButton.tag -130;
   if(tag == 1){ //进货总计
        _typeString = @"1";
    }else{ //推广总计
       _typeString = @"2";
       
    }
    _isDownloadMore = @"";
    if (![_recordId isEqualToString:@"0"]) {
        _recordId = @"";
    }
    _todaySaleView.allNumLable.text = @"共计：0笔";
    [self.data_array removeAllObjects];
    [self.myPerfTableView reloadData];
    [self getMyRechargeDataWithType:_typeString];
}
#pragma mark-点击电话 拨打电话
-(void)clickMyTeamButtonWithIndex:(NSInteger)index{
    if ([self.data_array count]) {
        self.myPerfModel = self.data_array[index];
    }
    NSString *mobile = [NSString stringWithFormat:@"%@",self.myPerfModel.mobile];
    
    if (IsNilOrNull(mobile)){
        [self showNoticeView:@"电话为空"];
        return;
    }
    [MessageAlert shareInstance].isDealInBlock = YES;
    [[MessageAlert shareInstance] hiddenCancelBtn:NO];
    NSString *phone = [NSString stringWithFormat:@"是否拨打电话%@？",mobile];
    [[MessageAlert shareInstance] showCommonAlert:phone btnClick:^{
        NSString *num = @"";
        if (phone.length > 18 || phone.length == 18) {
            NSRange range = {6,11};
            NSString *string = [phone substringWithRange:range];
            num = [NSString stringWithFormat:@"tel:%@",string];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //
        }

    }];
}

-(void)refreshData{
    
    __typeof (self) __weak weakSelf = self;
    self.myPerfTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"1";
        [weakSelf.myPerfTableView.mj_header beginRefreshing];
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
                    [weakSelf getMyRechargeDataWithType:_typeString];
                }else{
                    [weakSelf.myPerfTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.myPerfTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.myPerfTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"2";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf getMyRechargeDataWithType:_typeString];
//                [weakSelf.myPerfTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.myPerfTableView.mj_footer endRefreshing];
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
