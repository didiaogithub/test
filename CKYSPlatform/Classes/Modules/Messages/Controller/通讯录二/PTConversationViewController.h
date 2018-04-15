//
//  PTConversationViewController.h
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/9.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "CKGroupModel.h"

@interface PTConversationViewController : RCConversationViewController<RCIMUserInfoDataSource, RCIMConnectionStatusDelegate>

@property (nonatomic, copy)   NSString *titleString;
@property (nonatomic, copy)   NSString *headUrl;
@property (nonatomic, copy)   NSString *groupId;

@property (nonatomic, strong) NSMutableArray *userIdArray;
@property (nonatomic, strong) CKGroupModel *groupModel;

@end
