//
//  CKCTheHeadlinesController.m
//  CKYSPlatform
//
//  Created by ckys on 16/7/14.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "MediaReportsController.h"
#import "WebDetailViewController.h"
#import "MediaTableViewCell.h"
#import "HeaderModel.h"

@interface MediaReportsController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_pageId;
    NSString *_isDownloadMore;
}
@property(nonatomic,strong)HeaderModel *mediaModel;
@property (nonatomic, strong) UITableView *headerTableView;
@property (nonatomic, strong) NSMutableArray *mediaArray;

@end

@implementation MediaReportsController

-(NSMutableArray *)mediaArray{
    if (_mediaArray == nil) {
        _mediaArray = [[NSMutableArray alloc] init];
    }
    return _mediaArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"媒体报道";
    [self createTableView];
    [self getCKCMediaData];
    [self refreshData];
}

#pragma mark - 请求媒体报道列表数据
- (void)getCKCMediaData {
    if ([_isDownloadMore isEqualToString:@"1"]) {
        [self.mediaArray removeAllObjects];
    }
    if (IsNilOrNull(_pageId)) {
        _pageId = @"0";
    }
    if (![_isDownloadMore isEqualToString:@"2"]) {
        _pageId = @"0";
    }else{
        _pageId =  [NSString stringWithFormat:@"%zd",self.mediaArray.count];
        NSLog(@"当前行号%@",_pageId);
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getTopHotNews_Url];
//   请求类型（1：新闻 2：媒体报道 3：素材中心）
    NSDictionary *pramaDic = @{@"id":_pageId, @"pagesize":@"20", @"type":@"2", DeviceId:uuid};
    if (IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.headerTableView.mj_header endRefreshing];
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
            self.mediaModel = [[HeaderModel alloc] init];
            [self.mediaModel setValuesForKeysWithDictionary:newsDic];
            [self.mediaArray addObject:self.mediaModel];
        }

        [self.headerTableView.mj_header endRefreshing];
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

-(void)createTableView{
    if (@available(iOS 11.0, *)){
       _headerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-65-NaviAddHeight-BOTTOM_BAR_HEIGHT)];
    }else{
        _headerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    
    _headerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_headerTableView];
    // 自动布局
    self.headerTableView.backgroundColor = [UIColor tt_grayBgColor];
    self.headerTableView.rowHeight = UITableViewAutomaticDimension;
    self.headerTableView.estimatedRowHeight = 44;
    if (@available(iOS 11.0, *)){
        self.headerTableView.estimatedSectionHeaderHeight = 0;
        self.headerTableView.estimatedSectionFooterHeight = 0;
    }
    
    _headerTableView.delegate = self;
    _headerTableView.dataSource = self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mediaArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MediaTableViewCell"];
    if (cell == nil) {
        cell = [[MediaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MediaTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor tt_grayBgColor];
    if([self.mediaArray count]){
        _mediaModel = self.mediaArray[indexPath.row];
        [cell refreshWithMediaModel:_mediaModel];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.mediaArray count]){
        self.mediaModel = self.mediaArray[indexPath.row];
    }
    
    NSString *title = [NSString stringWithFormat:@"%@",self.mediaModel.title];
    if(IsNilOrNull(title)){
        title = @"";
    }
    NSString *headImageUrl = [NSString stringWithFormat:@"%@",self.mediaModel.imgurl];
    NSString *headUrl = [NSString loadImagePathWithString:headImageUrl];
    if(IsNilOrNull(headUrl)){
        headUrl = @"";
    }
    NSString *info = [NSString stringWithFormat:@"%@",self.mediaModel.info];
    if(IsNilOrNull(info)){
        info = @"";
    }

    NSString *detailurl = [NSString stringWithFormat:@"%@",self.mediaModel.url];
    if (IsNilOrNull(detailurl)){
        detailurl = @"";
    }
    WebDetailViewController *header = [[WebDetailViewController alloc] init];
    header.typeString = @"media";
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
                    [weakSelf getCKCMediaData];
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
                [weakSelf getCKCMediaData];
//                [weakSelf.headerTableView.mj_footer endRefreshing];
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
