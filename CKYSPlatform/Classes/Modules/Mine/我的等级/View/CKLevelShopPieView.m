//
//  CKLevelShopPieView.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKLevelShopPieView.h"
#import "SCChart.h"

@interface CKLevelShopPieView ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *endPercentages;
@property (nonatomic, strong) SCPieChart *chartView;

@end

@implementation CKLevelShopPieView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupShopPie];
    }
    return self;
}

-(void)setupShopPie {
    _items = @[[SCPieChartDataItem dataItemWithValue:0.5 color:[UIColor redColor] description:@"50套"], [SCPieChartDataItem dataItemWithValue:0.5 color:[UIColor yellowColor] description:@"21套"]];
    //    _items = @[[SCPieChartDataItem dataItemWithValue:0.5 color:[UIColor redColor] description:@"50套"]];
    _chartView = [[SCPieChart alloc] initWithFrame:CGRectMake(self.center.x - 50, self.center.y - 50, 100, 100) items:_items];
    //得到的数据最好按照从小到大排列. 如果只有一种也要注意位置。
    [_chartView updateChartByNumbers:@[@"10", @"100"]];
    //    [_chartView updateChartByNumbers:@[@"100"]];
    
    [self addSubview:_chartView];
    
    _endPercentages = [_chartView valueForKeyPath:@"endPercentages"];
    
    NSLog(@"%@", _endPercentages);
    
    for (int i = 0; i < _items.count; i++) {
        [self descriptionLabelForItemAtIndex:i];
    }
    
    
}

- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index{
    if(index == 0){
        return 0;
    }
    
    return [_endPercentages[index - 1] floatValue];
}

- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index{
    return [_endPercentages[index] floatValue];
}

- (void)descriptionLabelForItemAtIndex:(NSUInteger)index{
    CGFloat distance = _chartView.frame.size.width * 0.5;
    CGFloat centerPercentage = ([self startPercentageForItemAtIndex:index] + [self endPercentageForItemAtIndex:index])/ 2;
    CGFloat rad = centerPercentage * 2 * M_PI;
    
    // 1. 初始化 (UIBezierPath) 路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointZero;
    if (index == 0) {
        if (_items.count == 1) {
            startPoint =  CGPointMake(_chartView.frame.origin.x + distance + sqrtf(20) + distance * sin(rad), _chartView.frame.origin.y - distance - sqrtf(20) - distance * cos(rad));
        }else{
            startPoint = CGPointMake(_chartView.frame.origin.x + distance + sqrtf(20) + distance * sin(rad), _chartView.frame.origin.y + distance - sqrtf(20) - distance * cos(rad));
        }
    }else{
        startPoint = CGPointMake(_chartView.frame.origin.x + distance - sqrtf(20) + distance * sin(rad), _chartView.frame.origin.y + distance + sqrtf(20) - distance * cos(rad));
    }
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 5, 5)];
    view.center = startPoint;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 2.5;
    view.layer.borderWidth = 2;
    view.layer.borderColor = [UIColor redColor].CGColor;
    view.backgroundColor = [UIColor redColor];
    [self addSubview:view];
    
    // 2. 添加起点 moveToPoint:(CGPoint)
    [path moveToPoint:startPoint];
    // 3. 添加经过点 addLineToPoint:(CGPoint)
    
    CGPoint movePoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    if (index == 0) {
        movePoint = CGPointMake(startPoint.x + 20, startPoint.y - 20);
        endPoint = CGPointMake(self.frame.size.width - 20, startPoint.y - 20);
    }else{
        movePoint = CGPointMake(startPoint.x - 20, startPoint.y + 20);
        endPoint = CGPointMake(20, startPoint.y + 20);
    }
    
    [path addLineToPoint:movePoint];
    [path addLineToPoint:endPoint];
    
    // 1. 初始化CAShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    // 2. 设置ShapeLayer样式
    shapeLayer.borderWidth = 1; // 线宽
    shapeLayer.strokeColor = [UIColor redColor].CGColor; // 线的颜色
    shapeLayer.fillColor = [UIColor whiteColor].CGColor; // 填充色
    // 3. 给画线的视图添加ShapeLayer
    [self.layer addSublayer:shapeLayer];
    
    // 4. 设置shapeLayer的路径
    shapeLayer.path = path.CGPath;
    
    [self addDesciptionLabel:endPoint index:index];
    
    
    
}

-(void)addDesciptionLabel:(CGPoint)endPoint index:(NSInteger)index{
    CGFloat x = 0;
    CGFloat y = endPoint.y;
    CGFloat w = 100;
    CGFloat h = 20;
    
    NSTextAlignment textAlign = NSTextAlignmentCenter;
    
    if (endPoint.x < self.center.x) {
        x = endPoint.x;
        textAlign = NSTextAlignmentLeft;
    }else{
        x = endPoint.x - w;
        textAlign = NSTextAlignmentRight;
    }
    
    SCPieChartDataItem *currentDataItem = _items[index];
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y - h, w, h)];
    descriptionLabel.textAlignment = textAlign;
    descriptionLabel.font = [UIFont systemFontOfSize:12];
    descriptionLabel.text = currentDataItem.textDescription;
    descriptionLabel.numberOfLines   = 0;
    descriptionLabel.textColor       = [UIColor blackColor];
    [self addSubview:descriptionLabel];
    
    NSArray *typeArr = @[@"非直推", @"直推"];
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    typeLabel.textAlignment = textAlign;
    typeLabel.font = [UIFont systemFontOfSize:12];
    typeLabel.text = typeArr[index];
    typeLabel.numberOfLines   = 0;
    typeLabel.textColor       = [UIColor blackColor];
    [self addSubview:typeLabel];
}


@end
