//
//  CollegeTableViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CollegeTableViewController.h"
#import "MiddleViewController.h"
//#import "SearchViewController.h"
#import "CKClassSearchViewController.h"
#import "ClassModel.h"
#import "WebDetailViewController.h"
#import "CollegeCommon.h"
#import "ZJScrollPageViewDelegate.h"
#import "ZJScrollPageView.h"
#import "XWAlterVeiw.h"
#import "UIButton+XN.h"

@interface CollegeTableViewController ()<ZJScrollPageViewDelegate, ZJScrollPageViewChildVcDelegate, XWAlterVeiwDelegate>

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleModelArray;
@property (nonatomic, strong) NSMutableArray *sortIDArray;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property (nonatomic, strong) ZJSegmentStyle *style;
@property (nonatomic, copy)   NSString *liveUrl;
@property (nonatomic, copy)   NSString *classId;

@end

@implementation CollegeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initComponents];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    [self checkNetworkStatus];
}

-(NSMutableArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

-(NSMutableArray *)titleModelArray {
    if (_titleModelArray == nil) {
        _titleModelArray = [NSMutableArray array];
    }
    return _titleModelArray;
}

-(NSMutableArray *)sortIDArray {
    if (_sortIDArray == nil) {
        _sortIDArray = [NSMutableArray array];
    }
    return _sortIDArray;
}

-(void)checkNetworkStatus {
    
    NSLog(@"检查网络");
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    switch (status) {
        case RequestReachabilityStatusReachableViaWiFi:
        case RequestReachabilityStatusReachableViaWWAN: {
//            if(_titleArray.count == 0){
//                RLMResults *result = [[CacheData shareInstance] search:[ClassTitleModel class]];
//                if (result.count > 0) {
//                    [self bindCollegeTitleData];
//                }else{
//                    [self requestData];
//                }
//            }else{
//                if (_nodataLableView) {
//                    [_nodataLableView removeFromSuperview];
//                }
//                RLMResults *result = [[CacheData shareInstance] search:[ClassTitleModel class]];
//                if (result.count > 0) {
//                    [self bindCollegeTitleData];
//                }else{
//                    [self requestData];
//                }
//            }
            [self requestData];
        }
            break;
            
        default: {
            if (_nodataLableView) {
                [_nodataLableView removeFromSuperview];
            }
            [self bindCollegeTitleData];
        }
            break;
    }
}


#pragma mark - 请求数据
-(void)requestData {
    
    if (_nodataLableView) {
        [_nodataLableView removeFromSuperview];
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSDictionary *pramaDic = @{DeviceId:uuid};
    
    [CollegeCommon getCollegeData:getLessonsSort parameter:pramaDic compeletionHandle:^(id obj, NSError *error) {
        if (obj) {
            NSDictionary *dict = obj;
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
            if ([code isEqualToString:@"200"]) {
                
                NSArray *lessonTypeArr = dict[@"lessonType"];

                if (lessonTypeArr.count == 0) {
                    if (_titleModelArray.count == 0) {
                        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT - 113)];
                        _nodataLableView.nodataLabel.text = @"暂无课程";
                        [self.view addSubview:_nodataLableView];
                    }
                    return;
                }
                
                ClassTitleModel *clsTM = [[ClassTitleModel alloc] init];
                [clsTM setValuesForKeysWithDictionary:dict];
                clsTM.ckid = KCKidstring;
                if (lessonTypeArr.count > 0) {
                    for (NSDictionary *dic in lessonTypeArr) {
                        lessonType *typeM = [[lessonType alloc] init];
                        [typeM setValuesForKeysWithDictionary:dic];
                        [clsTM.lessonTypeArr addObject:typeM];
                    }
                }
                
                NSArray *cacheArr = [[XNArchiverManager shareInstance] xnUnarchiverObject:@"CKCollegeTitle"];
                
                if (![lessonTypeArr isEqualToArray:cacheArr]) {
                    NSLog(@"CollegeTitle 有更新了");
                    [[XNArchiverManager shareInstance] xnArchiverObject:lessonTypeArr archiverName:@"CKCollegeTitle"];
                    
                    RLMResults *result = [[CacheData shareInstance] search:[ClassTitleModel class]];
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    if (result.count > 0) {
                        [realm beginWriteTransaction];
                        [realm deleteObjects:result];
                        [realm commitWriteTransaction];
                    }
                    
                    [self.titleArray removeAllObjects];
                    
                    [realm beginWriteTransaction];
                    [ClassTitleModel createOrUpdateInRealm:realm withValue:clsTM];
                    [realm commitWriteTransaction];
                    
                }else{
                    
//                    RLMResults *result = [[CacheData shareInstance] search:[ClassTitleModel class]];
                    RLMRealm *realm = [RLMRealm defaultRealm];
//                    if (result.count > 0) {
//                        [realm beginWriteTransaction];
//                        [realm deleteObjects:result];
//                        [realm commitWriteTransaction];
//                    }
//                    [self.titleArray removeAllObjects];
                    
                    [realm beginWriteTransaction];
                    [ClassTitleModel createOrUpdateInRealm:realm withValue:clsTM];
                    [realm commitWriteTransaction];
                }
                
                [self bindCollegeTitleData];
            }
        }else if(error) {
            
            if (_titleModelArray.count == 0) {
                _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT - 113)];
                _nodataLableView.nodataLabel.text = @"暂无课程";
                [self.view addSubview:_nodataLableView];
            }
            if (error.code == -1009) {
                [self showNoticeView:NetWorkNotReachable];
            }else{
                [self showNoticeView:NetWorkTimeout];
            }
        }
    }];
}

