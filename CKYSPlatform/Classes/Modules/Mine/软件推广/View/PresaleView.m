//
//  PresaleView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/10.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "PresaleView.h"

@implementation PresaleView
-(instancetype)initWithFrame:(CGRect)frame andSection:(NSInteger)section{
    if (self = [super initWithFrame:frame]) {
        [self createUIWithSection:section];
    }
    return self;
}
-(void)createUIWithSection:(NSInteger)section{
    [self setBackgroundColor:[UIColor tt_grayBgColor]];

    UIView *bankView = [[UIView alloc] init];
    [self addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(5));
        make.bottom.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
    }];
    
    _leftImageView = [[UIImageView alloc] init];
    [bankView addSubview:_leftImageView];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_leftImageView setImage:[UIImage imageNamed:@"presale"]];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.left.mas_offset(AdaptedWidth(10));
        make.width.mas_offset(AdaptedWidth(16));
        make.height.mas_offset(AdaptedHeight(16));
    }];
    
    //名称
    _presaleShopNameLable =  [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_presaleShopNameLable];

    [_presaleShopNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftImageView.mas_top);
        make.left.equalTo(_leftImageView.mas_right).offset(AdaptedWidth(10));
    }];
    
    //倒计时图标
    _countdownImageView = [[UIImageView alloc] init];
    [bankView addSubview:_countdownImageView];
    [_countdownImageView setImage:[UIImage imageNamed:@"pretime"]];
    _countdownImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_countdownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_presaleShopNameLable.mas_top);
        make.left.equalTo(_presaleShopNameLable.mas_right).offset(AdaptedWidth(10));
        make.width.mas_offset(AdaptedWidth(16));
        make.height.mas_offset(AdaptedHeight(16));
        
    }];
    _countdownImageView.hidden = YES;
    
    //倒计时多少天
    _remainingLable =  [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_remainingLable];
    [_remainingLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_countdownImageView.mas_top);
        make.left.equalTo(_countdownImageView.mas_right).offset(AdaptedWidth(5));
    }];
    _remainingLable.hidden = YES;
    
    
    //比率
    _ratioLable =  [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_ratioLable];
    _ratioLable.text = @"0/10";
    [_ratioLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_presaleShopNameLable.mas_top);
        make.right.mas_offset(-10);
    }];
    

   
    
    
    //时间
    _timeLable =  [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_timeLable];
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_presaleShopNameLable.mas_bottom).offset(AdaptedHeight(AdaptedHeight(8)));
        make.left.equalTo(_presaleShopNameLable.mas_left);
        make.right.mas_offset(-AdaptedWidth(10));
        make.bottom.mas_offset(-AdaptedHeight(15));
    }];


    _headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_headerButton];
    _headerButton.tag = section;
    NSLog(@"_headerButtontag %ld",_headerButton.tag);
    [_headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    [_headerButton addTarget:self action:@selector(clickHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
//    
    _returnView = [[UIView alloc] init];
    [bankView addSubview:_returnView];
    _returnView.backgroundColor = [UIColor blackColor];
    _returnView.alpha = 0.5;
    [_returnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bankView);

    }];
    _returnView.hidden = YES;
    
    _recyclingImageView = [[UIImageView alloc] init];
    [bankView addSubview:_recyclingImageView];
    _recyclingImageView.contentMode = UIViewContentModeScaleAspectFit;
     [_recyclingImageView setImage:[UIImage imageNamed:@"returnback"]];
    [_recyclingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(SCREEN_WIDTH/3);
        make.width.mas_offset(SCREEN_WIDTH/3);
    }];
    _recyclingImageView.hidden = YES;
}

-(void)clickHeaderButton:(UIButton *)button{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickPresaleButton:)]){
        [self.delegate clickPresaleButton:button];
    }

}
@end
