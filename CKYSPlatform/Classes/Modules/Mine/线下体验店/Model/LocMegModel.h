//
//  LocMegModel.h
//  yingzi_iOS
//
//  Created by zhdd on 16/2/16.
//  Copyright © 2016年 lyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocMegModel : NSObject

/**
 *  省
 */
@property(nonatomic, copy) NSString *provinceStr;
/**
 *  市
 */
@property(nonatomic, copy) NSString *City;

/**
 *  国家
 */
@property(nonatomic, copy) NSString *Country;

/**
 *  国家编码
 */
@property(nonatomic, copy) NSString *CountryCode;
/**
 *  区
 */
@property(nonatomic, copy) NSString *districtStr;
/**
 *  街道名
 */
@property(nonatomic, copy) NSString *Name;
/**
 *  街道
 */
@property(nonatomic, copy) NSString *Street;
/**
 *  火星地址
 */
@property(nonatomic, copy) NSString *FormattedAddressLines;


/**
 *  门牌号
 */
@property(nonatomic, copy) NSString *streetNum;

/**
 *  详细地址
 */
@property(nonatomic, copy) NSString *sematicDescription;


/**
 *  地址
 */
@property(nonatomic, copy) NSString *addressStr;

/**
 *  商圈名称
 */
@property(nonatomic, copy) NSString *businessCircle;
/**
 *  纬度
 */
@property(nonatomic, assign) float latitude;
/**
 *  经度
 */
@property(nonatomic, assign) float longitude;

/**
 *
 */
@property(nonatomic, copy) NSString *State;
/**
 *
 */
@property(nonatomic, copy) NSString *SubLocality;
/**
 *
 */
@property(nonatomic, copy) NSString *SubThoroughfare;
/**
 *
 */
@property(nonatomic, copy) NSString *Thoroughfare;


@end
