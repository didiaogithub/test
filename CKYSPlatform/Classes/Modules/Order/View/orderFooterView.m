//
//  orderFooterView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "orderFooterView.h"

@implementation orderFooterView
-(instancetype)initWithFrame:(CGRect)frame andType:(NSString *)statusString andTypeStr:(NSString *)typeStr{
    if (self = [super initWithFrame:frame]) {
        _statustring = statusString;
        [self createUIWithStatus:statusString andStr:typeStr];
    }
    return self;
}
-(void)createUIWithStatus:(NSString *)statustr andStr:(NSString *)typeStr{
    
    [self setBackgroundColor:[UIColor tt_grayBgColor]];
    UIView *bankView = [[UIView alloc] init];
    [self addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.bottom.mas_offset(-AdaptedHeight(5));
    }];
    
    float topH = 0;
    UIFont *priceFont = nil;
    if (iphone4) {
        priceFont = CHINESE_SYSTEM(11);
        topH = AdaptedHeight(3);
    }else if (iphone5){
        priceFont = CHINESE_SYSTEM(14);
        topH = AdaptedHeight(5);
    }else{
        priceFont = CHINESE_SYSTEM(15);
        topH = AdaptedHeight(9);
    }

   //商品数量  商品总价  运费
    _priceLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:priceFont];
    [bankView addSubview:_priceLable];
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(topH);
        make.right.mas_offset(-AdaptedWidth(10));
        make.left.mas_offset(AdaptedWidth(10));
        
    }];
    
    _orderTimeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_NAMETITLE_FONT];
    [bankView addSubview:_orderTimeLable];
    [_orderTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLable.mas_bottom).offset(topH);
        make.right.left.equalTo(_priceLable);
    }];
    
    
    //中间的线
    UILabel *midlleLine = [UILabel creatLineLable];
    [bankView addSubview:midlleLine];
    [midlleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderTimeLable.mas_bottom).offset(topH);
        make.left.right.mas_offset(0);
        make.height.mas_offset(0.5);
    }];
   
//    86  25
    //右按钮
    _rightImageView = [[UIImageView alloc] init];
    [bankView addSubview:_rightImageView];
    [_rightImageView setImage:[UIImage imageNamed:@"orderbordergrey"]];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midlleLine.mas_bottom).offset(AdaptedHeight(10));
        make.right.mas_offset(-AdaptedWidth(10));
        make.bottom.mas_offset(-AdaptedHeight(10));
        make.height.mas_offset(AdaptedHeight(25));
        make.width.mas_offset(AdaptedWidth(90));
    }];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_rightButton];
    _rightButton.titleLabel.font = MAIN_NAMETITLE_FONT;
    [_rightButton setTitleColor:TitleColor forState:UIControlStateNormal];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_rightImageView);
    }];
    
    //    订单状态（99：全部0：已取消 1：未付款；2：已付款，3：已收货；，6：已完成，7：已发货 ） 3456有删除按钮
    if ([statustr isEqualToString:@"3"]||[statustr isEqualToString:@"6"] || [statustr isEqualToString:@"4"] || [statustr isEqualToString:@"5"]) {//
            [_rightImageView setImage:[UIImage imageNamed:@"orderbordergrey"]];
            [_rightButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [_rightButton setTitleColor:TitleColor forState:UIControlStateNormal];
    }else{// 0127
        if([statustr isEqualToString:@"1"]){ //未付款

            [_rightImageView setImage:[UIImage imageNamed:@"orderpay"]];
            [_rightButton setTitle:@"立即支付" forState:UIControlStateNormal];
            [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if ([statustr isEqualToString:@"7"]){//查看物流
                //删除订单
            [_rightButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [_rightButton setTitleColor:TitleColor forState:UIControlStateNormal];

        }else{ //已取消和已付款
            _rightImageView.hidden = YES;
            _rightButton.hidden = YES;
            
        }

    }

}



@end
