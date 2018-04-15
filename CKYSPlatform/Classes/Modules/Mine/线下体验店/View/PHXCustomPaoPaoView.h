//
//  ZJCustomPaoPaoView.h
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/10.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAnnotation.h"
typedef void (^OnClickHandle)(NSInteger buttonTag);

@interface PHXCustomPaoPaoView : UIView
@property (nonatomic,strong)UIImageView *backImageView1;//大圈
@property (nonatomic,strong)UIImageView *backImageView2;//箭头
@property (nonatomic,strong)UILabel *shopNameLable;
@property (nonatomic,strong)UILabel *phoneLable;
@property (nonatomic,strong)UIButton *shopCerButton;
@property (nonatomic,strong)UIButton *shopPhoneButton;
@property (nonatomic,copy)OnClickHandle clickhandle;
@property (strong,nonatomic)MyAnnotation *customAnno;
-(instancetype)initWithFrame:(CGRect)frame onClick:(OnClickHandle)clickBlock;
@end
