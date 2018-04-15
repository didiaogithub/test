//
//  RouteView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "RouteView.h"

@implementation RouteView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.addressLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(20))];
    [self addSubview:self.addressLable];
    [self.addressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.left.mas_offset(10);
        make.right.mas_offset(-65);
        
    }];

    self.detailAddressLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [self addSubview:self.detailAddressLable];
    
    [self.detailAddressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressLable.mas_bottom);
        make.left.equalTo(_addressLable.mas_left);
        make.right.equalTo(_addressLable.mas_right);
        make.bottom.mas_offset(-20);
    }];
    
    
    self.routeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.routeButton];
    [self.routeButton setImage:[UIImage imageNamed:@"expnav"] forState:UIControlStateNormal];
    self.routeButton.backgroundColor = [UIColor tt_greenColor];
    self.routeButton.layer.cornerRadius = 25;
    self.routeButton.clipsToBounds = YES;
    [self.routeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.right.mas_offset(-10);
        make.width.mas_offset(50);
        make.height.mas_offset(50);
    }];
    [self.routeButton addTarget:self action:@selector(clickRouteButton:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)clickRouteButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(nowToCheckRoute)]) {
        [self.delegate nowToCheckRoute];
    }
}

@end
