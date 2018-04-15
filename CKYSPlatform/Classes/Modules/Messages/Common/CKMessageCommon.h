//
//  CKMessageCommon.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTContactorModel.h"
#import "CKGroupModel.h"

@interface CKMessageCommon : NSObject


/**
 将ck的信息生成PTContactorModel

 @return PTContactorModel
 */
+ (PTContactorModel*)getCKInfoModel;

/**
 将PTContactorModel转换成CKGroupInfoModel

 @param contactorM 将ck的信息生成PTContactorModel
 @return CKGroupInfoModel
 */
+ (CKGroupInfoModel*)convertCKInfoToGroupInfo:(PTContactorModel*)contactorM ;

@end
