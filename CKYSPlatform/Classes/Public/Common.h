//
//  Common.h
//  ShoppingCentre
//
//  Created by 庞宏侠 on 16/7/12.
//  Copyright © 2016年 ckys. All rights reserved.
//#ifndef Common_h
#define Common_h

#define shareSDKAppID @"16bea2dd6ca10"
#define weiBoAppkey @"3663048893"
#define weiBoSecrete @"f80462f0efd68041e56759930c23d431"
#define qqAppID @"1106281908"
#define qqAppKey @"T9QPocuk37txhwNX"
#define JPush_appKey @"b7b046e6e9767dc0404df3ef"
#define JPush_appSecrete @"1f065c010affa4bcbc762586"


//wx0cf32894a88d6a65 创客云商APP
#define kWXAPP_ID @"wx0cf32894a88d6a65"
#define kWXAPP_SECRET @"7cdba7c134c87c690c2b73d00ba658b2"
#define WXCommercialTenantId @"1427373102"

//北京智齿客服appKey
#define WisdomTooth_AppKey @"78843e7d2f7a4f54bc894a34dbd2d968"
#define sysNum @"b96b3e57c0814d9d987bd21efc7c5934"

//京东支付相关
//商户号：110440579
//APPID：JDJR110440579001
#define JDMerchantID @"110440579002"
#define JDAPPID @"JDJR110440579001"


#define kWeiXinRefreshToken @"refresh_token"
#define KAccsess_token @"access_token"
#define KExpires_in @"expires_in"
#define KolderData @"older"

#define Kmobile @"CKYS_Mobile"
#define KnickName @"CKYS_NickName"
/**openid(通过微信授权获得)*/
#define KopenID @"CKYS_openid"
/**unionid(通过微信授权获得)*/
#define Kunionid @"CKYS_unionid"
#define kheamImageurl @"CKYS_headImageUrl"
#define Kckid @"CKYS_ckid"
#define Kpassword @"CKYS_PW"
#define DLBORDERID @"CKYS_dlbOrderid"
#define DLBORDERMoney @"CKYS_dlbOrderMoney"

#define KUserdefaults [NSUserDefaults standardUserDefaults]
/** 创客id*/
#define KCKidstring [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Kckid]]
/** 是否是预售店*/
#define KisPresaleShop @"CKYS_ispresale"
/**推广员登录  非推广员登录*/
#define KSales @"CKYS_sales"
/**店铺状态*/
#define KStatus @"CKYS_status"
/**确认店铺信息*/
#define KexitRegister @"exitRegister"
/**最新获取的店铺状态*/
#define KCheckStatus @"CKYS_checkstatus"
#define Ktype @"CKYS_type"
#define KjoinType @"CKYS_jointype"
#define Krealname @"CKYS_realname"
#define KshopName @"CKYS_shopname"

#define CKAppServerPushToken @"CKAppServerPushToken"
#define CKAppUpdateTokenStatus @"CKAppUpdateTokenStatus"


/**验证码登录成功状态*/
#define KMineLoginStatus @"mineloginstatus"
/**密码登录成功状态*/
#define KHomeLoginStatus @"homeloginstatus"

/**消息类型-*/
#define KMsgType_Customer @"顾客消息"
/**消息类型-系统通知*/
#define KMsgType_System @"系统通知"
/**消息类型-官方通知*/
#define KMsgType_Official @"官方通知"


//官方电话
#define PlatformMobile @"platform_tel"

//扫描二维码进入创客店铺，创客信息缓存
#define KckName @"name"
#define KckHeadImage @"logopath"
#define KckBankgroundImage @"topback_path"
#define KckCertifacateUrl @"cerpath"
#define CerShow @"cershow"
#define MobileShow @"mobileshow"


/**微信授权之后 跳转到加盟页*/
#define WeiXinAuthSuccess @"success"
/**搜索界面搜索成功按钮可点击*/
#define SearchSuccess @"searchsuccess"
/**是否已经搜索*/
#define IsHasSearch @"ishassearch"

/* 微信支付回调 */
#define WeiXinPay_CallBack @"weixinpay"
#define Alipay_CallBack @"AlipayBack"
#define UnionPay_CallBack @"UnionpayCallBack"


#define HasPayMoney @"HasPayMoney"
/**融云appkey*/  //y745wfm8yu15v  2.0测试lmxuhwagx94xd
#define RONGCLOUD_IM_Appkey @"z3v5yqkbvsfv0"//((AppEnvironment == 0) ? @"lmxuhwagx94xd" : @"z3v5yqkbvsfv0")

