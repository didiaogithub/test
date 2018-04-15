//
//  SalesBonusViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/6.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SalesBonusViewController.h"
#import "TopRedValueView.h"
#import "CoefficientShowView.h"
#import "SalesBonusView.h"


@interface SalesBonusViewController ()
@property(nonatomic,strong)TopRedValueView *topValueView;
@property(nonatomic,strong)CoefficientShowView *coefficientView;
@property(nonatomic,strong)SalesBonusView *saleBoneusView;
@end

@implementation SalesBonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([self.typeStr isEqualToString:@"0"]){
       self.navigationItem.title = @"普通店铺销售奖励费";
    }else{
       self.navigationItem.title = @"合伙人销售业绩奖励";
    }
    [self createViews];
    
}
#pragma mark-创建视图
-(void)createViews{
    _topValueView = [[TopRedValueView alloc] initWithFrame:CGRectZero andTitleStr:@"普通店铺销售奖励费"];
    [self.view addSubview:_topValueView];
    [_topValueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(100));
    }];
    
    _coefficientView = [[CoefficientShowView alloc] initWithFrame:CGRectZero andType:@"ck"];
    [self.view addSubview:_coefficientView];
    [_coefficientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topValueView.mas_bottom).offset(AdaptedHeight(10));
        make.left.right.equalTo(_topValueView);
        make.height.mas_offset(AdaptedHeight(110));
    }];
    
    _saleBoneusView = [[SalesBonusView alloc] initWithFrame:CGRectZero andTypeStr:@"ck"];
    [self.view addSubview:_saleBoneusView];
    if([self.typeStr isEqualToString:@"0"]){ //普通店铺
        _coefficientView.hidden = NO;
        [_saleBoneusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coefficientView.mas_bottom).offset(AdaptedHeight(10));
            make.left.right.equalTo(_topValueView);
            make.height.mas_offset(AdaptedHeight(130));
        }];
    }else{
        _coefficientView.hidden = YES;
        [_saleBoneusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topValueView.mas_bottom).offset(AdaptedHeight(10));
            make.left.right.equalTo(_topValueView);
            make.height.mas_offset(AdaptedHeight(130));
        }];
    }
    


}

@end
