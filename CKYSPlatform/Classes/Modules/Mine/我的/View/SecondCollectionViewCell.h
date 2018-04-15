//
//  SecondCollectionViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *bottomLable;

-(void)refreshWithCell:(NSArray *)imageArr andTitleArr:(NSArray *)titleArr andIndex:(NSInteger)index;

@end
