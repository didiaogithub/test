//
//  FXTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/14.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTeamListModel.h"
@protocol FXTableViewCellDelegate <NSObject>
-(void)clickMyTeamButtonTag:(NSInteger)buttonTag andIndex:(NSInteger)index;
@end
@interface FXTableViewCell : UITableViewCell
@property(nonatomic,weak)id<FXTableViewCellDelegate>delegate;

@property(nonatomic,assign)NSInteger index;
/**1*/
@property(nonatomic,strong)UILabel *firstLab;
/**2*/
@property(nonatomic,strong)UILabel *secondLab;
/**3*/
@property(nonatomic,strong)UILabel *threenLab;
/**4*/
@property(nonatomic,strong)UIView *fourView;

/**查看详情按钮*/
@property(nonatomic,strong)UIButton *detailButton;
@property(nonatomic,strong)UIButton *phoneButton;
-(void)refreshWithListModel:(MyTeamListModel *)teamListmodel;
@end
