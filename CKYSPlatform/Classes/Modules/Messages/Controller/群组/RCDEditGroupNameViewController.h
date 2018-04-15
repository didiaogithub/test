//
//  RCDEditGroupNameViewController.h
//  RCloudMessage
//
//  Created by Jue on 16/3/28.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ChangeGroupNameBlock)(NSString *name);

@interface RCDEditGroupNameViewController : BaseViewController <UITextFieldDelegate>

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *discussionId;
@property (nonatomic, copy) NSString *annoucemnet;

@property(nonatomic, strong) UITextField *groupNameTextField;
@property (nonatomic, copy) ChangeGroupNameBlock groupNameBlock;


@end
