//
//  WxuserView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/5/12.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "WxuserView.h"

@implementation WxuserView

-(instancetype)initWithFrame:(CGRect)frame andTypeStr:(NSString *)typeStr{
    if (self = [super initWithFrame:frame]) {
        
        [self createUIWithType:typeStr];
    }
    return self;
}
-(void)createUIWithType:(NSString *)type{
    
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
    
    _orderTimeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_NAMETITLE_FONT];
    [bankView addSubview:_orderTimeLable];
    
    if([type isEqualToString:@"CK"]){
        [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedHeight(5));
            make.right.mas_offset(-AdaptedWidth(10));
            make.left.mas_offset(AdaptedWidth(10));
        }];
        [_orderTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_priceLable.mas_bottom).offset(topH);
            make.right.left.equalTo(_priceLable);
            make.bottom.mas_offset(-AdaptedHeight(10));
        }];
    }else{
        [_orderTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedHeight(10));
            make.left.mas_offset(0);
            make.right.mas_offset(-AdaptedWidth(10));
            make.bottom.mas_offset(-AdaptedHeight(10));
        }];
    }
    
}
@end
