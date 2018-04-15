//
//  CardView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/30.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "CardView.h"
@interface CardView ()
{
    UIImage *imageHand;
}

@end
@implementation CardView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{

    [self setBackgroundColor:[UIColor whiteColor]];

    imageHand = [UIImage imageNamed:@"addcerphoto"];
    _bankGroundScrollview = [[UIScrollView alloc] init];
    [self addSubview:_bankGroundScrollview];
    _bankGroundScrollview.scrollEnabled = YES;
    _bankGroundScrollview.bounces = NO;
    _bankGroundScrollview.showsHorizontalScrollIndicator = NO;
    _bankGroundScrollview.showsVerticalScrollIndicator = NO;
    [_bankGroundScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.bottom.mas_offset(-10);
    }];
    
    UIView *bankView = [[UIView alloc] init];
    [_bankGroundScrollview addSubview:bankView];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.width.equalTo(_bankGroundScrollview.mas_width);
        make.height.equalTo(_bankGroundScrollview.mas_height);
    }];
    
    //左侧
     float buttonWidth = (SCREEN_WIDTH - 90)/2;
    
    //左侧最底的+号图
    UIImageView *leftHandImageView = [[UIImageView alloc] init];
    [bankView addSubview:leftHandImageView];
    [leftHandImageView setImage:imageHand];
    [leftHandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(20);
        make.size.mas_offset(CGSizeMake(buttonWidth, buttonWidth));
    }];
    
    //手持身份证照
    _handCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_handCardButton];
    _handCardButton.tag = 120;
    
    [_handCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(20);
        make.size.mas_offset(CGSizeMake(buttonWidth, buttonWidth));
    }];
    [_handCardButton addTarget:self action:@selector(clickCardButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //手持身份证照 示范照片
    UIImageView *handImageView = [[UIImageView alloc] init];
    [bankView addSubview:handImageView];
    handImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *handImages = [UIImage imageNamed:@"手持身份证"];
    [handImageView setImage:handImages];
    
    [handImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_handCardButton.mas_top);
        make.right.mas_offset(-20);
        make.size.mas_offset(CGSizeMake(buttonWidth, buttonWidth+20));
        
    }];
    
    UILabel *handLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:MAIN_SUBTITLE_FONT];
    [bankView addSubview:handLable];
    handLable.text = @"手持身份证照";
    [handLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_handCardButton.mas_bottom).offset(7);
        make.left.equalTo(_handCardButton.mas_left);
        make.width.equalTo(_handCardButton.mas_width);
        make.height.mas_offset(13);
    }];
    
    
    
    
    //左侧最底的+号图
    UIImageView *leftRightImageView = [[UIImageView alloc] init];
    [bankView addSubview:leftRightImageView];
    [leftRightImageView setImage:imageHand];
    [leftRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(handLable.mas_bottom).offset(10);
        make.left.equalTo(_handCardButton.mas_left);
        make.width.and.height.mas_equalTo(leftHandImageView);
    }];
    
    
    
    //身份证正面照
    _rightCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_rightCardButton];

    [_rightCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(handLable.mas_bottom).offset(10);
        make.left.equalTo(_handCardButton.mas_left);
        make.width.and.height.mas_equalTo(_handCardButton);
    }];
    _rightCardButton.tag = 121;
    [_rightCardButton addTarget:self action:@selector(clickCardButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    [bankView addSubview:rightImageView];
    UIImage *rightImage = [UIImage imageNamed:@"身份证2"];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightImageView setImage:rightImage];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightCardButton.mas_top);
        make.right.equalTo(handImageView.mas_right);
        make.width.and.height.mas_equalTo(handImageView);
    }];
    UILabel *rightLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:MAIN_SUBTITLE_FONT];
    [bankView addSubview:rightLable];
    rightLable.text = @"身份证正面照";
    [rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightCardButton.mas_bottom).offset(7);
        make.left.equalTo(_rightCardButton.mas_left);
        make.width.and.height.mas_equalTo(handLable);
    }];
    
    
    //左侧最底的+号图
    UIImageView *leftBankImageView = [[UIImageView alloc] init];
    [bankView addSubview:leftBankImageView];
    [leftBankImageView setImage:imageHand];
    [leftBankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightLable.mas_bottom).offset(10);
        make.left.equalTo(_rightCardButton.mas_left);
        make.width.and.height.mas_equalTo(leftRightImageView);
    }];


    //身份证反面照
    _backCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_backCardButton];
    [_backCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightLable.mas_bottom).offset(10);
        make.left.equalTo(_rightCardButton.mas_left);
        make.width.and.height.mas_equalTo(_rightCardButton);
    }];
    _backCardButton.tag = 122;
    [_backCardButton addTarget:self action:@selector(clickCardButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    [bankView addSubview:backImageView];
    UIImage *backImage = [UIImage imageNamed:@"身份证3"];
    backImageView.contentMode = UIViewContentModeScaleAspectFit;
    [backImageView setImage:backImage];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backCardButton.mas_top);
        make.right.equalTo(rightImageView.mas_right);
        make.width.and.height.mas_equalTo(rightImageView);
    }];
    
    UILabel *backLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:MAIN_SUBTITLE_FONT];
    [bankView addSubview:backLable];
    backLable.text = @"身份证反面照";
    [backLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backCardButton.mas_bottom).offset(7);
        make.left.equalTo(_backCardButton.mas_left);
        make.width.and.height.mas_equalTo(rightLable);
    }];
    
    _bankGroundScrollview.contentSize = CGSizeMake(0, buttonWidth*3+120);

}
#pragma mark-点击上传身份证照片 
-(void)clickCardButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addCardPhotoWithButtonTag:)]) {
        [self.delegate addCardPhotoWithButtonTag:button.tag];
    }

}

@end
