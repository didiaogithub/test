//
//  HeaderView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/10.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView
@property(nonatomic,strong) UIImageView *leftImageView;
@property(nonatomic,strong)UILabel *personCountLable;
@property(nonatomic,strong)UILabel *textLable;

/**第二个view的文字*/
@property(nonatomic,strong)UILabel *firstLable;
@property(nonatomic,strong)UILabel *secondLable;
@property(nonatomic,strong)UILabel *threenLable;
@property(nonatomic,strong)UILabel *fourLable;
@end
