//
//  CKMapManager.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/12.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKMapManager : NSObject

@property (nonatomic, strong) NSMutableArray *annotationsArray;

+(instancetype)manager;

@end
