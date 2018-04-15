//
//  PTContactorViewController.m
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/8.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "PTContactorViewController.h"
#import "RCDCommonDefine.h"
#import "PTContactorTableViewCell.h"
#import "RCDNoFriendView.h"
#import "RCDUtilities.h"
#import "pinyin.h"
#import "FFAlertView.h"
#import "FFWarnAlertView.h"
#import "PTFriendDetailViewController.h"
#import "PTContactorModel.h"

#define kScreenWidth SCREEN_WIDTH

@interface PTContactorViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate>
@property(nonatomic, strong) NSMutableArray *friends;

@property(strong, nonatomic) NSMutableArray *friendsArr;

@property(nonatomic, strong) NSMutableArray *tempOtherArr;


@property(nonatomic, strong) NSIndexPath *selectIndexPath;

@property(nonatomic, strong) NSMutableArray *discussionGroupMemberIdList;

@property(nonatomic, strong) RCDNoFriendView *noFriendView;


@property(nonatomic, strong) NSMutableArray *collectionViewResource;

@property(nonatomic, strong) UITableView *tableView;

//进入页面以后选中的userId的集合
@property(nonatomic, strong) NSMutableArray *selecteUserIdList;



//搜索出的结果数据集合
@property(nonatomic, strong) NSMutableArray *matchSearchList;

//是否是显示搜索的结果
@property(nonatomic, assign) BOOL isSearchResult;

// tableView中indexPath和userId的对应关系字典
@property(nonatomic, strong) NSMutableDictionary *indexPathDic;

@property(nonatomic, strong) UITextField *searchField;



@property(nonatomic, strong) NSString *searchContent;

@end

@implementation PTContactorViewController

- (NSMutableArray *)collectionViewResource {
    if (!_collectionViewResource) {
        _collectionViewResource = [NSMutableArray array];
    }
    return _collectionViewResource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"通讯录";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    [self createSearchBar];
    self.matchSearchList = [NSMutableArray new];
    self.selecteUserIdList = [NSMutableArray new];
    self.indexPathDic = [NSMutableDictionary new];
    self.searchContent = @"";
    
    [self requestContactorData];
    
    [self refreshData];
    
    [CKCNotificationCenter addObserver:self selector:@selector(requestContactorData) name:@"upateRemarkNameNoti" object:nil];
}

- (void)createTableView {
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.tableView.frame =
        CGRectMake(0, 54 + 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - (54 + 64+NaviAddHeight));
    }else{
        self.tableView.frame =
        CGRectMake(0, 54, SCREEN_WIDTH, SCREEN_HEIGHT - 54);
    }
    
    [self.view addSubview:self.tableView];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    separatorLine.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    self.tableView.tableHeaderView = separatorLine;
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - 创建搜索框
- (void)createSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, 54)];
    self.searchBar.text = @"搜索";
    self.searchBar.backgroundColor = [UIColor whiteColor];

    self.searchField = [self.searchBar valueForKey:@"_searchField"];
    self.searchField.clearButtonMode = UITextFieldViewModeNever;
    self.searchField.textColor = [UIColor colorWithHexString:@"999999"];
    
    [self.searchBar setDelegate:self];
    [self.searchBar setKeyboardType:UIKeyboardTypeDefault];
    
    for (UIView *subview in [[self.searchBar.subviews firstObject] subviews]) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
        }
    }
    [self.view addSubview:self.searchBar];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.searchField.text.length == 0 && self.searchContent.length < 1) {
        [self setDefaultDisplay];
    }
}

- (void)setDefaultDisplay {
    self.isSearchResult = NO;
    [self.tableView reloadData];
    self.searchBar.text = @"搜索";
    self.searchContent = @"";
    [self.searchBar resignFirstResponder];
}

- (void)closeKeyboard {
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }

    if (self.searchContent.length < 1) {
        self.searchBar.text = @"搜索";
    }
    if (self.isSearchResult == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setDefaultDisplay];
        });
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isSearchResult == NO) {
        return [_allKeys count];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearchResult == NO) {
        NSString *key = [_allKeys objectAtIndex:section];
        NSArray *arr = [_allFriends objectForKey:key];
        return [arr count];
    }
    return self.matchSearchList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

