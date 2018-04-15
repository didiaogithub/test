//
//  UITableView+WLEmptyPlaceHolder.m
//  WLPlaceHolder
//
//  Created by 庞宏侠 on 16/10/24.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "UITableView+WLEmptyPlaceHolder.h"
#import <objc/runtime.h>

@implementation UITableView (WLEmptyPlaceHolder)
//添加一个方法
- (void) tableViewDisplayView:(UIView *) displayView ifNecessaryForRowCount:(NSUInteger) rowCount
{
    [self setBackgroundColor:[UIColor tt_grayBgColor]];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (rowCount == 0) {
        self.backgroundView = displayView;
        self.scrollEnabled = YES;
      
    } else {
        self.scrollEnabled = YES;
        self.backgroundView = nil;
    }
}



@end
