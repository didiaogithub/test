//
//  CityViewController.m
//  MySelectCityDemo
//
//  Created by 李阳 on 15/9/1.
//  Copyright (c) 2015年 WXDL. All rights reserved.
//

#import "OffLineShopCityController.h"
#import "CustomSearchView.h"
#import "ResultCityController.h"
#import "CityTableViewCell.h"
#import "OfflineShopViewController.h"
@interface OffLineShopCityController ()<CustomSearchViewDelegate,ResultCityControllerDelegate>

@property (nonatomic,strong)CustomSearchView *provinceSearchView;//searchBar所在的view
@property (nonatomic,strong)UIView *blackView; //输入框编辑时的黑色背景view
@property (nonatomic,strong)NSMutableArray *dataArray;// cell数据源数组
@property (nonatomic,strong)NSMutableArray *searchArray;//用于搜索的数组
@property (nonatomic,strong)NSMutableArray *pinYinArray; // 地区名字转化为拼音的数组
@property (nonatomic,strong)ResultCityController *resultController;//显示结果的controller


@end

@implementation OffLineShopCityController
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(NSMutableArray *)searchArray{
    if (_searchArray == nil) {
        _searchArray = [[NSMutableArray alloc] init];
    }
    return _searchArray;
}
-(UIView *)blackView
{
    if(!_blackView)
    {
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+50, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _blackView.backgroundColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.6];
        _blackView.alpha = 0;
        [self.view addSubview:_blackView];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectCancelBtn)];
        [_blackView addGestureRecognizer:ges];
    }
    return _blackView;
}
-(ResultCityController *)resultController
{
    if(!_resultController)
    {
        _resultController = [[ResultCityController alloc] init];
        
        _resultController.view.frame = CGRectMake(0, 64+50, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _resultController.delegate = self;
        [self.view addSubview:_resultController.view];
    }
    return _resultController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择城市";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadCityData];
    [self createTableView];
    
}
-(void)createTableView{
    
    if (@available(iOS 11.0, *)) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    }else{
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 44;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    //索引的背景颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.provinceSearchView = [[CustomSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.provinceSearchView.delegate = self;
    _tableView.tableHeaderView  = self.provinceSearchView;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexColor = [UIColor redColor];
    [self.view addSubview:_tableView];
}
-(void)loadCityData
{
    NSString *nameStr = nil;
    if ([self.typeStr isEqualToString:@"0"]){ //通过当前的城市查下级城市
        nameStr = self.provinceStr;
    }else{
       nameStr = [NSString stringWithFormat:@"%@",self.cityModel.name];
    }
    if (IsNilOrNull(nameStr)) {
        nameStr = @"";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"name":nameStr,DeviceId:uuid};
    NSString *cityUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getExpCityList_Url];
    [HttpTool postWithUrl:cityUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
        }
        NSArray *cityArr = dict[@"list"];
        for (NSDictionary *citydict in cityArr) {
            _cityModel = [[SelecteAreaModel alloc] init];
            [_cityModel setValuesForKeysWithDictionary:citydict];
            [self.dataArray addObject:_cityModel];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
#pragma mark --UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *lineLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 49, SCREEN_WIDTH-15, 1)];
    lineLable.backgroundColor = [UIColor tt_lineBgColor];
    [cell addSubview:lineLable];
    
    if ([self.dataArray count]) {
        _cityModel = self.dataArray[indexPath.row];
        cell.textLabel.text = _cityModel.name;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.dataArray count]) {
        _cityModel  = self.dataArray[indexPath.row];
    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if([controller isKindOfClass:[OfflineShopViewController class]]){
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    NSString *provinceString = [NSString stringWithFormat:@"%@",self.provinceStr];
    NSString *cityString = [NSString stringWithFormat:@"%@",_cityModel.name];
    NSDictionary *dict = @{@"province":provinceString,@"city":cityString};
    [CKCNotificationCenter postNotificationName:@"offlinereturn" object:nil userInfo:dict];

}
#pragma mark-开始搜索
-(void)searchBeginEditing
{
    [self.view addSubview:_blackView];

    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _tableView.frame = CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.blackView.alpha = 0.6;
        
    } completion:^(BOOL finished) {

    }];
    [_tableView reloadData];
}
#pragma mark-点击取消搜索按钮
-(void)didSelectCancelBtn
{
    [_blackView removeFromSuperview];
     _blackView = nil;
    [self.resultController.view removeFromSuperview];
    self.resultController=nil;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    
        _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        
        [self.provinceSearchView.searchBar  setShowsCancelButton:NO animated:YES];
        [self.provinceSearchView.searchBar resignFirstResponder];

    } completion:^(BOOL finished) {
    }];
    [_tableView reloadData];
}
#pragma mark-点击搜索按钮
-(void)searchString:(NSString *)string{
    NSLog(@"点击搜索按钮");
    [self.searchArray removeAllObjects];
    if (IsNilOrNull(string)) {
        string = @"";
    }
    NSString *requesUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getsearchExpShop_Url];
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"keywords":string,DeviceId:uuid};
    [HttpTool postWithUrl:requesUrl params:pramaDic success:^(id json) {
        [_blackView removeFromSuperview];
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:@"暂无搜索结果"];
            [self.resultController.tableView reloadData];
            return ;
        }
        NSArray *listArr = dict[@"list"];
        for (NSDictionary *citylistDic in listArr){
            NSArray *citylistArr = citylistDic[@"citylist"];
            for (NSDictionary *cityDict in citylistArr) {
                _cityModel = [[SelecteAreaModel alloc] init];
                [_cityModel setValuesForKeysWithDictionary:cityDict];
                [self.searchArray addObject:_cityModel];
            }
        }
        self.resultController.dataArray = self.searchArray;
        self.resultController.provinceStr = self.provinceStr;
        [self.resultController.tableView reloadData];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];

}
#pragma mark-点击搜索到的市
-(void)didSelectedProVinceString:(NSString *)provinceString andCityStr:(NSString *)cityStr
{
    NSDictionary *dict = @{@"province":provinceString,@"city":cityStr};
    [CKCNotificationCenter postNotificationName:@"offlinereturn" object:nil userInfo:dict];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if([controller isKindOfClass:[OfflineShopViewController class]]){
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

#pragma mark --ResultCityControllerDelegate
-(void)didScroll
{
    [self.provinceSearchView.searchBar resignFirstResponder];
}


@end
