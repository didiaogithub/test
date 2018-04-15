//
//  CKProductLibCell.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKProductLibModel.h"

@interface CKProductLibCell : UITableViewCell

-(void)refreshWithModel:(CKProductLibModel*)model;

@end
