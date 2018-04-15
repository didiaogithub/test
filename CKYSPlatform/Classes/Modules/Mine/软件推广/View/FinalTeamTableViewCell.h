//
//  FinalTeamTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/10.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTeamListModel.h"

@protocol FinalTeamTableViewCellDelegate <NSObject>
-(void)clickMyTeamButtonWithIndex:(NSInteger)index;

@end

@interface FinalTeamTableViewCell : UITableViewCell
@property(nonatomic,weak)id<FinalTeamTableViewCellDelegate>delegate;

@property(nonatomic,strong) UIView *bankView;
@property(nonatomic,strong) UIView *topCotentView;
@property(nonatomic,strong) UIView *detailContentView;

@property(nonatomic,strong) MASConstraint *aConstrain;
@property(nonatomic,strong) MASConstraint *bConstrain;
@property(nonatomic,copy)NSString *typeString;
@property(nonatomic,assign)NSInteger index;
/**头像*/
@property(nonatomic,strong)UIImageView *headImageView;
/**姓名*/
@property(nonatomic,strong)UILabel *nameLable;
/**电话*/
@property(nonatomic,strong)UILabel *phoneLable;
/**招商人数*/
@property(nonatomic,strong)UILabel *attractiveLable;
/**个人业绩*/
@property(nonatomic,strong)UILabel *salesMoneyLable;

/**电话按钮*/
@property(nonatomic,strong)UIButton *phoneButton;

@property(nonatomic,strong)UILabel *bottomLine;
/**进货总计*/
@property(nonatomic,strong)UILabel *stopupTotalLable;
/**招商总计*/
@property(nonatomic,strong)UILabel *attractiveTotalLable;
@property(nonatomic,strong)UILabel *joinTimeLable;


-(void)refreshWithListModel:(MyTeamListModel *)teamListModel andOpen:(BOOL)isOpen;
@end
