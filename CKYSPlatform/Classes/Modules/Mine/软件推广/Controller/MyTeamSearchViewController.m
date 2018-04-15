//
//  MyTeamSearchViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/5/3.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "MyTeamSearchViewController.h"
#import "SearchNavView.h"
#import "MyTeamListModel.h"
#import "FinalTeamTableViewCell.h"
#import "MyTeamTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CKSearchView.h"

static NSString *ckSearchCell = @"FinalTeamTableViewCell";
static NSString *fxCustomerSearchCell = @"MyTeamTableViewCell";
@interface MyTeamSearchViewController ()<SearchNavViewDelegate, UITableViewDelegate, UITableViewDataSource, FinalTeamTableViewCellDelegate, MyTeamTableViewCellDelegate, CKSearchNavViewDelegate>

@property (nonatomic, copy)   NSString *ckidString;
@property (nonatomic, copy)   NSString *idString;
@property (nonatomic, copy)   NSString *isHasSearch;
@property (nonatomic, strong) SearchNavView *searchNavView;
@property (nonatomic, strong) CKSearchView *searchView;

@property (nonatomic, strong) MyTeamListModel *myTeamListModel;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) NodataImageView *nodataImageView;
@property (nonatomic, strong) NSMutableArray *boolArray;

@end

@implementation MyTeamSearchViewController

-(NSMutableArray *)boolArray{
    if (_boolArray == nil) {
        _boolArray = [[NSMutableArray alloc] init];
    }
    return _boolArray;
}

- (NodataImageView *)nodataImageView {
    if(_nodataImageView == nil) {
        _nodataImageView = [[NodataImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64-49)];
    }
    return _nodataImageView;
}

-(NSMutableArray *)searchArray{
    if (_searchArray == nil) {
        _searchArray = [[NSMutableArray alloc] init];
    }
    return _searchArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    [CKCNotificationCenter addObserver:self selector:@selector(isHasSearched) name:IsHasSearch object:nil];
    [self createOtherViews];
    [self createTableView];
    
}
#pragma mark-是否已经搜索
-(void)isHasSearched{
    _isHasSearch = @"1";
    [self.searchTableView reloadData];
    
}
/**刷新列表数据*/
-(void)getMyTeamListData{

    NSString * requestUrl = nil;
    if ([self.typeStr isEqualToString:@"B"]) {
        requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getMyTeamCkList_Url];
    }else if([self.typeStr isEqualToString:@"D"]){
        requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getMyTeamFxList_Url];
    }else{
        requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getCustomerList_Url];
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSString *keywords = @"";
    if (@available(iOS 11.0, *)) {
        keywords = self.searchView.searchTextField.text;
    }else{
        keywords = _searchNavView.searchTextField.text;
    }
    if (IsNilOrNull(keywords)){
        keywords = @"";
    }
    if (IsNilOrNull(_idString)){
        _idString = @"0";
    }
    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"keywords":keywords,@"pagesize":@"10000",@"id":_idString,DeviceId:uuid};
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        [CKCNotificationCenter postNotificationName:SearchSuccess object:@"YES"];
        [CKCNotificationCenter postNotificationName:IsHasSearch object:nil];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        NSArray *listArr = nil;
        if ([self.typeStr isEqualToString:@"B"] || [self.typeStr isEqualToString:@"D"]) {
            listArr = dict[@"members"];
        }else{ //创客和分销
            listArr = dict[@"customers"]; //顾客
        }
        for (NSDictionary *customerDic in listArr) {
            self.myTeamListModel = [[MyTeamListModel alloc] init];
            [self.myTeamListModel setValuesForKeysWithDictionary:customerDic];
            [self.searchArray addObject:self.myTeamListModel];
            [self.boolArray addObject:@NO];
        }
        
        [self.searchTableView reloadData];
    } failure:^(NSError *error) {
         [self.viewDataLoading stopAnimation];
        
    }];
    
   
}

