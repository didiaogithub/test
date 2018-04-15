//
//  PTContactorViewController.h
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/8.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "BaseViewController.h"

@interface PTContactorViewController : BaseViewController

@property(nonatomic, strong) NSArray *keys;

@property(nonatomic, strong) NSMutableDictionary *allFriends;

@property(nonatomic, strong) NSArray *allKeys;

@property(nonatomic, strong) NSString *groupId;

@property(nonatomic, assign) BOOL forCreatingGroup;

@property(nonatomic, assign) BOOL forCreatingDiscussionGroup;

@property(nonatomic, strong) NSMutableArray *addDiscussionGroupMembers;

@property(nonatomic, strong) NSString *discussiongroupId;

@property(nonatomic, strong) UISearchBar *searchBar;

@end
