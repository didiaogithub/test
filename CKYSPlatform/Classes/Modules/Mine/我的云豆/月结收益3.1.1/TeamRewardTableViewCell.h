//
//  TeamRewardTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/9.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthAccountModel.h"
@protocol TeamRewardTableViewCellDelegate <NSObject>
-(void)pushToTeamVCWithtag:(NSInteger)tag;
@end
@interface TeamRewardTableViewCell : UITableViewCell
@property(nonatomic,weak)id<TeamRewardTableViewCellDelegate>delegate;
/**团队收益*/
@property(nonatomic,strong)UILabel *teamAchieveLable;
/**团队进货*/
@property(nonatomic,strong)UILabel *teamGoodsLable;
/**团队招商*/
@property(nonatomic,strong)UILabel *teamAttractLable;
/**团队进货按钮*/
@property(nonatomic,strong)UIButton *teamGoodsButton;
/**团队招商按钮*/
@property(nonatomic,strong)UIButton *teamAttractButton;
-(void)refreshTeamWithModel:(MonthAccountModel *)monthModel;

@end
