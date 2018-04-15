//
//  Mediator+CKMainPage.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "Mediator.h"

@interface Mediator (CKMainPage)

-(UIViewController*)ckMainPageViewController;

/**
 写首页数据到Realm

 @param dict 内容
 @param ckid 创客id
 */
-(UIViewController*)ckWriteMainPageDataToDB:(NSDictionary*)dict ckid:(NSString*)ckid;

@end
