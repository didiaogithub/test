//
//  DefaultValue.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "DefaultValue.h"

@implementation DefaultValue

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        
    }
    return self;
}

+(instancetype)shareInstance {
    static DefaultValue *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[DefaultValue alloc] initPrivate];
    });
    return instance;
}


-(id)getDefaultValue:(NSString*)key {
    
    id value = [KUserdefaults objectForKey:key];
    if (IsNilOrNull(value)) {
         value = [self getDefaultObjectWithKey:key];
    }

    return value;
}

-(void)setDefaultValue:(NSString*)value forKey:(NSString*)key {
    //获取路径
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"CKDefaultValue.plist"];
    //所有的数据列表
    NSMutableDictionary *datalist= [[[NSMutableDictionary alloc]initWithContentsOfFile:filepath]mutableCopy];
    
    [datalist setValue:value forKey:key];
    [datalist writeToFile:filepath atomically:YES];
    NSLog(@"修改成功");
}

-(void)paymentAvaliable:(NSString*)value forKey:(NSString*)key {
    //获取路径
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"CKDefaultValue.plist"];
    //所有的数据列表
    NSMutableDictionary *datalist= [[[NSMutableDictionary alloc]initWithContentsOfFile:filepath]mutableCopy];
    NSDictionary *paymentMethod = [datalist objectForKey:@"PayMethod"];
    if ([value isEqualToString:@"0"]) {
        [paymentMethod setValue:@"NO" forKey:key];
    }else if ([value isEqualToString:@"1"]){
        [paymentMethod setValue:@"YES" forKey:key];
    }
    [datalist setValue:paymentMethod forKey:@"PayMethod"];
    [datalist writeToFile:filepath atomically:YES];
    NSLog(@"修改成功:%@", datalist);
}

-(id)getDefaultObjectWithKey:(NSString*)key {
    //获取路径
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"CKDefaultValue.plist"];
    //所有的数据列表
    NSMutableDictionary *datalist= [[[NSMutableDictionary alloc]initWithContentsOfFile:filepath]mutableCopy];
    return [datalist objectForKey:key];
}

-(void)defaultValue {
    
    NSArray *sandboxpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[sandboxpath objectAtIndex:0] stringByAppendingPathComponent:@"CKDefaultValue.plist"];
    NSMutableDictionary *datalist= [[[NSMutableDictionary alloc]initWithContentsOfFile:filePath]mutableCopy];
    
    //如果是升级后的，那么版本号如果大于3.0.3，那么就要设置默认值
