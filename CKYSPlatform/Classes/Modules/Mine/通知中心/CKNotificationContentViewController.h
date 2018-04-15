//
//  CKNotificationContentViewController.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/15.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SelectedIndexBlock)(NSInteger selectedIndex);

@interface CKNotificationContentViewController : BaseViewController

@property (nonatomic, copy) SelectedIndexBlock selectedIndexBlock;

-(void)returnIndex:(SelectedIndexBlock)block;

@end
