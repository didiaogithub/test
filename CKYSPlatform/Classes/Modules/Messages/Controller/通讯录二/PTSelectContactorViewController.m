//
//  PTSelectContactorViewController.m
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/14.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "PTSelectContactorViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDCommonDefine.h"
#import "PTSelectDiscussionMemberCell.h"
#import "RCDNoFriendView.h"
#import "RCDUIBarButtonItem.h"
#import "PTContactorModel.h"
#import "RCDUtilities.h"
#import "pinyin.h"
#import "FFAlertView.h"
#import "FFWarnAlertView.h"
#import "PTContactorSelectCollectionViewCell.h"
#import "FFTextAlertView.h"
#import "CKGroupModel.h"
#import "PTConversationViewController.h"
#import "CKMessageCommon.h"

@interface PTSelectContactorViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *friends;

@property (nonatomic, strong) NSMutableArray *friendsArr;

@property (nonatomic, strong) NSMutableArray *tempOtherArr;

@property (nonatomic, strong) RCDUIBarButtonItem *rightBtn;

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, strong) NSMutableArray *discussionGroupMemberIdList;

@property (nonatomic, strong) RCDNoFriendView *noFriendView;

@property (nonatomic, strong) UITableView *tableView;

//进入页面以后选中的userId的集合
@property (nonatomic, strong) NSMutableArray *selecteUserIdList;

@property (nonatomic, strong) UICollectionView *selectedUsersCollectionView;
@property (nonatomic, strong) NSMutableArray *collectionViewResource;
// collectionView展示的最大数量
@property (nonatomic, assign) NSInteger maxCount;

//判断当前操作是否是删除操作
@property (nonatomic, assign) BOOL isDeleteUser;
//搜索出的结果数据集合
@property (nonatomic, strong) NSMutableArray *matchSearchList;

//是否是显示搜索的结果
@property (nonatomic, assign) BOOL isSearchResult;

// tableView中indexPath和userId的对应关系字典
@property (nonatomic, strong) NSMutableDictionary *indexPathDic;

@property (nonatomic, strong) UITextField *searchField;

@property (nonatomic, strong) NSString *searchContent;


@end

@implementation PTSelectContactorViewController

- (NSMutableArray *)collectionViewResource {
    if (!_collectionViewResource) {
        _collectionViewResource = [NSMutableArray array];
    }
    return _collectionViewResource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _titleStr;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableView];
    
    [self createCollectionView];
    
    [self createSearchBar];
    
    
    self.matchSearchList = [NSMutableArray new];
    
    //自定义rightBarButtonItem
    self.rightBtn = [[RCDUIBarButtonItem alloc] initWithbuttonTitle:@"确定" titleColor:SubTitleColor buttonFrame:CGRectMake(0, 0, 90, 30) target:self action:@selector(clickedDone:)];
    self.rightBtn.button.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightBtn.button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [self.rightBtn buttonIsCanClick:NO
                        buttonColor:SubTitleColor
                      barButtonItem:self.rightBtn];
    self.navigationItem.rightBarButtonItems = [self.rightBtn setTranslation:self.rightBtn translation:-11];
    //当是讨论组加人的情况，先生成讨论组用户的ID列表
    if (_addDiscussionGroupMembers.count > 0) {
        self.discussionGroupMemberIdList = [NSMutableArray new];
        for (PTContactorModel *contactor in _addDiscussionGroupMembers) {
            [self.discussionGroupMemberIdList addObject:contactor.meid];
        }
    }
    
    self.selecteUserIdList = [NSMutableArray new];
    self.indexPathDic = [NSMutableDictionary new];
    
    //搜索框一行显示几个图像
    [self setMaxCountForDevice];
    
    self.searchContent = @"";
    
    if (![self.titleStr isEqualToString:@"删除成员"]) {
        [self requestContactorData];
    }else{
        _allFriends = [NSMutableDictionary new];
        _allKeys = [NSMutableArray new];
        _friendsArr = [NSMutableArray new];
        [self dealWithFriendList];
    }
    
    if ([self.titleStr isEqualToString:@"删除成员"]){
        
    }else{
        [self refreshData];
    }
}

