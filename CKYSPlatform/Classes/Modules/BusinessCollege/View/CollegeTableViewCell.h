//
//  CollegeTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/9.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"
@interface CollegeTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView  *pictureImageView;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UILabel *subTitlelable;

@property(nonatomic,strong)UILabel *seePeoplelable;
@property(nonatomic,strong)UIImageView *seeImageView;

@property(nonatomic,strong)UILabel *timelable;
-(void)refreshWithLessons:(ClassModel *)classModel;
@end
