//
//  CKVersionCheckManager.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKVersionCheckManager : NSObject

+(instancetype)shareInstance;

-(void)checkVersion;

-(void)compareVersion:(NSString*)serviceVersion forceUpdate:(NSString*)forceUpdate;

-(void)showForceUpdate;

@end
