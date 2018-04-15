//
//  RCDGroupSettingsTableViewController.h
//  RCloudMessage
//
//  Created by Jue on 16/3/22.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "BaseViewController.h"
#import <RongIMKit/RongIMKit.h>
#import <UIKit/UIKit.h>
#import "CKGroupModel.h"

@interface RCDGroupSettingsTableViewController
    : BaseViewController

@property (nonatomic, copy)   NSString *groupName;
@property (nonatomic, copy)   NSString *annoucemnet;
@property (nonatomic, strong) NSMutableArray *memberIdList;
@property (nonatomic, strong) CKGroupModel *groupModel;

@end