-(void)bindCollegeTitleData {
    
    [self.titleModelArray removeAllObjects];
    RLMResults *result = [[CacheData shareInstance] search:[ClassTitleModel class]];
    if (result.count == 0) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT - 113)];
        _nodataLableView.nodataLabel.text = @"暂无课程";
        [self.view addSubview:_nodataLableView];
    }else{
        ClassTitleModel *clsTM = result.firstObject;
        _liveUrl = [NSString stringWithFormat:@"%@", clsTM.url];
        if (IsNilOrNull(_liveUrl)){
            _liveUrl = @"";
        }
        
        NSMutableArray *temp = [NSMutableArray array];
        for (lessonType *typeM in clsTM.lessonTypeArr) {
            [self.titleModelArray addObject:typeM];
            [temp addObject:typeM.name];
        }
        
        if (self.titleArray.count == 0) {
            for (int i = 0; i<self.titleModelArray.count; i++) {
                lessonType *typeM = [self.titleModelArray objectAtIndex:i];
                NSString *titleStr = [NSString stringWithFormat:@"%@", typeM.name];
                NSString *sortID = [NSString stringWithFormat:@"%@", typeM.sortID];
                [self.titleArray addObject:titleStr];
                [self.sortIDArray addObject:sortID];
            }
            [_scrollPageView reloadWithNewTitles:self.titleArray andIndex:self.zj_currentIndex];
        }
        
        [self.titleArray removeAllObjects];
        self.titleArray = temp;
    }
}

-(void)initComponents{
    /**设置title样式*/
    _style = [[ZJSegmentStyle alloc] init];
    _style.normalTitleColor = TitleColor;
    _style.selectedTitleColor = [UIColor tt_redMoneyColor];
    _style.scrollLineColor = [UIColor tt_redMoneyColor];
    _style.scrollLineHeight = 1.5;
    
    //显示滚动条
    _style.showLine = YES;
    _style.titleFont = MAIN_TITLE_FONT;
    _style.autoAdjustTitlesWidth = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.titleArray removeAllObjects];

    // 初始化
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 65-49-BOTTOM_BAR_HEIGHT-NaviAddHeight) segmentStyle:_style titles:self.titleArray parentViewController:self delegate:self];

    [_scrollPageView setBackgroundColor:[UIColor tt_grayBgColor]];
    [self.view addSubview:_scrollPageView];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];

    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn setTitleColor:TitleColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"classsearchbank"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"classsearchbank"] forState:UIControlStateHighlighted];
    [btn layoutButtonWithEdgeInsetsStyle:XNButtonEdgeInsetsStyleRight imageTitleSpace:0];
    
    [btn addTarget:self action:@selector(clickSearchButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = btn;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"商学院" style:UIBarButtonItemStylePlain target:self action:nil];
    left.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.leftBarButtonItem = left;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = 10;
        self.navigationItem.leftBarButtonItems = @[spaceItem, left];
    }
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"classlive"] style:UIBarButtonItemStylePlain target:self action:@selector(clickClassLiveButton)];
    right.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = 10;
        self.navigationItem.rightBarButtonItems = @[spaceItem, right];
    }
    
    
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(requestDataWithoutCache) name:@"RequestCollegeData" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(updateClassTitle) name:DidReceiveClassTitleUpdatePushNoti object:nil];

}

