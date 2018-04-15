//
//  CKPickupGoodsModel.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/2/26.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKPickupGoodsModel.h"

@implementation CKPickupGoodsModel

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _ID = value;;
    }
    if ([key isEqualToString:@"description"]) {
        _desCription = value;;
    }
    
    [super setValue:value forKey:key];
}

@end
