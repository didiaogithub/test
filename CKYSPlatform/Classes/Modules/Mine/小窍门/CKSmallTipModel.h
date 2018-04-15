//
//  CKSmallTipModel.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/2.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

@interface CKSmallTipModel : BaseEncodeModel

/**小窍门图片Url*/
@property (nonatomic, copy) NSString *imgurl;
/**小窍门阅读量*/
@property (nonatomic, copy) NSString *viewed;
/**小窍门发布时间*/
@property (nonatomic, copy) NSString *time;
/**小窍门id*/
@property (nonatomic, copy) NSString *classId;
/**小窍门类型*/
@property (nonatomic, copy) NSString *typecode;
/**小窍门标题*/
@property (nonatomic, copy) NSString *title;
/**小窍门分享url*/
@property (nonatomic, copy) NSString *urlshare;
/**小窍门讲师*/
@property (nonatomic, copy) NSString *teacher;
/**小窍门详情url*/
@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *sortID;

@end
