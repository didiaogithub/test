//
//  CKMainPageCell.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKMainPageCell : UITableViewCell

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


/**
 轮播
 */
@interface CKBannerCell : CKMainPageCell

@property (nonatomic, strong) NSMutableArray *bannerArray;

@end


/**
 创客云商特点
 */
@interface CKFeaturesCell : CKMainPageCell
/**图标*/
@property (nonatomic, strong) UIImageView *featuresImageView;
/**特点文字*/
@property (nonatomic, strong) UILabel *fratureLable;

@end


/**
 开店
 */
@protocol OpenShopDelegate <NSObject>

-(void)clickOpenShop;

@end

@interface CKOpenShopCell : CKMainPageCell

//@property (nonatomic, strong) UIImageView *ckImageView;
//
//@property (nonatomic, strong) UILabel *countLable;

@property (nonatomic, strong) UIButton *openShopButton;

@end


/**
 媒体报道
 */
@interface CKNewsCell : CKMainPageCell

@end

/**
 创客村头条
 */
@interface CKTopNewsCell : CKMainPageCell

@end


/**
 标题
 */
@interface CKHeaderTitleCell : CKMainPageCell

@end


/**
 资质荣誉
 */
@interface CKMPHonorCell : CKMainPageCell

@end


/**
 已经加入的创客
 */
@interface CKAllJoinCell : CKMainPageCell

@end


/**
 主要功能模块
 */
@protocol CKMainModuleDelegate <NSObject>

-(void)dealModuleWithTag:(NSInteger)currentTag andButton:(UIButton *)button;
-(void)seeSaleDeatilWithTag:(NSInteger)currentTag andButton:(UIButton *)button;

@end

@interface CKMainModuleCell : CKMainPageCell

@end

