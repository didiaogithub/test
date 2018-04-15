//
//  XWAlterVeiw.h
//  XWAleratView
//
//  Created by 庞宏侠. on 15/12/25.
//  Copyright © 2015年 庞宏侠. All rights reserved.
//

#import <UIKit/UIKit.h>
//防止多台设备登录 弹窗


@interface MultipleDevicesAlter : UIView
@property (nonatomic, strong) UIView *bigView;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UIButton *sureBut;

/**
 *  提供单利初始化方法
 */
+ (instancetype)shareInstance;
- (void)showAlert:(NSString *)title;

@end
