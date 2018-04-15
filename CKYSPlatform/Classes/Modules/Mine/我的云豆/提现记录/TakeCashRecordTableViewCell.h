//
//  TakeCashRecordTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/5/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakeCashRecordDetailModel.h"
@interface TakeCashRecordTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *timeLable;
@property(nonatomic,strong)UILabel *takeCashMoneyLable;
@property(nonatomic,strong)UILabel *cardLable;
@property(nonatomic,strong)UILabel *statusLable;
@property(nonatomic,strong)UILabel *becauseLable;
@property(nonatomic,strong) MASConstraint *aConstrain;
-(void)refreshWithRecordDetailModel:(TakeCashRecordDetailModel *)recordModel;

@end
