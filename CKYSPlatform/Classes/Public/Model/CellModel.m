//
//  CellModel.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/5/24.
//  Copyright © 2017年 ForgetFairy. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel

-(instancetype)init {
    self = [super init];
    if(self) {
        self.reuseIdentifier = [[NSUUID UUID] UUIDString];
    }
    return self;
}

+(instancetype)cellModelWithTitle:(NSString *)title sel:(NSString *)selectorString {
    CellModel *cell = [[CellModel alloc] init];
    cell.title = title;
    cell.selectorString = selectorString;
    return cell;
}

+(instancetype)cellModelWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(NSString *)image sel:(NSString *)selectorString {
    CellModel *cell = [[CellModel alloc] init];
    cell.title = title;
    cell.subTitle = subTitle;
    cell.image = image;
    cell.selectorString = selectorString;
    return cell;
}

@end
