//
//  CKWaterFlowLayout.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/3.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKWaterFlowLayout;

@protocol CKWaterFlowLayoutDelegate <NSObject>

@required
//计算item高度的代理方法，将item的高度与indexPath传递给外界
- (CGFloat)waterFlowLayout:(CKWaterFlowLayout *)waterFlowLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath;

@end

@interface CKWaterFlowLayout : UICollectionViewLayout

/**总共多少列，默认是2*/
@property (nonatomic, assign) NSInteger columnCount;
/**列间距，默认是0*/
@property (nonatomic, assign) NSInteger columnSpacing;
/**行间距，默认是0*/
@property (nonatomic, assign) NSInteger rowSpacing;
/**section与collectionView的间距，默认是（0，0，0，0）*/
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/**
 以下代理属性与block属性二选一，用来设置每一个item的高度
 会将item的宽度与indexPath传递给外界
 如果两个都设置，block的优先级高，即代理无效
 */

//代理，用来计算item的高度
@property (nonatomic, weak) id<CKWaterFlowLayoutDelegate> delegate;
//计算item高度的block，将item的高度与indexPath传递给外界
@property (nonatomic, strong) CGFloat(^itemHeightBlock)(CGFloat itemHeight,NSIndexPath *indexPath);

//同时设置列间距，行间距，sectionInset
- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset;

+ (instancetype)waterFlowLayoutWithColumnCount:(NSInteger)columnCount;

- (instancetype)initWithColumnCount:(NSInteger)columnCount;

@end
