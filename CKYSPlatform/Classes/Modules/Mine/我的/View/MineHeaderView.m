//
//  MineHeaderView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "MineHeaderView.h"
#import "UIButton+XN.h"

@implementation MineHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUIWithType];
    }
    return self;
}

-(void)createUIWithType{
    
    _headImageView = [[UIImageView alloc] init];
    [self addSubview:_headImageView];
    
    NSString *headUrl = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"CKYS_USER_HEAD"]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"name"]];
    
    [_headImageView setImage:[UIImage imageNamed:@"name"]];
    _headImageView.layer.cornerRadius = AdaptedWidth(60)/2;
    _headImageView.clipsToBounds = YES;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(50));
        make.left.mas_offset(AdaptedWidth(15));
        make.width.mas_offset(AdaptedWidth(60));
        make.height.mas_offset(AdaptedWidth(60));
       
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMineInfoButton:)];
    [self addGestureRecognizer:tap];
    
//    _bigButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:_bigButton];
//    _bigButton.tag = 333;
//    [_bigButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
//    [_bigButton addTarget:self action:@selector(clickMineInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    

    _shopNameLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM_BOLD(AdaptedWidth(16))];
    [self addSubview:_shopNameLable];
    
    [_shopNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImageView.mas_centerY).offset(AdaptedHeight(10));
        make.left.equalTo(_headImageView.mas_right).offset(AdaptedWidth(15));
        make.right.mas_offset(-AdaptedWidth(100));
    }];
    
//    _myLevelBtn = [UIButton new];
//    [_myLevelBtn setTitle:@"我的等级" forState:UIControlStateNormal];
//    _myLevelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_myLevelBtn addTarget:self action:@selector(myLevel:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_myLevelBtn];
//    [_myLevelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.headImageView.mas_centerY).offset(AdaptedHeight(10));
//        make.left.equalTo(_shopNameLable.mas_right).offset(AdaptedWidth(15));
//        make.width.mas_equalTo(AdaptedWidth(60));
//    }];

    //升级
    _gradeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_gradeButton];
    _gradeButton.hidden = YES;
    [_gradeButton addTarget:self action:@selector(clickHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
    [_gradeButton setImage:[UIImage imageNamed:@"upgradeToCK"] forState:UIControlStateNormal];
    [_gradeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shopNameLable.mas_bottom).offset(AdaptedHeight(5));
        make.left.equalTo(_shopNameLable.mas_left);
        make.height.mas_offset(AdaptedHeight(30));
        make.width.mas_offset(AdaptedWidth(86));
    }];
    
    //创客类型
    _typeLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_SUBTITLE_FONT];
    _typeLable.backgroundColor = [UIColor whiteColor];
    _typeLable.textColor = [UIColor tt_redMoneyColor];
    _typeLable.layer.cornerRadius = 10.0f;
    _typeLable.layer.masksToBounds = YES;
    [self addSubview:_typeLable];
    [_typeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shopNameLable.mas_bottom).offset(AdaptedHeight(7));
        make.left.equalTo(_shopNameLable.mas_left);
        make.height.mas_offset(AdaptedHeight(20));
        make.width.mas_offset(AdaptedHeight(40));
    }];


    _btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, self.frame.size.height *0.5 - 15, 90, 30)];
    [_btn setTitle:@"个人资料" forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"WhiteRightArrow"] forState:UIControlStateNormal];
    _btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btn addTarget:self action:@selector(clickMineInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    [_btn layoutButtonWithEdgeInsetsStyle:XNButtonEdgeInsetsStyleRight imageTitleSpace:1];
    [self addSubview:_btn];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_btn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _btn.bounds;
    maskLayer.path = path.CGPath;
    _btn.layer.mask = maskLayer;
    _btn.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6].CGColor;
    
   
    
    
    
    
}

//升级按钮
-(void)clickHeaderButton:(UIButton *)button {
    if(self.delegate && [self.delegate respondsToSelector:@selector(fxToCKClick)]){
        [self.delegate fxToCKClick];
    }
}

-(void)clickMineInfoButton:(UIButton *)button {
    if(self.delegate && [self.delegate respondsToSelector:@selector(comeToEditMyInfoWith:)]){
        [self.delegate comeToEditMyInfoWith:button];
    }
}

-(void)myLevel:(UIButton*)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkMyLevel:)]){
        [self.delegate checkMyLevel:sender];
    }
}

@end
