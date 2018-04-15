//
//  BankCardTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/3.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardModel.h"

@protocol BankCardTableViewCellDelegate <NSObject>

-(void)setDefaultBankCardWithRow:(NSInteger)row andButton:(UIButton *)button;

@end
@interface BankCardTableViewCell : UITableViewCell
@property(nonatomic,weak)id<BankCardTableViewCellDelegate>delegate;
@property(nonatomic,assign)NSInteger row;
/**银行卡*/
@property(nonatomic,strong)UILabel *bankCardLable;
/**选择图标按钮*/
@property(nonatomic,strong)UIButton *selectedButton;
-(void)refreshWithModel:(CardModel *)cardModel;


@end
