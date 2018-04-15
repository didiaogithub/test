//
//  CoefficientShowView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/6.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CoefficientShowView.h"
#import "CoefficientAlertview.h"
@interface CoefficientShowView()
@property(nonatomic,strong)CoefficientAlertview *codefficientAlertView;
@end
@implementation CoefficientShowView
-(instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type{
    if (self = [super initWithFrame:frame]) {
        [self createUIWithType:type];
    }
    return self;
}
-(void)createUIWithType:(NSString *)type{
    [self setBackgroundColor:[UIColor whiteColor]];
    //本月团队奖励系数
    _codeText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_NAMETITLE_FONT];
    [self addSubview:_codeText];
    
    //系数说明图
    _coefficientImageView = [[UIImageView alloc] init];
    [self addSubview:_coefficientImageView];
    _coefficientImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_coefficientImageView setImage:[UIImage imageNamed:@"monthcoefficient0"]];
    
    //具体奖励系数请查看
    UILabel *leftCoefficientLable = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentRight font:MAIN_NAMETITLE_FONT];
    [self addSubview:leftCoefficientLable];
    leftCoefficientLable.text = @"具体奖励系数请查看";
    
    //系数说明
    _coefficientButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_coefficientButton];
    _coefficientButton.tag = 1210;
    _coefficientButton.titleLabel.font = MAIN_NAMETITLE_FONT;
    [_coefficientButton setTitleColor:[UIColor tt_blueColor] forState:UIControlStateNormal];
    
    if ([type isEqualToString:@"ck"]){
        _codeText.text = @"本月产品销售奖励系数";
        [_coefficientButton setTitle:@"《产品销售奖励系数说明》" forState:UIControlStateNormal];
    }else{
        _codeText.text = @"创客礼包推广奖励系数";
        [_coefficientButton setTitle:@"《创客礼包推广奖励系数说明》" forState:UIControlStateNormal];
    
    }
    
    float width = 0;
    if (iphone5){
        width = SCREEN_WIDTH/2-10;
    }else{
        width = SCREEN_WIDTH/2-20;
    }
    
    //系数值下面的文字
    [_codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(30));
        make.left.mas_offset(AdaptedWidth(10));
        make.height.mas_offset(AdaptedHeight(15));
        make.width.mas_offset(width);
    }];
    
    [_coefficientImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_offset(AdaptedHeight(15));
        make.left.equalTo(_codeText.mas_right).offset(AdaptedWidth(5));
        make.right.mas_offset(-AdaptedWidth(10));
        make.height.mas_offset(AdaptedHeight(30));
    }];
    
    [leftCoefficientLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeText.mas_bottom).offset(AdaptedHeight(39/2));
        make.left.mas_offset(0);
        make.right.mas_offset(-SCREEN_WIDTH/2);
        make.height.mas_offset(AdaptedHeight(15));
        make.bottom.mas_offset(-AdaptedHeight(20));
    }];
    
    //查看系数说明
    [_coefficientButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(leftCoefficientLable);
        make.left.equalTo(leftCoefficientLable.mas_right);
    }];
    [_coefficientButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
}

/**点击查看系数说明*/
-(void)clickButton:(UIButton *)button{
    _codefficientAlertView = [[CoefficientAlertview alloc]init];
    [_codefficientAlertView show];
    
}

@end
