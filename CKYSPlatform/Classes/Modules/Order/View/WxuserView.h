//
//  WxuserView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/5/12.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WxuserView : UIView
@property(nonatomic,strong)UILabel *priceLable;
@property(nonatomic,strong)UILabel *orderTimeLable;
-(instancetype)initWithFrame:(CGRect)frame andTypeStr:(NSString *)typeStr;
@end
