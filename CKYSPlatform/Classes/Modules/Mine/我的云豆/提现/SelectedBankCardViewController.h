//
//  SelectedBankCardViewController.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/3.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseViewController.h"

#import "CardModel.h"
typedef void (^TransBlock)(CardModel *bankCardModel);

typedef void (^BackBlock)(NSString *deleteBankCardId);
@interface SelectedBankCardViewController : BaseViewController

@property(nonatomic,copy)TransBlock bankcardBlock;
-(void)setBankcardBlock:(TransBlock)bankcardBlock;

@property(nonatomic,copy)BackBlock backBlock;
-(void)setBackBlock:(BackBlock)backBlock;
@end
