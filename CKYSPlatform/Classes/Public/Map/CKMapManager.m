//
//  CKMapManager.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/12.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKMapManager.h"
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "MyAnnotation.h"
#import "LocMegModel.h"

@interface CKMapManager()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKMapManager *mapManager;
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) LocMegModel *locModel;
@property (nonatomic, copy)   NSString *currentCityStr;
@property (nonatomic, copy)   NSString *currentProvinceStr;
@property (nonatomic, strong) MyAnnotation *myanotationModel;

@end

@implementation CKMapManager

-(LocMegModel *)locModel{
    if (_locModel == nil) {
        _locModel = [[LocMegModel alloc] init];
    }
    return _locModel;
}

-(NSMutableArray *)annotationsArray{
    if (_annotationsArray == nil) {
        _annotationsArray = [[NSMutableArray alloc] init];
    }
    return _annotationsArray;
}

-(instancetype)initPrivate {
    if (self = [super init]) {
        [self startBaiduMap];
    }
    return self;
}

+(instancetype)manager {
    static CKMapManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CKMapManager alloc] initPrivate];
    });
    return instance;
}

-(void)startBaiduMap{
    //启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BMK_APPKEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
//    [self.window addSubview:navigationController.view];
    [self createBMKMapLocation];
    
}

#pragma mark-定位功能
-(void)createBMKMapLocation{
    //初始化BMKLocationServic
    _locationService = [[BMKLocationService alloc]init];
    _locationService.delegate = self;
    _locationService.distanceFilter = 200;//设定定位的最小更新距离，这里设置 200m 定位一次，频繁定位会增加耗电
    _locationService.desiredAccuracy = kCLLocationAccuracyBest;//定位精度
    //启动LocationService
    [_locationService startUserLocationService];
    
    //获取经纬度，编码服务的初始化
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
}
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //大头针摆放的坐标，必须从这里进行赋值，否则取不到值 ，这里可能涉及到委托方法执行顺序的问题
    CLLocationCoordinate2D coor;
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"appdelegatelat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    self.locModel.latitude = userLocation.location.coordinate.latitude;
    self.locModel.longitude = userLocation.location.coordinate.longitude;
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){self.locModel.latitude, self.locModel.longitude};
    [self getReverseLocationWith:pt];
    
}
-(void)getReverseLocationWith:(CLLocationCoordinate2D)coordinate{
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag) {
        NSLog(@"反geo检索发送成功");
    }else {
        NSLog(@"反geo检索发送失败");
    }
    //定位一次完后，停止定位
    self.locationService.delegate = nil;
}
/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位失败%@",error.localizedDescription);
}
#pragma mark-反地理编码BMKGeoCodeSearchDelegate代理方法
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    NSLog(@"错误码%d",error);
    if (error == BMK_SEARCH_NO_ERROR) {
        self.currentCityStr = result.addressDetail.city;
        self.currentProvinceStr = result.addressDetail.province;
        self.locModel.City = result.addressDetail.city;
        self.locModel.provinceStr = result.addressDetail.province;
        self.locModel.Name = result.addressDetail.streetName;
        self.locModel.businessCircle = result.businessCircle;
        self.locModel.addressStr = result.address;
        self.locModel.sematicDescription = result.sematicDescription;
        self.locModel.latitude = result.location.latitude;
        self.locModel.longitude = result.location.longitude;
        NSLog(@"定位当前城市%@",self.locModel.addressStr);
        
        [KUserdefaults setObject:self.locModel.provinceStr forKey:@"provinceStr"];
        
        [self getShopListData];
        
    }
}

#pragma mark-请求体验店数据
-(void)getShopListData{
    [self.annotationsArray removeAllObjects];
    NSString *shopListUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getExpShopList_Url];
    if (IsNilOrNull(self.currentProvinceStr)) {
        _currentProvinceStr = @"陕西省";
    }
    if (IsNilOrNull(self.currentCityStr)) {
        _currentCityStr = @"西安市";
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSDictionary *pramaDic = @{@"province":self.currentProvinceStr,@"city":self.currentCityStr,DeviceId:uuid};
    [HttpTool postWithUrl:shopListUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        _currentProvinceStr = [NSString stringWithFormat:@"%@",dict[@"province"]];
        _currentCityStr = [NSString stringWithFormat:@"%@",dict[@"city"]];
        
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            NSLog(@"大头针数组请求失败");
            return ;
        }
        NSArray *listArr = dict[@"list"];
        for (NSDictionary *listDic in listArr) {
            _myanotationModel = [[MyAnnotation alloc] init];
            [_myanotationModel setValuesForKeysWithDictionary:listDic];
            NSString *lantitudeStr = _myanotationModel.latitude;
            NSString *longitudeStr = _myanotationModel.longitude;
            double lantitude = [lantitudeStr doubleValue];
            double longitude = [longitudeStr doubleValue];
            _myanotationModel.coordinate = CLLocationCoordinate2DMake(lantitude, longitude);
            [self.annotationsArray addObject:_myanotationModel];
        }
        NSLog(@"大头针%@",self.annotationsArray);
    } failure:^(NSError *error) {
        NSLog(@"大头针数组网络请求超时，请刷新重试");
        
    }];
    
    [KUserdefaults setObject:self.currentCityStr forKey:@"currentCityStr"];
    [KUserdefaults setObject:self.currentProvinceStr forKey:@"currentProvinceStr"];

}

-(void)dealloc{
    if(_geoCodeSearch != nil){
        _geoCodeSearch = nil;
    }
}

@end
