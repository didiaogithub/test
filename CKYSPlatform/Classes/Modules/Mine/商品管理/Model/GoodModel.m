//
//  GoodModel.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/15.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "GoodModel.h"

@implementation GoodModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;;
    }
    if ([key isEqualToString:@"description"]) {
        _desCription = value;;
    }

    [super setValue:value forKey:key];
}

@end
