//
//  AddressModel.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/8/17.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;;
    }
    [super setValue:value forKey:key];
}

@end
