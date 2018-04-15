//
//  CKHotNewsCell.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/2/5.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderModel.h"

@interface CKHotNewsCell : UITableViewCell



//新闻
-(void)refreshWithHeaderModel:(HeaderModel *)headerModel;

@end