- (void)setMaxCountForDevice {
    if (SCREEN_WIDTH < 375) {
        self.maxCount = 4;
    } else if (SCREEN_WIDTH >= 375 && SCREEN_WIDTH < 414) {
        self.maxCount = 5;
    } else {
        self.maxCount = 6;
    }
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
//        _allKeys = [NSMutableArray new];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rightBtn buttonIsCanClick:YES buttonColor:SubTitleColor barButtonItem:self.rightBtn];
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
    
    //控制多选
    self.tableView.allowsMultipleSelection = YES;
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    separatorLine.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    self.tableView.tableHeaderView = separatorLine;
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.selectedUsersCollectionView =
    [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, 0, 54) collectionViewLayout:flowLayout];
    self.selectedUsersCollectionView.delegate = self;
    self.selectedUsersCollectionView.dataSource = self;
    self.selectedUsersCollectionView.scrollEnabled = YES;
    self.selectedUsersCollectionView.backgroundColor = [UIColor whiteColor];
    [self.selectedUsersCollectionView registerClass:[PTContactorSelectCollectionViewCell class] forCellWithReuseIdentifier:@"PTContactorSelectCollectionViewCell"];
    [self.view addSubview:self.selectedUsersCollectionView];
    self.selectedUsersCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)createSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, [UIScreen mainScreen].bounds.size.width, 54)];
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

#pragma mark - 点击确定
- (void)clickedDone:(id)sender {
    // 选中的用
    NSMutableArray *seletedUsers = [NSMutableArray new];
    NSMutableArray *seletedUsersId = [NSMutableArray new];
    for (PTContactorModel *user in self.collectionViewResource) {
        [seletedUsersId addObject:user.meid];
    }
    seletedUsers = [self.collectionViewResource mutableCopy];
    
    if ([self.titleStr isEqualToString:@"删除成员"]) {
        for (NSString *userid in seletedUsersId) {
            [[RCIMClient sharedRCIMClient] removeMemberFromDiscussion:self.discussiongroupId userId:userid success:^(RCDiscussion *discussion) {
                NSLog(@"踢人成功:%@", userid);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            } error:^(RCErrorCode status) {
                NSLog(@"踢人失败:%ld-userid:%@", status, userid);
            }];
        }
        
        [self deleteGroupMembers];
        
    }else{
        if (_addDiscussionGroupMembers.count > 0) {
            if (_discussiongroupId.length > 0) {
                [[RCIMClient sharedRCIMClient]
                 addMemberToDiscussion:_discussiongroupId
                 userIdList:seletedUsersId
                 success:^(RCDiscussion *discussion) {
                     NSLog(@"加人成功:%@-userid:%@", discussion, seletedUsersId);
                     dispatch_async(dispatch_get_main_queue(), ^{
                     });
                 }error:^(RCErrorCode status){
                     NSLog(@"加入失败:%ld-userid:%@", status, seletedUsersId);
                 }];
                [self addGroupMembers];
            }
        } else {
            if (seletedUsers.count < 2) {
                FFWarnAlertView *alert = [[FFWarnAlertView alloc] init];
                alert.titleLable.text = @"至少选择两个用户";
                [alert showFFWarnAlertView];
            }else if (seletedUsers.count > 30) {
                FFWarnAlertView *alert = [[FFWarnAlertView alloc] init];
                alert.titleLable.text = @"至多选择30个用户";
                [alert showFFWarnAlertView];
            }else{
                FFTextAlertView *popView =  [[FFTextAlertView alloc]initWithTitle:@"请输入群组名称" textFieldInitialValue:@"" textFieldTextMaxLength:20 textFieldText:^(NSString *textFieldText) {
                    NSLog(@"string%@", textFieldText);
                    
                    //将自己添加进群组
                    NSString *ckid = IsNilOrNull(KCKidstring) ? @"":KCKidstring;
                    [seletedUsersId addObject:ckid];
                    
                    // 判断融云登录状态
                   RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
                    if (status !=  ConnectionStatus_Connected) {
                        [RCloudManager manager];
                    }
                    
                    [[RCIMClient sharedRCIMClient] createDiscussion:textFieldText userIdList:seletedUsersId success:^(RCDiscussion *discussion) {
                        NSLog(@"success  %@",discussion.discussionName);
                        NSLog(@"%@",discussion.discussionId);
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.viewDataLoading showNoticeView:@"创建讨论组成功"];
                            [self createDiscussion:discussion.discussionId groupmember:seletedUsersId groupname:textFieldText];
                        });
                        
                    } error:^(RCErrorCode status) {
                        NSLog(@"faild %ld",status);
                        [self.viewDataLoading showNoticeView:@"创建失败"];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }];
                }];
                [popView show];
            }
        }
    }
}

