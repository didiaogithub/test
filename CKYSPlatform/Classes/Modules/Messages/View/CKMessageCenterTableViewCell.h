//
//  CKMessageCenterTableViewCell.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/17.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKGroupModel.h"
#import "CKUserMsgListModel.h"

//groupList
@interface CKMessageCenterTableViewCell : UITableViewCell

- (void)updateCellWithData:(CKGroupModel *)groupModel;
    
@end

//userList
@interface CKMessageCenterUserMsgListCell : UITableViewCell

- (void)updateCellWithData:(CKUserMsgListModel *)msgModel;

@end