//消息 点击按钮通知
#define NOTI_NAME_POST @"MenuBtnDidClick"

/**百度地图的APPKEY*/
#define BMK_APPKEY @"Om9zoLvi63Fs28rt2hT88VUF1UhWAPiz"

/**极光推送*/
#define KJPushAppDidReceiveMessage @"JPushReceiveMessage"

#pragma mark - ***********************屏幕适配相关*****************************
//适配缩放
#define SCREEN_WIDTH_SCALE SCREEN_WIDTH / 375.0
#define SCREEN_HEIGHT_SCALE SCREEN_HEIGHT / 667.0

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

//banb
#define iOS7M ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
#define iOS8M ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
#define iOS9M ([[[UIDevice currentDevice]systemVersion]floatValue]>=9.0)

//不同屏幕尺寸字体适配（320，568是因为效果图为IPHONE5系列 如果不是则根据实际情况修改）
#define kScreenWidthRatio       (SCREEN_WIDTH / 375.0)
#define kScreenHeightRatio      (SCREEN_HEIGHT / 667.0)
#define AdaptedWidth(x)         ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x)        ceilf((x) * kScreenHeightRatio)

#define IPHONE_X [[CommonMethod getCurrentDeviceModel] isEqualToString:@"iPhone_X"]
//高度等于480
#define iphone4 ([UIScreen mainScreen].bounds.size.height == 480)
//高度大于480
#define iphone5 ([UIScreen mainScreen].bounds.size.height ==568)
//高度等于667
#define iphone6 ([UIScreen mainScreen].bounds.size.height ==667)
//高度大于667
#define iphone6Plus ([UIScreen mainScreen].bounds.size.height ==736)


#pragma mark - ***********************字体适配相关*****************************
// 中文字体-未使用
#define CHINESE_FONT_NAME       @"Heiti SC"
// #define CHINESE_SYSTEM(x) [UIFont fontWithName:CHINESE_FONT_NAME size:x]
#define CHINESE_SYSTEM(x)       [UIFont systemFontOfSize:x]
#define CHINESE_SYSTEM_BOLD(x)  [UIFont boldSystemFontOfSize:x]

// 字体定义
#define NAV_BAR_FONT            CHINESE_SYSTEM(AdaptedWidth(18))  //导航栏文字
#define MAIN_BODYTITLE_FONT    CHINESE_SYSTEM(AdaptedWidth(17))    // 主标题 正文 文字

#define MAIN_SAVEBUTTON_FONT    CHINESE_SYSTEM(AdaptedWidth(16))    // 主标题 正文 文字
#define ALL_ALERT_FONT    CHINESE_SYSTEM(AdaptedWidth(15))    //弹窗文字

#define MAIN_BoldTITLE_FONT    CHINESE_SYSTEM_BOLD(AdaptedWidth(14)) // 主标题 名字
#define MAIN_TITLE_FONT        CHINESE_SYSTEM(AdaptedWidth(14))    // 默认文字大小
#define MAIN_NAMETITLE_FONT    CHINESE_SYSTEM(AdaptedWidth(13))    // 默认文字大小
#define MAIN_SUBTITLE_FONT     CHINESE_SYSTEM(AdaptedWidth(11))   // 辅助说明文字

/**主标题 正常字体 颜色#1b1b1b*/
#define TitleColor CKYS_Color(27,27,27)

/**副标题 灰色字体颜色#959595*/
#define SubTitleColor CKYS_Color(149,149,149)


//RGB color
#define CKYS_Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//切图
#define KresizeableImage(m,top,left,bottom,right)  [[UIImage imageNamed:m] resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch]



#define KCustomerNotReadNum @"customerNotReadNum"
#define KOrderNotReadNum @"orderNotReadNum"
#define KSystemNotReadNum @"systemNotReadNum"
#define KOfficialNotReadNum @"officialNotReadNum"


#define APP_KEY_WINDOW [UIApplication sharedApplication].keyWindow
//通知
#define CKCNotificationCenter [NSNotificationCenter defaultCenter]
//appDelegate对象MyAddressTableViewCell
#define AppDelegateObject (AppDelegate *)[[UIApplication sharedApplication] delegate];

#pragma mark - ********************域名地址********************************
//********************以下为正式域名地址*************************************
//bate版域名
//#define WebServiceAPI @"http://bateckysappserver.ckc8.com/"