// pinyin index
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.isSearchResult == NO) {
        return _allKeys;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.isSearchResult == NO) {
        if (_allKeys.count > 0) {
            NSString *key = [_allKeys objectAtIndex:section];
            return key;
        }
        return nil;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIdentifier = @"PTContactorTableViewCell";
    PTContactorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[PTContactorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PTContactorTableViewCell"];
    }
    

    PTContactorModel *user;
    if (self.isSearchResult == NO) {
        if (self.allKeys.count > 0) {
            NSString *key = [self.allKeys objectAtIndex:indexPath.section];
            NSArray *arrayForKey = [self.allFriends objectForKey:key];
            user = arrayForKey[indexPath.row];
        }
    } else {
        if (self.matchSearchList.count > 0) {
            user = [self.matchSearchList objectAtIndex:indexPath.row];
        }
    }
    
    //给控件填充数据
    [cell updateCellWithModel:user];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PTFriendDetailViewController *detailViewController = [[PTFriendDetailViewController alloc] init];
    if (self.isSearchResult == YES) {
        PTContactorModel *contactorM = self.matchSearchList[indexPath.row];
        detailViewController.contactorModel = contactorM;
    }else{
        NSString *keyStr = _allKeys[indexPath.section];
        NSArray *array = [_allFriends objectForKey:keyStr];
        PTContactorModel *contactorM = array[indexPath.row];
        detailViewController.contactorModel = contactorM;
    }
    
    [self.navigationController pushViewController:detailViewController animated:YES];

}

#pragma mark - 获取好友排序
- (void)dealWithFriendList {
    
    if (_friendsArr.count < 1) {
        CGRect frame = CGRectMake(0, 0, RCDscreenWidth, RCDscreenHeight - 64);
        self.noFriendView = [[RCDNoFriendView alloc] initWithFrame:frame];
        self.noFriendView.displayLabel.text = @"暂无好友";
        [self.view addSubview:self.noFriendView];
        [self.view bringSubviewToFront:self.noFriendView];
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableDictionary *resultDic = [RCDUtilities sortedArrayWithPinYinDic:_friendsArr];
            dispatch_async(dispatch_get_main_queue(), ^{
                _allFriends = resultDic[@"infoDic"];
                _allKeys = resultDic[@"allKeys"];
                [self.tableView reloadData];
            });
        });
    }
}

