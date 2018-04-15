//
//  CKMessageListViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/12.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKMessageListViewController.h"
#import "CKMessageContentViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "ZJScrollPageView.h"
#import "UIBarButtonItem+XYMenu.h"
#import "PTSelectContactorViewController.h"
#import "PTContactorViewController.h"
#import "CKMsgCenterHelpViewController.h"
#import "CKGroupModel.h"
#import "CKUserMsgListModel.h"

@interface CKMessageListViewController ()<ZJScrollPageViewDelegate, ZJScrollPageViewChildVcDelegate>

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property (nonatomic, strong) ZJSegmentStyle *style;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleModelArray;

@end

@implementation CKMessageListViewController

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

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

- (void)initComponents {
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"加号"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
    rightItem.tintColor = SubTitleColor;
    self.navigationItem.rightBarButtonItem = rightItem;

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"消息-帮助"] style:UIBarButtonItemStylePlain target:self action:@selector(msgCenterHelp)];
    leftItem.tintColor = SubTitleColor;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //设置title样式
    _style = [[ZJSegmentStyle alloc] init];
    _style.normalTitleColor = TitleColor;
    _style.selectedTitleColor = [UIColor tt_redMoneyColor];
    _style.scrollLineColor = [UIColor tt_redMoneyColor];
    _style.scrollLineHeight = 1.5;
    _style.showLine = YES; //显示滚动条
    _style.titleFont = MAIN_TITLE_FONT;
    _style.autoAdjustTitlesWidth = YES;
    _style.segmentHeight = AdaptedHeight(40);
    _style.scrollContentView = NO;//内容view是否能滑动 默认为YES
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.titleArray = [NSMutableArray arrayWithArray:@[@"金粉用户", @"意向用户", @"潜水用户", @"群发群组"]];
    
    // 初始化
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 65-49 - BOTTOM_BAR_HEIGHT-NaviAddHeight) segmentStyle:_style titles:self.titleArray parentViewController:self delegate:self];
    [_scrollPageView setBackgroundColor:[UIColor tt_grayBgColor]];
    [self.view addSubview:_scrollPageView];
    
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    
    [CKCNotificationCenter addObserver:self selector:@selector(reloadMsgCenterData) name:@"ReloadMsgCenterDataNoti" object:nil];

}

- (void)reloadMsgCenterData {
    [self.scrollPageView.contentView reload];
}

#pragma mark - 消息中心帮助
- (void)msgCenterHelp {
    CKMsgCenterHelpViewController *help = [[CKMsgCenterHelpViewController alloc] init];
    help.detailUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"front/ckappFront/html/messagehelp.html"];
    [self.navigationController pushViewController:help animated:YES];
}

#pragma mark - 挑选朋友创建讨论组
- (void)showMenu:(UIBarButtonItem*)item {
    
    NSArray *imageArr = @[@"群发", @"通讯录"];
    NSArray *titleArr = @[@"一键群发", @"通讯录"];
    [item xy_showMenuWithImages:imageArr titles:titleArr menuType:XYMenuRightNavBar currentNavVC:self.navigationController withItemClickIndex:^(NSInteger index) {
        if (index == 1) {
            [self chooseMemberCreateDiscussion];
        }else if (index == 2){
            [self showMyContactors];
        }
    }];
}

#pragma mark - 创建讨论组（一键群发）
- (void)chooseMemberCreateDiscussion {
    PTSelectContactorViewController *disCussion = [[PTSelectContactorViewController alloc] init];
    [self.navigationController pushViewController:disCussion animated:YES];
}

#pragma mark - 通讯录
- (void)showMyContactors {
    PTContactorViewController *contactor = [[PTContactorViewController alloc] init];
    [self.navigationController pushViewController:contactor animated:YES];
}

#pragma mark - ZJScrollPageViewDelegate
-(NSInteger)numberOfChildViewControllers {
    return self.titleArray.count;
}

-(UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    CKMessageContentViewController *contentVC = [[CKMessageContentViewController alloc] init];
    
    if (!childVc) {
        childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)contentVC;
    }
    
    SEL selector = NSSelectorFromString(@"messageListTitle:");
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
