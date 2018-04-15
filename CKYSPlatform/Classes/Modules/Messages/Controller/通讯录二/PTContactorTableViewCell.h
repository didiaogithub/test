//
//  PTContactorTableViewCell.h
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/9.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTContactorModel.h"

@interface PTContactorTableViewCell : UITableViewCell

- (void)updateCellWithModel:(PTContactorModel *)user;

@end
