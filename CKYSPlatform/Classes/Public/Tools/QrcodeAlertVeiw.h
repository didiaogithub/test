//
//  XWAlterVeiw.h
//  XWAleratView
//
//  Created by 庞宏侠. on 15/12/25.
//  Copyright © 2015年 庞宏侠. All rights reserved.
//

#import <UIKit/UIKit.h>

//注册时选择邀请码弹框
@protocol QrcodeAlertVeiwDelegate <NSObject>
-(void)copyQrcode;
-(void)writeQrcode;
@end

@interface QrcodeAlertVeiw : UIView
@property(nonatomic,weak)id<QrcodeAlertVeiwDelegate>delegate;
@property (nonatomic, strong) UIView *bigView;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UILabel *noticeLable;
@property(nonatomic,strong)UILabel *nameLable;
@property(nonatomic,strong)UILabel *qrcodeLable;

@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)UIButton *cancelBtn;

- (void)show;

-(void)dissmiss;

@end
