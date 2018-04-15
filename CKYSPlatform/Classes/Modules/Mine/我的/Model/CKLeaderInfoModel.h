//
//  CKLeaderInfoModel.h
//  CKYSPlatform
//
//  Created by majun on 2018/4/4.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

@interface CKLeaderInfoModel : BaseEncodeModel
/**  标题 例如 ：我的领导人 我的上级 我的领袖*/
@property (nonatomic, copy) NSString *title;
/**  级领导人姓名*/
@property (nonatomic, copy) NSString *name;
/**  领导人电话*/
@property (nonatomic, copy) NSString *mobile;
/**  是否可见 0：不可见 1：可见 比如某个人已经是领导人了，或者她上面没有领导人了，那是否还显示。*/
@property (nonatomic, copy) NSString *isvisible;
/**  备用标题1*/
@property (nonatomic, copy) NSString *label1;
/**  备用值1*/
@property (nonatomic, copy) NSString *text1;
/**  备用标题2*/
@property (nonatomic, copy) NSString *label2;
/**  备用值2*/
@property (nonatomic, copy) NSString *text2;
@end
