//
//  GiftModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/24.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftModel : NSObject

//选中状态
@property(nonatomic,assign)BOOL isSelect;
/**礼包详情图片*/
@property(nonatomic,strong)NSString *img;
/**礼包编号*/
@property(nonatomic,strong)NSString *giftno;
/**礼包名称*/
@property(nonatomic,strong)NSString *giftname;
/**礼包详情url*/
@property(nonatomic,strong)NSString *giftdetail;


@end
