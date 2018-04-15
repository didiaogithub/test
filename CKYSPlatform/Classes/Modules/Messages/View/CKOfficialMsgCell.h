//
//  CKOfficialMsgCell.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKOfficialMsgModel.h"

@interface CKOfficialMsgCell : UITableViewCell

-(void)refreshWithModel:(CKOfficialMsgModel *)messageModel iconName:(NSInteger)type;

@end
