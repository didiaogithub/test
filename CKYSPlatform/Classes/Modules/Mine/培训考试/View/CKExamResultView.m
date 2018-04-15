//
//  CKExamResultView.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/25.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKExamResultView.h"

@implementation CKExamResultView

- (instancetype)initWithFrame:(CGRect)frame score:(NSString *)score passOrNot:(BOOL)passOrNot {
    if (self = [super initWithFrame:frame]) {
        [self initComponent:score passOrNot:passOrNot];
    }
    return self;
}

- (void)initComponent:(NSString *)score passOrNot:(BOOL)passOrNot {
    self.backgroundColor = [UIColor whiteColor];
    
    NSString *scoreText = [NSString stringWithFormat:@"您的成绩为%@分", score];
    
    UILabel *scoreLabel = [UILabel new];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.font = [UIFont systemFontOfSize:25];
    [self addSubview:scoreLabel];
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.top.mas_offset(100);
    }];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:scoreText];
    NSRange range = NSMakeRange(5, attr.length - 6);
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor tt_redMoneyColor] range:range];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:45] range:range];
    [attr addAttribute:NSObliquenessAttributeName value:@0.3 range:NSMakeRange(0, attr.length)];
    
    
    scoreLabel.attributedText = attr;
    
    //通过笑脸  失败哭脸
    UIImageView *imgV = [UIImageView new];
    if (passOrNot) {
        imgV.image = [UIImage imageNamed:@"smileFace"];
    }else{
        imgV.image = [UIImage imageNamed:@"cryFace"];
    }
    [self addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(scoreLabel.mas_bottom).offset(100);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(100);
    }];
    
    UILabel *resultComment = [UILabel new];
    if (passOrNot) {
        resultComment.text = @"恭喜您顺利通过本轮考核";
    }else{
        resultComment.text = @"很遗憾，您没有通过本轮考试，望继续努力！";
    }
    resultComment.numberOfLines = 0;
    resultComment.textAlignment = NSTextAlignmentCenter;
    resultComment.font = [UIFont systemFontOfSize:25];
    [self addSubview:resultComment];
    [resultComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(30);
        make.right.mas_offset(-30);
        make.top.equalTo(scoreLabel.mas_bottom).offset(100);
        make.height.mas_equalTo(100);
    }];
    
    
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.backgroundColor = [UIColor tt_redMoneyColor];
    [backBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.layer.cornerRadius = 22.0;
    backBtn.layer.masksToBounds = YES;
    [backBtn addTarget:self action:@selector(exitExam) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resultComment.mas_bottom).offset(100);
        make.height.mas_equalTo(44);
        make.left.mas_offset(50);
        make.right.mas_offset(-50);
    }];
}

- (void)exitExam {
    if (self.delegate && [self.delegate respondsToSelector:@selector(exitExam:)]) {
        [self.delegate exitExam:self];
    }
}

@end
