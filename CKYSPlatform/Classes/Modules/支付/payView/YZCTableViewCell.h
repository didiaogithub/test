//
//  YZCTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/4/16.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZCTableViewCell : UITableViewCell
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)UIImageView *leftIamgeView;

@property(nonatomic,strong)UIButton *rightButton;
@end
