//
//  CKLevelLineView.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKLevelLineView.h"

@implementation CKLevelLineView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupLevelLine];
    }
    return self;
}

-(void)setupLevelLine {
    CAShapeLayer *chartLine = [CAShapeLayer layer];
    chartLine.lineCap = kCALineCapRound;
    chartLine.lineJoin = kCALineJoinBevel;
    chartLine.fillColor   = [[UIColor yellowColor] CGColor];
    chartLine.lineWidth   = 2.0;
    chartLine.strokeEnd   = 0.0;
    [self.layer addSublayer:chartLine];
    
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    [progressline moveToPoint:CGPointMake(0, 200)];
    [progressline setLineWidth:2.0];
    [progressline setLineCapStyle:kCGLineCapRound];
    [progressline setLineJoinStyle:kCGLineJoinRound];
    
    NSArray *array = @[@"JC1",@"JC2",@"JC3", @"LX1",@"LX2", @"LX3", @"HH1", @"HH2", @"HH3",@"JC1",@"JC2",@"JC3", @"LX1",@"LX2", @"LX3", @"HH1", @"HH2", @"HH3"];
//    NSArray *arrX = @[@"30", @"60", @"90", @"120", @"180", @"210", @"240", @"30", @"60", @"90", @"120", @"180", @"210", @"240"];
    NSArray *arrY = @[@"200",@"180", @"160", @"140", @"160", @"120", @"100",@"200",@"180", @"160", @"140", @"160", @"120", @"100"];
    
    CGFloat f = SCREEN_WIDTH / arrY.count;
    
    for (NSInteger i = 0; i < arrY.count; i++) {
        CGPoint point = CGPointMake(i * f + 30, [arrY[i] floatValue]);
        
        BOOL currentL = YES;
        if (i == arrY.count - 1) {
            currentL = YES;
            point = CGPointMake(i * f - sqrtf(18), [arrY[i] floatValue] + sqrtf(18));
        }else{
            currentL = NO;
        }
        
        [progressline addLineToPoint:point];
        [progressline moveToPoint:point];
        
        [self addPoint:point
                 index:i
                isShow:currentL
                 value:array[i]];
    }
    
    
    chartLine.path = progressline.CGPath;
    
    chartLine.strokeColor = [UIColor redColor].CGColor;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    chartLine.strokeEnd = 1.0;
    
    self.select = YES;
}

-(void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isShow value:(NSString*)value {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 8, 8)];
        view.center = point;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 4;
        view.layer.borderWidth = 2;
        view.layer.borderColor = [UIColor redColor].CGColor;
        view.backgroundColor = [UIColor redColor];
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkLevel:)];
        [view addGestureRecognizer:tap];

        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-80/2.0, point.y-10*2, 80, 10)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.text = value;
        
        if (isShow) {
            UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 18, 18)];
            view1.center = point;
            view1.layer.masksToBounds = YES;
            view1.layer.cornerRadius = 9;
            view1.layer.borderWidth = 2;
            view1.layer.borderColor = [UIColor redColor].CGColor;
            [self addSubview:view1];
            view1.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkLevel:)];
            [view1 addGestureRecognizer:tap];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 12, 12)];
            view.center = point;
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 6;
            view.layer.borderWidth = 2;
            view.layer.borderColor = [UIColor whiteColor].CGColor;
            [self addSubview:view];
            label.frame = CGRectMake(point.x-80/2.0, point.y-10*2 - 10, 80, 10);
        }
        
        [self addSubview:label];
        [self addSubview:view];
}

-(void)checkLevel:(UITapGestureRecognizer*)tap {
    UIView *view = [tap view];
    NSLog(@"%@", view);
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLevelPoint:)]) {
//        [self.delegate clickLevelPoint:view.tag];
//    }
    
    NSDictionary *dic;
    
//    self.select = !self.select;
//    if (self.select) {//降级
        dic = @{@"type":@"downgrade"};
//    }else{//升级
//        dic = @{@"type":@"upgrade"};
//
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickLevelPointNotification" object:dic];
}

@end
