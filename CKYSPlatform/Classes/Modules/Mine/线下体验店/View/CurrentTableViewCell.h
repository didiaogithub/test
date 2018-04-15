//
//  CurrentTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/20.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelecteAreaModel.h"
@interface CurrentTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *currentCityLable;
@property(nonatomic,strong)UILabel *rightLable;
@property(nonatomic,strong)UIImageView *rightImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSString *)type;
-(void)refreshWithCurrentStr:(NSString *)cityString;
-(void)refreshWithModel:(SelecteAreaModel *)provinceModel;
@end