//    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    
//    NSString *lastVersion = [KUserdefaults objectForKey:CKLastVersionKey];
//    if (IsNilOrNull(lastVersion) || [currentVersion compare:@"3.0.3"] == NSOrderedDescending) {
//        
//    }
    
    
    if (datalist == nil) {
        NSArray *sandboxpath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsDirectory = [sandboxpath objectAtIndex:0];
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"CKDefaultValue.plist"];
        //存储根数据
        NSMutableDictionary *rootDic = [[NSMutableDictionary alloc ] init];
       
        //字典中的详细数据
        NSString *domainName = (AppEnvironment == 0)? @"http://testofflineckysappserver.ckc8.com/": @"http://ckysappserver.ckc8.com/";
        NSString *domainNamePay = (AppEnvironment == 0)? @"http://testofflineckyspb.ckc8.com/":@"http://ckyspb.ckc8.com/";
        NSString *domainNameRes = (AppEnvironment == 0)?@"http://testofflineckysre.ckc8.com/ckc3/":@"http://ckysre.ckc8.com/ckc3/";
        NSString *baseImagestr = (AppEnvironment == 0)?@"http://testofflineckysre.ckc8.com/ckc3/Uploads/":@"http://ckysre.ckc8.com/ckc3/Uploads/";
        NSString *domainSmsMessage = (AppEnvironment == 0)?@"http://testofflineckysmsg.ckc8.com/":@"http://ckysmsg.ckc8.com/";
        NSString *domainNameUnionPay = (AppEnvironment == 0)?@"http://testofflineckyspb.ckc8.com/":@"http://ckyspb.ckc8.com/";
        
        [rootDic setObject:domainName forKey:@"domainName"];
        [rootDic setObject:domainNamePay forKey:@"domainNamePay"];
        [rootDic setObject:domainNameRes forKey:@"domainNameRes"];
        [rootDic setObject:baseImagestr forKey:@"domainImgRegetUrl"];
        [rootDic setObject:domainSmsMessage forKey:@"domainSmsMessage"];
        [rootDic setObject:domainNameUnionPay forKey:@"domainNameUnionPay"];
        
        NSMutableDictionary *payMethod = [[NSMutableDictionary alloc]init];
        [payMethod setObject:@"YES" forKey:@"alipay"];
        [payMethod setObject:@"NO" forKey:@"wxpay"];
        [payMethod setObject:@"YES" forKey:@"unionpay"];
        [payMethod setObject:@"NO" forKey:@"applepay"];
        [payMethod setObject:@"YES" forKey:@"jdpay"];

        [rootDic setObject:payMethod forKey:@"PayMethod"];
        
        //写入文件
        [rootDic writeToFile:plistPath atomically:YES];
        NSLog(@"%@",NSHomeDirectory());
        NSLog(@"写入成功");
        
        //消息提示默认值
        SetObjectForKey(@"当前网络不可用，请检查你的网络设置", @"CKYSmsgnonetwork");
        SetObjectForKey(@"网络不给力，请稍后再试", @"CKYSmsgtimeout");
        SetObjectForKey(@"确定是否转为永久创客？", @"CKYSmsgtransup");
        SetObjectForKey(@"二维码未加载完毕提示", @"CKYSmsgqrcode");
        SetObjectForKey(@"线上支付商品与普通商品不能共同下单，请重新选择", @"CKYSmsgpick");
        //提现金额不得少于x元
        SetObjectForKey(@"500", @"CKYSmsggetmoney");
        SetObjectForKey(@"充值提示", @"CKYSmsgcharge");
        //充值金额不能少于¥
        SetObjectForKey(@"5000", @"CKYSmsgchargeCK");
        //充值金额不能少于¥
        SetObjectForKey(@"2000", @"CKYSmsgchargeFX");
        //转出金额不得低于
        SetObjectForKey(@"5000", @"CKYSmsgBeanToMoneyCK");
        //转出金额不得低于
        SetObjectForKey(@"2000", @"CKYSmsgBeanToMoneyFX");
        SetObjectForKey(@"预售店铺只能选择永久加入", @"CKYSmsgpresale");
        SetObjectForKey(@"店铺状态提示", @"CKYSmsgshopstatus");
        SetObjectForKey(@"您还未完善资料，请前往个人中心完善资料。", @"CKYSmsgshopstatusUpdatePersonalInfo");
        SetObjectForKey(@"您的店铺已在审核中，请您耐心等待！", @"CKYSmsgshopstatusPending");
        SetObjectForKey(@"请联系上级创客开通店铺", @"CKYSmsgshopstatusConnectCKOpen");
        SetObjectForKey(@"您无权查看", @"CKYSmsgshopstatusNoRight");
        SetObjectForKey(@"您的账户已在另一台设备登录,如非本人操作请重新登录!", @"CKYSmsg9001");
        
        //校验提示文字
        SetObjectForKey(@"请输入手机号码", @"CheckMsgPhoneHolder");
        SetObjectForKey(@"请您输入手机号码", @"CheckMsgPhoneNull");
        SetObjectForKey(@"输入的手机号码错误，请重新输入", @"CheckMsgPhoneError");
        SetObjectForKey(@"验证码错误，请重新输入", @"CheckMsgVerificationCodeError");
        SetObjectForKey(@"请输入验证码", @"CheckMsgVerificationCodeNull");
        SetObjectForKey(@"请输入邀请码", @"CheckMsgInviteCodeNull");
        SetObjectForKey(@"邀请码错误，请重新输入", @"CheckMsgInviteCodeError");
        SetObjectForKey(@"两次输入密码不一致，请重新输入", @"CheckMsgPwTwiceError");
        SetObjectForKey(@"请您输入密码", @"CheckMsgPwNull");
        SetObjectForKey(@"请先阅读创客村协议", @"CheckMsgReadProtocolFirst");
        SetObjectForKey(@"请选择收货地址", @"CheckMsgSelectAddrFirst");
        SetObjectForKey(@"请选择开店大礼包", @"CheckMsgSelectGiftFirst");
        SetObjectForKey(@"二维码图片尚未加载完毕，无法保存", @"CheckMsgQRNotLoad");
        SetObjectForKey(@"您输入的手机号码有误", @"CheckMsgContactPhoneError");
        SetObjectForKey(@"请输入您的姓名", @"CheckMsgNameNull");
        SetObjectForKey(@"请选择收货地址", @"CheckMsgAddrNull");
        SetObjectForKey(@"店铺已开通，无法修改", @"CheckMsgCanNotChange");
    }
}

