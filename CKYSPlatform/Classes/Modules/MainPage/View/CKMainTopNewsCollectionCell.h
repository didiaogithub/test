//
//  CKMainTopNewsCollectionCell.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/8/16.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKMainTopNewsCollectionCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *bestNewImageView;

-(void)refreshWithCell:(NSMutableArray *)imageArr andIndex:(NSInteger)index;

@end
