//
//  OfflineShopViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/8.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "OfflineShopViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BaiduMapAPI_Base/BMKTypes.h>


#import "OffLineProvinceController.h"
#import "LocMegModel.h"
#import "JXMapNavigationView.h" //选择导航的方式
#import "GlobalResource.h"
#import "RouteView.h"
#import "CLLocation+YCLocation.h"
#import "PHXCustomPaoPaoView.h"
#import "MyAnnotation.h"
#import "WebDetailViewController.h"

#import "CKMapManager.h"

@interface OfflineShopViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,RouteViewDelegate>
{

   int curPage;
    
   UIButton *cityButton;
   UILabel *_currentCityLable;
    
   double annotationLatitude;
   double annotationLongitude;
    
    CLLocationCoordinate2D coordinate2D;
    RouteView *_routeView;
    PHXCustomPaoPaoView *_paopaoView;
    
    CLLocation *_cllocation;
    CLGeocoder *_CLGcoder;
}
@property(nonatomic,copy)BMKLocationService *locationService;
@property (nonatomic, strong)JXMapNavigationView *mapNavigationView;
@property(nonatomic,strong)LocMegModel *localModel;
@property(nonatomic,strong)BMKMapView * mapView;
@property(nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property(nonatomic,strong)BMKAddressComponent* addressDetail;
@property(nonatomic,strong)UILabel *currentCityLable;
@property(nonatomic,strong)MyAnnotation *myannotationModel;
@end

@implementation OfflineShopViewController
- (LocMegModel *)localModel
{
    if (!_localModel) {
        _localModel = [[LocMegModel alloc] init];
    }
    return _localModel;
}
- (JXMapNavigationView *)mapNavigationView{
    if (_mapNavigationView == nil) {
        _mapNavigationView = [[JXMapNavigationView alloc]init];
    }
    return _mapNavigationView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    [_mapView viewWillAppear];
     _mapView.delegate = self; // 不用时，置nil
    _geoCodeSearch.delegate = self; // 不用时，置nil
    _locationService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _geoCodeSearch.delegate = nil; // 不用时，置nil
    _locationService.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"体验店";
    
    //    //百度地图处理
    [CKMapManager manager];
    
    [CKCNotificationCenter addObserver:self selector:@selector(transName:) name:@"offlinereturn" object:nil];
    [self createMapView];
    //创建UI
    [self createTopAndBottomViews];
    [self createBMKMapLocation];

    [self getShopListData];
    if (IsNilOrNull(self.cityString)) {
        self.cityString = @"";
    }else{
        _currentCityLable.text = self.cityString;
    }
    
    [self popUpRouteView];
}

#pragma mark-展示地图上的大头针
-(void)showShopListAanatationDataWithArray:(NSMutableArray *)listArr{
    [self.mapView addAnnotations:listArr];
    //正向地理编码获取到经纬度
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= self.provinceString;
    if (IsNilOrNull(self.cityString)) {
        self.cityString = self.provinceString;
    }
    geocodeSearchOption.address = self.cityString;
    BOOL flag = [_geoCodeSearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

-(void)getShopListData{
    [self.shopListArray removeAllObjects];
   
    NSString *province = [KUserdefaults objectForKey:@"provinceStr"];
    
    if (IsNilOrNull(province)) {
        province = @"陕西省";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }

    NSString *shopListUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getExpShopList_Url];
    if (IsNilOrNull(self.provinceString)) {
        _provinceString = province;
    }
    if (IsNilOrNull(self.cityString)) {
        _cityString = @"";
    }
    NSDictionary *pramaDic = @{@"province":self.provinceString,@"city":self.cityString,DeviceId:uuid};
    [HttpTool postWithUrl:shopListUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        self.provinceString = [NSString stringWithFormat:@"%@",dict[@"province"]];
        self.cityString = [NSString stringWithFormat:@"%@",dict[@"city"]];
        
        NSArray *listArr = dict[@"list"];
        for (NSDictionary *listDic in listArr) {
            _myannotationModel = [[MyAnnotation alloc] init];
            [_myannotationModel setValuesForKeysWithDictionary:listDic];
            
            NSString *lantitudeStr = _myannotationModel.latitude;
            NSString *longitudeStr = _myannotationModel.longitude;
            double lantitude = [lantitudeStr doubleValue];
            double longitude = [longitudeStr doubleValue];
            _myannotationModel.coordinate = CLLocationCoordinate2DMake(lantitude, longitude);
            
            [self.shopListArray addObject:_myannotationModel];
        }
        [self showShopListAanatationDataWithArray:self.shopListArray];
        
        NSLog(@"大头针%@",self.shopListArray);
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
#pragma mark-传回来的城市
-(void)transName:(NSNotification *)notice{
    NSLog(@"选择的城市%@",notice.userInfo);
    NSDictionary *dict = notice.userInfo;
    self.provinceString = [NSString stringWithFormat:@"%@",dict[@"province"]];
    self.cityString = [NSString stringWithFormat:@"%@",dict[@"city"]];
    if (IsNilOrNull(self.cityString)){
        _currentCityLable.text = self.provinceString;
    }else{
       _currentCityLable.text = self.cityString;
    }
    [self getShopListData];

}
/**选择城市  查看路线*/
-(void)createTopAndBottomViews{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,65+NaviAddHeight, SCREEN_WIDTH, 40)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    _currentCityLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [topView addSubview:_currentCityLable];
    [_currentCityLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(20);
    }];
    
    UIImageView *selectedImageView = [[UIImageView alloc] init];
    [topView addSubview:selectedImageView];
    [selectedImageView setImage:[UIImage imageNamed:@"downup"]];
    selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
    [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(13);
        make.bottom.mas_offset(-13);
        make.left.equalTo(_currentCityLable.mas_right).offset(3);
        make.width.mas_offset(20);
    }];
    
    cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:cityButton];
    cityButton.tag = 800;
    [cityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
    [cityButton addTarget:self action:@selector(seeRouteButton) forControlEvents:UIControlEventTouchUpInside];
}
/**选择城市 查看路线*/
-(void)seeRouteButton{
    OffLineProvinceController *controller = [[OffLineProvinceController alloc] init];
    controller.provinceString = self.provinceString;
    controller.currentCityString = _currentCityLable.text;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)createMapView{
    
//    //获取经纬度，编码服务的初始化
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
    _mapView.delegate = self;
    // 设置地图级别
    [_mapView setZoomLevel:13.0f];
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    [self.view addSubview:_mapView];
    
    [_mapView setMinZoomLevel:3.0f];
    [_mapView setMaxZoomLevel:21.0f];
    _mapView.zoomEnabled = YES;
    
    
    self.mapView.mapType = BMKMapTypeStandard;
    _mapView.buildingsEnabled = YES;
    _mapView.gesturesEnabled = YES;
    _mapView.showMapScaleBar =YES;
    _mapView.showsUserLocation = YES;
    
    //指南针位置
    CGPoint pt = CGPointMake(10,50);
    [_mapView setCompassPosition:pt];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}
/**根据anntation生成对应的View*/
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"myannotationId";
    NSLog(@"annotation === %@",NSStringFromClass([annotation class]));
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
    
        // 检查是否有重用的缓存
        MyAnnotation *myannatation = (MyAnnotation *)annotation;
        BMKPinAnnotationView *annotationView = nil;
        // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:myannatation reuseIdentifier:AnnotationViewID];
          
//          ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
            annotationView.image = [UIImage imageNamed:@"annotation"];
        }
        
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
        annotationView.annotation = myannatation;
        // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
        annotationView.canShowCallout = YES;
        // 设置是否可以拖拽
        annotationView.draggable = NO;
        
        NSString *title = myannatation.expname;
        NSString *phoneStr = myannatation.exptel;
    
        float width = 0;
        CGSize nameSize = [title sizeWithFont:MAIN_TITLE_FONT maxSize:CGSizeMake(0, 25)];
        CGSize phoneSize = [phoneStr sizeWithFont:MAIN_TITLE_FONT maxSize:CGSizeMake(0, 25)];
        width = nameSize.width > phoneSize.width ? nameSize.width : phoneSize.width;
        
        _paopaoView = [[PHXCustomPaoPaoView alloc] initWithFrame:CGRectMake(0, 0, width + 45,75) onClick:^(NSInteger buttonTag) {
            [self dealWithTag:buttonTag annotation:myannatation];
            
        }];
        _paopaoView.shopNameLable.text = title;
        _paopaoView.phoneLable.text = phoneStr;

        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:_paopaoView];
        pView.frame = CGRectMake(0, 0,width+45,75);
        pView.layer.cornerRadius = 10;
        ((BMKPinAnnotationView*)annotationView).paopaoView = nil;
        ((BMKPinAnnotationView*)annotationView).paopaoView = pView;
         return annotationView;
        
    }
    return nil;
}
/**选中大头针调用的方法*/
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
    
    annotationLatitude = view.annotation.coordinate.latitude;
    annotationLongitude = view.annotation.coordinate.longitude;
    [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
     MyAnnotation *annotation = view.annotation;
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        NSString *exname = [NSString stringWithFormat:@"%@",annotation.expname];
        NSString *address = [NSString stringWithFormat:@"%@",annotation.address];
        _routeView.addressLable.text = exname;
        _routeView.detailAddressLable.text = address;
        _routeView.hidden = NO;
    }
}
/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    
    [_paopaoView.shopNameLable setTextColor:TitleColor];
    [_paopaoView.phoneLable setTextColor:TitleColor];
    _routeView.hidden = YES;
}
-(void)dealWithTag:(NSInteger)buttonTag annotation:(MyAnnotation *)annotationModel{
    if (buttonTag == 0){
        NSLog(@"%@",annotationModel.credentialpath);
        
        WebDetailViewController *cerVc = [[WebDetailViewController alloc] init];
        cerVc.typeString = @"shopcer";
        cerVc.detailUrl = annotationModel.credentialpath;
        [self.navigationController pushViewController:cerVc animated:YES];
        NSLog(@"点击资质证书");
    }else{
       NSLog(@"点击电话号码");
        NSString *phoneStr = annotationModel.exptel;
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneStr];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"弹出的泡泡view.paopaoView===%@",NSStringFromClass([view.paopaoView class]));
}
/**弹出导航的view*/
-(void)popUpRouteView{

    _routeView = [[RouteView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-90, SCREEN_WIDTH, 90)];
    _routeView.delegate = self;
    _routeView.backgroundColor = [UIColor whiteColor];
    _routeView.hidden = YES;
    [self.view addSubview:_routeView];
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
    NSLog(@"location error");
}
#pragma mark-底部view导航按钮代理方法
-(void)nowToCheckRoute{
    [self startNavi];

}

