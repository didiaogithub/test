//
//  XWAlterVeiw.h
//  XWAleratView
//
//  Created by 温仲斌 on 15/12/25.
//  Copyright © 2015年 温仲斌. All rights reserved.
//

#import <UIKit/UIKit.h>
//产品销售系数弹框
@interface CoefficientAlertview : UIView
@property (nonatomic, strong) UIView *bankGroundView;
@property(nonatomic,strong)UILabel *titleLable;
@property (nonatomic, strong)UILabel *contentLable;
@property (nonatomic, strong)UILabel *lastLable;
@property(nonatomic,strong)UIButton *deleteButton;
- (void)show;
@end
