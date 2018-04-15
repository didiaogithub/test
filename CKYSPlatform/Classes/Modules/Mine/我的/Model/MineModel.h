//
//  MineModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/29.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

@interface MineModel : BaseEncodeModel
/** 店铺名称*/
@property (nonatomic, copy) NSString *shopname;
/** 类型*/
@property (nonatomic, copy) NSString *type;
/** 创客类型*/
@property (nonatomic, copy) NSString *jointype;
/** 图像*/
@property (nonatomic, copy) NSString *headurl;
/** 二维码地址*/
@property (nonatomic, copy) NSString *qrcodeurl;
/** 邀请码*/
@property (nonatomic, copy) NSString *invitecode;
/** 店铺状态*/
@property (nonatomic, copy) NSString *status;
/**显示股权  incomeorstock=2表示显示股权，1不显示股权*/
@property (nonatomic, copy) NSString *incomeorstock;
/** 股权数量*/
@property (nonatomic, copy) NSString *stocknum;
/**  股权url*/
@property (nonatomic, copy) NSString *stockurl;
/**  店铺url*/
@property (nonatomic, copy) NSString *shopurl;
/**3.1.3  0未考试 1考试未通过 2 通过 3 超期未通过（无礼包销售权） */
@property (nonatomic, copy) NSString *giftshare;
/**3.1.4  0：无一条件满足，不显示入口 1：最低条件满足显示申请服务商入口 2：全部条件满足，显示成为服务商入口 3：提交申请，等待审核中 4：已成为服务商，显示升级服务商入口 */
@property (nonatomic, copy) NSString *serviceprovider;
/**  申请服务商查看页面地址*/
@property (nonatomic, copy) NSString *applyurl;
/**  升级服务商页面地址*/
@property (nonatomic, copy) NSString *upgradeurl;

@end