//*正式域名地址
//#define WebServiceAPI @"http://ckysappserver.ckc8.com/"
///////**下载图片资源路径*/
//#define BaseImagestr_Url @"http://ckysre.ckc8.com/ckc3/Uploads/"
///**上传图片资源路径*/
//#define UploadPicAndPhoto_Url @http://ckysre.ckc8.com/ckc3/""
///**消息服务*/
//#define PostMessageAPI @"http://ckysmsg.ckc8.com/"
///**支付服务*/
//#define WebServicePayAPI @"http://ckyspb.ckc8.com/"

//********************以前环境测试域名地址*************************************
//*测试地址域名
//#define WebServiceAPI @"http://testckysappserver.ckc8.com/"
////*下载图片资源路径
//#define BaseImagestr_Url @"http://testckysre.ckc8.com/ckc3/Uploads/"
////*消息服务
//#define PostMessageAPI @"http://testckysmsg.ckc8.com/"
////*上传图片和身份证测试
//#define UploadPicAndPhoto_Url @"http://testckysre.ckc8.com/ckc3/"
////*支付服务
//#define WebServicePayAPI @"http://testckyspb.ckc8.com/"

//********************现在线下测试环境域名地址*************************************
////*线下测试域名地址
//#define WebServiceAPI @"http://testofflineckysappserver.ckc8.com/"
///**下载图片资源路径*/
//#define BaseImagestr_Url @"http://testofflineckysre.ckc8.com/ckc3/Uploads/"
///**上传图片资源路径*/
//#define UploadPicAndPhoto_Url @"http://testofflineckysre.ckc8.com/ckc3/"
///**消息服务*/
//#define PostMessageAPI @"http://testofflineckysmsg.ckc8.com/"
///**支付服务*/
//#define WebServicePayAPI @"http://testofflineckyspb.ckc8.com/"

//***2017.8.2域名地址获取方法，如果改测试环境，将public.h中的AppEnvironment值改0 ****
//*域名地址
#define WebServiceAPI [[DefaultValue shareInstance] domainName]
/**下载图片资源路径*/
#define BaseImagestr_Url [[DefaultValue shareInstance] baseImagestr]
/**上传图片资源路径*/
#define UploadPicAndPhoto_Url [[DefaultValue shareInstance] domainNameRes]
/**消息服务*/
#define PostMessageAPI [[DefaultValue shareInstance] domainSmsMessage]
/**微信支付宝域名*/
#define WebServicePayAPI [[DefaultValue shareInstance] domainNamePay]
/**银联Apple Pay域名*/
#define WebServiceUnitPayAPI [[DefaultValue shareInstance] domainNameUnionPay]
//********************域名地址*************************************

/**融云聊天的默认头像*/
#define DefaultHeadPath @"front/ckappFront/img/dafname.png"
/**判断ios是否在审核中*/
#define CheckSuccessCode @"200"
/**判断多台设备登录*/
#define MutipDeviceLoginCode @"9001"
#define ShopCloseCode @"8001"
#define DeviceId @"deviceid"


#define DeviceId_UUID_Value [NSString stringWithFormat:@"%@", [getUUID getUUID]]

#pragma mark - *************************接口地址********************************

//2017.10.26.新的注册流程接口
/**取得注册状态~*/
#define GetRegistStatus @"Ckapp3/Regist/getRegistStatus"
/**大礼包列表~*/
#define GetRegistItem @"Ckapp3/Regist/getRegistItem"
/**提交大礼包订单~*/
#define SubmitRegistOrder @"Ckapp3/Regist/submitRegistOrder"
/**提交大礼包订单~*/
#define ConfirmRegist @"Ckapp3/Regist/confirmRegist"

//2018.1.1 v3.1.2新增接口
/**获取优惠券列表*/
#define GetMyCoupons @"Ckapp3/Coupon/getMyCoupons"
/**获取优惠券详情*/
#define GetCouponInfoById @"Ckapp3/Coupon/getCouponInfoById"
/**获取月结信息接口*/
#define GetMonthStatement @"Ckapp3/CkCal/getMonthStatement"
/**获取云豆库标签*/
#define GetYlibSorts @"Ckapp3/Item/getYlibSorts"
/**获取产品库*/
#define GetGlibSorts @"Ckapp3/Item/getGlibSorts"
/**获取产品库金额*/
#define GetGlibMoney @"Ckapp3/Item/getGlibMoney"


