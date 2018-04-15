//
//  PTContactorModel.h
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/9.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "BaseEncodeModel.h"

@interface PTContactorModel : BaseEncodeModel

/*!
 用户ID
 */
@property(nonatomic, strong) NSString *meid;

/*!
 用户名称
 */
@property(nonatomic, strong) NSString *name;

/*!
 用户头像的URL
 */
@property(nonatomic, strong) NSString *head;

/*!
 用户备注名字
 */
@property(nonatomic, strong) NSString *remark;

/*!
 用户手机
 */
@property(nonatomic, strong) NSString *mobile;


@end
