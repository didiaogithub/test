//
//  CKdlbGoodsModel.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKdlbGoodsModel.h"

@implementation CKdlbGoodsModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _goodsId = value;;
    }
    [super setValue:value forKey:key];
}
@end