/**上传deviceToken*/
//#define PushService @"http://192.168.2.32:1234/"
//#define PushService @"http://192.168.2.110:8080/"
#define PushService @"http://ckysapppush.ckc8.com/" //正式上传token域名
//#define PushService @"http://testofflineckyspush.ckc8.com" //测试环境上传token域名
#define updateDeviceToken @"ckys-push/app/getAuthToken"
/**取得首页一些数据~*/
#define GetMainSomeData @"Ckapp3/Index/getMainSomeData"
/**获取课程阅读量~*/
#define GetLessonReadNum @"Ckapp3/News/getLessonReadNum"
/**上传错误日志~*/
#define UploadErrorLog @"Ckapp3/Index/uploadData"
/**银联支付~*/
#define Uionpay_Url @"pay/ckapp_pay3/unionpay/pages/payinfo.php"
/**京东支付~*/
#define JDPay_Url @"pay/ckapp_pay3/jdpay/action/app.php"

#define AppConfirmVersion @"Ckapp3/Login/appConfirmVersion"


/**发送短信验证码*/
//#define sendMsg_Url @"Msg/Sms/sendSmsMsg"
#define sendMsg_Url @"Msg/Sms/getValidCodeA"

/**取得大礼包信息~*/
#define getGiftList_Url @"Ckapp3/Join/getGiftList"
/**创客 或者分销 注册~*/
#define ckRegist_Url @"Ckapp3/Join/ckRegist"
/**注册校验手机号 邀请码~*/
#define ckRegistCheck_Url @"Ckapp3/Join/ckRegistCheck"

/**手机号 密码  登录~*/
#define ckLogin_Url @"Ckapp3/Login/ckLogin"
/**短信验证码登录~*/
#define ckLoginValidateCode_Url @"Ckapp3/Login/ckLoginValidateCode"
/**获取首页数据~*/
#define getMainData_Url @"Ckapp3/Index/getMainData"
/**获取今日销售收入*/
#define getTodayOrders_Url @"Ckapp3/Index/getTodayOrders"

/**注册时候 直接获取邀请码~*/
#define getInviteCode_Url @"Ckapp3/Join/getInviteCode"

/**获取省市区地址~*/
#define getArea_Url @"Ckapp3/Address/getArea"

/**保存个人信息~*/
#define savePersonalInfo_Url @"Ckapp3/CkInfo/savePersonalInfo"

/**个人中心上传头像*/
#define uploadPic_Url @"Resource/CkApp/uploadPic"
/**个人中心上传身份证*/
#define uploadPhoto_Url @"Resource/CkApp/uploadPhoto"

/**获取个人信息~*/
#define getPersonalInfo_Url @"Ckapp3/CkInfo/getPersonalInfo"
/**上传身份证照片~*/
#define saveIDPhoto_Url @"Ckapp3/CkInfo/saveIDPhoto"
/**修改密码~*/
#define modPassword_Url @"Ckapp3/CkInfo/modPassword"
/**获取荣誉，资质证书*/
#define getAppHonorArr_Url @"Ckapp3/Index/getHonors"

/**获取个人中心数据~*/
#define getMyZoneData_Url @"Ckapp3/CkInfo/getMyZoneData"
/**获取店铺的二维码~*/
#define getQRCode_Url @"Ckapp3/CkInfo/getQRCode"




/**获取创客当前产品库~~*/
#define getGlibMoney_Url @"Ckapp3/Item/getGlibMoney"
/**获取创客当前云豆库~~*/
#define getYlibMoney_Url @"Ckapp3/Item/getYlibMoney"

/**云豆库转转产品库最大金额*/
#define getYlibtoGlibMoney_Url @"Ckapp3/CkCal/getYlibtoGlibMoney"

/**产品库收支明细获取~*/
#define glibrecordRequest_Url @"Ckapp3/Item/glibrecordRequest"
/**获取云豆库收支明细记录~*/
#define ylibrecordRequest_Url @"Ckapp3/Item/ylibrecordRequest"
/**获取月结信息~*/
#define getMonthlyStatement_Url @"Ckapp3/CkCal/getMonthlyStatement"

/**获取个人进货记录（按月查询）*/
#define getRechargeCK_Url @"Ckapp3/CkCal/getRechargeCK"

/**获取个人招商记录（按月查询）*/
#define getInviteCK_Url @"Ckapp3/CkCal/getInviteCK"

