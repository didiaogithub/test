//
//  TodaySaleView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/4/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TodaySaleViewDelegate <NSObject>

-(void)refreshSalesButton:(UIButton *)saleButton;

@end
@interface TodaySaleView : UIView
@property(nonatomic,weak)id<TodaySaleViewDelegate>delegate;
/**实销收入*/
@property(nonatomic,strong)UILabel *moneyTotalLable; //
/**销售总金额*/
@property(nonatomic,strong)UILabel *moneySalesLable;
/**退货金额*/

/**总笔数*/
@property(nonatomic,strong)UILabel *allNumLable;
@property(nonatomic,strong)UILabel *moneyOrderBackLable;
@property(nonatomic,strong)UIButton *topButton;
@property(nonatomic,strong)UIButton *saleButton;
@property(nonatomic,strong)UIButton *returnButton;

@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *allsalesView;
@property(nonatomic,strong)UIView *returnView;

-(instancetype)initWithFrame:(CGRect)frame andTypeStr:(NSString *)typeStr;

@end
