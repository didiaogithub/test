//
//  PTSelectContactorViewController.h
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/14.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "BaseViewController.h"

@interface PTSelectContactorViewController : BaseViewController

@property(nonatomic, strong) NSArray *keys;

@property(nonatomic, strong) NSMutableDictionary *allFriends;

@property(nonatomic, strong) NSArray *allKeys;

@property(nonatomic, copy) NSString *titleStr;


@property(nonatomic, strong) NSMutableArray *delGroupMembers;

@property(nonatomic, copy) NSString *groupId;
@property(nonatomic, copy) NSString *groupName;
@property(nonatomic, copy) NSString *discussiongroupId;


@property(nonatomic, strong) NSMutableArray *addDiscussionGroupMembers;


@property(nonatomic, strong) UISearchBar *searchBar;

@end