//发起导航
- (void)startNavi
{
    
    //从目前位置导航到指定地
    NSLog(@"导航的 目的地%@",_routeView.detailAddressLable.text);
    NSString *navAddress = _routeView.detailAddressLable.text;
    
    NSLog(@" 经度%f  纬度%f",annotationLatitude,annotationLongitude);
    [self.mapNavigationView showMapNavigationViewWithtargetLatitude:annotationLatitude targetLongitute:annotationLongitude toName:navAddress];
    [self.view addSubview:_mapNavigationView];
}
///**算路成功后，在回调函数中发起导航，如下：算路成功回调*/
//-(void)routePlanDidFinished:(NSDictionary *)userInfo
//{
//    NSLog(@"算路成功");
//    //路径规划成功，开始导航
//    [BNCoreServices_UI showPage:BNaviUI_NormalNavi delegate:self extParams:nil];
//}

#pragma mark-反地理编码BMKGeoCodeSearchDelegate代理方法
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        self.addressDetail = result.addressDetail;
        self.localModel.businessCircle = result.businessCircle;
        self.localModel.addressStr = result.address;
        self.localModel.sematicDescription = result.sematicDescription;
        self.localModel.latitude = result.location.latitude;
        self.localModel.longitude = result.location.longitude;
    }
}

