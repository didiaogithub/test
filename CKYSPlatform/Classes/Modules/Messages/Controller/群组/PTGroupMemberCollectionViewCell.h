//
//  PTGroupMemberCollectionViewCell.h
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/13.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTContactorModel.h"

@interface PTGroupMemberCollectionViewCell : UICollectionViewCell

@property(nonatomic, copy) NSString *userId;
@property (nonatomic, strong) UILabel *nameLabel;
- (void)updateCellData:(PTContactorModel*)userModel;

@end
