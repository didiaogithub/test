
//
//  MainViewController.m
//  Demo
//
//  Created by 庞宏侠 on 16/12/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DNewsViewController.h"
#import "TableViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "ZJScrollPageView.h"

@interface DNewsViewController ()<ZJScrollPageViewDelegate, ZJScrollPageViewChildVcDelegate>

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property (nonatomic, strong) ZJSegmentStyle *style;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UILabel *userNoReadLabel;
@property (nonatomic, strong) UILabel *sysNoReadLabel;
@property (nonatomic, strong) UILabel *officialNoReadLabel;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation DNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息中心";
    
    [self initComponents];
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"为了您不错过消息提示，请前往设置打开通知" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
        [vc presentViewController:alert animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSString *tgStr = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    if (IsNilOrNull(tgStr) || [tgStr isEqualToString:@"0"]) {
        _titles = @[KMsgType_Customer, KMsgType_System, KMsgType_Official];
    }else{
//        _titles = @[KMsgType_System, KMsgType_Official];
    //2017.06.28如果是推广人登录则只有官方通知
        _titles = @[KMsgType_Official];

    }
    
    if (self.titleArray.count == 0) {
        self.titleArray = [NSMutableArray arrayWithArray:_titles];
        [_scrollPageView reloadWithNewTitles:self.titleArray andIndex:self.zj_currentIndex];
    }else{
        if (self.titleArray.count == _titles.count) {
            
        }else{
            [self.titleArray removeAllObjects];
            self.titleArray = [NSMutableArray arrayWithArray:_titles];
            [_scrollPageView reloadWithNewTitles:self.titleArray andIndex:self.zj_currentIndex];
        }
    }
    
    //进入二级页面返回重新加载界面，是为了消除列表未读数角标
    [self.scrollPageView.contentView reload];
    [self getNotReadData: self.zj_currentIndex];

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
    _style.scrollContentView = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.titleArray removeAllObjects];
    
    // 初始化
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 65-49 - BOTTOM_BAR_HEIGHT-NaviAddHeight) segmentStyle:_style titles:self.titleArray parentViewController:self delegate:self];
    [_scrollPageView setBackgroundColor:[UIColor tt_grayBgColor]];
    [self.view addSubview:_scrollPageView];
    
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    
    //顾客消息红点
    if (!_userNoReadLabel){
        _userNoReadLabel = [[UILabel alloc] init];
        [self.view addSubview:_userNoReadLabel];
        _userNoReadLabel.backgroundColor = [UIColor tt_redMoneyColor];
        _userNoReadLabel.layer.cornerRadius = AdaptedWidth(10)/2;
        _userNoReadLabel.clipsToBounds = YES;
    }
    //系统通知红点
    if (!_sysNoReadLabel){
        _sysNoReadLabel = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM(AdaptedWidth(9))];
        [self.view addSubview:_sysNoReadLabel];
        _sysNoReadLabel.layer.cornerRadius = AdaptedWidth(10)/2;
        _sysNoReadLabel.backgroundColor = [UIColor tt_redMoneyColor];
        _sysNoReadLabel.clipsToBounds = YES;
    }
    //官方通知红点
    if (!_officialNoReadLabel){
        _officialNoReadLabel = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM(AdaptedWidth(9))];
        [self.view addSubview:_officialNoReadLabel];
        _officialNoReadLabel.layer.cornerRadius = AdaptedWidth(10)/2;
        _officialNoReadLabel.backgroundColor = [UIColor tt_redMoneyColor];
        _officialNoReadLabel.clipsToBounds = YES;
    }
    
}

