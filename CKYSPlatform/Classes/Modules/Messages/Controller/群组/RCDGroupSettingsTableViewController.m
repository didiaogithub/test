//
//  RCDGroupSettingsTableViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/3/22.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDGroupSettingsTableViewController.h"
#import "RCDCommonDefine.h"
#import "RCDEditGroupNameViewController.h"
#import "PTFriendDetailViewController.h"
#import "RCDUtilities.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDUIBarButtonItem.h"
#import "PTGroupSettingTableViewCell.h"
#import "FFWarnAlertView.h"
#import "PTGroupMemberCollectionViewCell.h"
#import "PTManageMemberCollectionViewCell.h"

#import "PTFriendDetailViewController.h"
#import "PTSelectContactorViewController.h"
#import "RCDGroupAnnouncementViewController.h"
#import "XWAlterVeiw.h"
#import "CKMessageCommon.h"

@interface RCDGroupSettingsTableViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, XWAlterVeiwDelegate>{
    PTGroupMemberCollectionViewCell *_groupMemberCell;
}

@property (nonatomic, strong) UITableView *tableView;
//解散删除群组
@property (strong, nonatomic) UIButton *dismissGroupBtn;

@property (nonatomic, strong) NSMutableArray *groupMemberList;


@end

@implementation RCDGroupSettingsTableViewController {
    NSInteger numberOfSections;
    RCConversation *currentConversation;
    BOOL enableNotification;
    NSMutableArray *collectionViewResource;
    UICollectionView *headerView;
    NSString *groupId;
    BOOL isCreator;
    UIImage *image;
    NSData *data;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    RLMResults *result = [CKGroupModel objectsWhere:[NSString stringWithFormat:@"groupid = '%@'", self.groupModel.groupid]];
    if (result.count > 0) {
        CKGroupModel *groupM = [[CKGroupModel alloc] init];
        groupM = result.firstObject;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.groupMemberList removeAllObjects];
            [self.memberIdList removeAllObjects];
            [collectionViewResource removeAllObjects];
            for (CKGroupInfoModel *userInfo in groupM.groupinfoArray) {
                PTContactorModel *contactor = [[PTContactorModel alloc] init];
                contactor.name = userInfo.name;
                contactor.meid = userInfo.meid;
                contactor.mobile = userInfo.mobile;
                contactor.remark = userInfo.remark;
                contactor.head = userInfo.head;
                [self.groupMemberList addObject:contactor];
                [self.memberIdList addObject:userInfo.meid];
            }
            self.groupMemberList = [self moveCreator:self.groupMemberList];
            collectionViewResource = [[NSMutableArray alloc] initWithArray:self.groupMemberList];

            [self setHeaderView];
            
        });
        
        [CKCNotificationCenter postNotificationName:@"ReloadMsgCenterDataNoti" object:nil];
        
        if (collectionViewResource.count < 1) {
            [self startLoad];
        }
    }
    
    if (self.groupModel.groupinfoArray.count > 0) {
        self.title = [NSString stringWithFormat:@"群组信息(%ld)", (unsigned long)self.groupModel.groupinfoArray.count];
    } else {
        self.title = @"群组信息";
    }
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    if (IsNilOrNull(self.annoucemnet)) {
        self.annoucemnet = @"未设置";
    }

    if (@available (iOS 11.0, *)) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-(64+NaviAddHeight)) style:UITableViewStyleGrouped];

    }else{
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    }
    self.tableView.estimatedRowHeight = 0;
    if (@available(iOS 11.0, *)){
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = HEXCOLOR(0xf0f0f6);
    self.tableView.separatorColor = HEXCOLOR(0xdfdfdf);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    numberOfSections = 0;
  
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotification:) name:RCKitDispatchMessageNotification object:nil];

    CGRect tempRect =
        CGRectMake(0, 0, RCDscreenWidth, headerView.collectionViewLayout.collectionViewContentSize.height);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    headerView = [[UICollectionView alloc] initWithFrame:tempRect collectionViewLayout:flowLayout];
    headerView.delegate = self;
    headerView.dataSource = self;
    headerView.scrollEnabled = NO;
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView registerClass:[PTGroupMemberCollectionViewCell class] forCellWithReuseIdentifier:@"PTGroupMemberCollectionViewCell"];
    [headerView registerClass:[PTManageMemberCollectionViewCell class] forCellWithReuseIdentifier:@"PTManageMemberCollectionViewCell"];
    
}

#pragma mark - 本类的私有方法
- (void)clickNotificationBtn:(id)sender {
    UISwitch *swch = sender;
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP
        targetId:groupId
        isBlocked:swch.on
        success:^(RCConversationNotificationStatus nStatus) {
            NSLog(@"成功");

        }
        error:^(RCErrorCode status) {
            NSLog(@"失败");
        }];
}

