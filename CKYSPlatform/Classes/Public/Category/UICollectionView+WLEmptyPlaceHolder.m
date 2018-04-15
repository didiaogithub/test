//
//  UICollectionView+WLEmptyPlaceHolder.m
//  WLPlaceHolder
//
//  Created by 王林 on 16/5/11.
//  Copyright © 2016年 com.ptj. All rights reserved.
//

#import "UICollectionView+WLEmptyPlaceHolder.h"

@implementation UICollectionView (WLEmptyPlaceHolder)

//添加一个方法
- (void) collectionViewDisplayView:(UIView *) displayView ifNecessaryForRowCount:(NSUInteger) rowCount
{
    if (rowCount == 0) {
        self.scrollEnabled = NO;
        self.backgroundView = displayView;
    } else {
        self.scrollEnabled = YES;
        self.backgroundView = nil;
    }
}

@end