#pragma mark-创建搜索栏
-(void)createOtherViews{
    
    if (@available(iOS 11.0, *)) {
        
        self.searchView = [[CKSearchView alloc] init];
        [self.view addSubview:self.searchView];
        self.searchView.delegate = self;
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_offset(0);
            make.height.mas_offset(64);
        }];
        self.navigationItem.titleView = self.searchView;
        
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:nil];
        left.tintColor = [UIColor tt_redMoneyColor];
        self.navigationItem.leftBarButtonItem = left;
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(popView)];
        right.tintColor = SubTitleColor;
        self.navigationItem.rightBarButtonItem = right;
    }else{
        _searchNavView = [[SearchNavView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _searchNavView.searchTextField.placeholder = @"请输入您要查询的姓名或电话号码";
        _searchNavView.delegate = self;
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.titleView = _searchNavView;
    }
}

-(void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-/**返回上一页*/
-(void)poptoLastPage{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-点击键盘上的搜索按钮
-(void)keyboardSearchWithString:(NSString *)searchStr{
    
    NSString *searchText = _searchNavView.searchTextField.text;
    if (IsNilOrNull(searchText)){
        [CKCNotificationCenter postNotificationName:SearchSuccess object:@"YES"];
        if([self.typeStr isEqualToString:@"B"] || [self.typeStr isEqualToString:@"D"]){
            [self showNoticeView:@"请输入您要查询的姓名或电话号码"];
        }else{
            [self showNoticeView:@"请输入您要查询的姓名、昵称或电话号码"];
        }
        return;
    }
    [self getMyTeamListData];
}

-(void)searchKeyWords:(NSString *)keyWords {
    if (IsNilOrNull(keyWords)){
        [CKCNotificationCenter postNotificationName:SearchSuccess object:@"YES"];
        if([self.typeStr isEqualToString:@"B"] || [self.typeStr isEqualToString:@"D"]){
            [self showNoticeView:@"请输入您要查询的姓名或电话号码"];
        }else{
            [self showNoticeView:@"请输入您要查询的姓名、昵称或电话号码"];
        }
        return;
    }
    
    [self getMyTeamListData];
}

-(void)createTableView{
    
    if (@available(iOS 11.0, *)) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-65-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    }else{
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1,SCREEN_WIDTH, SCREEN_HEIGHT-1) style:UITableViewStylePlain];
    }
    [self.view addSubview:_searchTableView];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_searchTableView setBackgroundColor:[UIColor tt_grayBgColor]];
    
    [self.searchTableView registerClass:[FinalTeamTableViewCell class] forCellReuseIdentifier:ckSearchCell];
    [self.searchTableView registerClass:[MyTeamTableViewCell class] forCellReuseIdentifier:fxCustomerSearchCell];
    _searchTableView.estimatedRowHeight = 44;

    
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([_isHasSearch isEqualToString:@"1"]){
        [tableView tableViewDisplayView:self.nodataImageView ifNecessaryForRowCount:self.searchArray.count];
    }
    NSLog(@"搜到的%zd",self.searchArray.count);
    return self.searchArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.typeStr isEqualToString:@"B"]){
        BOOL isOpen = [self.boolArray[indexPath.row] boolValue];
        FinalTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ckSearchCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.index = indexPath.row;
        if ([self.searchArray count]){
            [cell refreshWithListModel:self.searchArray[indexPath.row] andOpen:isOpen];
        }
        cell.backgroundColor = [UIColor tt_grayBgColor];
        // cell 行高
        cell.fd_enforceFrameLayout = NO;
        return cell;

    }else{
        //分销  和  顾客
        MyTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fxCustomerSearchCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor tt_grayBgColor];
        cell.delegate = self;
        cell.index = indexPath.row;
        if([self.typeStr isEqualToString:@"D"]){
           cell.typeString = @"1";
        }else if ([self.typeStr isEqualToString:@"C"]){
           cell.typeString = @"2";
        }
        if ([self.searchArray count]){
            [cell refreshWithListModel:self.searchArray[indexPath.row]];
        }
        return cell;

    }

}
// 此处主要用第三方工具解决tableView自动布局下 进行编辑的时候定位不准确
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //高度计算并且缓存
    if ([self.typeStr isEqualToString:@"B"]){
        if ([self.searchArray count]) {
            self.myTeamListModel = self.searchArray[indexPath.row];
        }
        BOOL isOpen = [self.boolArray[indexPath.row] boolValue];
        CGFloat height = [tableView fd_heightForCellWithIdentifier:ckSearchCell cacheByIndexPath:indexPath configuration:^(FinalTeamTableViewCell *cell) {
            [cell refreshWithListModel:_myTeamListModel andOpen:isOpen];
        }];
        return height;
    }else{
        return AdaptedHeight(120);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 改变数据标识，刷新
    if ([self.typeStr isEqualToString:@"B"]){
        BOOL isOpen = [self.boolArray[indexPath.row] boolValue];
        [self.boolArray replaceObjectAtIndex:indexPath.row withObject:@(!isOpen)];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}
#pragma mark/**电话按钮*/
-(void)clickMyTeamButtonWithIndex:(NSInteger)index{
    
    if ([self.searchArray count]) {
        self.myTeamListModel = self.searchArray[index];
    }
    NSString *mobile = [NSString stringWithFormat:@"%@",self.myTeamListModel.mobile];
    NSString *gettermobile = [NSString stringWithFormat:@"%@",self.myTeamListModel.gettermobile];
    
    if (IsNilOrNull(gettermobile)){
        gettermobile = @"";
    }
    if (IsNilOrNull(mobile)){
        mobile = @"";
    }
    
    NSString *contentStr = @"";
    if ([self.typeStr isEqualToString:@"B"] || [self.typeStr isEqualToString:@"D"]){ //创客 和分销
        if (IsNilOrNull(mobile)){
            [self showNoticeView:@"电话为空"];
            return;
        }
        contentStr = [NSString stringWithFormat:@"是否拨打电话%@？",mobile];
    }else{
        if(IsNilOrNull(gettermobile)){
            [self showNoticeView:@"电话为空"];
            return;
        }
        
        contentStr =  [NSString stringWithFormat:@"是否拨打电话%@？",gettermobile];
    }
    [MessageAlert shareInstance].isDealInBlock = YES;
    [[MessageAlert shareInstance] hiddenCancelBtn:NO];
    [[MessageAlert shareInstance] showCommonAlert:contentStr btnClick:^{
    
        NSString *num = @"";
        if (contentStr.length == 18 || contentStr.length > 18) {
            NSRange range = {6,11};
            NSString *string = [contentStr substringWithRange:range];
            num = [NSString stringWithFormat:@"tel:%@",string];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //
        }
    
    }];
   
}

@end
