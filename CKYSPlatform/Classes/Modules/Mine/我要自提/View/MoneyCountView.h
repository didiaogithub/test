//
//  MoneyCountView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/17.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MoneyCountViewDelegate <NSObject>
-(void)moneyCountViewButtonClicked;

@end
@interface MoneyCountView : UIView
@property(nonatomic,weak)id<MoneyCountViewDelegate>delegate;
@property(nonatomic,strong)UILabel *allMoneyLable;
@property(nonatomic,strong)UIButton *nowToBuyButton;
@end