#pragma mark 正向地理编码 BMKSearchDelegate
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    if (error == BMK_SEARCH_NO_ERROR){
         [self.mapView addAnnotations:self.shopListArray];
        NSLog(@"大头症数量%ld",self.shopListArray.count);
        _mapView.centerCoordinate = result.location;
        self.localModel.addressStr = result.address;
        
        NSLog(@"正向编码纬度 %f  正向编码经度%f 省份%@ 城市%@",result.location.latitude,result.location.longitude,self.provinceString,self.cityString);
        
        BMKCoordinateRegion region;
        region.center.latitude  = result.location.latitude;
        region.center.longitude = result.location.longitude;
        
        if([self.cityString isEqualToString:self.provinceString]){
            region.span.latitudeDelta  = 2;
            region.span.longitudeDelta = 2;
        }else{
            region.span.latitudeDelta  = 0.5;
            region.span.longitudeDelta = 0.5;
        }
        //放大地图到自身的经纬度位置。
        BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
        [self.mapView setRegion:adjustedRegion animated:YES];
    }else{
        //请求失败默认显示的是西安的数据
        self.provinceString = @"陕西省";
        self.cityString = @"陕西省";
        _currentCityLable.text = @"西安市";
        [self getShopListData];
    }
}
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的 poi annotation
    NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
    NSMutableArray *myMutableArray = [array mutableCopy];
    [myMutableArray removeObjectAtIndex:0];
    NSArray *myArray = [myMutableArray copy];
    [_mapView removeAnnotations:myArray];
    if (error == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            item.subtitle = poi.phone;
            [GlobalResource sharedInstance].colorPin = YES;
            [self.mapView addAnnotation:item];
            if(i == 0)
            {
                _mapView.centerCoordinate = poi.pt;
            }
        }
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        
    }
}


/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    
    [_paopaoView.shopNameLable setTextColor:TitleColor];
    [_paopaoView.phoneLable setTextColor:TitleColor];
    _routeView.hidden = YES;
}
#pragma mark-定位功能
-(void)createBMKMapLocation{
    //初始化BMKLocationServic
    _locationService = [[BMKLocationService alloc]init];
    _locationService.distanceFilter = 200;//设定定位的最小更新距离，这里设置 200m 定位一次，频繁定位会增加耗电
    _locationService.desiredAccuracy = kCLLocationAccuracyBest;//定位精度
    //启动LocationService
    [_locationService startUserLocationService];
    
    //获取经纬度，编码服务的初始化
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
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
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.mapView updateLocationData:userLocation];
    self.localModel.latitude = userLocation.location.coordinate.latitude;
    self.localModel.longitude = userLocation.location.coordinate.longitude;

    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.localModel.latitude, self.localModel.longitude};
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
- (void)dealloc {
    [CKCNotificationCenter removeObserver:self name:@"offlinereturn" object:nil];
    if (_geoCodeSearch != nil) {
        _geoCodeSearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}



@end
