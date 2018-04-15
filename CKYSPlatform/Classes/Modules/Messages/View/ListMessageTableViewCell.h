//
//  ListMessageTableViewCell.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/7/5.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface ListMessageTableViewCell : UITableViewCell
{
    UILabel *bottomLineLable;

}

@property(nonatomic,copy)NSString *typestr;

@property(nonatomic,strong)UILabel *redLable;
/**顾客头像*/
@property(nonatomic,strong)UIImageView *headImageView;
/**顾客姓名*/
@property(nonatomic,strong)UILabel *nameLable;
/**顾客消息*/
@property(nonatomic,strong)UILabel *messageLable;
/**时间*/
@property(nonatomic,strong)UILabel *timeLable;
-(void)refreshWithModel:(MessageModel *)messageModel;

@end
