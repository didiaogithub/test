//
//  XWAlterVeiw.h
//  XWAleratView
//
//  Created by 庞宏侠. on 15/12/25.
//  Copyright © 2015年 庞宏侠. All rights reserved.
//

#import <UIKit/UIKit.h>
//店铺关闭


@interface CloseShopAlter : UIView
@property (nonatomic, strong) UIView *bigView;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UIButton *sureBut;

/**
 *  提供单利初始化方法
 */
+ (instancetype)shareInstance;
- (void)showCloseShopAlert:(NSString *)title;

@end
