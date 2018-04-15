//
//  CKCHeaderTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/13.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderModel.h"
@interface CKCHeaderTableViewCell : UITableViewCell
/**商品图片*/
@property(nonatomic,strong)UIImageView *goodsImageView;
/**头条标题*/
@property(nonatomic,strong)UILabel *titleLable;
/**头条副标题*/
@property(nonatomic,strong)UILabel *subTitleLable;
/**头条时间*/
@property(nonatomic,strong)UILabel *timeLable;
@property(nonatomic, copy)NSString *typestring;

//新闻
-(void)refreshWithHeaderModel:(HeaderModel *)headerModel;
@end
