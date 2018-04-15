//
//  OrderBottomView.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/8/10.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderBottomViewDelegate <NSObject>

-(void)bottomViewButtonClicked:(UIButton *)button;

@end

@interface OrderBottomView : UIView

@property(nonatomic,weak)id<OrderBottomViewDelegate>delegate;
@property(nonatomic,strong)UIButton *allSelectedButton;
/**总计*/
@property(nonatomic,strong)UILabel *realPayMoneyLable;
@property(nonatomic,strong)UIButton *nowGoToBuyButton;
@end
