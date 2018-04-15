//
//  CKCollegeCell.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/3.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKCollegeCell.h"

@interface CKCollegeCell()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *seeView;
@property (nonatomic, strong) UILabel *viewed;
@property (nonatomic, strong) UILabel *detail;

@end

@implementation CKCollegeCell

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    self.backgroundColor = [UIColor redColor];
    
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor greenColor];
    [self addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageNamed:@"waithhomehonour"];
    [_bgView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.bgView);
        make.bottom.mas_equalTo(AdaptedHeight(-50));
    }];
    
    _title = [UILabel new];
    _title.text = @"类人胶原蛋白";
    _title.font = [UIFont systemFontOfSize:13.0f];
    [_bgView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(AdaptedWidth(10));
        make.top.equalTo(_imageView.mas_bottom).offset(AdaptedHeight(5));
        make.height.mas_equalTo(AdaptedHeight(20));
    }];
    
    
    _viewed = [UILabel new];
    _viewed.text = @"1234567";
    _viewed.font = [UIFont systemFontOfSize:11.0f];
    [_bgView addSubview:_viewed];
    [_viewed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(AdaptedWidth(-10));
        make.top.equalTo(_imageView.mas_bottom).offset(AdaptedHeight(5));
        make.height.mas_equalTo(AdaptedHeight(20));
    }];
    
    _seeView = [UIImageView new];
    UIImage *image = [UIImage imageNamed:@"classesee"];
    _seeView.image = image;
    [_bgView addSubview:_seeView];
    [_seeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_viewed.mas_left).offset(AdaptedWidth(-5));
        make.centerY.equalTo(_title.mas_centerY);
        make.size.mas_equalTo(image.size);
    }];
    
    _detail = [UILabel new];
    _detail.text = @"类人胶原蛋白类人胶原蛋白类人胶原蛋白类人胶原蛋白类人胶原蛋白";
    _detail.font = [UIFont systemFontOfSize:12.0f];
    [_bgView addSubview:_detail];
    [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(AdaptedWidth(10));
        make.right.mas_equalTo(AdaptedWidth(-10));
        make.top.equalTo(_title.mas_bottom).offset(AdaptedHeight(5));
        make.bottom.mas_equalTo(AdaptedHeight(-3));
    }];
}

@end
