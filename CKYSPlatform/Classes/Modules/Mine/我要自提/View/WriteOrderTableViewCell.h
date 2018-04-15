//
//  WriteOrderTableViewCell.h
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/8/10.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface WriteOrderTableViewCell : UITableViewCell
{
    UIView *_bankView;
    UILabel *linelable;

}
@property(nonatomic,strong)UIImageView *addressImageView;
@property(nonatomic,strong)UILabel *addressNameLable;
@property(nonatomic,strong)UILabel *addressDetailLable;
@property(nonatomic,strong)UILabel *addressTelPhoneLable;

/**右箭头*/
@property(nonatomic,strong)UIImageView *rightImageView;
@property(nonatomic,strong)UIImageView *bottomImageView;
@property(nonatomic,strong)UIImageView *defaultImageView;


-(void)refreshWithAddressModel:(AddressModel *)addressModel;




@end
