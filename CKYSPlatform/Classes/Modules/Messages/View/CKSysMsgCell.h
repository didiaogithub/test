//
//  CKSysMsgCell.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKSysMsgModel.h"

@interface CKSysMsgCell : UITableViewCell
{
    UILabel *bottomLineLable;
    
}

@property(nonatomic,copy)NSString *typestr;

@property(nonatomic,strong)UILabel *redLable;
/**类型图片*/
@property(nonatomic,strong)UIImageView *headImageView;
/**类型名称*/
@property(nonatomic,strong)UILabel *nameLable;
/**最新消息*/
@property(nonatomic,strong)UILabel *messageLable;
/**时间*/
@property(nonatomic,strong)UILabel *timeLable;

-(void)refreshWithModel:(CKSysMsgListModel *)messageModel iconName:(NSInteger)type;

@end
