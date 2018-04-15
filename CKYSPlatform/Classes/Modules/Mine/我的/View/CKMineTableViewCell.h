//
//  CKMineTableViewCell.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/17.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKMineTableViewCell : UITableViewCell
/**
 代表任意代理协议，有子类决定
 */
@property(nonatomic,weak) id delegate;

/**
 由子类实现，数据填充方法
 */
-(void)fillData:(id)data;

/**
 由子类实现，由子类决定此方法用途
 */
-(void)callWithParameter:(id)parameter;

/**
 高度计算，由子类完成
 */
+(CGFloat)computeHeight:(id)data;

@end



@interface CKMyGovernorCell :CKMineTableViewCell
{
    UILabel *nameLable;
    UILabel *phoneLable;
    UILabel *contentLable;
}
/** 我的管理者*/
@property (nonatomic, strong) UIView *myGovernorView;

@end

@class CKNewerDLBTestCell;
@protocol CKNewerDLBTestCellDelegate <NSObject>

-(void)beginDLBTest:(CKNewerDLBTestCell*)cell;

@end

//礼包考核
@interface CKNewerDLBTestCell : CKMineTableViewCell

@property (nonatomic, strong) UIImageView *rmksImageView;

@end


@class CKMineSPCell;
@protocol CKMineSPCellDelegate <NSObject>

-(void)applyServiceProvider:(CKMineSPCell*)cell;

@end

//服务商cell  serviceprovider
@interface CKMineSPCell : CKMineTableViewCell

@property (nonatomic, strong) UIImageView *spImageView;

@end



@class CKSchemeToolTableViewCell;

@protocol CKSchemeToolTableViewCellDelegate <NSObject>

@optional
-(void)clickShareCodeWithIndex:(NSInteger)index;

- (void)extendCell:(CKSchemeToolTableViewCell*)extendCell didSelectItem:(NSString*)item;

@end

@interface CKSchemeToolTableViewCell : CKMineTableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mineCollectionView;
@property (nonatomic, strong) NSArray *iconArray;
@property (nonatomic, strong) NSArray *tgTitleArray;
@property (nonatomic, copy)   NSString *typeString;

@end

@class CKUsefulToolTableViewCell;
@protocol CKUsefulToolTableViewCellDelegate <NSObject>

-(void)didSelectedItem:(CKUsefulToolTableViewCell*)cell itemName:(NSString*)itemName;

@end

@interface CKUsefulToolTableViewCell : CKMineTableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mineCollectionView;
@property (nonatomic, copy)   NSString *typeString;
@property (nonatomic, strong) NSArray *iconArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, copy)   NSString *isshowStock;
@property (nonatomic, copy)   NSString *tgidString;

@end