/**获取创客直营团队进货记录（按月查询）*/
#define getRechargeTeam_Url @"Ckapp3/CkCal/getRechargeTeam"
/**获取创客直营团队招商记录（按月查询）*/
#define getInviteTeam_Url @"Ckapp3/CkCal/getInviteTeam"
/**获取我的团队数据*/
#define getMyTeamInfo_Url @"Ckapp3/CkInfo/getMyTeamInfo"

/**获取顾客列表 */
#define getCustomerList_Url @"Ckapp3/CkInfo/getCustomerList"
/**获取下级创客列表 */
#define getMyTeamCkList_Url @"Ckapp3/CkInfo/getMyTeamCkList"
/**获取下级分销列表 */
#define getMyTeamFxList_Url @"Ckapp3/CkInfo/getMyTeamFxList"
/**获取领导人信息 */
#define getLeaderInfo_Url @"Ckapp3/CkInfo/getLeaderInfo"


///**获取创客信息 */
//#define getCkInfo_Url @"Ckapp3/CkInfo/getCkInfo"


/**商品上架*/
#define putGoodsOnSale_Url @"Ckapp3/Goods/putGoodsOnSale"
/**商品下架*/
#define pullGoodsOffShelves_Url @"Ckapp3/Goods/pullGoodsOffShelves"

/**获取上架的商品列表*/
#define getGoodsOnSale_Url @"Ckapp3/Goods/getGoodsOnSale"
/**获取下架的商品列表*/
#define getGoodsOffShelves_Url @"Ckapp3/Goods/getGoodsOffShelves"

/**获取自提商品列表*/
#define getGoodsList_Url @"Ckapp3/Goods/getGoodsList"


//地址部分
/**根据id 获取 地址*/
#define getAddressById_Url @"Ckapp3/Address/getAddressById"

/**添加地址*/
#define addAddress_Url @"Ckapp3/Address/addAddress"
/**设置为默认收货地址*/
#define setDefaultAddress_Url @"Ckapp3/Address/setDefaultAddress"
/**编辑地址*/
#define modifyAddress_Url @"Ckapp3/Address/modifyAddress"

/**删除地址*/
#define deleteAddress_Url @"Ckapp3/Address/deleteAddress"
/**获取收货地址列表*/
#define getAddress_Url @"Ckapp3/Address/getAddress"
/**获取默认收货地址*/
#define getDefaultAddress_Url @"Ckapp3/Address/getDefaultAddress"
/**修改订单地址*///代付款和支付成功15分钟内的可以更改
#define updateOrderAddress_Url @"Ckapp3/Order/updateOrderAddress"


//银行卡部分
/** 添加银行卡*/
#define addBankCard_Url @"Ckapp3/BankCard/addBankCard"
/** 获取已添加银行卡列表*/
#define getBankCardList_Url @"Ckapp3/BankCard/getBankCardList"
/** 左滑删除银行卡*/
#define deleteBankCard_Url @"Ckapp3/BankCard/deleteBankCard"
/**设置默认银行卡*/
#define setDefaultBankCard_Url @"Ckapp3/BankCard/setDefaultBankCard"
/**获取默认银行卡*/
#define getDefaultBankCard_Url @"Ckapp3/BankCard/getDefaultBankCard"

/**提现申请*/
#define withDrawCash_Url @"Ckapp3/TeamMoney/withDrawCash"
/**我的提现记录*/
#define getWithdrawCashRecord_Url @"Ckapp3/TeamMoney/getWithdrawCashRecord"



/**零风险转正式创客*/
#define updateToSure_Url @"Ckapp3/CkInfo/updateToSure"

/**云转产充值（进货）*/
#define addGlibByYlib_Url @"Ckapp3/TeamMoney/addGlibByYlib"

/**加盟支付（微信）*/
#define payForJoinByWX_Url @"pay/ckapp_pay3/weixin/example/app.php"
/**加盟支付（支付宝）*/
#define payForJoinByAli_Url @"pay/ckapp_pay3/alipay/app.php"


//自提部分
/**只能自提商品*/
#define pickUpGoods_Url @"Ckapp3/Ckzt/pickUpGoods"
/**可以支付的商品请求*/
#define ztzfOrder_UpGoods_Url @"Ckapp3/Ckzt/ztzfOrder"

/**根据关键字搜索商品*/
#define searchGoods_Url @"Ckapp3/Goods/searchGoods"

/************************消息模块接口部分********************/
/**获取系统消息列表*/
//#define getSysMsgs_Url @"Msg/CkApp3/getSysMsgs"

