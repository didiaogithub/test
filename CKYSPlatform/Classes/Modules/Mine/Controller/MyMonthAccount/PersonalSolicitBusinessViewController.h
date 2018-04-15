//
//  PersonalSolicitBusinessViewController.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/9.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseViewController.h"
//个人招商
@interface PersonalSolicitBusinessViewController : BaseViewController
@property(nonatomic,copy)NSString *typeString;
@property(nonatomic,copy)NSString *yearString;
@property(nonatomic,copy)NSString *monthString;

/**个人招商记录的ckid*/
@property(nonatomic,copy)NSString *personalCkidString;

@end
