//
//  NSString+Common.m
//  yingzi_iOS
//
//  Created by liyongwei on 15/7/31.
//  Copyright (c) 2015年 lyw. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

/**
 *  数字字符串加入逗号位数分隔
 */
+ (NSString *)countNumAndChangeformat:(NSString *)num
{
    NSString *firstStr = @"";
    NSString *lastStr = @"";
    if ([num containsString:@"."]) {
        NSArray *arr = [num componentsSeparatedByString:@"."];
        firstStr = [arr firstObject];
        lastStr = [arr lastObject];
    }else{
        firstStr = num;
    }
    
    int count = 0;
    long long int a = firstStr.longLongValue;
    while (a != 0) {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:firstStr];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    
    NSString *resStr = @"";
    if (![lastStr isEqualToString:@""]) {
        resStr = [NSString stringWithFormat:@"%@.%@",newstring,lastStr];
    }else{
        resStr = newstring;
    }
    return resStr;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        resultSize = [self boundingRectWithSize:size
                                        options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                     attributes:@{NSFontAttributeName: font}
                                        context:nil].size;
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        resultSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
#endif
    }
    resultSize = CGSizeMake(MIN(size.width, ceilf(resultSize.width)), MIN(size.height, ceilf(resultSize.height)));
    return resultSize;
}

//内连，使用情况较多下使用，

//static inline NSString * GetUUIDString()
//
//{
//    CFUUIDRef uuidObj = CFUUIDCreate(nil);
//
//    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
//
//    CFRelease(uuidObj);
//
//    return uuidString;
//
//}


// 获取uuid的类方法，建议新建NSString的分类使用，

//NSUUID *udid = [[UIDevice currentDevice] identifierForVendor];//获取设备的udid
+ (NSString*) getUUIDString
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    
    return uuidString;
}


// 获取字符串的长度    高度固定
+(CGFloat)countLength:(NSString*)text  withFont:(UIFont*) font{
    CGRect frame = CGRectMake(0, 0, 200, 200);
    CGRect newframe = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    CGFloat lenth = newframe.size.width;
    return lenth;
}
//字符串是否包某字符
+ (BOOL)string:(NSString*) stringg isContantStr:(NSString*)str
{
    //判断roadTitleLab.text 是否含有qingjoin
    if([stringg rangeOfString:str].location !=NSNotFound)//_roaldSearchText
    {
        return YES;
    }
    else
    {
        return NO;
    }

}
// 判断 是否是 email
+ (BOOL)isEmail:(NSString *)email
{
//    NSString *number= @"^(([0-9a-zA-Z]+)|([0-9a-zA-Z]+[_.0-9a-zA-Z-]*[0-9a-zA-Z]+))@([a-zA-Z0-9-]+[.])+([a-zA-Z]{2}|net|NET|com|COM|gov|GOV|mil|MIL|org|ORG|edu|EDU|int|INT)$";
//    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
//    return [numberPre evaluateWithObject:email];
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 判断 是否是 mobile
+ (BOOL)isMobile:(NSString *)mobile
{
//    NSString *number = @"^((13[0-9])|(15[^4])|(16[0-9])|(18[0-9])|(19[0-9])|(17[0-8])|(14[5,7]))\\d{8}$";
    NSString *number = @"^(1[3|4|5|6|7|8|9])\\d{9}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    return [numberPre evaluateWithObject:mobile];
}

// 判断 是否是 座机号码
+ (BOOL)isLandlineTelephone:(NSString *)telephone
{
    
    //验证输入的固话中不带 "-"符号
//    NSString * strNum = @"^(0[0-9]{2,3})?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$)";
    
    //验证输入的固话中带 "-"符号
    
    NSString * strNum = @"^(0[0-9]{2,3}-)?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$)";
    NSPredicate *predicateNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strNum];
    return [predicateNumber evaluateWithObject:telephone];
}

//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

// 判断 是否是 testCode
+ (BOOL)isPinCode:(NSString *)testCode
{
    NSString *number = @"^[0-9]{6}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:testCode];
}
+ (BOOL)isPassWord:(NSString *)passWord
{
    NSString *number = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:passWord];
}
// 验证价格是否格式正确
+ (BOOL)isCheckPrice:(NSString *)price
{
    if (price == nil || [price isEqualToString:@""]){
        return NO;
    }
    
    NSString *exp1 = @"^[1-9][0-9]{0,7}";
    NSString *exp2 = @"^[1-9][0-9]{0,7}[.][0-9]{1,2}";
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", exp1];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", exp2];
    
    if ([predicate1 evaluateWithObject:price] || [predicate2 evaluateWithObject:price])
    {
        return YES;
    }
    
    return NO;
}

