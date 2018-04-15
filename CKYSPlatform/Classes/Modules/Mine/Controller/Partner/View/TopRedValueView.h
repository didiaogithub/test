//
//  TopRedValueView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/6.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopRedValueView : UIView


/**
 文字
 */
@property(nonatomic,strong)UILabel *topTextLable;
/**
 红色总值
 */
@property(nonatomic,strong)UILabel *topValueLable;
-(instancetype)initWithFrame:(CGRect)frame andTitleStr:(NSString *)title;
@end
