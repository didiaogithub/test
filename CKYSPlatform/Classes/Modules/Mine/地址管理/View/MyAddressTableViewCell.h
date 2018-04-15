//
//  MyAddressTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/17.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@protocol MyAddressTableViewCellDelegate <NSObject>
-(void)addressButtonClicked:(UIButton *)button andRow:(NSInteger)row;

@end
@interface MyAddressTableViewCell : UITableViewCell
{
    UIView *_bankView;
    UILabel *middleLine;
    
}
@property(nonatomic,weak)id<MyAddressTableViewCellDelegate>delegate;
@property(nonatomic,assign)NSInteger row;
@property(nonatomic,strong)UIImageView *addressImageView;
@property(nonatomic,strong)UILabel *addressNameLable;
@property(nonatomic,strong)UILabel *addressDetailLable;
@property(nonatomic,strong)UILabel *addressTelPhoneLable;

@property(nonatomic,strong)UIButton *setDefaultButton;
@property(nonatomic,strong)UIButton *editButton;
@property(nonatomic,strong)UIButton *deleteButton;

@property(nonatomic,strong)UIButton *selectedAddressButton;
-(void)refreshWithModel:(AddressModel *)addressModel andIndex:(NSInteger)index;

@end
