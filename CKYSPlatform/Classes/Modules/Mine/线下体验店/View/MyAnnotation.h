//
//  MyAnnotation.h
//  地图测试
//
//  Created by zhangjiang on 14/11/10.
//  Copyright (c) 2014年 zhangjiang. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : BMKPointAnnotation
//@interface MyAnnotation : NSObject <BMKAnnotation>

/**体验店id*/
@property(nonatomic,copy)NSString *ID;
/**创客手机号码*/
@property(nonatomic,copy)NSString *ckmobile;
/**创客姓名*/
@property(nonatomic,copy)NSString *ckname;
/**体验店名称*/
@property(nonatomic,copy)NSString *expname;
/**体验店电话*/
@property(nonatomic,copy)NSString *exptel;
/**体验店状态*/
@property(nonatomic,copy)NSString *status;
/**体验店开通时间*/
@property(nonatomic,copy)NSString *opentime;
/**省*/
@property(nonatomic,copy)NSString *province;
/**市*/
@property(nonatomic,copy)NSString *city;
/**详细地址*/
@property(nonatomic,copy)NSString *address;
/**证书url（完整的url）*/
@property(nonatomic,copy)NSString *credentialpath;
/**描述*/
@property(nonatomic,copy)NSString *desc;
/**
 *  纬度
 */
@property(nonatomic,copy)NSString *latitude;
/**
 *  经度
 */
@property(nonatomic,copy)NSString * longitude;

/**区*/
@property(nonatomic,copy)NSString *area;

/**ckid*/
@property(nonatomic,copy)NSString *ckid;
/**no*/
@property(nonatomic,copy)NSString *no;
/**imgpath*/
@property(nonatomic,copy)NSString *imgpath;



@end
