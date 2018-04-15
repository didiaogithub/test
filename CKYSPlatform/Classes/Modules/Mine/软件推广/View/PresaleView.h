//
//  PresaleView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/10.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PresaleViewDelegate <NSObject>
-(void)clickPresaleButton:(UIButton *)button;
@end


@interface PresaleView : UIView
@property(nonatomic,weak)id<PresaleViewDelegate>delegate;
/**预售店图标*/
@property(nonatomic,strong)UIImageView *leftImageView;
@property(nonatomic,strong)UILabel *presaleShopNameLable;
@property(nonatomic,strong)UILabel *ratioLable;
/**投资时间*/
@property(nonatomic,strong)UILabel *timeLable;

/**倒计时图标*/
@property(nonatomic,strong)UIImageView *countdownImageView;
/**剩余时间*/
@property(nonatomic,strong)UILabel *remainingLable;
@property(nonatomic,strong)UIButton *headerButton;

@property(nonatomic,strong)UIView *returnView;
/**已回收背景*/
@property(nonatomic,strong)UIImageView *recyclingImageView;



-(instancetype)initWithFrame:(CGRect)frame andSection:(NSInteger)section;



@end
