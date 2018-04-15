//
//  CKProcessView.m
//  process
//
//  Created by ForgetFairy on 2018/1/18.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "CKProcessView.h"

@interface CKProcessView()

@property (nonatomic, assign) CGFloat stepWidth;
@property (nonatomic, copy)   NSString *totalNo;

@property (nonatomic, strong) UIView *aView;
@property (nonatomic, strong) UIView *progress;
@property (nonatomic, strong) UILabel *currentQLabel;
@property (nonatomic, strong) UILabel *totalQLabel;
@property (nonatomic, strong) UILabel *titleL;

@end

@implementation CKProcessView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title totalNo:(NSString*)totalNo {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI:title totalNo:totalNo];
    }
    return self;
}

- (void)initUI:(NSString*)title totalNo:(NSString*)totalNo {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.totalNo = totalNo;
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 20)];
    self.titleL.text = title;
    self.titleL.textColor = [UIColor redColor];
    [self addSubview:self.titleL];
    
    //初始化
    self.aView = [[UIView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(self.titleL.frame)+30, SCREEN_WIDTH-100, 20)];
    self.aView.backgroundColor = [UIColor colorWithRed:0.841 green:0.848 blue:0.773 alpha:1.000];
    
    self.stepWidth = self.aView.frame.size.width / [totalNo integerValue];
    
    self.progress=[[UIView alloc]initWithFrame:CGRectMake(0, 1, self.stepWidth, 18)];
    self.aView.layer.cornerRadius=10;
    self.aView.layer.masksToBounds=YES;
    self.progress.layer.cornerRadius=10;
    self.progress.layer.masksToBounds=YES;
    self.progress.backgroundColor = [UIColor tt_redMoneyColor];
    [self.aView addSubview:self.progress];
    [self addSubview:self.aView];
    
    self.currentQLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleL.frame)+30, 40, 20)];
    self.currentQLabel.textAlignment = NSTextAlignmentRight;
    self.currentQLabel.text = @"1";
    self.currentQLabel.textColor = SubTitleColor;
    [self addSubview:self.currentQLabel];
    
    self.totalQLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, CGRectGetMaxY(self.titleL.frame)+30, 40, 20)];
    self.totalQLabel.text = totalNo;
    self.totalQLabel.textColor = SubTitleColor;
    [self addSubview:self.totalQLabel];
}

#pragma mark - 进度条增加
- (void)progressIncrease {
    
    self.currentQLabel.text = [NSString stringWithFormat:@"%ld", [self.currentQLabel.text integerValue]+1];
    if ([self.currentQLabel.text integerValue] >= [self.totalNo integerValue]) {
        self.currentQLabel.text = self.totalNo;
    }
    
    CGRect changeFrame=self.progress.frame;
    changeFrame.size.width += self.stepWidth;
    if (changeFrame.size.width >= self.aView.frame.size.width) {
        changeFrame.size.width = self.aView.frame.size.width;
    }
    self.progress.frame = changeFrame;
}

#pragma mark - 进度条减少
- (void)progressReduce {
    self.currentQLabel.text = [NSString stringWithFormat:@"%ld", [self.currentQLabel.text integerValue]-1];
    if ([self.currentQLabel.text integerValue] <= 1) {
        self.currentQLabel.text = @"1";
    }
    CGRect changeFrame = self.progress.frame;
    
    changeFrame.size.width -= self.stepWidth;
    
    if (changeFrame.size.width <= self.stepWidth) {
        changeFrame.size.width = self.stepWidth;
    }
    self.progress.frame = changeFrame;
}

@end