- (void)clickIsTopBtn:(id)sender {
    UISwitch *swch = sender;
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_GROUP targetId:groupId isTop:swch.on];
}

- (void)startLoad {
    currentConversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_GROUP targetId:groupId];
    numberOfSections = 1;
    
    self.groupMemberList = [NSMutableArray array];
    for (CKGroupInfoModel *userModel in self.groupModel.groupinfoArray) {
        PTContactorModel *contactor = [[PTContactorModel alloc] init];
        contactor.meid = userModel.meid;
        contactor.name = userModel.name;
        contactor.head = userModel.head;
        contactor.mobile = userModel.mobile;
        contactor.remark = userModel.remark;
        [self.groupMemberList addObject:contactor];
    }
    
    
    
    self.groupMemberList = [self moveCreator:self.groupMemberList];

    

    if ([self.groupMemberList count] > 0) {
        /******************添加headerview*******************/
        collectionViewResource = [[NSMutableArray alloc] initWithArray:self.groupMemberList];
        // dispatch_async(dispatch_get_main_queue(), ^{
        [self setHeaderView];
        // });
    }

    /******************添加footerview*******************/
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];

    //删除并退出按钮
    _dismissGroupBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 50, SCREEN_WIDTH-60, 50)];
    [_dismissGroupBtn setTitle:@"删除并退出" forState:UIControlStateNormal];
    [_dismissGroupBtn addTarget:self action:@selector(btnJOQAction:) forControlEvents:UIControlEventTouchUpInside];
    _dismissGroupBtn.backgroundColor = [UIColor redColor];
    [view addSubview:_dismissGroupBtn];

    self.tableView.tableFooterView = view;
}

#pragma mark - 删除并退出讨论组
- (void)btnJOQAction:(id)sender {
    
    XWAlterVeiw *alert = [[XWAlterVeiw alloc] init];
    alert.titleLable.text = @"确定删除群组";
    alert.delegate = self;
    [alert show];
}

- (void)subuttonClicked {
   
    for (NSString *userid in self.memberIdList) {
        if ([userid isEqualToString:self.groupModel.rygroupid]) {
            [[RCIMClient sharedRCIMClient] quitDiscussion:self.groupModel.rygroupid success:^(RCDiscussion *discussion) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSLog(@"退出成功");
                });
            } error:^(RCErrorCode status) {
                NSLog(@"退出失败:%ld",(long)status);
            }];
        }else{
            [[RCIMClient sharedRCIMClient] removeMemberFromDiscussion:self.groupModel.rygroupid userId:userid success:^(RCDiscussion *discussion) {
                NSLog(@"踢人成功");
            } error:^(RCErrorCode status) {
                NSLog(@"踢人失败");
            }];
        }
    }
    
    [self deleteServerGroupData];
}

