//
//  CKShareManager.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/12.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKShareManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"

@implementation CKShareManager

+(instancetype)manager {
    static CKShareManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CKShareManager alloc] initPrivate];
    });
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        [self configShare];
    }
    return self;
}

-(void)configShare {
    //分享
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。 11891bf4882e0
     */
    [ShareSDK registerActivePlatforms:
            @[@(SSDKPlatformTypeSinaWeibo),//新浪
            @(SSDKPlatformTypeWechat),
            @(SSDKPlatformTypeQQ),//QQ好友
            @(SSDKPlatformSubTypeQZone),//空间
            @(SSDKPlatformSubTypeWechatSession),//微信好友
            @(SSDKPlatformSubTypeWechatTimeline),//微信朋友圈
            @(SSDKPlatformSubTypeQQFriend)]//QQ好友
    onImport:^(SSDKPlatformType platformType) {
             switch (platformType)
             {
                 case SSDKPlatformTypeWechat:
                     [ShareSDKConnector connectWeChat:[WXApi class]];
                     break;
                     
                 case SSDKPlatformTypeQQ:
                     [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                     break;
                 case SSDKPlatformTypeSinaWeibo:
                     [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                     break;
                 default:
                     break;
             }
    }onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
             switch (platformType){
                 case SSDKPlatformTypeSinaWeibo:
                     //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                     [appInfo SSDKSetupSinaWeiboByAppKey:weiBoAppkey
                                               appSecret:weiBoSecrete
                                             redirectUri:@"http://www.sharesdk.cn"
                                                authType:SSDKAuthTypeBoth];
                     break;
                 case SSDKPlatformTypeWechat:
                     [appInfo SSDKSetupWeChatByAppId:kWXAPP_ID appSecret:kWXAPP_SECRET];
                     
                     break;
                 case SSDKPlatformTypeQQ:
                     [appInfo SSDKSetupQQByAppId:qqAppID
                                          appKey:qqAppKey
                                        authType:SSDKAuthTypeBoth];
                     break;
                 case SSDKPlatformSubTypeQZone:
                 default:
                     break;
             }
         }];
}


+(void)shareToFriendWithName:(NSString *)name andHeadImages:(id)headImages  andUrl:(NSURL *)url andTitle:(NSString*)title{
    
   
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:name
                                     images:headImages
                                        url:url
                                      title:title
                                       type:SSDKContentTypeAuto];
    // 定制新浪微博的分享内容
    NSString *shopnameStr = [NSString stringWithFormat:@"%@%@",name,url];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:shopnameStr title:title images:headImages video:nil url:url latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:shopnameStr title:title image:headImages url:url
                                            latitude:0
                                           longitude:0
                                            objectID:nil
                                                type:SSDKContentTypeAuto];
//    [shareParams SSDKSetupSinaWeiboShareParamsByText:shopnameStr title:title images:headImages video:nil url:url latitude:0 longitude:0 objectID:nil isShareToStory:YES type:SSDKContentTypeAuto];
//
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:@[@(SSDKPlatformSubTypeWechatSession),
                                     @(SSDKPlatformSubTypeWechatTimeline),
                                     @(SSDKPlatformSubTypeQQFriend),
                                     @(SSDKPlatformSubTypeQZone),
                                     @(SSDKPlatformTypeSinaWeibo)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                           [successAlertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                           [failAlert show];
                           break;
                       }
                       case SSDKResponseStateBegin:
                           if (![ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo]) {
                               UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请安装新浪客户端" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                               [failAlert show];
                           }
                       default:
                           break;
                   }
               }
     ];
    
}

@end