#pragma mark-获取最新未读订单消息  系统消息
-(void)getNotReadData:(NSInteger)selectedIndex{
    
    NSString *titleStr = _titleArray[selectedIndex];
    if ([titleStr isEqualToString:KMsgType_Official]) {
        [self freshBagdeLabel:selectedIndex];
        return;
    }

    NSString *ckidStr = KCKidstring;
    if (IsNilOrNull(ckidStr)){
        ckidStr = @"";
    }
    
    NSDictionary *paramsDic = [[NSDictionary alloc] init];
    NSString *notReadUrl = @"";

    if ([titleStr isEqualToString:KMsgType_Customer]) {
        paramsDic = @{@"ckid":ckidStr,@"type":@"user"};
    }else if ([titleStr isEqualToString:KMsgType_System]){
        paramsDic = @{@"ckid":ckidStr,@"type":@"system"};
    }
    notReadUrl = [NSString stringWithFormat:@"%@%@",PostMessageAPI, getNotReadMsgNum];
    
    [HttpTool postWithUrl:notReadUrl params:paramsDic success:^(id json) {
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return;
        }
        NSString *userStr = [NSString stringWithFormat:@"%@",dict[@"notreadnum"]];
        if (IsNilOrNull(userStr) || [userStr isEqualToString:@"0"]) {
            userStr = @"0";
        }
        
        if ([titleStr isEqualToString:KMsgType_Customer]) {
            [KUserdefaults setObject:userStr forKey:KCustomerNotReadNum];
            [KUserdefaults synchronize];
        }else if ([titleStr isEqualToString:KMsgType_System]){
            [KUserdefaults setObject:userStr forKey:KSystemNotReadNum];
            [KUserdefaults synchronize];
        }
        //刷新未读消息角标
        [self freshBagdeLabel:selectedIndex];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 刷新未读消息角标:顾客消息、系统通知 点击的时候红点隐藏，列表所有都为已读 红点隐藏；官方通知：只要点击了就隐藏
-(void)freshBagdeLabel:(NSInteger)selectedIndex {
    
    if (_titleArray.count == 1) {
        [self pressBageForTG:selectedIndex];
    }else if (_titleArray.count == 2) {
        [self pressBageForTG:selectedIndex];
    }else{
        [self pressBageForCK:selectedIndex];
    }
}

-(void)pressBageForTG:(NSInteger)selectedIndex {
//    NSMutableArray *titleViews = [self.scrollPageView.segmentView valueForKeyPath:@"titleViews"];
    //系统通知未读
//    NSString *sysMsgStr =  [KUserdefaults objectForKey:KSystemNotReadNum];
//    if (IsNilOrNull(sysMsgStr)) {
//        sysMsgStr = @"0";
//    }
//    ZJTitleView *titleView = titleViews[0];
////    CGFloat offset = titleView.frame.origin.x + titleView.frame.size.width + 10;
//    //官方通知未读
//    NSString *officialStr =  [KUserdefaults objectForKey:KOfficialNotReadNum];
//    if (IsNilOrNull(officialStr)) {
//        officialStr = @"0";
//    }
    
    [_userNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        [self makeZeroConstraint:make];
    }];
    
    [_sysNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        [self makeZeroConstraint:make];
    }];
    
    [KUserdefaults setObject:@"0" forKey:KOfficialNotReadNum];
    [_officialNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        [self makeZeroConstraint:make];
    }];

//    ZJTitleView *titleView1 = titleViews[1];
//    CGFloat offset1 = titleView1.frame.origin.x + titleView1.frame.size.width + 10;
//    
//    [_userNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        [self makeZeroConstraint:make];
//    }];
//    
//    if (selectedIndex == 0) {
//        [_sysNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            [self makeZeroConstraint:make];
//        }];
//        
//        [_officialNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            [self makeConstraint:make offset:offset1 notReadNumer:officialStr];
//        }];
//    }else if(selectedIndex == 1){
//        [_sysNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            [self makeConstraint:make offset:offset notReadNumer:sysMsgStr];
//        }];
//        
//        [KUserdefaults setObject:@"0" forKey:KOfficialNotReadNum];
//        [_officialNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            [self makeZeroConstraint:make];
//        }];
//    }
}

