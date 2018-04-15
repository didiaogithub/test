//
//  GoodsDetailView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/21.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

/**代理*/
@protocol GoodsDetailViewDelegate <NSObject>
-(void)clickButtonWithTag:(NSInteger)tag;
@end
@interface GoodsDetailView : UIView

@property(nonatomic,weak)id<GoodsDetailViewDelegate>delegate;
@property(nonatomic,assign)NSInteger chooseCount;
/**数量*/
@property(nonatomic,strong)UILabel *textNumberLable;
@property(nonatomic,strong)UIView *countView;
@property(nonatomic,strong)UIButton *reduceButton;
@property(nonatomic,strong)UIButton *plusButton;
@property(nonatomic,strong)UILabel *countLable;

/**合计*/
@property(nonatomic,strong)UILabel *allMoneyLable;
/**立即购买*/
@property(nonatomic,strong)UIButton *nowToBuyButton;

@end
