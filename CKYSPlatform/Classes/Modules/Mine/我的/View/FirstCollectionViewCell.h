//
//  FirstCollectionViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *topImageView;
@property(nonatomic,strong)UILabel *tgLable;

-(void)refreshWithCell:(NSArray *)imageArr andTitleArr:(NSArray *)titleArr andIndex:(NSInteger)index;
@end
