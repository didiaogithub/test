//
//  CardModel.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/12/6.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "CardModel.h"

@implementation CardModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{


}
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;;
    }
    [super setValue:value forKey:key];
}

@end
