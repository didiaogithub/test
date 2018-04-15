//
//  TakeCashRecordViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/5/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "TakeCashRecordViewController.h"
#import "KKDatePickerView.h"
#import "TakeCashRecordDetailModel.h"
#import "TakeCashRecordModel.h"
#import "TakeCashRecordTableViewCell.h"
#import "TakeCashHeaderView.h"
static NSString *recordCell = @"TakeCashRecordTableViewCell";
@interface TakeCashRecordViewController ()<KKDatePickerViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
   TakeCashHeaderView *_takeCashHeaderView;
   NSString *_yearStr;
   NSString *_monthStr;
   TakeCashRecordDetailModel *_recordDetailModel;
   TakeCashRecordModel *_recordModel;
   UILabel *_timeLable;
   UILabel *_allCountLable;
    
   NSString *_isDownloadMore;
   NSString *_recordId;
    NSString *_ckidString;
    
}
@property(nonatomic,strong)UITableView *recordTableView;
@property(nonatomic,strong)NSMutableArray *recordDataArray;
@property(nonatomic,strong)NodataLableView *nodataLableView;
@end

@implementation TakeCashRecordViewController
-(NSMutableArray *)recordDataArray{
    if (_recordDataArray == nil){
        _recordDataArray = [[NSMutableArray alloc] init];
    }
    return _recordDataArray;
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
    self.navigationItem.title = @"我的提现记录";
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
    [self createNavButton];
    [self createTableView];
    [self loadMyTakeCashRecordData];
    [self refreshData];

}
-(void)createNavButton{
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"selectconditions"] style:UIBarButtonItemStylePlain target:self action:@selector(clickNavButton)];
    right.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10;
        self.navigationItem.rightBarButtonItems = @[spaceItem, right];
    }
}