#pragma mark - 创建群组，同步数据
- (void)createDiscussion:(NSString*)discussionId groupmember:(NSArray*)groupmember groupname:(NSString*)groupname {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Group/setUpGroup"];
    NSDictionary *pramaDic = @{@"ckid":ckid, DeviceId:uuid, @"rygroupid":discussionId, @"groupmember":groupmember, @"groupnotice":@"", @"groupname":groupname};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        //将自己添加进群组
        [self.collectionViewResource addObject:[CKMessageCommon getCKInfoModel]];
        
        NSString *groupid = [NSString stringWithFormat:@"%@", dict[@"groupid"]];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        CKGroupModel *groupM = [[CKGroupModel alloc] init];
        for (PTContactorModel *contactorM in self.collectionViewResource) {
            [groupM.groupinfoArray addObject:[CKMessageCommon convertCKInfoToGroupInfo:contactorM]];
        }
        groupM.rygroupid = discussionId;
        groupM.groupid = groupid;
        groupM.groupname = groupname;
        groupM.groupnotice = @"";
        groupM.groupidKey = [NSString stringWithFormat:@"%@_%@", ckid, groupid];
        [CKGroupModel createOrUpdateInRealm:realm withValue:groupM];
        [realm commitWriteTransaction];
        
        PTConversationViewController *conversationVC = [[PTConversationViewController alloc] init];
        conversationVC.conversationType = ConversationType_DISCUSSION;
        conversationVC.groupModel = groupM;
        conversationVC.targetId = groupM.rygroupid;
        conversationVC.title = groupM.groupname;
        conversationVC.groupId = groupM.groupid;
        conversationVC.titleString = groupM.groupname;
        conversationVC.userIdArray = [NSMutableArray array];
        for (CKGroupInfoModel *userModel in groupM.groupinfoArray) {
            if (![userModel.meid isEqualToString:ckid]) {
                [conversationVC.userIdArray addObject:userModel.meid];
            }
        }
        [self.navigationController pushViewController:conversationVC animated:YES];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

- (void)setDefaultDisplay {
    self.isSearchResult = NO;
    [self.tableView reloadData];
    self.searchBar.text = @"搜索";
    self.searchContent = @"";
    [self.searchBar resignFirstResponder];
}


- (void)setRightButton {
    NSString *titleStr;
    if (self.selecteUserIdList.count > 0) {
        titleStr = [NSString stringWithFormat:@"确定(%zd)", [self.selecteUserIdList count]];
    } else {
        titleStr = @"确定";
        [self.rightBtn buttonIsCanClick:NO buttonColor:SubTitleColor barButtonItem:self.rightBtn];
    }
    [self.rightBtn.button setTitle:titleStr forState:UIControlStateNormal];
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
        NSString *key = [_allKeys objectAtIndex:section];
        return key;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIdentifier = @"PTSelectDiscussionMemberCell";
    
    PTSelectDiscussionMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[PTSelectDiscussionMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PTSelectDiscussionMemberCell"];
    }
    
    PTContactorModel *contact;
    if (self.isSearchResult == NO) {
        if (self.allKeys.count > 0) {
            NSString *key = [self.allKeys objectAtIndex:indexPath.section];
            NSArray *arrayForKey = [self.allFriends objectForKey:key];
            contact = arrayForKey[indexPath.row];
        }
        
    } else {
        if (self.matchSearchList.count > 0) {
            contact = [self.matchSearchList objectAtIndex:indexPath.row];
        }
    }
    
    //设置选中状态
    BOOL isSelected = NO;
    for (NSString *userId in self.selecteUserIdList) {
        if ([contact.meid isEqualToString:userId]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            isSelected = YES;
        }
    }
//    if (isSelected == NO) {
//        [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    }
    if ([self isContain:contact.meid] == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.selectedImageView.image = [UIImage imageNamed:@"disable_select"];
        });
        cell.userInteractionEnabled = NO;
    }else{
        cell.userInteractionEnabled = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell updateCellWithModel:contact];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((self.collectionViewResource.count + self.addDiscussionGroupMembers.count) >= 30) {
        FFWarnAlertView *alert = [[FFWarnAlertView alloc] init];
        alert.titleLable.text = @"至多选择30个用户";
        [alert showFFWarnAlertView];
        return;
    }
    
    [self.rightBtn buttonIsCanClick:YES buttonColor:SubTitleColor barButtonItem:self.rightBtn];
    PTSelectDiscussionMemberCell *cell =
    (PTSelectDiscussionMemberCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:YES];
    if (self.selectIndexPath && [self.selectIndexPath compare:indexPath] == NSOrderedSame) {
        [cell setSelected:NO];
        self.selectIndexPath = nil;
    } else {
        PTContactorModel *user;
        if (self.isSearchResult == YES) {
            user = [self.matchSearchList objectAtIndex:indexPath.row];
        } else {
            self.selectIndexPath = indexPath;
            if (self.allKeys.count > 0) {
                NSString *key = [self.allKeys objectAtIndex:indexPath.section];
                NSArray *arrayForKey = [self.allFriends objectForKey:key];
                user = arrayForKey[indexPath.row];
            }
            
        }
        
        NSMutableArray *idArray = [NSMutableArray array];
        for (PTContactorModel *user in self.collectionViewResource) {
            [idArray addObject:user.meid];
        }
        if (![idArray containsObject:user.meid]) {
            if (user != nil) {
                
                [self.collectionViewResource addObject:user];
            }
        }
        
        NSInteger count = self.collectionViewResource.count;
        self.isDeleteUser = NO;
        [self setCollectonViewAndSearchBarFrame:count];
        [self.selectedUsersCollectionView reloadData];
        [self scrollToBottomAnimated:YES];
        
        if (!IsNilOrNull(user.meid)) {
            [self.selecteUserIdList addObject:user.meid];
        }
        
        [self setRightButton];
    }
    if (self.isSearchResult == YES) {
        [self setDefaultDisplay];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    PTSelectDiscussionMemberCell *cell =
    (PTSelectDiscussionMemberCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (self.isSearchResult == YES) {
        [self setDefaultDisplay];
        return;
    }
    [cell setSelected:NO];
    self.selectIndexPath = nil;
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [self.allFriends objectForKey:key];
    PTContactorModel *contact = arrayForKey[indexPath.row];
    
    NSInteger index = -1;
    for (NSInteger i = 0; i < self.collectionViewResource.count ; i++) {
        PTContactorModel *user = self.collectionViewResource[i];
        if ([user.meid isEqualToString:contact.meid]) {
            index = i;
            break;
        }
    }
    if (index != -1) {
        [self.collectionViewResource removeObjectAtIndex:index];
        [self.selecteUserIdList removeObject:contact.meid];
    }
    
    [self.selectedUsersCollectionView reloadData];
    NSInteger count = self.collectionViewResource.count;
    self.isDeleteUser = YES;
    [self setCollectonViewAndSearchBarFrame:count];
    
    [self setRightButton];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.searchField.text.length == 0 && self.searchContent.length < 1) {
        [self setDefaultDisplay];
    }
}