// 验证登录名是否由6-20位字母或数字组成
+ (BOOL)isCheckLoginUserName:(NSString *)userName
{
    if (userName == nil || [userName isEqualToString:@""]){
        return NO;
    }
    
    NSString *exp1 = @"^[A-Za-z0-9]{6,20}$";
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", exp1];
    
    if ([predicate1 evaluateWithObject:userName])
    {
        return YES;
    }
    
    return NO;
}

// 验证搜索的用户名是否为字母与数字组成 不超过20位
+ (BOOL)isCheckSearchUserName:(NSString *)userName
{
    if (userName == nil || [userName isEqualToString:@""]){
        return NO;
    }
    
    NSString *exp1 = @"^[A-Za-z0-9]{1,20}$";
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", exp1];
    
    if ([predicate1 evaluateWithObject:userName])
    {
        return YES;
    }
    return NO;
}


//换行
+ (NSString *)changeResponsibilityAndReqireMent:(NSString *)str
{
    NSString * resStr;
    BOOL isContaint = [NSString string:str isContantStr:@"<br/>"];
    if (isContaint) {
        resStr = [str stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    }else{
        return str;
    }
    return resStr;
}

//只输入数字
+ (BOOL)validateNumber:(NSString *)number{
    
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:number];
}

+(NSString *)reviseString:(NSString *)string{
    
    /** 直接传入精度丢失有问题的Double类型*/
    double conversionValue        = (double)[string floatValue];
    NSString *doubleString        = [NSString stringWithFormat:@"%.2f",conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}
/**检测是否合法的银行卡号*/
+ (BOOL)isCheckCardNo:(NSString*)cardNumber{
    if(cardNumber.length==0){
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++){
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c)){
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--){
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo){
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}
+(BOOL)checkCardNo:(NSString*)cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}


- (NSString *)VerticalString{
    NSMutableString * str = [[NSMutableString alloc] initWithString:self];
    NSInteger count = str.length;
    for (int i = 1; i < count; i ++) {
        [str insertString:@"\n" atIndex:i*2 - 1];
    }
    return str;
}


+(NSMutableAttributedString *)attributedStrWthStr:(NSString *)commonStr{
    NSRange range = {0,1};
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:commonStr];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    
    return AttributedStr;
}

+(NSString *)loadImagePathWithString:(NSString *)string{
    NSString *headPath = @"";
    //如果传过来的字符串为空  没有图片
    if (IsNilOrNull(string)){
        return headPath;
    }
    if ([string hasPrefix:@"http"] || [string hasPrefix:@"https"]){
        headPath = string;
    }else{
        headPath = [BaseImagestr_Url stringByAppendingString:string];
    }
    return headPath;
}

#pragma makk-清除web缓存
+(void)deleteWebCache{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        
//        NSSet *websiteDataTypes
//        
//        = [NSSet setWithArray:@[
//                                
//                                WKWebsiteDataTypeDiskCache,
//                                
//                                //WKWebsiteDataTypeOfflineWebApplicationCache,
//                                
//                                WKWebsiteDataTypeMemoryCache,
//                                
//                                //WKWebsiteDataTypeLocalStorage,
//                                
//                                //WKWebsiteDataTypeCookies,
//                                
//                                //WKWebsiteDataTypeSessionStorage,
//                                
//                                //WKWebsiteDataTypeIndexedDBDatabases,
//                                
//                                //WKWebsiteDataTypeWebSQLDatabases
//                                
//                                ]];
        
        // All kinds of data
        
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        // Date from
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        //// Execute
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            // Done
            NSLog(@"清除wkwebview缓存");
            
        }];
        
    } else {

        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        
    }
    
}
+(NSString *)getCurrentVersionStr{
    //获取项目版本号
    NSString *localversionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return localversionStr;
}

+(NSString *)getCurrentVersionAndDeviceType{
    //获取项目版本号和设备类型的拼接
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"ios%@", version];
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

@end