/** 获取所有支付方式*/
-(NSArray*)getAllPaymentMethod {
    NSDictionary *payMethod = [self getDefaultObjectWithKey:@"PayMethod"];
    return payMethod.allKeys;
}
/** 获取可用的支付方式*/
-(NSArray*)getAvailablePaymentMethod {
    
    NSMutableArray *values = [NSMutableArray array];
    NSDictionary *payMethod = [self getDefaultObjectWithKey:@"PayMethod"];
    for (NSString *keyStr in payMethod.allKeys) {
        NSString *valueStr = [payMethod objectForKey:keyStr];
        if ([valueStr isEqualToString:@"YES"]) {
            [values addObject:keyStr];
        }
    }
    return values;
}

/**域名*/
-(NSString*)domainName {
    NSString *keyStr = @"domainName";
    return [self getDefaultValue:keyStr];
}
/**微信支付宝支付服务*/
-(NSString*)domainNamePay {
    NSString *keyStr = @"domainNamePay";
    return [self getDefaultValue:keyStr];
}

/**银联支付服务*/
-(NSString*)domainNameUnionPay {
    NSString *keyStr = @"domainNameUnionPay";
    return [self getDefaultValue:keyStr];
}

/**消息服务*/
-(NSString*)domainSmsMessage {
    NSString *keyStr = @"domainSmsMessage";
    return [self getDefaultValue:keyStr];
}
/**上传图片资源路径*/
-(NSString*)domainNameRes {
    NSString *keyStr = @"domainNameRes";
    return [self getDefaultValue:keyStr];
}

/**下载图片资源路径*/
-(NSString*)baseImagestr {
    NSString *keyStr = @"domainImgRegetUrl";
    return [self getDefaultValue:keyStr];
}

-(void)resetDefaultDomain {
    
    NSString *domainName = (AppEnvironment == 0)? @"http://testofflineckysappserver.ckc8.com/": @"http://ckysappserver.ckc8.com/";
    NSString *domainNamePay = (AppEnvironment == 0)? @"http://testofflineckyspb.ckc8.com/":@"http://ckyspb.ckc8.com/";
    NSString *domainNameRes = (AppEnvironment == 0)?@"http://testofflineckysre.ckc8.com/ckc3/":@"http://ckysre.ckc8.com/ckc3/";
    NSString *baseImagestr = (AppEnvironment == 0)?@"http://testofflineckysre.ckc8.com/ckc3/Uploads/":@"http://ckysre.ckc8.com/ckc3/Uploads/";
    NSString *domainSmsMessage = (AppEnvironment == 0)?@"http://testofflineckysmsg.ckc8.com/":@"http://ckysmsg.ckc8.com/";
    NSString *domainNameUnionPay = (AppEnvironment == 0)?@"http://testofflineckyspb.ckc8.com/":@"http://ckyspb.ckc8.com/";
    
    [self setDefaultValue:domainName forKey:@"domainName"];
    [self setDefaultValue:domainNamePay forKey:@"domainNamePay"];
    [self setDefaultValue:domainNameRes forKey:@"domainNameRes"];
    [self setDefaultValue:baseImagestr forKey:@"domainImgRegetUrl"];
    [self setDefaultValue:domainSmsMessage forKey:@"domainSmsMessage"];
    [self setDefaultValue:domainNameUnionPay forKey:@"domainNameUnionPay"];
}

@end
