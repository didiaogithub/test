//
//  PTUpdateFriendNickNameVC.h
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/9.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ChangeRemarkNameBlock)(NSString *name);

@interface PTUpdateFriendNickNameVC : BaseViewController

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *meid;
@property (nonatomic, copy) ChangeRemarkNameBlock remarkNameBlock;



@end
