//
//  AllPresaleShopTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/10.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresaleDetailModel.h"
@protocol AllPresaleShopTableViewCellDelegate <NSObject>
-(void)clickDeatailButton:(UIButton *)button Index:(NSInteger)index andSection:(NSInteger)section;
@end
@interface AllPresaleShopTableViewCell : UITableViewCell

@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSInteger section;
@property(nonatomic,weak)id<AllPresaleShopTableViewCellDelegate>delegate;
/**头像*/
@property(nonatomic,strong)UIImageView *headImageView;
/**第一行*/
@property(nonatomic,strong)UILabel *topLable;

/**文字*/
@property(nonatomic,strong)UILabel *leftTextLable;

/**第二行*/
@property(nonatomic,strong)UILabel *bottomLable;
/**复制按钮*/
@property(nonatomic,strong)UIButton *codeCopyButton;

/**右侧按钮  已加盟  待开通  待出售*/
@property(nonatomic,strong)UIButton *rightButton;

-(void)refreshWithModel:(PresaleDetailModel *)presaleModel;

@end
