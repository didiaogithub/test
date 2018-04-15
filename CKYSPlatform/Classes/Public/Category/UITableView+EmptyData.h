//
//  UITableView+EmptyData.h
//  yingzi_iOS
//
//  Created by panghongxia on 16/4/11.
//  Copyright © 2016年 lyw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyData)

- (void)tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;
@end
