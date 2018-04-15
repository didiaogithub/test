///Users/zhangjiang/Desktop/测试/OC/地图测试/地图测试/MyAnnotation.m
//  MyAnnotation.m
//  地图测试
//
//  Created by zhangjiang on 14/11/10.
//  Copyright (c) 2014年 zhangjiang. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize ID = _ID;
@synthesize ckmobile = _ckmobile;
@synthesize ckname = _ckname;
@synthesize expname = _expname;
@synthesize exptel = _exptel;
@synthesize status = _status;
@synthesize opentime = _opentime;
@synthesize province = _province;
@synthesize city = _city;
@synthesize address = _address;
@synthesize credentialpath = _credentialpath;
@synthesize desc = _desc;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;;
    }
    if ([key isEqualToString:@"description"]) {
        _desc = value;;
    }
    [super setValue:value forKey:key];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{



}

@end
