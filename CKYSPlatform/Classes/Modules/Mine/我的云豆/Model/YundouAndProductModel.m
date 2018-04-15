//
//  YundouAndProductModel.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/12/9.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "YundouAndProductModel.h"

@implementation YundouAndProductModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
    
}
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;;
    }
    [super setValue:value forKey:key];
}
@end
