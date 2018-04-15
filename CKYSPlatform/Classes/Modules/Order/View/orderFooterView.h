//
//  orderFooterView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface orderFooterView : UIView
@property(nonatomic,copy)NSString *statustring;
@property(nonatomic,strong)UILabel *priceLable;

@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)UIImageView *rightImageView;
@property(nonatomic,strong)UILabel *orderTimeLable;
-(instancetype)initWithFrame:(CGRect)frame andType:(NSString *)statusString andTypeStr:(NSString *)typeStr;
@end
