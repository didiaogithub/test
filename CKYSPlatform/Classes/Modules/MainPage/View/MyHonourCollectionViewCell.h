//
//  MyHonourCollectionViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/28.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHonourCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bankGroundImageView;

@property (nonatomic, assign) NSInteger index;

-(void)refreshWithArray:(NSMutableArray *)honourArray anTag:(NSInteger)index;

@end
