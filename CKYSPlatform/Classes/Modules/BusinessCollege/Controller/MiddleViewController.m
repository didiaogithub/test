//
//  MiddleViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "MiddleViewController.h"
#import "UIViewController+ZJScrollPageController.h"
#import "ClassDetailViewController.h"
#import "CollegeTableViewCell.h"
#import "ClassModel.h"
#import "CollegeCommon.h"
#import "ZJScrollPageViewDelegate.h"
#import "CKC_CustomProgressView.h"
#import "CacheData.h"

@interface MiddleViewController ()<ZJScrollPageViewChildVcDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy)   NSString *ckidString;
@property (nonatomic, copy)   NSString *classId;
@property (nonatomic, strong) UITableView *collegeTableView;
@property (nonatomic, strong) NSMutableArray *classifiArray;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, strong) NSArray *sortIDArr;
@property (nonatomic, copy)   NSString *sortID;
@property (nonatomic, assign) NSTimeInterval startInterval;
@property (nonatomic, assign) NSTimeInterval endInterval;
@property (nonatomic, strong) CKC_CustomProgressView *viewDataLoading;
@property (nonatomic, strong) JGProgressHUD *viewNetError;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation MiddleViewController

-(NodataLableView *)nodataLableView {
    if (_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64-49-50)];
        _nodataLableView.nodataLabel.text = @"暂无课程";
    }
    return _nodataLableView;
}

-(NSMutableArray *)classifiArray{
    if (_classifiArray == nil) {
        _classifiArray = [NSMutableArray array];
    }
    return _classifiArray;
}

-(void)passSortIdArray:(id)data {
    _sortIDArr = data;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeComponent];
    
    [self refreshData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.viewDataLoading stopAnimation];
}

-(void)initializeComponent {
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
    self.startInterval = [nowDate timeIntervalSince1970];
    
    _collegeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-65-49-AdaptedHeight(35)) style:UITableViewStylePlain];
    _collegeTableView.rowHeight = UITableViewAutomaticDimension;
    _collegeTableView.estimatedRowHeight = 44;
    _collegeTableView.backgroundColor = [UIColor tt_grayBgColor];
    _collegeTableView.delegate = self;
    _collegeTableView.dataSource = self;
    _collegeTableView.showsVerticalScrollIndicator = NO;
    _collegeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_collegeTableView];
    
    [self createLoadDataUI];
    
    [CKCNotificationCenter addObserver:self selector:@selector(getLessonsData) name:@"refreshCollegeLesson" object:nil];
    
    [CKCNotificationCenter addObserver:self selector:@selector(getLessonsDataWithoutCache) name:@"RequestLessonsData" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(updateReadNumber:) name:@"updateReadNumber" object:nil];
    //暂时不用
    [CKCNotificationCenter addObserver:self selector:@selector(updateClassDetail:) name:DidReceiveClassDetailUpdatePushNoti object:nil];

}

-(void)zj_viewDidLoadForIndex:(NSInteger)index{
    NSLog(@"点击了%zd",index);

    _sortID = _sortIDArr[index];
    _isLoading = YES;
    [self checkNetworking];

}

- (void)zj_viewWillAppearForIndex:(NSInteger)index {
    NSLog(@"点击了%zd",index);
    _sortID = _sortIDArr[index];
    
    NSArray *sordidArr = [KUserdefaults objectForKey:@"CollegeClassPushIdArr"];
    
    if ([sordidArr containsObject:_sortID] || ([self getCacheData].count == 0)) {
        if ([sordidArr containsObject:_sortID]) {
            RLMResults *classArr = [ClassModel objectsWhere:[NSString stringWithFormat:@"sortID = '%@'", _sortID]];
            RLMRealm *realm = [RLMRealm defaultRealm];
            if (classArr.count > 0) {
                for (ClassModel *classM in classArr) {
                    [realm beginWriteTransaction];
                    [realm deleteObject:classM];
                    [realm commitWriteTransaction];
                }
            }
            [self.classifiArray removeAllObjects];
            [self.collegeTableView reloadData];
        }
        [self getLessonsData];
    }
}

-(void)getLessonsDataWithoutCache {
    if ([self getCacheData].count == 0) {
        [self getLessonsData];
    }
}

-(RLMResults *)getCacheData {
    NSString *predicate = [NSString stringWithFormat:@"sortID = '%@'", _sortID];
//    RLMResults *results = [[CacheData shareInstance] search:[ClassModel class] predicate:predicate sorted:@"time" ascending:NO];
    RLMResults *results = [[CacheData shareInstance] search:[ClassModel class] predicate:predicate];
    return results;
}

-(void)checkNetworking {
    
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    switch (status) {
        case RequestReachabilityStatusReachableViaWiFi:
        case RequestReachabilityStatusReachableViaWWAN: {
            if ([self getCacheData].count > 0) {
                [self loadCacheData:[self getCacheData]];
            }
            [self getLessonsData];
        }
            break;
            
        default: {
            if ([self getCacheData].count > 0) {
                [self loadCacheData:[self getCacheData]];
            }else{
                if([self.classifiArray count] == 0){
                    [self.collegeTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.classifiArray.count];
                }
            }
        }
            break;
    }
}

