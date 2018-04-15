//
//  MineHeaderView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineHeaderViewDelagate <NSObject>
@optional
-(void)fxToCKClick;
/**去完善个人资料信息*/
-(void)comeToEditMyInfoWith:(UIButton *)button;
/**我的等级*/
-(void)checkMyLevel:(UIButton *)button;

@end

@interface MineHeaderView : UIView

@property(nonatomic,weak)id<MineHeaderViewDelagate>delegate;
/*头像*/
@property(nonatomic,strong)UIImageView *headImageView;
/*头像*/
@property(nonatomic,strong)UIButton *bigButton;
/*店铺名称*/
@property(nonatomic,strong)UILabel *shopNameLable;
/*类型*/
@property(nonatomic,strong)UILabel *typeLable;
/*升级*/
@property(nonatomic,strong)UIButton *gradeButton;
/*等级*/
@property(nonatomic,strong)UIImageView *gradeImageView;
/**进入个人资料*/
@property(nonatomic, strong) UIButton *btn;
/**进入个人资料*/
@property(nonatomic, strong) UIButton *myLevelBtn;

//-(instancetype)initWithFrame:(CGRect)frame;

@end
