//
//  UserModel.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/25.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

@end


@implementation ClearAllCache : RLMObject

+(NSString*)primaryKey {
    return @"isClear";
}


@end
