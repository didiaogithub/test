//
//  MyTeamTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/11.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTeamListModel.h"
@protocol MyTeamTableViewCellDelegate <NSObject>
-(void)clickMyTeamButtonWithIndex:(NSInteger)index;
@end

@interface MyTeamTableViewCell : UITableViewCell

@property(nonatomic,weak)id<MyTeamTableViewCellDelegate>delegate;

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,copy)NSString *typeString;


@property(nonatomic,strong)UIImageView *headImageView;
/**1*/
@property(nonatomic,strong)UILabel *firstLab;
/**2*/
@property(nonatomic,strong)UILabel *secondLab;
/**3*/
@property(nonatomic,strong)UILabel *threenLab;
@property(nonatomic,strong)UILabel *textsaleLable;
/**4*/
@property(nonatomic,strong)UILabel *saleMoneyLable;


@property(nonatomic,strong)UIButton *phoneButton;
-(void)refreshWithListModel:(MyTeamListModel *)teamListModel;
@end