#pragma mark - 获取好友排序
- (void)dealWithFriendList {
    
    if ([self.titleStr isEqualToString:@"删除成员"]) {
        _friendsArr = _delGroupMembers;
    }
    
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

#pragma mark - 添加群组成员
- (void)addGroupMembers {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSMutableArray *seletedUsersId = [NSMutableArray new];
    for (PTContactorModel *user in self.collectionViewResource) {
        [seletedUsersId addObject:user.meid];
    }
    NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Group/updateGroupMembers"];
    NSDictionary *pramaDic = @{@"groupid":self.groupId, DeviceId:uuid, @"groupmemberadd":seletedUsersId, @"groupmemberdel":@"", @"ckid":ckid};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        RLMResults *result = [CKGroupModel objectsWhere:[NSString stringWithFormat:@"groupid = '%@'", self.groupId]];
        if (result.count > 0) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            CKGroupModel *groupModel = [[CKGroupModel alloc] init];
            groupModel = result.firstObject;
            CKGroupModel *groupM = [[CKGroupModel alloc] init];
            groupM.groupinfoArray = groupModel.groupinfoArray;
            for (PTContactorModel *contactorM in self.collectionViewResource) {
                [groupM.groupinfoArray addObject:[CKMessageCommon convertCKInfoToGroupInfo:contactorM]];
            }
            groupM.rygroupid = groupModel.rygroupid;
            groupM.groupid = groupModel.groupid;
            groupM.groupname = groupModel.groupname;
            groupM.groupnotice = groupModel.groupnotice;
            groupM.groupidKey = groupModel.groupidKey;
            [CKGroupModel createOrUpdateInRealm:realm withValue:groupM];
            [realm commitWriteTransaction];
            
            [CKCNotificationCenter postNotificationName:@"ReloadMsgCenterDataNoti" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}

#pragma mark - 删除群组成员
- (void)deleteGroupMembers {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSMutableArray *seletedUsersId = [NSMutableArray new];
    for (PTContactorModel *user in self.collectionViewResource) {
        [seletedUsersId addObject:user.meid];
    }
    NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Group/updateGroupMembers"];
    NSDictionary *pramaDic = @{@"groupid":self.groupId, DeviceId:uuid, @"groupmemberadd":@"", @"groupmemberdel":seletedUsersId, @"ckid":ckid};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        RLMResults *result = [CKGroupModel objectsWhere:[NSString stringWithFormat:@"groupid = '%@'", self.groupId]];
        if (result.count > 0) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            CKGroupModel *groupModel = [[CKGroupModel alloc] init];
            groupModel = result.firstObject;
            CKGroupModel *groupM = [[CKGroupModel alloc] init];
            [groupM.groupinfoArray removeAllObjects];
            
            NSMutableArray *meidArray = [NSMutableArray array];
            NSMutableArray *userArray = [NSMutableArray array];
            for (PTContactorModel *contactorM in self.collectionViewResource) {
                CKGroupInfoModel *infoModel = [[CKGroupInfoModel alloc] init];
                infoModel = [CKMessageCommon convertCKInfoToGroupInfo:contactorM];
                [userArray addObject:infoModel];
                [meidArray addObject:infoModel.meid];
            }
            
            for (CKGroupInfoModel *infoM in groupModel.groupinfoArray) {
                if (![meidArray containsObject:infoM.meid]) {
                    [groupM.groupinfoArray addObject:infoM];
                }
            }
            
            groupM.rygroupid = groupModel.rygroupid;
            groupM.groupid = groupModel.groupid;
            groupM.groupname = groupModel.groupname;
            groupM.groupnotice = groupModel.groupnotice;
            groupM.groupidKey = groupModel.groupidKey;
            [CKGroupModel createOrUpdateInRealm:realm withValue:groupM];
            [realm commitWriteTransaction];
            
            [CKCNotificationCenter postNotificationName:@"ReloadMsgCenterDataNoti" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];

    
}

- (BOOL)isContain:(NSString *)userId {
    BOOL contain = NO;
    NSArray *userList;
    if (_addDiscussionGroupMembers.count > 0) {
        userList = self.discussionGroupMemberIdList;
    }
    for (NSString *memberId in userList) {
        if ([userId isEqualToString:memberId]) {
            contain = YES;
            break;
        }
    }
    return contain;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(36, 36);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    return UIEdgeInsetsMake(10, 10, 10, 0);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionViewResource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PTContactorSelectCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"PTContactorSelectCollectionViewCell" forIndexPath:indexPath];
    
    if (self.collectionViewResource.count > 0) {
        PTContactorModel *user = self.collectionViewResource[indexPath.row];
        [cell updateCellData:user];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self closeKeyboard];
    PTContactorModel *contactor = [self.collectionViewResource objectAtIndex:indexPath.row];
    [self.collectionViewResource removeObjectAtIndex:indexPath.row];
    [self.selecteUserIdList removeObject:contactor.meid];
    NSInteger count = self.collectionViewResource.count;
    self.isDeleteUser = YES;
    [self setCollectonViewAndSearchBarFrame:count];
    [self.selectedUsersCollectionView reloadData];
    
  
    for (NSIndexPath *indexP in self.tableView.indexPathsForSelectedRows) {
        
        PTContactorModel *contact = [[PTContactorModel alloc] init];
        if (self.isSearchResult == NO) {
            if (self.allKeys.count > 0) {
                NSString *key = [self.allKeys objectAtIndex:indexP.section];
                NSArray *arrayForKey = [self.allFriends objectForKey:key];
                contact = arrayForKey[indexP.row];
            }
            
        } else {
            if (self.matchSearchList.count > 0) {
                contact = [self.matchSearchList objectAtIndex:indexP.row];
            }
        }
        
        if ([contactor.name isEqualToString:contactor.name] || [contactor.remark isEqualToString:contactor.remark]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView deselectRowAtIndexPath:indexP animated:YES];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexP, nil] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
        
        
//        PTSelectDiscussionMemberCell *cell = [self.tableView cellForRowAtIndexPath:indexP];
//        if ([cell.nicknameLabel.text isEqualToString:contactor.name] || [cell.nicknameLabel.text isEqualToString:contactor.remark]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView deselectRowAtIndexPath:indexP animated:YES];
//                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexP, nil] withRowAnimation:UITableViewRowAnimationNone];
//
//            });
//        }
    }
    
    [self setRightButton];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSUInteger finalRow = MAX(0, [self.selectedUsersCollectionView numberOfItemsInSection:0] - 1);
    
    if (0 == finalRow) {
        return;
    }
    
    NSIndexPath *finalIndexPath = [NSIndexPath indexPathForItem:finalRow inSection:0];
    [self.selectedUsersCollectionView scrollToItemAtIndexPath:finalIndexPath
                                             atScrollPosition:UICollectionViewScrollPositionRight
                                                     animated:animated];
}

