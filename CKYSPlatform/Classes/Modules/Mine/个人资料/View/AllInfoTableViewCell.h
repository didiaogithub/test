//
//  AllInfoTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/28.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AllInfoTableViewCell : UITableViewCell<UITextFieldDelegate>
/**个人信息*/
@property(nonatomic,strong)UILabel *leftInfoLable;
/**右边可编辑或者可点击*/
@property(nonatomic,strong)UITextField *rightTextField;
@property(nonatomic,strong)UIButton *rightButton;
@end
