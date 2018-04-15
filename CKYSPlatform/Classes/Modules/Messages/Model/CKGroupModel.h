//
//  CKGroupModel.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/17.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <Realm/Realm.h>

@interface CKGroupInfoModel : RLMObject

/**群组成员id*/
@property NSString *meid;
/**群组成员姓名*/
@property NSString *name;
/**群组成员备注*/
@property NSString *remark;
/**群组成员头像*/
@property NSString *head;
/**群组成员电话*/
@property NSString *mobile;

@end
RLM_ARRAY_TYPE(CKGroupInfoModel)

@interface CKGroupModel : RLMObject

/**群组id*/
@property NSString *groupid;
/**融云群组id*/
@property NSString *rygroupid;
/**群组名称*/
@property NSString *groupname;
/**群组公告*/
@property NSString *groupnotice;
/**群组建立时间*/
@property NSString *grouptime;
/**群组成员*/
@property RLMArray<CKGroupInfoModel*><CKGroupInfoModel> *groupinfoArray;
/**主键ckid+groupid*/
@property NSString *groupidKey;

@end
