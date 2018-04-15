//
//  HeadImageTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/28.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@protocol HeadImageTableViewCellDelegate <NSObject>

-(void)changeHeadImageWithButton:(UIButton *)button;

@end


@interface HeadImageTableViewCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,weak)id<HeadImageTableViewCellDelegate>delegate;
/**店铺头像lable*/
@property(nonatomic,strong)UILabel *headLable;
/**店铺名称lable*/
@property(nonatomic,strong)UILabel *shopNameLable;
/**店铺昵称lable*/
@property(nonatomic,strong)UILabel *shopNickNameLable;
/**店铺头像*/
@property(nonatomic,strong)UIButton *headImageButton;
/**店铺名称*/
@property(nonatomic,strong)UITextField *shopNameTextField;
/**店铺昵称*/
@property(nonatomic,strong)UITextField *shopNickNameTextField;


-(void)refreshWithModel:(UserModel *)userModel;

@end
