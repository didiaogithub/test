//
//  RCDGroupAnnouncementViewController.h
//  RCloudMessage
//
//  Created by Jue on 16/7/14.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "UITextViewAndPlaceholder.h"
#import "BaseViewController.h"

typedef void (^ChangeGroupAnnouncementBlock)(NSString *content);

@interface RCDGroupAnnouncementViewController : BaseViewController <UITextViewDelegate>

@property (nonatomic, strong) UITextViewAndPlaceholder *AnnouncementContent;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) ChangeGroupAnnouncementBlock groupAnnounceBlock;
@property (nonatomic, copy) NSString *annoucemnet;


@end
