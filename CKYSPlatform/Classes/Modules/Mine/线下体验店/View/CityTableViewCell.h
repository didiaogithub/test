//
//  CityTableViewCell.h
//  MySelectCityDemo
//
//  Created by ZJ on 15/10/28.
//  Copyright © 2015年 WXDL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedBlock)(NSString *currentStr);

@interface CityTableViewCell : UITableViewCell

@property(nonatomic,strong)UIButton *locationButton;
@property(nonatomic,copy)NSString *provinceStr;
@property (nonatomic,copy)selectedBlock transBlock;
-(void)setTransBlock:(selectedBlock)transBlock;
-(void)refreshCurrentCity:(NSString *)currentStr;
@end
