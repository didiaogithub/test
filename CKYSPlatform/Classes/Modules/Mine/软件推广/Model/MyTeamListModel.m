//
//  MyTeamListModel.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/12/2.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "MyTeamListModel.h"

@implementation MyTeamListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{



}
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;;
    }
    [super setValue:value forKey:key];
}

@end
