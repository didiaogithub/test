//
//  TakeCashRecordModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/5/4.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TakeCashRecordDetailModel.h"
@interface TakeCashRecordModel : NSObject
/**时间*/
@property(nonatomic,copy)NSString *time;

@property(nonatomic,strong)TakeCashRecordDetailModel *recordDetailModel;
@property(nonatomic,strong)NSMutableArray *detailArray;
+(TakeCashRecordModel *)getRecordModelWithDictionary:(NSDictionary *)dict;


@end
