//
//  PersonalStokUpTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/10.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeAndAttactiveModel.h"
//个人进货
@interface PersonalStokUpTableViewCell : UITableViewCell
{
    UIView *_personbankGroundView;
    
}
@property(nonatomic,copy)NSString *typestr;
/**序号*/
@property(nonatomic,strong)UILabel *nameLable;
/**进货金额*/
@property(nonatomic,strong)UILabel *moneyLable;
/**进货时间*/
@property(nonatomic,strong)UILabel *timeLable;
-(void)refreshWithModel:(RechargeAndAttactiveModel *)rechargeModel;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTypeStr:(NSString *)typeStr;
@end
