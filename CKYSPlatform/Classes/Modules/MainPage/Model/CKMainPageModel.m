//
//  CKMainPageModel.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/5/24.
//  Copyright © 2017年 ForgetFairy. All rights reserved.
//

#import "CKMainPageModel.h"

@implementation Honor_list

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
};

+(NSString*)primaryKey {
    return @"path";
}

@end


@implementation Banners

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
};

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _bannerID = value;
    }
    [super setValue:value forKey:key];
}

+(NSString*)primaryKey {
    return @"path";
}

@end


@implementation Top3ckheaders

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
};

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _top3ckID = value;
    }
    [super setValue:value forKey:key];
}

+(NSString*)primaryKey {
    return @"top3ckID";
}

@end


@implementation Topnews

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
};

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _lineID = value;
    }
    [super setValue:value forKey:key];
}

+(NSString*)primaryKey {
    return @"lineID";
}

@end


@implementation Mediareport

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
};

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _lineId = value;
    }
    [super setValue:value forKey:key];
}

+(NSString*)primaryKey {
    return @"lineId";
}

@end


@implementation CKMainPageModel

+(NSDictionary*)mj_objectClassInArray {
    return @{@"honor_list": [Honor_list class], @"banners": [Banners class], @"top3ckheaders": [Top3ckheaders class], @"topnews": [Topnews class]};
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
};

+(NSString*)primaryKey {
    return @"ckid";
}

@end