/**获取创客跟顾客的会话列表*/
#define getConversations_Url @"Msg/CkApp3/getConversations"
/**清除顾客列表未读消息*/
#define clearAllNotReadMsg_Url @"Msg/CkApp3/clearAllNotReadMsg"
#pragma mark - 以下3.0.2添加的新的接口*****************************
/**获取系统通知列表二级页面展开*/
#define getSystemMsgs @"Msg/CkApp3/getSystemMsgs" //参数：ckid:创客id, tgid:推广人id, pagesize:分页大小, id:行号 type:1：订单 2：开店 3：云豆 4：产品
/**获取官方通知列表*/
#define getofficialsMsgs @"Ckapp3/News/getofficialsMsgs"  //参数：ckid:创客id, pagesize:分页大小, id:行号
/**获取未读消息数*/
#define getNotReadMsgNum @"Msg/CkApp3/getNotReadMsgNum"  //参数
/**清除未读消息数*/
#define clearNotReadNum @"Msg/CkApp3/clearNotReadNum" //参数：ckid:创客id type:(1：订单 2：开店 3：云豆 4：产品) deviceid:udid
/**获取系统通知分类的列表*/
#define getSysMsgInfo @"Msg/CkApp3/getSysMsgInfo"  //参数：ckid:创客id，deviceid:udid

#pragma mark - 以上3.0.2添加的新的接口*****************************


/**我的订单*/
#define getMyOrders_Url @"Ckapp3/Order/getMyOrders"
/**订单详情*/
#define getOrderDetail_Url @"Ckapp3/Order/getOrderDetail"
/**获取物流信息*/
#define getLogisticsInfo_Url @"Ckapp3/Order/getLogisticsInfo"
/**删除订单*/
#define deleteOrder_Url @"Ckapp3/Order/deleteOrder"
/** 获取商学院课标题分类*/
#define getLessonsSort_Url @"Ckapp3/News/getLessonsSort"

/** 根据商学院标题查课程*/
#define getLessonsBySortId_Url @"Ckapp3/News/getLessonsBySortId"

/** 根据关键字搜索商学院课程	*/
#define searchLessons_Url @"Ckapp3/News/searchLessons"
/** 获取创客村头条新闻列表接口~~~*/
#define getTopHotNews_Url @"Ckapp3/News/getTopHotNews"


/**获取当前需要支付的金额*/
#define getSomePath_Url @"Ckapp3/Index/getSomePath"

/**获取融云Token*/
#define  getRongYunToken @"Ckapp3/RongYun/getRongYunToken"
/** 保存消息*/
#define  writeMsg_Url  @"Msg/CkApp3/writeMsg"

/**预售店铺列表*/
#define  getCkPreSale_Url  @"Ckapp3/CkInfo/getCkPreSale"
/**开通预售店铺*/
#define  openPreSaleShop_Url  @"Ckapp3/CkInfo/openPreSaleShop"

/**获取体验店信息*/
#define  getExpShopList_Url  @"Ckapp3/Exp/getExpShopList"
/**搜索体验店信息*/
#define  getsearchExpShop_Url  @"Ckapp3/Exp/searchExpShop"
/**获取省市信息*/
#define  getExpCityList_Url  @"Ckapp3/Exp/getExpCityList"

/**获取股权*/
#define  getCkStockMsg_Url  @"Ckapp3/CkStock/getCkStockMsg"
/**退出登录接口*/
#define  loginOut_Url  @"Ckapp3/Login/loginOut"

/**是否在审核中*/
#define IsIosCheck_Url @"Ckapp3/Login/isIosCheck"

/**获取进货总计*/
#define getMyRechargeRecord_Url @"Ckapp3/CkInfo/getMyRechargeRecord"
/**获取推广总计*/
#define getMyInviteRecord_Url @"Ckapp3/CkInfo/getMyInviteRecord"
/**检测是否可点击*/
#define checkStatus_Url @"Ckapp3/CkInfo/checkStatus"
/**请求课程点击量*/
#define setViewed @"Ckapp3/News/setViewed"


#pragma mark - ****************************为空判断*****************************
/**判空处理*/
#define IsNilOrNull(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]])  || ([(_ref) isKindOfClass:[NSNull class]]) || ([(_ref) isEqualToString:@"(null)"]) || ([(_ref) isEqualToString:@""]) || ([(_ref) isEqualToString:@"null"]) || ([(_ref) isEqualToString:@"<null>"]))

//debug状态输出log，release状态屏蔽log
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()



#endif /* Common_h */
