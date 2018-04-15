//
//  TopTipView.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/12/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "TopTipView.h"

@interface TopTipView()

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation TopTipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    self.backgroundColor = [UIColor colorWithHexString:@"#FDEDE5"];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"tipBall"];
    [self addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.top.mas_offset(8);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(26);
    }];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"tipClose"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeTip:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-3);
        make.top.mas_offset(4.5);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    
    _tipLabel = [UILabel configureLabelWithTextColor:[UIColor tt_bigRedBgColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    _tipLabel.text = @"";
    _tipLabel.numberOfLines = 0;
    [self addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgV.mas_right).offset(5);
        make.top.mas_offset(5);
        make.right.equalTo(_closeBtn.mas_left).offset(-10);
        make.bottom.mas_offset(-5);
    }];
}

-(void)closeTip:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(topTipView:closeTip:)]) {
        [self.delegate topTipView:self closeTip:btn];
    }
}

@end
