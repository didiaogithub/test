//
//  Public.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/5/24.
//  Copyright © 2017年 ForgetFairy. All rights reserved.
//

#ifndef Public_h
#define Public_h

/**App网络环境：1：线上环境， 0：表示测试环境*/
#define AppEnvironment 0
/**银联与银联Apple Pay环境："00" 表示线上环境"01"表示测试环境*/
#define UnionPayEnvironment @"00"

#import "NSString+MD5.h"
#import "RequestManager.h"
#import "MJExtension.h"
#import "SectionModel.h"
#import "CellModel.h"
#import "RequestManager+CK.h"
#import "RCloudManager.h"
#import "CacheData.h"
#import "NSDictionary+FF.h"
#import "JPUSHService.h"
#import "CKShareManager.h"
#import "DefaultValue.h"
#import "CommonMethod.h"
#import "UIViewController+BackButtonHandler.h"

#define Interval 5 /* 两次刷新的时间间隔 */
/** app最新版本号 */
#define ServerVersion @"CKYS_versioncode"
#define CKLastVersionKey @"CKYS_lastVersion"
/** 是否强制更新 */
#define Forceupdate @"CKYS_forceupdate"
#define AppStoreUrl @"AppStoreUrl"
/** 通知 */
#define DidReceiveBannerUpdatePushNoti @"didReceiveBannerUpdatePushNoti"
#define DidReceiveClassTitleUpdatePushNoti @"didReceiveClassTitleUpdatePushNoti"
#define DidReceiveClassDetailUpdatePushNoti @"didReceiveClassDetailUpdatePushNoti"


#define SetObjectForKey(Value, Key) [[NSUserDefaults standardUserDefaults] setObject:Value forKey:Key]
#define ObjectForKey(Key) [[NSUserDefaults standardUserDefaults] objectForKey:Key]

/** 消息提示 */
#define NetWorkNotReachable ObjectForKey(@"CKYSmsgnonetwork")
#define NetWorkTimeout ObjectForKey(@"CKYSmsgtimeout")
#define CKYSmsgtransup ObjectForKey(@"CKYSmsgtransup")
#define CKYSmsgqrcode ObjectForKey(@"CKYSmsgqrcode")
#define CKYSmsgpick ObjectForKey(@"CKYSmsgpick")
#define CKYSmsggetmoney ObjectForKey(@"CKYSmsggetmoney")
#define CKYSmsgcharge ObjectForKey(@"CKYSmsgcharge")
#define CKYSmsgchargeCK ObjectForKey(@"CKYSmsgchargeCK")
#define CKYSmsgchargeFX ObjectForKey(@"CKYSmsgchargeFX")
#define CKYSmsgBeanToMoneyCK ObjectForKey(@"CKYSmsgBeanToMoneyCK")
#define CKYSmsgBeanToMoneyFX ObjectForKey(@"CKYSmsgBeanToMoneyFX")
#define CKYSmsgpresale ObjectForKey(@"CKYSmsgpresale")
#define CKYSmsgshopstatus ObjectForKey(@"CKYSmsgshopstatus")
#define CKYSmsgshopstatusUpdatePersonalInfo ObjectForKey(@"CKYSmsgshopstatusUpdatePersonalInfo")
#define CKYSmsgshopstatusPending ObjectForKey(@"CKYSmsgshopstatusPending")
#define CKYSmsgshopstatusConnectCKOpen ObjectForKey(@"CKYSmsgshopstatusConnectCKOpen")
#define CKYSmsgshopstatusNoRight ObjectForKey(@"CKYSmsgshopstatusNoRight")
#define CKYSmsg9001 ObjectForKey(@"CKYSmsg9001")

/** 校验或者占位文字 */
#define CheckMsgPhoneHolder ObjectForKey(@"CheckMsgPhoneHolder")
#define CheckMsgPhoneNull ObjectForKey(@"CheckMsgPhoneNull")
#define CheckMsgPhoneError ObjectForKey(@"CheckMsgPhoneError")
#define CheckMsgVerificationCodeError ObjectForKey(@"CheckMsgVerificationCodeError")
#define CheckMsgVerificationCodeNull ObjectForKey(@"CheckMsgVerificationCodeNull")
#define CheckMsgInviteCodeNull ObjectForKey(@"CheckMsgInviteCodeNull")
#define CheckMsgInviteCodeError ObjectForKey(@"CheckMsgInviteCodeError")
#define CheckMsgPwTwiceError ObjectForKey(@"CheckMsgPwTwiceError")
#define CheckMsgPwNull ObjectForKey(@"CheckMsgPwNull")
#define CheckMsgReadProtocolFirst ObjectForKey(@"CheckMsgReadProtocolFirst")
#define CheckMsgSelectAddrFirst ObjectForKey(@"CheckMsgSelectAddrFirst")
#define CheckMsgSelectGiftFirst ObjectForKey(@"CheckMsgSelectGiftFirst")
#define CheckMsgQRNotLoad ObjectForKey(@"CheckMsgQRNotLoad")
#define CheckMsgContactPhoneError ObjectForKey(@"CheckMsgContactPhoneError")
#define CheckMsgNameNull ObjectForKey(@"CheckMsgNameNull")
#define CheckMsgAddrNull ObjectForKey(@"CheckMsgAddrNull")
#define CheckMsgCanNotChange ObjectForKey(@"CheckMsgCanNotChange")

/**距离导航栏底部的距离*/
#define NaviHeight (IPHONE_X ? 88 : 64)
/**iphonex导航栏增加的高度*/
#define NaviAddHeight (IPHONE_X ? 24 : 0)
#define BOTTOM_BAR_HEIGHT (IPHONE_X ? 34 : 0)

#endif /* Public_h */
