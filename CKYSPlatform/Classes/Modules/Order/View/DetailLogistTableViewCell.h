//
//  LogistTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/21.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogistModel.h"
@interface DetailLogistTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *verticalLable;
@property(nonatomic,strong)UILabel *latestLogistLable;
@property(nonatomic,strong)UILabel *latestTimeLable;
@property(nonatomic,strong)UIImageView *imageViewR;

@property(nonatomic,strong)UILabel *bottomLable;
-(void)refreshWithLogistModel:(LogistModel *)logistModel;
@end
