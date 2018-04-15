//
//  CKMonthStatisticsCell.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/12/28.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SCChart.h"
#import "JHChartHeader.h"

@class CKMonthCalShopStockCell;

@interface CKMonthStatisticsCell : UITableViewCell

@end

@protocol CKMonthCalShopStockCellDelegate<NSObject>

@optional
-(void)rewardRate:(CKMonthCalShopStockCell*)ckMonthCalShopStockCell;

@end

@interface CKMonthCalShopStockCell : CKMonthStatisticsCell

@property (nonatomic, weak) id<CKMonthCalShopStockCellDelegate> delegate;

- (void)updateCellData:(NSString*)rechargemoney modulus:(NSString*)modulus;

@end


@interface CKMonthCalDLBProfitCell : CKMonthStatisticsCell

- (void)updateCellWithInvitemoney:(NSString*)invitemoney;

@end


@interface CKColumnCell : CKMonthStatisticsCell

//@property (nonatomic, strong) SCChart *chartView;
@property (nonatomic, strong) NSMutableArray *xValueArray;
@property (nonatomic, strong) NSMutableArray *yValueArray;
@property (nonatomic, strong) JHColumnChart *column;

- (void)updateCellWithInvitereward:(NSString*)invitereward xValueArray:(NSArray*)xValueArray gettedArray:(NSArray*)gettedArray yValueArray:(NSArray*)yValueArray;

@end
