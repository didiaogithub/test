//
//  CKMyGrowupViewController.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/6.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKMyGrowupViewController.h"
#import "CKMyGrowupCell.h"

@interface CKMyGrowupViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SectionModel*> *dataArray;

@end

@implementation CKMyGrowupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的成长";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor tt_grayBgColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self bindMyLevelData:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLevelLine:) name:@"ClickLevelPointNotification" object:nil];
}

-(void)bindMyLevelData:(NSDictionary *)data {
    
    _dataArray = [NSMutableArray array];
    
    CellModel *titleModel = [self createCellModel:[CKMyGrowupTitleCell class] userInfo:@{@"title":@"等级变化"} height:44*SCREEN_WIDTH/375.0f];
    CellModel *detailModel = [self createCellModel:[CKMyGrowupContentCell class] userInfo:@{@"title":@"等级", @"type":@"levelLine"} height:220*SCREEN_WIDTH/375.0f];
    SectionModel *section0 = [self createSectionModel:@[titleModel, detailModel] headerHeight:10 footerHeight:10];
    [self.dataArray addObject:section0];
    
    CellModel *updateModel = [self createCellModel:[CKMyGrowupUpdateCell class] userInfo:@{@"title":@"升级时间"} height:44*SCREEN_WIDTH/375.0f];
    SectionModel *section1 = [self createSectionModel:@[updateModel] headerHeight:0.1 footerHeight:10];
    [self.dataArray addObject:section1];
    
    CellModel *titleModel1 = [self createCellModel:[CKMyGrowupTitleCell class] userInfo:@{@"title":@"店铺套数"} height:44*SCREEN_WIDTH/375.0f];
    CellModel *detailModel1 = [self createCellModel:[CKMyGrowupContentCell class] userInfo:@{@"title":@"店铺", @"type":@"shopPie"} height:200*SCREEN_WIDTH/375.0f];
    SectionModel *section2 = [self createSectionModel:@[titleModel1, detailModel1] headerHeight:0.1 footerHeight:10];
    [self.dataArray addObject:section2];
    
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
    
    CKMyGrowupCell *cell = [tableView dequeueReusableCellWithIdentifier:item.reuseIdentifier];
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
    
    SEL selector = NSSelectorFromString(@"myGrowupData:");
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

-(void)reloadLevelLine:(NSNotification*)noti {
    
    NSString *type = [noti.object objectForKey:@"type"];
    //增加判断，是否要显示降级的原因。由此来处理删除增加元素。
    
    CellModel *updateModel = [self createCellModel:[CKMyGrowupUpdateCell class] userInfo:@{@"title":@"降级时间"} height:44*SCREEN_WIDTH/375.0f];
    SectionModel *section = [self createSectionModel:@[updateModel] headerHeight:0.1 footerHeight:10];

    CellModel *downModel = [self createCellModel:[CKMyGrowupUpdateCell class] userInfo:@{@"title":@"降级原因"} height:44*SCREEN_WIDTH/375.0f];
    CellModel *downDetailModel = [self createCellModel:[CKMyGrowupUpdateCell class] userInfo:@{@"title":@"降级时间"} height:44*SCREEN_WIDTH/375.0f];
    
    SectionModel *section1 = [self createSectionModel:@[downModel, downDetailModel] headerHeight:0.1 footerHeight:10];

    
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [indexPaths addObject:indexPath];

    if ([type isEqualToString:@"downgrade"]) {
        [self.dataArray replaceObjectAtIndex:1 withObject:section];
        if (self.dataArray.count < 4) {
            [self.dataArray insertObject:section1 atIndex:2];
        }else{
            [self.dataArray replaceObjectAtIndex:2 withObject:section1];
        }
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:2];
        [indexPaths addObject:indexPath1];

    }else if([type isEqualToString:@"upgrade"]){
        [self.dataArray replaceObjectAtIndex:1 withObject:section];
    }
    
    
    [self.tableView reloadData];
    
//    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

@end
