//
//  CKMainPageCommon.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/5/24.
//  Copyright © 2017年 ForgetFairy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKMainPageModel.h"
#import "CKMainPageCell.h"

extern NSString * const BKClassifyStrAPI;
extern NSString * const BKClassify_goods_classify;

typedef void(^CompeletionCallBack)(id result, NSError *error);
typedef void(^FailureCallBack)(id result, NSError *error);

@interface CKMainPageCommon : NSObject

//+(void)getMainPageData:(CompeletionCallBack)callback;


@end
