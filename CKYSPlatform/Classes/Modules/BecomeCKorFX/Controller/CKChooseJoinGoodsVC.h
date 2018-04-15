//
//  CKChooseJoinGoodsVC.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/18.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ChangeDLBBlock)(NSMutableArray* dataArray, NSString* totalMoney, NSString* itemid, NSString* goodsName);

@interface CKChooseJoinGoodsVC : BaseViewController
/**
 创客id
 */
@property (nonatomic, copy) NSString *ckid;
/**
 大礼包订单信息
 */
@property (nonatomic, strong) NSArray *orderinfoArray;
/**
 是否显示所有类型大礼包
 */
@property (nonatomic, copy) NSString *showAllTypeDLB;

@property (nonatomic, copy) NSString *fromVC;

@property (nonatomic, copy) ChangeDLBBlock changeGoodsBlock;

-(void)changeGoods:(ChangeDLBBlock)changeGoodsBlock;

@end
