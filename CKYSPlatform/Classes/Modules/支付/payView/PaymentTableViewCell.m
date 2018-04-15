//
//  PaymentTableViewCell.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/8/14.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "PaymentTableViewCell.h"

@implementation PaymentTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(1);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];


    _leftIamgeView = [[UIImageView alloc] init];
    [bankView addSubview:_leftIamgeView];
    _leftIamgeView.contentMode = UIViewContentModeScaleAspectFit;
    [_leftIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.mas_offset(AdaptedWidth(40));
        make.width.mas_offset(AdaptedWidth(100));
        make.bottom.mas_offset(-AdaptedHeight(15));
    }];
    
    //选择按钮
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_rightButton];
    _rightButton.userInteractionEnabled = NO;

    [_rightButton setImage:[UIImage imageNamed:@"giftwhite"] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"pinkselected"] forState:UIControlStateSelected];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(-AdaptedWidth(30));
        make.width.mas_offset(AdaptedWidth(30));
    }];
}


@end
