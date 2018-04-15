//
//  OrderModel.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/8/10.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "OrderModel.h"

@implementation Ordersheet

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+(NSString*)primaryKey {
    return @"sheetKey";
}

@end

@implementation OrderModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+(NSString*)primaryKey {
    return @"oid";
}

@end
