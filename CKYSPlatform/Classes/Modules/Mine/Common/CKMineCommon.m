//
//  CKMineCommon.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/21.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKMineCommon.h"
#import "XNArchiverManager.h"

@implementation CKMineCommon

-(void)requestQRcode:(void(^)(NSString *qrcodeUrl, NSString *localQr, BOOL qrtype))qrCode {
    NSString *tgidString = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    if (IsNilOrNull(tgidString)) {
        tgidString = @"0";
    }
    NSString *ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    
    NSString *getQRCodeUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getQRCode_Url];
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    // 增加风火轮
    self.viewDataLoading = [[CKC_CustomProgressView alloc] init];
    // 增加网络错误时提示
    self.viewNetError = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.viewNetError.indicatorView = nil;
    self.viewNetError.userInteractionEnabled = NO;
    self.viewNetError.position = JGProgressHUDPositionBottomCenter;
    self.viewNetError.marginInsets = (UIEdgeInsets)
    {
        .top = 0.0f,
        .bottom = 60.0f,
        .left = 0.0f,
        .right = 0.0f,
    };

    
    [[UIApplication sharedApplication].keyWindow addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    NSDictionary *pramaDic = @{@"ckid": ckidString, @"tgid": tgidString, DeviceId: uuid};
    [HttpTool postWithUrl:getQRCodeUrl params:pramaDic success:^(id json) {
        
        [self.viewDataLoading stopAnimation];

        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        int x = arc4random() % 100000;
        NSString *codelUrl = [NSString stringWithFormat:@"%@?%d",dict[@"qrcodeurl"], x];
        if (IsNilOrNull(codelUrl)) {
            codelUrl = @"";
        }
        
        NSLog(@"请求的最新二维码%@",codelUrl);
        
        NSArray *keysArray = [dict allKeys];
        if ([keysArray containsObject:@"qrtype"]) {
            qrCode(codelUrl, @"requested", YES);
        }else{
            qrCode(codelUrl, @"requested", NO);
        }
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
    }];
}

-(void)showNoticeView:(NSString*)title {
    if (IsNilOrNull(title)){
        return;
    }
    if (self.viewNetError && !self.viewNetError.visible) {
        self.viewNetError.textLabel.text = title;
        [self.viewNetError showInView:[UIApplication sharedApplication].keyWindow];
        [self.viewNetError dismissAfterDelay:1.5f];
    }
}

/**
 推广工具名字数组
 
 @param type 用户类型
 @return 名字数组
 */
+ (NSArray*)userSchemeToolTitleArray:(NSString*)type {

    if ([type isEqualToString:@"D"]) {//分销
        return @[@"二维码",@"店铺链接",@"分享"];
    }else{//创客或者未登录
        return @[@"二维码", @"邀请码", @"店铺链接", @"分享"];
    }
    
   
}

/**
 推广工具图标数组
 
 @param type 用户类型
 @return 名字数组
 */
+ (NSArray*)userSchemeToolIconArray:(NSString*)type {
    if ([type isEqualToString:@"D"]) {//分销
        return @[@"mineqrcode", @"minecopy", @"mineshare"];
    }else{//创客或者未登录
        return @[@"mineqrcode", @"mineinvitecode", @"minecopy", @"mineshare"];
    }
}

/**
 必备工具名字数组
 
 @param type 用户类型
 @return 名字数组
 */
+ (NSArray*)userUsefulToolTitleArray:(NSString*)type showCoupon:(BOOL)showCoupon {
    if (showCoupon) {
        if ([type isEqualToString:@"D"]) {//分销
            return @[@"我的云豆", @"我的产品库", @"我要自提", @"商品管理", @"小窍门", @"地址管理", @"素材中心", @"线下体验店", @"优惠券统计", @"在线客服", @"通知", @"帮助", @"设置"];
        }else if([type isEqualToString:@"TG"]){//推广人
            return @[@"资金管理", @"素材中心", @"线下体验店", @"在线客服", @"通知", @"帮助", @"设置"];
        }else{//创客或者未登录
            return @[@"礼包销售", @"我的云豆", @"我的产品库", @"我要自提", @"商品管理", @"小窍门", @"地址管理", @"素材中心", @"线下体验店", @"我的业绩", @"优惠券统计", @"在线客服", @"通知", @"帮助", @"设置"];
        }
    }else{
        if ([type isEqualToString:@"D"]) {//分销
            return @[@"我的云豆", @"我的产品库", @"我要自提", @"商品管理", @"小窍门", @"地址管理", @"素材中心", @"线下体验店", @"在线客服", @"通知", @"帮助", @"设置"];
        }else if([type isEqualToString:@"TG"]){//推广人
            return @[@"资金管理", @"素材中心", @"线下体验店", @"在线客服", @"通知", @"帮助", @"设置"];
        }else{
            return @[@"礼包销售", @"我的云豆", @"我的产品库", @"我要自提", @"商品管理", @"小窍门", @"地址管理", @"素材中心", @"线下体验店", @"我的业绩", @"在线客服", @"通知", @"帮助", @"设置"];
        }
    }
}

/**
 必备工具图标数组
 
 @param type 用户类型
 @return 名字数组
 */
+ (NSArray*)userUsefulToolIconArray:(NSString*)type showCoupon:(BOOL)showCoupon {
    if (showCoupon) {
        if ([type isEqualToString:@"D"]) {//分销
            return @[@"mineyundou", @"myproduct", @"minetakeself", @"minegoosmanage", @"smalltips",  @"mineaddressmanage", @"mysource", @"mineoflineshop", @"myCoupon", @"customerservice", @"通知", @"apphelp", @"minesetup"];
        }else if([type isEqualToString:@"TG"]){//推广人
            return @[@"tgmoneymanage", @"mysource", @"mineoflineshop", @"customerservice", @"通知", @"apphelp", @"minesetup"];
        }else{
            return @[@"buydlb", @"mineyundou", @"myproduct", @"minetakeself", @"minegoosmanage", @"smalltips", @"mineaddressmanage", @"mysource", @"mineoflineshop", @"myresults", @"myCoupon", @"customerservice", @"通知",  @"apphelp", @"minesetup"];
        }
    }else{
        if ([type isEqualToString:@"D"]) {//分销
            return @[@"mineyundou", @"myproduct", @"minetakeself", @"minegoosmanage", @"smalltips",  @"mineaddressmanage", @"mysource", @"mineoflineshop", @"customerservice", @"通知", @"apphelp", @"minesetup"];
            
        }else if([type isEqualToString:@"TG"]){//推广人
            return @[@"tgmoneymanage", @"mysource", @"mineoflineshop", @"customerservice", @"通知", @"apphelp", @"minesetup"];
        }else{
            return @[@"buydlb", @"mineyundou", @"myproduct", @"minetakeself", @"minegoosmanage", @"smalltips", @"mineaddressmanage", @"mysource", @"mineoflineshop", @"myresults", @"customerservice", @"通知", @"apphelp", @"minesetup"];
        }
    }
}


@end