-(void)requestDataWithoutCache {
    RLMResults *result = [[CacheData shareInstance] search:[ClassTitleModel class]];
    if (result.count == 0) {
        [self requestData];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestLessonsData" object:nil];
    }
}

-(void)updateClassTitle {
    
    [self.titleModelArray removeAllObjects];
    [self.titleArray removeAllObjects];

    RLMResults *result = [[CacheData shareInstance] search:[ClassTitleModel class]];
    ClassTitleModel *clsTM = result.firstObject;
    _liveUrl = [NSString stringWithFormat:@"%@", clsTM.url];
    if (IsNilOrNull(_liveUrl)){
        _liveUrl = @"";
    }
    
    NSMutableArray *temp = [NSMutableArray array];
    for (lessonType *typeM in clsTM.lessonTypeArr) {
        [self.titleModelArray addObject:typeM];
        [temp addObject:typeM.name];
    }
    
    for (int i = 0; i<self.titleModelArray.count; i++) {
        lessonType *typeM = [self.titleModelArray objectAtIndex:i];
        NSString *titleStr = [NSString stringWithFormat:@"%@", typeM.name];
        NSString *sortID = [NSString stringWithFormat:@"%@", typeM.sortID];
        [self.titleArray addObject:titleStr];
        [self.sortIDArray addObject:sortID];
    }
    [_scrollPageView reloadWithNewTitles:self.titleArray andIndex:self.zj_currentIndex];
    
    self.titleArray = temp;
}

-(void)defaultTableViewFrame {
    self.netTip.frame = CGRectMake(0, 20+NaviAddHeight, SCREEN_WIDTH, 44);
    _scrollPageView.frame = CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 65-49-BOTTOM_BAR_HEIGHT-NaviAddHeight);
}

-(void)changeTableViewFrame {
    self.netTip.frame = CGRectMake(0, 20+44+NaviAddHeight, SCREEN_WIDTH, 44);
    _scrollPageView.frame = CGRectMake(0, 65+44+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 65-49-BOTTOM_BAR_HEIGHT-NaviAddHeight);
}

#pragma mark - 搜索课程
-(void)clickSearchButton{
    
    CKClassSearchViewController *searchVC = [[CKClassSearchViewController alloc] init];

//    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
}

#pragma mark-点击直播间
-(void)clickClassLiveButton{
    

    XWAlterVeiw *alertView = [[XWAlterVeiw alloc] init];
    alertView.delegate = self;
    alertView.titleLable.text = @"点击直播间，使其它手机扫描二维码登录，每次按此步骤进行进入直播学习";
    [alertView show];
    
}

-(void)subuttonClicked {
    WebDetailViewController *classLive = [[WebDetailViewController alloc] init];
    classLive.typeString = @"classlive";
    classLive.detailUrl = _liveUrl;
    [self.navigationController pushViewController:classLive animated:YES];
}


- (NSInteger)numberOfChildViewControllers {
    return self.titleArray.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)[[MiddleViewController alloc] init];
    }
    
    SEL selector = NSSelectorFromString(@"passSortIdArray:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
    [childVc performSelector:selector withObject:self.sortIDArray];
#pragma clang diagnostic pop
    
    return childVc;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

-(void)dealloc {
    [CKCNotificationCenter removeObserver:self name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter removeObserver:self name:@"NoNetNotification" object:nil];
    [CKCNotificationCenter removeObserver:self name:@"RequestCollegeData" object:nil];
}

@end
