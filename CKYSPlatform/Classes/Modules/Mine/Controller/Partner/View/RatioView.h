//
//  RatioView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCChart.h"

@interface RatioView : UIView

@property(nonatomic,strong)SCPieChart *chartView;
/*1**/
@property(nonatomic,strong)UILabel *firstLable;
/*2**/
@property(nonatomic,strong)UILabel *secondLable;
/*3**/
@property(nonatomic,strong)UILabel *threenLable;

/*1值**/
@property(nonatomic,strong)UILabel *firstVlaueLable;
/*2值**/
@property(nonatomic,strong)UILabel *secondVlaueLable;
/*3值**/
@property(nonatomic,strong)UILabel *threenValueLable;

-(instancetype)initWithFrame:(CGRect)frame andTypeStr:(NSString *)userType;

@end
