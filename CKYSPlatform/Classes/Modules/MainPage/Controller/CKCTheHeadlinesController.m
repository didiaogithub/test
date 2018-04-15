//
//  CKCTheHeadlinesController.m
//  CKYSPlatform
//
//  Created by ckys on 16/7/14.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "CKCTheHeadlinesController.h"
#import "CKHotNewsCell.h"
#import "WebDetailViewController.h"
#import "HeaderModel.h"

@interface CKCTheHeadlinesController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_pageId;
    NSString *_isDownloadMore;
}
@property (nonatomic, strong) HeaderModel *headerModel;
@property (nonatomic, strong) UITableView *headerTableView;
@property (nonatomic, strong) NSMutableArray *headerArray;

@end

@implementation CKCTheHeadlinesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"创客村头条";
    [self createTableView];
    [self getCKCHeaderData];
    [self refreshData];
}

-(NSMutableArray *)headerArray{
    if (_headerArray == nil) {
        _headerArray = [[NSMutableArray alloc] init];
    }
    return _headerArray;
}

#pragma mark-/**获取创客村头条新闻列表*/
-(void)getCKCHeaderData{
    if ([_isDownloadMore isEqualToString:@"1"]) {
        [self.headerArray removeAllObjects];
    }
    if (IsNilOrNull(_pageId)) {
        _pageId = @"0";
    }
    if (![_isDownloadMore isEqualToString:@"2"]) {
        _pageId = @"0";
    }else{
        _pageId =  [NSString stringWithFormat:@"%zd",self.headerArray.count];
        NSLog(@"当前行号%@",_pageId);
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getTopHotNews_Url];
//   请求类型（1：新闻 2：学习天地 3：素材中心）
    NSDictionary *pramaDic = @{@"id":_pageId,@"pagesize":@"20",@"type":@"1",DeviceId:uuid};
    if (IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.headerTableView.mj_header endRefreshing];
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.headerTableView.mj_footer endRefreshing];
            return ;
        }
        
        NSArray *newsArr = dict[@"news"];
        if (newsArr.count == 0) {
            if ([_isDownloadMore isEqualToString:@"2"]) {
                [self.headerTableView.mj_footer endRefreshingWithNoMoreData];

            }
            return;
        }
        for (NSDictionary *newsDic in newsArr) {
            self.headerModel = [[HeaderModel alloc] init];
            [self.headerModel setValuesForKeysWithDictionary:newsDic];
            [self.headerArray addObject:self.headerModel];
        }
        [self.headerTableView.mj_footer endRefreshing];
        [self.headerTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.headerTableView.mj_header endRefreshing];
        [self.headerTableView.mj_footer endRefreshing];
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];

}

- (void)createTableView {
    
    _headerTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _headerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_headerTableView];
    self.headerTableView.backgroundColor = [UIColor tt_grayBgColor];
    self.headerTableView.rowHeight = UITableViewAutomaticDimension;
    self.headerTableView.estimatedRowHeight = 44;
    _headerTableView.delegate = self;
    _headerTableView.dataSource = self;
    
    if (@available(iOS 11.0, *)){
//        _headerTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        [_headerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
            make.left.right.mas_offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
        }];
    }else{
        [_headerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.right.bottom.mas_offset(0);
        }];
    }
}

#pragma mark - tableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.headerArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CKHotNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKHotNewsCell"];
    if (cell == nil) {
        cell = [[CKHotNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKHotNewsCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor tt_grayBgColor];
    if([self.headerArray count]){
        _headerModel = self.headerArray[indexPath.row];
        [cell refreshWithHeaderModel:_headerModel];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.headerArray count]){
        _headerModel = self.headerArray[indexPath.row];
    }
    //标题
    NSString *title = [NSString stringWithFormat:@"%@",_headerModel.title];
    if(IsNilOrNull(title)){
        title = @"";
    }
    //图片
    NSString *headImageUrl = [NSString stringWithFormat:@"%@",_headerModel.imgurl];
    NSString *headUrl = [NSString loadImagePathWithString:headImageUrl];
    if(IsNilOrNull(headUrl)){
        headUrl = @"";
    }
    //描述
    NSString *info = [NSString stringWithFormat:@"%@",_headerModel.info];
    if(IsNilOrNull(info)){
        info = @"";
    }
    //详情url
    NSString *detailurl = [NSString stringWithFormat:@"%@",_headerModel.url];
    if (IsNilOrNull(detailurl)) {
       detailurl = @"";
    }
    WebDetailViewController *header = [[WebDetailViewController alloc] init];
    header.typeString = @"news";
    header.detailUrl = detailurl;
    header.shareTitle = title;
    header.shareDescrip = info;
    header.imgUrl = headUrl;
    [self.navigationController pushViewController:header animated:YES];

}

-(void)refreshData{
    
    __typeof (self) __weak weakSelf = self;
    self.headerTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _pageId = @"0";
        _isDownloadMore = @"1";
        [weakSelf.headerTableView.mj_header beginRefreshing];
        
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
                    [weakSelf getCKCHeaderData];
                }else{
                    [weakSelf.headerTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.headerTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.headerTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"2";
        
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf getCKCHeaderData];
                [weakSelf.headerTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.headerTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
}

@end
