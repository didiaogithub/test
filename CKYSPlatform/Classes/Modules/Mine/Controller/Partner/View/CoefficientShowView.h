//
//  CoefficientShowView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/6.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoefficientShowView : UIView
@property(nonatomic,strong)UILabel *codeText;
@property(nonatomic,strong)UIImageView *coefficientImageView;
@property(nonatomic,strong)UIButton *coefficientButton;
-(instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type;

@end
