//
//  BestNewsCollectionViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/5/2.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BestNewsCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *bestNewImageView;

-(void)refreshWithCell:(NSMutableArray *)imageArr andIndex:(NSInteger)index;

@end
