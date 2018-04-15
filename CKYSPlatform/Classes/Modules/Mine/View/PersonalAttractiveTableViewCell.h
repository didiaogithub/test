//
//  PersonalAttractiveTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/4/2.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeAndAttactiveModel.h"
@interface PersonalAttractiveTableViewCell : UITableViewCell
@property(nonatomic,copy)NSString *typeStr;


@property(nonatomic,strong)UILabel *nameLable;
@property(nonatomic,strong)UILabel *phoneLable;


//团队招商 右侧为招商人数
@property(nonatomic,strong)UILabel *rightLable;

-(void)cellfreshWithModel:(RechargeAndAttactiveModel *)personalModel;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTypeStr:(NSString *)typestr;
@end
