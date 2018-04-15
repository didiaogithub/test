//
//  PTGroupSettingTableViewCell.h
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/13.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTGroupSettingTableViewCell : UITableViewCell

@end


@interface PTUpdateGroupNameTableViewCell : PTGroupSettingTableViewCell

@property (nonatomic, strong) UILabel *groupNameLabel;

@end

@interface PTUpdateAnnounceTableViewCell : PTGroupSettingTableViewCell

@property (nonatomic, strong) UILabel *groupAnnounceLabel;
@property (nonatomic, strong) UIImageView *rightArrow;

@end


@interface PTUpdateAnnounceContentCell : PTGroupSettingTableViewCell

@property (nonatomic, strong) UILabel *announceLabel;

@end
