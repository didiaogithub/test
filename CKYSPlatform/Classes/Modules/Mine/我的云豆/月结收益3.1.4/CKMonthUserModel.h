//
//  CKMonthUserModel.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/19.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

@interface CKMonthUserModel : BaseEncodeModel

/**姓名*/
@property (nonatomic, copy) NSString *name;
/**手机号*/
@property (nonatomic, copy) NSString *mobile;
/**加盟类型（SURE：正式 NOTSURE：零风险）*/
@property (nonatomic, copy) NSString *jointype;
/**加盟时间*/
@property (nonatomic, copy) NSString *jointime;


@end