//设置collectionView和searchBar实时显示的frame效果
- (void)setCollectonViewAndSearchBarFrame:(NSInteger)count {
    CGRect frame = CGRectZero;
    if (count == 0) {
        //只显示searchBar
        frame = CGRectMake(0, 64+NaviAddHeight, 0, 54);
        self.selectedUsersCollectionView.frame = frame;
        self.searchBar.frame = [self getSearchBarFrame:frame];
        self.searchBar.text = @"搜索";
    } else if (count == 1) {
        frame = CGRectMake(0, 64+NaviAddHeight, 46, 54);
        self.selectedUsersCollectionView.frame = frame;
        self.searchBar.frame = [self getSearchBarFrame:frame];
    } else if (count > 1 && count <= self.maxCount) {
        if (self.isDeleteUser == NO) {
            //如果是删除选中的联系人时候的处理
            frame = CGRectMake(0, 64+NaviAddHeight, 46 + (count - 1) * 46, 54);
            self.selectedUsersCollectionView.frame = frame;
            self.searchBar.frame = [self getSearchBarFrame:frame];
        } else if (self.isDeleteUser == YES) {
            if (count < self.maxCount) {
                //判断如果当前collectionView的显示数量小于最大展示数量的时候，collectionView和searchBar的frame都会改变
                frame = CGRectMake(0, 64+NaviAddHeight, 61 + (count - 1) * 46, 54);
                self.selectedUsersCollectionView.frame = frame;
                self.searchBar.frame = [self getSearchBarFrame:frame];
            }
        }
    }
}

- (CGRect)getSearchBarFrame:(CGRect)frame {
    CGRect searchBarFrame = CGRectZero;
    frame.origin.x = frame.size.width;
    CGFloat searchBarWidth = [UIScreen mainScreen].bounds.size.width - frame.size.width;
    frame.size.width = searchBarWidth;
    searchBarFrame = frame;
    return searchBarFrame;
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
            self.isSearchResult = YES;
            
            self.searchContent = searchBar.text;
            
            [self searchContactorData];
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

#pragma mark - 搜索通讯录（网络）
- (void)searchContactorData {
    
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
        
        [self.matchSearchList removeAllObjects];
        NSArray *contactArr = dict[@"list"];
        for (NSDictionary *contactorDic in contactArr) {
            PTContactorModel *contactorM = [[PTContactorModel alloc] init];
            [contactorM setValuesForKeysWithDictionary:contactorDic];
            [self.matchSearchList addObject:contactorM];
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
                        [weakSelf searchContactorData];
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


@end