#pragma mark - 加载缓存
-(void)loadCacheData:(RLMResults *)classArr {
    
    [_classifiArray removeAllObjects];
    if (classArr.count > 20) {
        for (NSInteger i = 0; i < 20; i++) {
            ClassModel *cls = classArr[i];
            [_classifiArray addObject:cls];
        }
    }else{
        for (ClassModel *cls in classArr) {
            [_classifiArray addObject:cls];
        }
    }
    
    [self.collegeTableView.mj_header endRefreshing];
    [self.collegeTableView.mj_footer endRefreshing];
    [self.collegeTableView reloadData];
}

#pragma mark - 请求商学院课程列表数据
-(void)getLessonsData{
    
    if (IsNilOrNull(_classId)) {
        _classId = @"0";
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSDictionary *pramaDic = @{@"id":@"0",@"pagesize":@"20",@"sortid":_sortID,DeviceId:uuid};
    
    if (_isLoading) {
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    
    if (_nodataLableView) {
        [_nodataLableView removeFromSuperview];
    }
    
    [NSString deleteWebCache];
    
    [CollegeCommon getCollegeData:getLessonsBySortId parameter:pramaDic compeletionHandle:^(id obj, NSError *error) {
        if (obj) {
            
            NSDictionary *dict = obj;
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
            if ([code isEqualToString:@"200"]) {
                
                NSDictionary *nonNullDict = [dict deleteAllNullValue];

                NSArray *lessonsArr = nonNullDict[@"lessons"];
                //1.请求最新课程
                if (lessonsArr.count == 0) {
                    if (_classifiArray.count == 0) {
                        [self.collegeTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.classifiArray.count];
                        }
                    [self.collegeTableView.mj_header endRefreshing];
                }else{
                    
                    
                    RLMResults *classArr = [ClassModel objectsWhere:[NSString stringWithFormat:@"sortID = '%@'", _sortID]];
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    if (classArr.count > 0) {
                        for (ClassModel *classM in classArr) {
                            [realm beginWriteTransaction];
                            [realm deleteObject:classM];
                            [realm commitWriteTransaction];
                        }
                    }
                    
                    [self.classifiArray removeAllObjects];
                    for (NSDictionary *listDic in lessonsArr){
                        ClassModel *classModel = [[ClassModel alloc] init];
                        [classModel setValuesForKeysWithDictionary:listDic];
                        classModel.sortID = _sortID;
                        [self.classifiArray addObject:classModel];
                    }
                    

                    for (NSInteger i = 0; i < self.classifiArray.count; i++) {
                        ClassModel *classM = self.classifiArray[i];
                        RLMRealm *realm = [RLMRealm defaultRealm];
                        [realm beginWriteTransaction];
                        [ClassModel createOrUpdateInRealm:realm withValue:classM];
                        [realm commitWriteTransaction];
                    }
                }
            }
            
            [self loadCacheData:[self getCacheData]];
            [self.viewDataLoading stopAnimation];
        }else if(error) {
            
            if (error.code == -1009) {
                [self showNoticeView:NetWorkNotReachable];
            }else{
                [self showNoticeView:NetWorkTimeout];
            }
            
            [self.collegeTableView.mj_header endRefreshing];
            
            if (self.classifiArray.count == 0) {
                [self loadCacheData:[self getCacheData]];
            }
            [self.viewDataLoading stopAnimation];
        }
    }];
}

#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.classifiArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollegeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollegeTableViewCell"];
    if (cell == nil) {
        cell = [[CollegeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CollegeTableViewCell"];
    }
    cell.backgroundColor = [UIColor tt_grayBgColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    RLMResults *result = [self getCacheData];
    if (result.count > 0) {
        ClassModel *classModel = result[indexPath.row];
        [cell refreshWithLessons:classModel];
    }
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm invalidate];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RLMResults *result = [self getCacheData];
    
    ClassModel *classModel = [[ClassModel alloc] init];
    if (result.count > 0) {
       classModel = result[indexPath.row];
    }
    _indexPath = indexPath;
    
    NSString *detailUrl = [NSString stringWithFormat:@"%@", classModel.url];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", WebServiceAPI, setViewed];
    NSDictionary *params = @{@"type": @"course", @"id":  classModel.classId};
    [HttpTool postWithUrl:urlStr params:params success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"点击了一次");
        }
    } failure:^(NSError *error) {
        
    }];
    
    
    ClassDetailViewController *classDetail = [[ClassDetailViewController alloc] init];
    classDetail.detailUrl = detailUrl;
    classDetail.classId = classModel.classId;
    classDetail.sortID = classModel.sortID;
    [self.navigationController pushViewController:classDetail animated:YES];

}

