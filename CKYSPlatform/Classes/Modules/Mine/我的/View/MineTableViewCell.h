//
//  MineTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineTableViewCellDelegate <NSObject>

-(void)didSelectedItemWithName:(NSString*)itemName;

@end

@interface MineTableViewCell : UITableViewCell

@property (nonatomic, weak)   id<MineTableViewCellDelegate>delegate;
@property (nonatomic, strong) UICollectionView *mineCollectionView;
@property (nonatomic, copy)   NSString *typeString;
@property (nonatomic, strong) NSArray *iconArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, copy)   NSString *isshowStock;
@property (nonatomic, copy)   NSString *tgidString;

-(void)cellrefreshWithArray:(NSArray *)imageArr andTitleArr:(NSArray *)titleArr;

@end