#pragma mark - UISearchBarDelegate
/**
 *  执行delegate联系人
 *
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.matchSearchList removeAllObjects];
    if ([searchText isEqualToString:@""]) {
        self.isSearchResult = NO;
        [self.tableView reloadData];
        return;
    } else {
        for (PTContactorModel *userInfo in [_friendsArr copy]) {
            //忽略大小写去判断是否包含
            if ([userInfo.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound ||
                [[RCDUtilities hanZiToPinYinWithString:userInfo.name] rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                if (![self.matchSearchList containsObject:userInfo]) {
                    [self.matchSearchList addObject:userInfo];
                }
            }
            
            if ([userInfo.remark rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound ||
                [[RCDUtilities hanZiToPinYinWithString:userInfo.remark] rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                if (![self.matchSearchList containsObject:userInfo]) {
                    [self.matchSearchList addObject:userInfo];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isSearchResult = YES;
            [self.tableView reloadData];
        });
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if ([self.searchField.text isEqualToString:@"搜索"] || [self.searchField.text isEqualToString:@"Search"]) {
        self.searchField.text = @"";
    }
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@""] && self.searchContent.length > 1) {
        self.searchContent = [self.searchContent substringWithRange:NSMakeRange(0, self.searchContent.length - 1)];
    } else if ([text isEqualToString:@""] && self.searchContent.length == 1) {
        self.searchContent = @"";
        self.isSearchResult = NO;
        [self.tableView reloadData];
        return YES;
    } else if ([text isEqualToString:@"\n"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchBar resignFirstResponder];
            if (!IsNilOrNull(self.searchContent)) {
                self.isSearchResult = YES;
                self.searchContent = searchBar.text;
                [self searchContactor];
            }
        });
        return YES;
    } else {
        self.searchContent = searchBar.text;
//        self.searchContent = [NSString stringWithFormat:@"%@%@", self.searchContent, text];
    }
    [self.matchSearchList removeAllObjects];
    
    NSString *temp = [self.searchContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (temp.length <= 0) {
        self.matchSearchList = [_friendsArr mutableCopy];
    } else {
        for (PTContactorModel *userInfo in [_friendsArr copy]) {
            if ([userInfo.name rangeOfString:temp options:NSCaseInsensitiveSearch].location != NSNotFound ||
                [[RCDUtilities hanZiToPinYinWithString:userInfo.name] rangeOfString:temp options:NSCaseInsensitiveSearch].location != NSNotFound) {
                if (![self.matchSearchList containsObject:userInfo]) {
                    [self.matchSearchList addObject:userInfo];
                }
            }
            
            if ([userInfo.remark rangeOfString:temp options:NSCaseInsensitiveSearch].location != NSNotFound ||
                [[RCDUtilities hanZiToPinYinWithString:userInfo.remark] rangeOfString:temp options:NSCaseInsensitiveSearch].location != NSNotFound) {
                if (![self.matchSearchList containsObject:userInfo]) {
                    [self.matchSearchList addObject:userInfo];
                }
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isSearchResult = YES;
        [self.tableView reloadData];
    });
    return YES;
}

#pragma mark - 设置刷新
-(void)refreshData{
    __typeof (self) __weak weakSelf = self;
    self.tableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header beginRefreshing];
        
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
                    if (!IsNilOrNull(self.searchContent)) {
                        [weakSelf searchContactor];
                    }else{
                        [weakSelf requestContactorData];
                    }
                }else{
                    [weakSelf.tableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView:NetWorkNotReachable];
                [weakSelf.tableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.tableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
        weakSelf.endLoadMoreInterval = [nowDate timeIntervalSince1970];
        NSTimeInterval value = weakSelf.endLoadMoreInterval - weakSelf.startLoadMoreInterval;
        CGFloat second = [[NSString stringWithFormat:@"%.2f",value] floatValue];//秒
        NSLog(@"间隔------%f秒",second);
        weakSelf.startLoadMoreInterval = weakSelf.endLoadMoreInterval;
        
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                if (value >= Interval) {
                    if (!IsNilOrNull(self.searchContent)) {
                        [weakSelf searchMoreContactor];
                    }else{
                        [weakSelf requestMoreContactorData];
                    }
                }else{
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView:NetWorkNotReachable];
                [weakSelf.tableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
}

#pragma mark - 请求通讯录数据
- (void)requestContactorData {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Group/getMyUsers"];
    NSDictionary *pramaDic = @{@"ckid":ckid, DeviceId:uuid, @"rowid":@"0", @"pagesize":@"50", @"keywords":@""};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.viewDataLoading stopAnimation];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        
        _allFriends = [NSMutableDictionary new];
        _allKeys = [NSMutableArray new];
        _friendsArr = [NSMutableArray new];
        
        NSArray *contactArr = dict[@"list"];
        for (NSDictionary *contactorDic in contactArr) {
            PTContactorModel *contactorM = [[PTContactorModel alloc] init];
            [contactorM setValuesForKeysWithDictionary:contactorDic];
            [_friendsArr addObject:contactorM];
        }
        
        
        [self dealWithFriendList];
        
        [self.viewDataLoading stopAnimation];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 请求更多通讯数据
- (void)requestMoreContactorData {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Group/getMyUsers"];
    NSDictionary *pramaDic = @{@"ckid":ckid, DeviceId:uuid, @"rowid":[NSString stringWithFormat:@"%ld", _friendsArr.count], @"pagesize":@"50", @"keywords":@""};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {

        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.viewDataLoading stopAnimation];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        
        NSArray *contactArr = dict[@"list"];
        for (NSDictionary *contactorDic in contactArr) {
            PTContactorModel *contactorM = [[PTContactorModel alloc] init];
            [contactorM setValuesForKeysWithDictionary:contactorDic];
            [_friendsArr addObject:contactorM];
        }
        
        
        [self dealWithFriendList];
        
        [self.viewDataLoading stopAnimation];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 搜索通讯录（先搜本地，本地没有再请求网络）
- (void)searchContactor {
    
    if (IsNilOrNull(self.searchContent)) {
        return;
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Group/getMyUsers"];
    NSDictionary *pramaDic = @{@"ckid":ckid, DeviceId:uuid, @"rowid":@"0", @"pagesize":@"50", @"keywords":self.searchContent};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.viewDataLoading stopAnimation];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        
        [_matchSearchList removeAllObjects];
        NSArray *contactArr = dict[@"list"];
        for (NSDictionary *contactorDic in contactArr) {
            PTContactorModel *contactorM = [[PTContactorModel alloc] init];
            [contactorM setValuesForKeysWithDictionary:contactorDic];
            [_matchSearchList addObject:contactorM];
        }
        
        [self.tableView reloadData];
        
        [self.viewDataLoading stopAnimation];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 搜索通讯录更多
- (void)searchMoreContactor {
    
    if (IsNilOrNull(self.searchContent)) {
        return;
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Group/getMyUsers"];
    NSDictionary *pramaDic = @{@"ckid":ckid, DeviceId:uuid, @"rowid":[NSString stringWithFormat:@"%ld", _matchSearchList.count], @"pagesize":@"50", @"keywords":self.searchContent};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.viewDataLoading stopAnimation];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        
        
        NSArray *contactArr = dict[@"list"];
        for (NSDictionary *contactorDic in contactArr) {
            PTContactorModel *contactorM = [[PTContactorModel alloc] init];
            [contactorM setValuesForKeysWithDictionary:contactorDic];
            [_matchSearchList addObject:contactorM];
        }
        
        [self.tableView reloadData];
        
        [self.viewDataLoading stopAnimation];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

- (void)dealloc {
    [CKCNotificationCenter removeObserver:self name:@"upateRemarkNameNoti" object:nil];
}

@end
