//
//  ShareCodeTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareCodeTableViewCell;

@protocol ShareCodeTableViewCellDelegate <NSObject>

@optional
-(void)clickShareCodeWithIndex:(NSInteger)index;

- (void)extendCell:(ShareCodeTableViewCell*)extendCell didSelectItem:(NSString*)item;

@end

@interface ShareCodeTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic,weak)id<ShareCodeTableViewCellDelegate>delegate;
@property(nonatomic,strong)UICollectionView *mineCollectionView;
@property(nonatomic,strong)NSArray *iconArray;
@property(nonatomic,strong)NSArray *tgTitleArray;
@property(nonatomic,copy)NSString *typeString;

-(void)cellrefreshWithArray:(NSArray *)imageArr  andTitleArr:(NSArray *)titleArr;

@end