-(void)pressBageForCK:(NSInteger)selectedIndex {
    NSMutableArray *titleViews = [self.scrollPageView.segmentView valueForKeyPath:@"titleViews"];
    //顾客未读消息
    NSString *userNotReadStr = [KUserdefaults objectForKey:KCustomerNotReadNum];
    if (IsNilOrNull(userNotReadStr)) {
        userNotReadStr = @"0";
    }
    ZJTitleView *titleView = titleViews[0];
    CGFloat offset = titleView.frame.origin.x + titleView.frame.size.width + 10;
    //系统通知未读
    NSString *sysMsgStr = [KUserdefaults objectForKey:KSystemNotReadNum];
    if (IsNilOrNull(sysMsgStr)) {
        sysMsgStr = @"0";
    }
    ZJTitleView *titleView1 = titleViews[1];
    CGFloat offset1 = titleView1.frame.origin.x + titleView1.frame.size.width + 10;
    //官方通知未读
    NSString *officialStr = [KUserdefaults objectForKey:KOfficialNotReadNum];
    if (IsNilOrNull(officialStr)) {
        officialStr = @"0";
    }
    ZJTitleView *titleView2 = titleViews[2];
    CGFloat offset2 = titleView2.frame.origin.x + titleView2.frame.size.width + 10;
    
    if (selectedIndex == 0) {
        [_userNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            [self makeZeroConstraint:make];
        }];
        
        [_sysNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            [self makeConstraint:make offset:offset1 notReadNumer:sysMsgStr];
        }];

        [_officialNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            [self makeConstraint:make offset:offset2 notReadNumer:officialStr];
        }];
    }else if(selectedIndex == 1){
        [_userNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            [self makeConstraint:make offset:offset notReadNumer:userNotReadStr];
        }];
        
        [_sysNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            [self makeZeroConstraint:make];
        }];
        
        [_officialNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            [self makeConstraint:make offset:offset2 notReadNumer:officialStr];
        }];
        
    }else if(selectedIndex == 2){
        [_userNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            [self makeConstraint:make offset:offset notReadNumer:userNotReadStr];
        }];
        
        [_sysNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            [self makeConstraint:make offset:offset1 notReadNumer:sysMsgStr];
        }];
        
        [KUserdefaults setObject:@"0" forKey:KOfficialNotReadNum];
        [_officialNoReadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            [self makeZeroConstraint:make];
        }];
    }
}

-(void)makeConstraint:(MASConstraintMaker*)make offset:(CGFloat)offset notReadNumer:(NSString*)notReadNumer {
    
    make.centerY.equalTo(self.scrollPageView.segmentView.mas_centerY).offset(-5);
    make.right.equalTo(self.view.mas_left).offset(offset);
    if ([notReadNumer isEqualToString:@"0"]){
        [self makeZeroConstraint:make];
    }else{
        make.width.mas_offset(AdaptedWidth(10));
        make.height.mas_offset(AdaptedWidth(10));
    }
}

-(void)makeZeroConstraint:(MASConstraintMaker*)make {
    make.width.mas_offset(AdaptedWidth(0));
    make.height.mas_offset(AdaptedWidth(0));
}

#pragma mark - ZJScrollPageViewDelegate
-(NSInteger)numberOfChildViewControllers {
    return self.titleArray.count;
}

-(UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    TableViewController *tableVc = [[TableViewController alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [tableVc returnIndex:^(NSInteger selectedIndex) {
        NSLog(@"%@", _titleArray[selectedIndex]);
        //调整指示线宽
        UIView *scrollLine = [weakSelf.scrollPageView.segmentView valueForKeyPath:@"scrollLine"];
        if (_titles.count == 1) {
            scrollLine.frame = CGRectZero;
        }else{
            scrollLine.frame = CGRectMake(SCREEN_WIDTH / _titles.count * selectedIndex, AdaptedHeight(33.5), SCREEN_WIDTH / _titles.count, AdaptedHeight(1.5));
        }
        
        //获取最新未读订单消息  系统消息
        [weakSelf getNotReadData: selectedIndex];
    }];
    
    if (!childVc) {
        childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)tableVc;
    }
    
    SEL selector = NSSelectorFromString(@"passTitleArray:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
    [childVc performSelector:selector withObject:self.titleArray];
#pragma clang diagnostic pop
    
    return childVc;
}

-(void)defaultTableViewFrame {
    self.netTip.frame = CGRectMake(0, 20+NaviAddHeight, SCREEN_WIDTH, 44);
    _scrollPageView.frame = CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 65-49 - BOTTOM_BAR_HEIGHT-NaviAddHeight);
}

-(void)changeTableViewFrame {
    self.netTip.frame = CGRectMake(0, 20+44+NaviAddHeight, SCREEN_WIDTH, 44);
    _scrollPageView.frame = CGRectMake(0, 65+44+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 65-49 - BOTTOM_BAR_HEIGHT-NaviAddHeight);
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

-(void)dealloc {
    [CKCNotificationCenter removeObserver:self name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter removeObserver:self name:@"NoNetNotification" object:nil];
}

@end
