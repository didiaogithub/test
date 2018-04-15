//
//  CKSmallTipCell.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/2.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKSmallTipModel.h"

@interface CKSmallTipCell : UITableViewCell

- (void)refreshWithLessons:(CKSmallTipModel*)smallTipModel;

@end
