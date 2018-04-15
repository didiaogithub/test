//
//  CardModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/12/6.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardModel : NSObject
/**银行卡id*/
@property(nonatomic,copy)NSString *ID;
/**开户行名称*/
@property(nonatomic,copy)NSString *bankname;
/**银行卡尾号后4位*/
@property(nonatomic,copy)NSString *bankcardno;
/**是否默认*/
@property(nonatomic,copy)NSString *isdefault;


@end
