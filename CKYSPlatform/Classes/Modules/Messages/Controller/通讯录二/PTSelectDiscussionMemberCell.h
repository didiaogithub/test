//
//  PTSelectDiscussionMemberCell.h
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/9.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTContactorModel.h"

@interface PTSelectDiscussionMemberCell : UITableViewCell

/**
 *  选中图片
 */
@property(nonatomic, strong) UIImageView *selectedImageView;
/**
 *  昵称
 */
@property(nonatomic, strong) UILabel *nicknameLabel;

- (void)updateCellWithModel:(PTContactorModel *)user;

@end
