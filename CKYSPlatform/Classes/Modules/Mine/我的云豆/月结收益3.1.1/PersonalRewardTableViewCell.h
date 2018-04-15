//
//  PersonalRewardTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/9.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthAccountModel.h"
@protocol PersonalRewardTableViewCellDelegate <NSObject>
-(void)pushToVCWithtag:(NSInteger)tag;
@end
@interface PersonalRewardTableViewCell : UITableViewCell
@property(nonatomic,weak)id<PersonalRewardTableViewCellDelegate>delegate;
/**个人业绩数额*/
@property(nonatomic,strong)UILabel *personalAchieveLable;

/**个人进货*/
@property(nonatomic,strong)UILabel *personalGoodsLable;
/**个人招商*/
@property(nonatomic,strong)UILabel *personalAttractLable;
/**点击团队奖励系数说明*/
@property(nonatomic,strong)UIButton *coefficientButton;
/**个人进货按钮*/
@property(nonatomic,strong)UIButton *personalGoodsButton;
/**个人招商按钮*/
@property(nonatomic,strong)UIButton *personalAttractButton;
-(void)refreshPersonalWithModel:(MonthAccountModel *)monthModel;


@end
