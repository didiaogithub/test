//
//  CKMessageCommon.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKMessageCommon.h"
#import "MineModel.h"
@implementation CKMessageCommon

+ (PTContactorModel*)getCKInfoModel {
    //将自己添加进群组
    NSString *ckid = IsNilOrNull(KCKidstring) ? @"":KCKidstring;
    NSString *smallName = [KUserdefaults objectForKey:KnickName];
    if(IsNilOrNull(smallName)){
        smallName = ckid;
    }
    NSString *head = [KUserdefaults objectForKey:kheamImageurl];
    if(IsNilOrNull(head)){
        head = [NSString stringWithFormat:@"%@%@", WebServiceAPI, DefaultHeadPath];
    }
    
    PTContactorModel *contactor = [[PTContactorModel alloc] init];
    contactor.name = smallName;
    contactor.mobile = [KUserdefaults objectForKey:Kmobile];
    contactor.meid = ckid;
    contactor.remark = @"";
    contactor.head = head;
    return contactor;
}

+ (CKGroupInfoModel*)convertCKInfoToGroupInfo:(PTContactorModel*)contactorM {
    CKGroupInfoModel *groupInfo = [[CKGroupInfoModel alloc] init];
    groupInfo.meid = contactorM.meid;
    groupInfo.name = contactorM.name;
    groupInfo.remark = contactorM.remark;
    groupInfo.head = contactorM.head;
    groupInfo.mobile = contactorM.mobile;
    return groupInfo;
}

@end
