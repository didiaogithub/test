//
//  AddAddressTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/2/20.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddAddressTableViewCellDelegate <NSObject>
@optional
-(void)clickToAddressVC;

@end
@interface AddAddressTableViewCell : UITableViewCell
@property(nonatomic,weak)id<AddAddressTableViewCellDelegate>delegate;
@property(nonatomic,strong)UIButton *selectedAddressButton;
@property(nonatomic,strong)UIImageView *rightImageView;
@property(nonatomic,strong)UIImageView *bottomImageView;

@end
