//
//  HeaderModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/12/8.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeaderModel : NSObject
/**新闻id*/
@property(nonatomic,copy)NSString *ID;
/**新闻图片url*/
@property(nonatomic,copy)NSString *imgurl;
/**新闻标题*/
@property(nonatomic,copy)NSString *title;
/**新闻内容*/
@property(nonatomic,copy)NSString *content;
/**新闻时间*/
@property(nonatomic,copy)NSString *time;
/**加载详情url*/
@property(nonatomic,copy)NSString *url;
/**分享url*/
@property(nonatomic,copy)NSString *urlshare;
/**描述信息*/
@property(nonatomic,copy)NSString *info;



@end
