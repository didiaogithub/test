//
//  CardView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/30.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CardViewDelegate <NSObject>
-(void)addCardPhotoWithButtonTag:(NSInteger)buttonTag;

@end
@interface CardView : UIView
@property(nonatomic,weak)id<CardViewDelegate>delegate;
@property(nonatomic,strong)UIScrollView *bankGroundScrollview;
@property(nonatomic,strong)UIButton *handCardButton;
@property(nonatomic,strong)UIButton *rightCardButton;
@property(nonatomic,strong)UIButton *backCardButton;

@property(nonatomic,strong)UIButton *saveButton;

@end