-(void)clickNavButton{
    KKDatePickerView *pickerView = [[KKDatePickerView alloc]initWithFrame:self.view.bounds];
    pickerView.delegate = self;
    [pickerView show];
}
#pragma mark-/**点击pickerview代理方法*/
- (void)pickView:(NSString *)yes month:(NSString *)moth{
    
    if (![_recordId isEqualToString:@"0"]){
        _recordId = @"0";
    }
    _isDownloadMore = @"";
    _yearStr = yes;
    _monthStr = moth;
    [self loadMyTakeCashRecordData];
    if([self.recordDataArray count]){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.recordTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    }

}
#pragma mark-获取提现记录
-(void)loadMyTakeCashRecordData{
    if (IsNilOrNull(_recordId)){
        _recordId = @"0";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    if(![_isDownloadMore isEqualToString:@"2"]){
      _recordId = @"0";
    }
  
    NSString *timeStr = [NSString stringWithFormat:@"%@年%@月",_yearStr,_monthStr];;
    if (IsNilOrNull(_yearStr)){
        _yearStr = @"";
        timeStr = @"";
    }
    if (IsNilOrNull(_monthStr)){
        _monthStr = @"";
        timeStr = @"";
    }
    NSString *takeCashRecordUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getWithdrawCashRecord_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"time":timeStr,@"id":_recordId,@"pagesize":@"10",DeviceId:uuid};
    _nodataLableView.hidden = YES;
    if (IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    [HttpTool postWithUrl:takeCashRecordUrl params:pramaDic success:^(id json) {
        
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.recordTableView.mj_header endRefreshing];
            [self.recordTableView.mj_footer endRefreshing];
            return ;
        }
        if (![_isDownloadMore isEqualToString:@"2"]) {
            [self.recordDataArray removeAllObjects];
        }
        NSLog(@"提现记录%@",dict);
        
        
        NSArray *listArr = dict[@"list"];
        
        if (listArr.count == 0) {
            if ([_isDownloadMore isEqualToString:@"2"]) {
                [self.recordTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
        }
        
        for (NSDictionary *listRecordDic in listArr) {
            _recordModel = [TakeCashRecordModel getRecordModelWithDictionary:listRecordDic];
            [self.recordDataArray addObject:_recordModel];
        }
        _recordId = [NSString stringWithFormat:@"%zd",self.recordDataArray.count];
        
        if(![self.recordDataArray count]){
            _nodataLableView.hidden = NO;
            [self.recordTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.recordDataArray.count];
        }
        
        [self.recordTableView.mj_header endRefreshing];
        [self.recordTableView.mj_footer endRefreshing];
        [self.recordTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.recordTableView.mj_footer endRefreshing];
        [self.recordTableView.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
-(void)createTableView{
    
    if (@available(iOS 11.0, *)) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-65-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStyleGrouped];
    }else{
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,1, SCREEN_WIDTH, SCREEN_HEIGHT-1) style:UITableViewStyleGrouped];
    }
    [self.view addSubview:_recordTableView];
    _recordTableView.backgroundColor = [UIColor tt_grayBgColor];
    _recordTableView.rowHeight = UITableViewAutomaticDimension;
    _recordTableView.estimatedRowHeight = 44;
    _recordTableView.delegate = self;
    _recordTableView.dataSource = self;
    _recordTableView.showsVerticalScrollIndicator = NO;
    _recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark-tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.recordDataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    _recordModel = self.recordDataArray[section];
    return _recordModel.detailArray.count;
}
/**段头 自定义sectionHeader*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    
    _takeCashHeaderView = [[TakeCashHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AdaptedHeight(55))];
    
    [self refreshHeaderDataWithSection:section];

    return _takeCashHeaderView;
}
#pragma mark-刷新段头数据
-(void)refreshHeaderDataWithSection:(NSInteger)section{
    if ([self.recordDataArray count]) {
        _recordModel = self.recordDataArray[section];
    }
    NSString *timeStr = [NSString stringWithFormat:@"%@",_recordModel.time];
    if (IsNilOrNull(timeStr)) {
        timeStr = @"";
    }
    NSArray *timeArr = [timeStr componentsSeparatedByString:@"年"];
    _takeCashHeaderView.yearLable.text = [timeArr firstObject];
    _takeCashHeaderView.monthLable.text = [timeArr lastObject];
    
    NSInteger length = _takeCashHeaderView.monthLable.text.length;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_takeCashHeaderView.monthLable.text ];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:CHINESE_SYSTEM_BOLD(AdaptedHeight(51/2))
                          range:NSMakeRange(0, 2)];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:CHINESE_SYSTEM(AdaptedHeight(16))
                          range:NSMakeRange(length-1, 1)];
    _takeCashHeaderView.monthLable.attributedText = AttributedStr;


    NSString *countStr = nil;
    if([_recordModel.detailArray count]){
        countStr = [NSString stringWithFormat:@"%zd",_recordModel.detailArray.count];
    }else{
       countStr = @"0";
    }
    _takeCashHeaderView.allCountLable.text = [NSString stringWithFormat:@"共%@笔",countStr];
    

}
/**段头*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptedHeight(55);
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TakeCashRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordCell];
    if (cell == nil){
        cell = [[TakeCashRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recordCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor tt_grayBgColor];
    if ([self.recordDataArray count]){
        _recordModel = self.recordDataArray[indexPath.section];
        if ([_recordModel.detailArray count]){
            _recordDetailModel = _recordModel.detailArray[indexPath.row];
            [cell refreshWithRecordDetailModel:_recordDetailModel];
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(void)refreshData{
    __typeof (self) __weak weakSelf = self;
    self.recordTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"1";
        _yearStr = @"";
        _monthStr = @"";
        [weakSelf.recordTableView.mj_header beginRefreshing];
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
                     [weakSelf loadMyTakeCashRecordData];
                }else{
                    [weakSelf.recordTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.recordTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.recordTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"2";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf loadMyTakeCashRecordData];
//                [weakSelf.recordTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.recordTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
    
}



@end
