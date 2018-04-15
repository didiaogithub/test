//
//  ShopListModel.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/17.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "ShopListModel.h"

@implementation ShopListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;;
    }
    if ([key isEqualToString:@"description"]) {
        _descrip = value;;
    }
    [super setValue:value forKey:key];
}

@end