- (void)deleteServerGroupData {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/group/delGroupByid"];
    NSDictionary *pramaDic = @{@"ckid":ckid, DeviceId:uuid, @"groupid":self.groupModel.groupid};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        [CKCNotificationCenter postNotificationName:@"ReloadMsgCenterDataNoti" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (IsNilOrNull(self.annoucemnet) || [self.annoucemnet isEqualToString:@"未设置"]) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        PTUpdateGroupNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PTUpdateGroupNameTableViewCell"];
        if (!cell) {
            cell = [[PTUpdateGroupNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PTUpdateGroupNameTableViewCell"];
        }
        cell.groupNameLabel.text = self.groupName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row == 1){
        PTUpdateAnnounceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PTUpdateAnnounceTableViewCell"];
        if (!cell) {
            cell = [[PTUpdateAnnounceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PTUpdateAnnounceTableViewCell"];
        }
        if(IsNilOrNull(self.annoucemnet) || [self.annoucemnet isEqualToString:@"未设置"]){
            cell.groupAnnounceLabel.text = @"未设置";
            cell.rightArrow.hidden = NO;
        }else{
            cell.groupAnnounceLabel.text = @"";
            cell.rightArrow.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        PTUpdateAnnounceContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PTUpdateAnnounceContentCell"];
        if (!cell) {
            cell = [[PTUpdateAnnounceContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PTUpdateAnnounceContentCell"];
        }
        cell.announceLabel.text = self.annoucemnet;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        RCDEditGroupNameViewController *editGroupNameVC =
        [[RCDEditGroupNameViewController alloc] init];
        editGroupNameVC.discussionId = self.groupModel.rygroupid;
        editGroupNameVC.groupName = self.groupModel.groupname;
        editGroupNameVC.groupId = self.groupModel.groupid;
        editGroupNameVC.annoucemnet = self.groupModel.groupnotice;
        editGroupNameVC.groupNameBlock = ^(NSString *name) {
            self.groupName = name;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:editGroupNameVC animated:YES];
    }else{
        RCDGroupAnnouncementViewController *announce = [[RCDGroupAnnouncementViewController alloc] init];
        announce.annoucemnet = self.groupModel.groupnotice;
        announce.groupName = self.groupModel.groupname;
        announce.groupId = self.groupModel.groupid;
        announce.groupAnnounceBlock = ^(NSString *content) {
            self.annoucemnet = content;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:announce animated:YES];
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = 55;
    float height = width + 15 + 9;

    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                                 layout:(UICollectionViewLayout *)collectionViewLayout
    minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.minimumLineSpacing = 12;
    return UIEdgeInsetsMake(15, 10, 10, 10);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [collectionViewResource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < collectionViewResource.count - 2) {
        _groupMemberCell =
        [collectionView dequeueReusableCellWithReuseIdentifier:@"PTGroupMemberCollectionViewCell" forIndexPath:indexPath];
        PTContactorModel *contactor = [[PTContactorModel alloc] init];
        contactor = collectionViewResource[indexPath.row];
        [_groupMemberCell updateCellData:contactor];
        return _groupMemberCell;
    }else{
        PTManageMemberCollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:@"PTManageMemberCollectionViewCell" forIndexPath:indexPath];
        UIImage *image = collectionViewResource[indexPath.row];
        cell.manageMemberView.image = image;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == collectionViewResource.count - 2) {
        #pragma mark - 添加成员
        PTSelectContactorViewController *vc = [[PTSelectContactorViewController alloc] init];
        vc.titleStr = @"添加成员";
        vc.addDiscussionGroupMembers = [NSMutableArray arrayWithArray:self.groupMemberList];
        vc.discussiongroupId = self.groupModel.rygroupid;
        vc.groupId = self.groupModel.groupid;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == collectionViewResource.count - 1){
        #pragma mark - 删除成员
        PTSelectContactorViewController *vc = [[PTSelectContactorViewController alloc] init];
        vc.titleStr = @"删除成员";
        vc.discussiongroupId = self.groupModel.rygroupid;
        vc.groupId = self.groupModel.groupid;
        NSMutableArray *deleteMemberList = [NSMutableArray array];
        for (PTContactorModel *contactor in self.groupMemberList) {
            //删除群成员的列表不能包含自己
            NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
            if (![contactor.meid isEqualToString:ckid]) {
                [deleteMemberList addObject:contactor];
            }
        }
        vc.delGroupMembers = deleteMemberList;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        PTContactorModel *contactorM = collectionViewResource[indexPath.row];
        PTFriendDetailViewController *detailViewController = [[PTFriendDetailViewController alloc] init];
        detailViewController.contactorModel = contactorM;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {

}

- (void)limitDisplayMemberCount {
    if (isCreator == YES && [collectionViewResource count] > 18) {
        NSRange rang = NSMakeRange(18, [collectionViewResource count] - 18);
        [collectionViewResource removeObjectsInRange:rang];
    } else if ([collectionViewResource count] > 19) {
        NSRange rang = NSMakeRange(19, [collectionViewResource count] - 19);
        [collectionViewResource removeObjectsInRange:rang];
    }
}

#pragma mark - 将创建者挪到第一的位置
- (NSMutableArray *)moveCreator:(NSMutableArray *)groupMemberList {
    if (groupMemberList == nil || groupMemberList.count == 0) {
        return nil;
    }
    int index = 0;
    for (int i = 0; i < groupMemberList.count; i++) {
        PTContactorModel *user = [groupMemberList objectAtIndex:i];
        NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
        if ([ckid isEqualToString:user.meid]) {
            index = i;
            break;
        }
    }
    [self.groupMemberList exchangeObjectAtIndex:index withObjectAtIndex:0];
    return self.groupMemberList;
}

- (void)setHeaderView {
//    [self limitDisplayMemberCount];
    UIImage *addImage = [UIImage imageNamed:@"add_member"];
    if (![collectionViewResource containsObject:addImage]) {
        [collectionViewResource addObject:addImage];
    }
    UIImage *delImage = [UIImage imageNamed:@"delete_member"];
    if (![collectionViewResource containsObject:delImage]) {
        [collectionViewResource addObject:delImage];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [headerView reloadData];
        headerView.frame =
            CGRectMake(0, 0, RCDscreenWidth, headerView.collectionViewLayout.collectionViewContentSize.height);
        CGRect frame = headerView.frame;
        frame.size.height += 14;
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
        self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
        [self.tableView.tableHeaderView addSubview:headerView];

        UIView *separatorLine =
            [[UIView alloc] initWithFrame:CGRectMake(10, frame.size.height - 1, frame.size.width - 10, 1)];
        separatorLine.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
        [self.tableView.tableHeaderView addSubview:separatorLine];
    });
}

@end
