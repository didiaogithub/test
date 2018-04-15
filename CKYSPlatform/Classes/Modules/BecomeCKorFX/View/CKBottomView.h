//
//  CKBottomView.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CKBottomViewDelegate <NSObject>

-(void)bottomViewClickWithIndex:(NSInteger)index;

@end

@interface CKBottomView : UIView

@property (nonatomic, weak)   id<CKBottomViewDelegate>delegate;
@property (nonatomic, strong) UILabel *moneyLable;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIButton *changeGoodsBtn;

@end
