//
//  CKOrderDetailCell.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKOrderDetailCell : UITableViewCell

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


@interface CKLogisticsCell : CKOrderDetailCell

@property (nonatomic, strong) UIImageView *leftImgageView;
@property (nonatomic, strong) UILabel *logistLable;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UIImageView *rightImageView;

@end



@interface CKOrderNameCell : CKOrderDetailCell

@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) UILabel *nickNameLable;

@end


@interface CKOrderGetterCell : CKOrderDetailCell

@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) UILabel *getterLable;
@property (nonatomic, strong) UILabel *telPhoneLable;

@end


@interface CKOrderAddressCell : CKOrderDetailCell

@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) UIImageView *addressImageView;
@property (nonatomic, strong) UILabel *addressDetailLable;

@end



@interface CKOrderChangeAddressCell : CKOrderDetailCell

@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) UIButton *changeAdrrBtn;
@property (nonatomic, copy)   NSString *oidStr;
@property (nonatomic, copy)   NSString *paytime;
@property (nonatomic, copy)   NSString *ordertime;
@property (nonatomic, copy)   NSString *orderStatus;
@property (nonatomic, copy)   NSString *limitTime;
@property (nonatomic, copy)   NSString *systime;
@property (nonatomic, copy)   NSString *orderNo;

@property (nonatomic, copy)   NSString *gettername;
@property (nonatomic, copy)   NSString *gettermobile;
@property (nonatomic, copy)   NSString *homeaddress;
@property (nonatomic, copy)   NSString *address;
@property (nonatomic, copy)   NSString *isNeedRealName;

@end


@interface CKOrderSpaImageCell : CKOrderDetailCell

@property (nonatomic, strong) UIView *bankView;
@property (nonatomic, strong) UIImageView *bottomImageView;

@end



@interface CKGoodDetailCell : CKOrderDetailCell

@end


@interface CKOrderPaymentCell : CKOrderDetailCell

@end

@interface CKOrderInfoCell : CKOrderDetailCell


@end

@class CKOriginalOrderInfoCell;
@protocol CKOriginalOrderInfoCellDelegate <NSObject>

- (void)showOriginalOrderDetail:(CKOriginalOrderInfoCell*)originalOrderInfoCell index:(NSInteger)index;
- (void)closeOriginalOrderDetail:(CKOriginalOrderInfoCell*)originalOrderInfoCell index:(NSInteger)index;

@end

//原订单信息
@interface CKOriginalOrderInfoCell : CKOrderDetailCell

@end

//原订单订单商品信息
@interface CKOriginalOrderGoodsCell : CKOrderDetailCell

@end


@class CKChangeOrderInfoCell;
@protocol CKChangeOrderInfoCellDelegate <NSObject>

- (void)showChangeOrderDetail:(CKChangeOrderInfoCell*)changeOrderInfoCell index:(NSInteger)index;
- (void)closeChangeOrderDetail:(CKChangeOrderInfoCell*)changeOrderInfoCell index:(NSInteger)index;

@end

//换货订单信息
@interface CKChangeOrderInfoCell : CKOrderDetailCell

@end

//换货订单商品信息
@interface CKChangOrderGoodsCell : CKOrderDetailCell

@end