-(void)refreshData{
    
    __typeof (self) __weak weakSelf = self;
    self.collegeTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _classId = @"0";
        _isLoading = NO;
        [weakSelf.collegeTableView.mj_header beginRefreshing];
        
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
                    [self getLessonsData];
                }else{
                    [weakSelf.collegeTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.collegeTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.collegeTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isLoading = NO;

        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf loadMoreData];
                [weakSelf.collegeTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.collegeTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
}

-(void)loadMoreData {
    
    if (_isLoading) {
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    _classId = [NSString stringWithFormat:@"%zd", self.classifiArray.count];
    NSDictionary *pramaDic = @{@"id":_classId, @"pagesize":@"20", @"sortid":_sortID, DeviceId:uuid};
    
    [CollegeCommon getCollegeData:getLessonsBySortId parameter:pramaDic compeletionHandle:^(id obj, NSError *error) {
        if (obj) {
            NSDictionary *dict = obj;
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
            if ([code isEqualToString:@"200"]) {
                
                NSDictionary *nonNullDict = [dict deleteAllNullValue];
                NSArray *lessonsArr = nonNullDict[@"lessons"];
                NSLog(@"加载更多课程内容%@", self.classifiArray);

                if (lessonsArr.count == 0) {
                    [self.collegeTableView.mj_footer endRefreshingWithNoMoreData];
                    [self.viewDataLoading stopAnimation];
                    return;
                }else{
                    for (NSDictionary *listDic in lessonsArr){
                        ClassModel *classModel = [[ClassModel alloc] init];
                        [classModel setValuesForKeysWithDictionary:listDic];
                        classModel.sortID = _sortID;
                        [self.classifiArray addObject:classModel];
                    }
                    for (NSInteger i = 0; i < self.classifiArray.count; i++) {
                        ClassModel *classM = self.classifiArray[i];
                        RLMRealm *realm = [RLMRealm defaultRealm];
                        [realm beginWriteTransaction];
                        [ClassModel createOrUpdateInRealm:realm withValue:classM];
                        [realm commitWriteTransaction];
                    }
                    
                    [self.collegeTableView.mj_footer endRefreshing];
                    [self.collegeTableView reloadData];
                    [self.viewDataLoading stopAnimation];
                }
            }
        }else if(error) {
            [self.collegeTableView.mj_footer endRefreshing];
            [self.viewDataLoading stopAnimation];
        }
    }];
}

- (void)delayInSeconds:(CGFloat)delayInSeconds block:(dispatch_block_t) block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC),  dispatch_get_main_queue(), block);
}

/**添加风火轮*/
-(void)createLoadDataUI {
    // 增加风火轮
    self.viewDataLoading = [[CKC_CustomProgressView alloc] init];
    self.viewDataLoading.frame = self.view.bounds;
    // 增加网络错误时提示
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.indicatorView = nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionBottomCenter;
    self.viewNetError.marginInsets = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
    [self.viewDataLoading stopAnimation];
    
}
//添加提示view
- (void)showNoticeView:(NSString*)title {
    if (self.viewNetError && !self.viewNetError.visible) {
        self.viewNetError.textLabel.text = title;
        [self.viewNetError showInView:[UIApplication sharedApplication].keyWindow];
        [self.viewNetError dismissAfterDelay:1.5f];
    }
}

-(void)updateReadNumber:(NSNotification*)noti {
    
    NSDictionary *dict = noti.userInfo;
    if (_indexPath != nil) {
        ClassModel *classModel = self.classifiArray[_indexPath.row];
        ClassModel *classM = [[ClassModel alloc] init];
        classM.imgurl = classModel.imgurl;
        classM.viewed = [NSString stringWithFormat:@"%@",dict[@"viewed"]];
        classM.time = classModel.time;
        classM.classId = classModel.classId;
        classM.typecode = classModel.typecode;
        classM.title = classModel.title;
        classM.urlshare = classModel.urlshare;
        classM.teacher = classModel.teacher;
        classM.url = classModel.url;
        classM.sortID = classModel.sortID;
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [ClassModel createOrUpdateInRealm:realm withValue:classM];
        [realm commitWriteTransaction];
        if (_indexPath != nil) {
            [_collegeTableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
}

-(void)updateClassDetail:(NSNotification*)noit {
    
//    NSString *predicate = [NSString stringWithFormat:@"sortID == '%@'", _sortID];
//    RLMResults *results = [[CacheData shareInstance] search:[ClassModel class] predicate:predicate];
//    
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    RLMResults *results = [NSClassFromString(objName) objectsWhere:predicate];
//    if (results.count > 0) {
//        [realm beginWriteTransaction];
//        [realm deleteObject:results.firstObject];
//        [realm commitWriteTransaction];
//    }
//
//    [_classifiArray removeAllObjects];
//    for (ClassModel *cls in classArr) {
//        [_classifiArray addObject:cls];
//    }
//    
//    [self.collegeTableView.mj_header endRefreshing];
//    [self.collegeTableView reloadData];
    NSDictionary *dict = noit.userInfo;
    NSArray *sortIDArr = [dict allValues];
    if ([sortIDArr containsObject:_sortID]) {
        
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshCollegeLesson" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshColRequestLessonsDatalegeLesson" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateReadNumber" object:nil];
}

@end
