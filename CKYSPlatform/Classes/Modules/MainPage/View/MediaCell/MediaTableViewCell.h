//
//  MediaTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/6/2.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderModel.h"
@interface MediaTableViewCell : UITableViewCell
/**报导图片*/
@property(nonatomic,strong)UIImageView *goodsImageView;
/**头条标题*/
@property(nonatomic,strong)UILabel *titleLable;
/**头条副标题*/
@property(nonatomic,strong)UILabel *subTitleLable;
/**头条时间*/
@property(nonatomic,strong)UILabel *timeLable;

//媒体
-(void)refreshWithMediaModel:(HeaderModel *)mediaModel;
@end
