//
//  GlobalResource.m
//  Movie
//
//  Created by Apple on 10/15/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import "GlobalResource.h"

@implementation GlobalResource

__strong static GlobalResource *globalLocation = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        globalLocation = [[super allocWithZone:NULL] init];
    });
    return globalLocation;
}

@end
