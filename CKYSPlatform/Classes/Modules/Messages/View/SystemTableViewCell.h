//
//  SystemTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/20.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface SystemTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *redLable;

/**左侧图标*/
@property(nonatomic,strong)UIImageView *logoImageView;
/**标题*/
@property(nonatomic,strong)UILabel *titleLable;
/**时间*/
@property(nonatomic,strong)UILabel *timeLable;
/**内容*/
@property(nonatomic,strong)UILabel *contentLable;
-(void)refreshWithModel:(MessageModel *)systeModel;
@end
