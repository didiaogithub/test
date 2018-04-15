//
//  CityViewController.m
//  MySelectCityDemo
//
//  Created by 李阳 on 15/9/1.
//  Copyright (c) 2015年 WXDL. All rights reserved.
//

#import "OffLineProvinceController.h"
#import "CustomSearchView.h"
#import "ResultCityController.h"
#import "CityTableViewCell.h"
#import "OffLineShopCityController.h"
#import "SelecteAreaModel.h"
#import "CurrentTableViewCell.h"


@interface OffLineProvinceController ()<CustomSearchViewDelegate,ResultCityControllerDelegate>
{
    NSString  *_provinceStr;
}
@property(nonatomic,strong)SelecteAreaModel *provinceModel;
@property (nonatomic,strong)CustomSearchView *provinceSearchView;//searchBar所在的view
@property (nonatomic,strong)UIView *blackView; //输入框编辑时的黑色背景view
@property (nonatomic,strong)NSMutableArray *dataArray;// cell数据源数组
@property (nonatomic,strong)NSMutableArray *searchArray;//用于搜索的数组
@property (nonatomic,strong)NSMutableArray *pinYinArray; // 地区名字转化为拼音的数组
@property (nonatomic,strong)ResultCityController *resultController;//显示结果的controller

@end

@implementation OffLineProvinceController
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
    self.navigationItem.title = @"选择省份";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadProvinceData];
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
    
    self.provinceSearchView = [[CustomSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.provinceSearchView.delegate = self;
    _tableView.tableHeaderView  = self.provinceSearchView;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}
-(void)loadProvinceData
{
    //   地区类型（0：省   1：市 ）
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"name":@"",DeviceId:uuid};
    NSString *provinceUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getExpCityList_Url];
    [HttpTool postWithUrl:provinceUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
        }
        NSArray *areaList = dict[@"list"];
        for (NSDictionary *listdict in areaList) {
            _provinceModel = [[SelecteAreaModel alloc] init];
            [_provinceModel setValuesForKeysWithDictionary:listdict];
            [self.dataArray addObject:_provinceModel];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        if([self.dataArray count]){
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            _tableView.separatorColor = [UIColor tt_lineBgColor];
            return self.dataArray.count;
        }else{
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
    }else{
        return 1;
    }

    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *HeaderIdentifier = @"header";
    if (section == 1){
        UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
        if( headerView == nil)
        {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
            UILabel * titleLabel = [[UILabel alloc] init];
            titleLabel.tag = 1;
            titleLabel.textColor = [UIColor tt_monthGrayColor];
            [headerView.contentView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_offset(0);
                make.left.mas_offset(AdaptedWidth(10));
            }];
        }

        headerView.contentView.backgroundColor = [UIColor clearColor];
        UILabel *label = (UILabel *)[headerView viewWithTag:1];
        label.font = MAIN_TITLE_FONT;
        label.text = @"定位省份";
        return headerView;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 50;
    }else{
        return 70;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
       return 40;
    }else{
        return 0;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0){
        CurrentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrentTableViewCell"];
        if (cell == nil) {
            cell = [[CurrentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CurrentTableViewCell" andType:@"0"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *selelctedString = nil;
        if([self.provinceString isEqualToString:self.currentCityString]){
            selelctedString = self.provinceString;
        }else{
          selelctedString = [self.provinceString stringByAppendingString:self.currentCityString];
        }
        [cell refreshWithCurrentStr:selelctedString];
        return cell;
    }else if (indexPath.section == 1){
        
        CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
        if(cell==nil)
        {
            cell = [[CityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //刷新数据 传的是当前选择的省份
        cell.provinceStr = self.provinceString;
        [cell refreshCurrentCity:self.provinceString];
        [cell setTransBlock:^(NSString *currentStr) {
            
            NSDictionary *dict = @{@"province":self.provinceString,@"city":@""};
            [CKCNotificationCenter postNotificationName:@"offlinereturn" object:nil userInfo:dict];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        return cell;
    }else{
        CurrentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"province"];
        if (cell == nil) {
            cell = [[CurrentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"province" andType:@"1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.dataArray count]) {
            _provinceModel  = self.dataArray[indexPath.row];
            [cell refreshWithModel:_provinceModel];
        }
    
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.dataArray count]){
        _provinceModel = self.dataArray[indexPath.row];
    }
     OffLineShopCityController *cityVc = [[OffLineShopCityController alloc] init];
    if (indexPath.section == 0) {
        cityVc.provinceStr = self.provinceString;
        cityVc.typeStr = @"0";
    }else if (indexPath.section == 2){
        cityVc.cityModel = _provinceModel;
        cityVc.provinceStr = _provinceModel.name;
        cityVc.typeStr = @"1";
    }
    [self.navigationController pushViewController:cityVc animated:YES ];
}

#pragma mark-开始搜索
-(void)searchBeginEditing
{
    [self.view addSubview:_blackView];

    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
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
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSString *requesUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getsearchExpShop_Url];
    NSDictionary *pramaDic = @{@"keywords":string,DeviceId:uuid};
    [HttpTool postWithUrl:requesUrl params:pramaDic success:^(id json) {
        
        [_blackView removeFromSuperview];
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self.resultController.tableView reloadData];
            [self showNoticeView:@"暂无搜索结果"];
            return ;
        }
        NSArray *listArr = dict[@"list"];
        for (NSDictionary *citylistDic in listArr){
            NSArray *citylistArr = citylistDic[@"citylist"];
            for (NSDictionary *cityDict in citylistArr) {
                _provinceModel = [[SelecteAreaModel alloc] init];
                [_provinceModel setValuesForKeysWithDictionary:cityDict];
                [self.searchArray addObject:_provinceModel];
            }
            _provinceStr = [NSString stringWithFormat:@"%@",citylistDic[@"province"]];
            if (IsNilOrNull(_provinceStr)) {
                _provinceStr = @"";
            }
            
        }
        
        self.resultController.dataArray = self.searchArray;
        self.resultController.provinceStr = _provinceStr;
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
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --ResultCityControllerDelegate
-(void)didScroll
{
    [self.provinceSearchView.searchBar resignFirstResponder];
}


@end
