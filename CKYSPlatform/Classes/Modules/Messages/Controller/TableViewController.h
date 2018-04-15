//
//  TableViewController.h
//  Demo
//
//  Created by 王家强 on 16/12/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedIndexBlock)(NSInteger selectedIndex);

@interface TableViewController : UIViewController

@property (nonatomic, copy) SelectedIndexBlock selectedIndexBlock;

-(void)returnIndex:(SelectedIndexBlock)block;

@end
