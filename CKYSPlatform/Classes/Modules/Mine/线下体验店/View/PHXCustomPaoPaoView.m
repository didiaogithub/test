//
//  ZJCustomPaoPaoView.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/10.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "PHXCustomPaoPaoView.h"

@interface PHXCustomPaoPaoView ()


@end


@implementation PHXCustomPaoPaoView

-(instancetype)initWithFrame:(CGRect)frame onClick:(OnClickHandle)clickBlock{
    self = [super initWithFrame:frame];
    if (self) {
        self.clickhandle = clickBlock;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowOpacity = 0.7;
        [self initMyPaoPaoViewUIWithFrame:frame];
        
    }
    return self;
}

#pragma mark -自定义视图中的控件
-(void)initMyPaoPaoViewUIWithFrame:(CGRect)frame{
    CGFloat ViewW = frame.size.width;
    CGFloat LabelW = ViewW - 45;
    self.backImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ViewW, frame.size.height-5)];
    self.backImageView1.image = [UIImage imageNamed:@"popup"];
    [self addSubview:self.backImageView1];
    
    //店铺名称
    self.shopNameLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, LabelW, 20)];
    self.shopNameLable.textColor = TitleColor;
    self.shopNameLable.font = MAIN_TITLE_FONT;
    self.shopNameLable.backgroundColor = [UIColor clearColor];
    [self addSubview:self.shopNameLable];
    
    
    //按钮单击事件
    self.shopCerButton = [[UIButton alloc]initWithFrame:CGRectMake(LabelW+13,self.shopNameLable.frame.origin.y,20,20)];
    self.shopCerButton.tag = 20000;
    self.shopCerButton.showsTouchWhenHighlighted = NO;
    [self.shopCerButton addTarget:self action:@selector(clickPaoPaoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.shopCerButton setImage:[UIImage imageNamed:@"expcer"] forState:UIControlStateNormal];
    [self addSubview:self.shopCerButton];
    
    
    
    //电话按钮单击事件
    self.shopPhoneButton = [[UIButton alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.shopNameLable.frame)+5,20,20)];
    self.shopPhoneButton.tag = 20001;
    self.shopPhoneButton.showsTouchWhenHighlighted = NO;
    [self.shopPhoneButton addTarget:self action:@selector(clickPaoPaoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.shopPhoneButton setBackgroundImage:[UIImage imageNamed:@"打电话"] forState:UIControlStateNormal];
    [self addSubview:self.shopPhoneButton];

    //电话
    self.phoneLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.shopPhoneButton.frame)+5,CGRectGetMaxY(self.shopNameLable.frame)+5, LabelW,20)];
    self.phoneLable.textColor = TitleColor;
    self.phoneLable.font = MAIN_TITLE_FONT;
    self.phoneLable.backgroundColor = [UIColor clearColor];
    [self addSubview:self.phoneLable];

}

-(void)setCustomAnno:(MyAnnotation *)customAnno{
    _customAnno = customAnno;
    self.shopNameLable.text = customAnno.expname;
    self.phoneLable.text = customAnno.exptel;
}
#pragma mark -导航按钮的触发事件
-(void)clickPaoPaoButton:(UIButton*)sender{
    //TODO:开始设置代理或者是block回执
    NSInteger buttonTag = sender.tag - 20000;
    NSLog(@"函数回调开始");
    if (self.clickhandle) {
       self.clickhandle(buttonTag);
    }
}

@end
