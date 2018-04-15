//
//  CKMyLevelViewController.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/6.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKMyLevelViewController.h"
#import "WebDetailViewController.h"
#import "CKMyLevelCell.h"
#import "CKMyGrowupViewController.h"
#import "CKLevelGifViewController.h"
#import "CKLevelExplainViewController.h"

@interface CKMyLevelViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SectionModel*> *dataArray;

@end

@implementation CKMyLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的等级";
  
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"等级规则" style:UIBarButtonItemStylePlain target:self action:@selector(levelRule)];
    right.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10;
        self.navigationItem.rightBarButtonItems = @[spaceItem, right];
    }
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor tt_grayBgColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    [self bindMyLevelData:nil];
}

-(void)levelRule {
    WebDetailViewController *web = [[WebDetailViewController alloc] init];
    web.detailUrl = @"http://www.baidu.com";
    web.typeString = @"levelRule";
    [self.navigationController pushViewController:web animated:YES];
}

-(void)bindMyLevelData:(NSDictionary *)data {
  
    _dataArray = [NSMutableArray array];

    CellModel *headerModel = [self createCellModel:[CKMyLevelHeaderCell class] userInfo:@{@"title":@"头像"} height:220*SCREEN_WIDTH/375.0f];
    CellModel *titleModel = [self createCellModel:[CKMyLevelTitleCell class] userInfo:@{@"title":@"合伙人"} height:44*SCREEN_WIDTH/375.0f];
    CellModel *detailModel = [self createCellModel:[CKMyLevelDetailCell class] userInfo:@{@"title":@"等级"} height:100*SCREEN_WIDTH/375.0f];
    SectionModel *section0 = [self createSectionModel:@[headerModel, titleModel, detailModel] headerHeight:0.1 footerHeight:10];
    [self.dataArray addObject:section0];
    
    CellModel *titleModel1 = [self createCellModel:[CKMyLevelTitleCell class] userInfo:@{@"title":@"权益与说明"} height:44*SCREEN_WIDTH/375.0f];
    CellModel *rightModel0 = [self createCellModel:[CKMyLevelRightCell class] userInfo:@{@"title":@"升级专享"} height:60*SCREEN_WIDTH/375.0f];
    CellModel *rightModel1 = [self createCellModel:[CKMyLevelRightCell class] userInfo:@{@"title":@"等级说明"} height:60*SCREEN_WIDTH/375.0f];
    CellModel *rightModel2 = [self createCellModel:[CKMyLevelRightCell class] userInfo:@{@"title":@"我的成长"} height:60*SCREEN_WIDTH/375.0f];
    SectionModel *section1 = [self createSectionModel:@[titleModel1, rightModel0, rightModel1, rightModel2] headerHeight:0.1 footerHeight:10];
    [self.dataArray addObject:section1];
    
    [_tableView reloadData];
}

-(CellModel*)createCellModel:(Class)cls userInfo:(id)userInfo height:(CGFloat)height {
    CellModel *model = [[CellModel alloc] init];
    model.selectionStyle = UITableViewCellSelectionStyleNone;
    model.userInfo = userInfo;
    model.height = height;
    model.className = NSStringFromClass(cls);
    return model;
}

-(SectionModel*)createSectionModel:(NSArray<CellModel*>*)items headerHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight {
    SectionModel *model = [SectionModel sectionModelWithTitle:nil cells:items];
    model.headerhHeight = headerHeight;
    model.footerHeight = footerHeight;
    return model;
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_dataArray){
        return _dataArray.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SectionModel *s = _dataArray[section];
    if(s.cells) {
        return s.cells.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModel *s = _dataArray[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    
    CKMyLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:item.reuseIdentifier];
    if(!cell) {
        cell = [[NSClassFromString(item.className) alloc] initWithStyle:item.style reuseIdentifier:item.reuseIdentifier];
    }
    cell.selectionStyle = item.selectionStyle;
    cell.accessoryType = item.accessoryType;
    cell.delegate = item.delegate;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModel *s = _dataArray[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    
    if(item.title) {
        cell.textLabel.text = item.title;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithRed:0.294 green:0.298 blue:0.302 alpha:1.00];
    }
    if(item.subTitle) {
        cell.detailTextLabel.text = item.subTitle;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.294 green:0.298 blue:0.302 alpha:1.00];
    }
    
    SEL selector = NSSelectorFromString(@"myLevelData:");
    if([cell respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
        [cell performSelector:selector withObject:item.userInfo];
#pragma clang diagnostic pop
    }
}

#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionModel *s = _dataArray[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    return item.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SectionModel *s = _dataArray[section];
    return s.headerhHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SectionModel *s = _dataArray[section];
    return s.footerHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            CKLevelGifViewController *levelGif = [[CKLevelGifViewController alloc] init];
            [self.navigationController pushViewController:levelGif animated:YES];
        }else if (indexPath.row == 2) {
            CKLevelExplainViewController *levelExplain = [[CKLevelExplainViewController alloc] init];
            [self.navigationController pushViewController:levelExplain animated:YES];
        }else if (indexPath.row == 3) {
            CKMyGrowupViewController *growUp = [[CKMyGrowupViewController alloc] init];
            [self.navigationController pushViewController:growUp animated:YES];
        }
    }
}

@end
