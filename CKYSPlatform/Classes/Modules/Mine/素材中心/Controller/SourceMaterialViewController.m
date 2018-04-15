//
//  SourceMaterialViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/28.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "SourceMaterialViewController.h"
#import "CKCHeaderTableViewCell.h"
#import "HeaderModel.h"
#import "WebDetailViewController.h"
#import "CKSourceSearchViewController.h"

@interface SourceMaterialViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_isDownloadMore;
    NSString *_pageId;
}
@property(nonatomic,strong)HeaderModel *headerModel;
@property (nonatomic, strong) UITableView *sourceTableView;
@property (nonatomic, strong) NSMutableArray *sourceArray;

@end

@implementation SourceMaterialViewController

-(NSMutableArray *)sourceArray{
    if (_sourceArray == nil) {
        _sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"素材中心";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"source_Search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchSource)];
    right.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10;
        self.navigationItem.rightBarButtonItems = @[spaceItem, right];
    }
    
    [self createTableView];
    [self getSourceData];
    [self refreshData];
}

-(void)searchSource {
    CKSourceSearchViewController *sourceSearch = [[CKSourceSearchViewController alloc] init];
    [self.navigationController pushViewController:sourceSearch animated:YES];
}

/**获取资源中心列表*/
-(void)getSourceData{
    
//    请求类型（1：新闻 2：学习天地 3：素材中心
    if ([_isDownloadMore isEqualToString:@"1"]) {
        [self.sourceArray removeAllObjects];
    }
    if (IsNilOrNull(_pageId)){
        _pageId = @"0";
    }
    if (![_isDownloadMore isEqualToString:@"2"]) {
        _pageId = @"0";
    }else{
        _pageId =  [NSString stringWithFormat:@"%zd",self.sourceArray.count];
        NSLog(@"当前行号%@",_pageId);
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getTopHotNews_Url];
    NSDictionary *pramaDic = @{@"id":_pageId,@"pagesize":@"20",@"type":@"3"};
    if(IsNilOrNull(_isDownloadMore)){
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.sourceTableView.mj_header endRefreshing];
        [self.sourceTableView.mj_footer endRefreshing];
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        NSArray *newsArr = dict[@"news"];
        if (newsArr.count == 0) {
            if ([_isDownloadMore isEqualToString:@"2"]) {
                [self.sourceTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        
        for (NSDictionary *newsDic in newsArr) {
            _headerModel = [[HeaderModel alloc] init];
            [_headerModel setValuesForKeysWithDictionary:newsDic];
            [self.sourceArray addObject:_headerModel];
        }
//        _pageId = [NSString stringWithFormat:@"%zd",self.sourceArray.count];
        
        [self.sourceTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.sourceTableView.mj_header endRefreshing];
        [self.sourceTableView.mj_footer endRefreshing];
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
        _sourceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    }else{
        _sourceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    }
    
    _sourceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_sourceTableView];
    _sourceTableView.backgroundColor = [UIColor tt_grayBgColor];
    // 自动布局
    self.sourceTableView.rowHeight = UITableViewAutomaticDimension;
    self.sourceTableView.estimatedRowHeight = 44;
    _sourceTableView.delegate = self;
    _sourceTableView.dataSource = self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CKCHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sourceCell"];
    if (cell == nil) {
        cell = [[CKCHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sourceCell"];
    }
    cell.typestring = @"3";
    cell.backgroundColor = [UIColor tt_grayBgColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([self.sourceArray count]){
        _headerModel = self.sourceArray[indexPath.row];
        [cell refreshWithHeaderModel:_headerModel];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.sourceArray count]){
        self.headerModel = self.sourceArray[indexPath.row];
    }
    NSString *title = [NSString stringWithFormat:@"%@",self.headerModel.title];
    if(IsNilOrNull(title)){
        title = @"";
    }
    NSString *headImageUrl = [NSString stringWithFormat:@"%@",self.headerModel.imgurl];
    NSString *headUrl = [NSString loadImagePathWithString:headImageUrl];
    if(IsNilOrNull(headUrl)){
        headUrl = @"";
    }
    NSString *info = [NSString stringWithFormat:@"%@",self.headerModel.info];
    if(IsNilOrNull(info)){
        info = @"";
    }

    //详情Url
    NSString *detailUrl = [NSString stringWithFormat:@"%@",self.headerModel.url];
    if (IsNilOrNull(detailUrl)){
        detailUrl = @"";
    }
    WebDetailViewController *sourcedetail = [[WebDetailViewController alloc] init];
    sourcedetail.typeString = @"source";
    sourcedetail.detailUrl = detailUrl;
    sourcedetail.shareTitle = title;
    sourcedetail.shareDescrip = info;
    sourcedetail.imgUrl = headUrl;
    [self.navigationController pushViewController:sourcedetail animated:YES];
}

-(void)refreshData{
    
    __typeof (self) __weak weakSelf = self;
    self.sourceTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _pageId = @"0";
        _isDownloadMore = @"1";
        [weakSelf.sourceTableView.mj_header beginRefreshing];
        
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
                    [weakSelf getSourceData];
                }else{
                    [weakSelf.sourceTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.sourceTableView.mj_header endRefreshing];
            }
                break;
        }
    }];

    self.sourceTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isDownloadMore = @"2";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf getSourceData];
//                [weakSelf.sourceTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.sourceTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
}

@end
