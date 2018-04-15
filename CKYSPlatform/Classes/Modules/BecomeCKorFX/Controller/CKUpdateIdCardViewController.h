//
//  CKUpdateIdCardViewController.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/14.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^CerUrlBlock)(NSString *handImgUrl, NSString *frontImgUrl, NSString *backImgUrl);

@interface CKUpdateIdCardViewController : BaseViewController

/**手持身份证*/
@property (nonatomic, copy) NSString *handimgfile;
/**身份证正面*/
@property (nonatomic, copy) NSString *frontimgfile;
/**身份证反面*/
@property (nonatomic, copy) NSString *backimgfile;

@property (nonatomic, copy) CerUrlBlock cerBlock;

-(void)setCerBlock:(CerUrlBlock)cerBlock;

@end
