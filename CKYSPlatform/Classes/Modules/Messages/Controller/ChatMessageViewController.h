//
//  ChatMessageViewController.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/7/10.
//  Copyright © 2016年 ckys. All rights reserved.
//


#import <RongIMKit/RongIMKit.h>
@interface ChatMessageViewController : RCConversationViewController<RCIMUserInfoDataSource,RCIMConnectionStatusDelegate>
@property(nonatomic,copy) NSString *titleString;
@property(nonatomic,copy) NSString *headUrl;

@end
