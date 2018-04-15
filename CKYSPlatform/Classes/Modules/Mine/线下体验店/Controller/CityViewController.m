//
//  CityViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/9/14.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "CityViewController.h"
#import "DistrictViewController.h"
@interface CityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    SelecteAreaModel *cityModel;

}
@property(nonatomic,strong)UITableView *cityTableView;
@property(nonatomic,strong)NSMutableArray *cityArray;
@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择市";

    [self createTableView];
    [self createCollectedListData];
}
-(NSMutableArray *)cityArray{
    if (_cityArray == nil) {
        _cityArray = [[NSMutableArray alloc] init];
    }
    return _cityArray;
}

#pragma mark-市列表数据
-(void)createCollectedListData{
    //    地区类型（0：省   1：市    2：县（区））
    NSString *codestr = [NSString stringWithFormat:@"%@",self.areaModel.code];
    if (IsNilOrNull(codestr)) {
        codestr = @"";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"areaCode":codestr,DeviceId:uuid};
     NSString *cityUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getArea_Url];
    [HttpTool postWithUrl:cityUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return;
        }
        NSArray *cityArr = dict[@"arealist"];
        if (cityArr.count == 0) {
            return;
        }
        for (NSDictionary *citydict in cityArr) {
            cityModel = [[SelecteAreaModel alloc] init];
            [cityModel setValuesForKeysWithDictionary:citydict];
            [self.cityArray addObject:cityModel];
        }
        [self.cityTableView reloadData];
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
-(void)createTableView{

    if (@available(iOS 11.0, *)) {
        _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+2+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-2-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    }else{
        _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 2, SCREEN_WIDTH, SCREEN_HEIGHT-2) style:UITableViewStylePlain];
    }
    
    _cityTableView.delegate  = self;
    _cityTableView.dataSource = self;
    _cityTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _cityTableView.separatorColor = [UIColor tt_lineBgColor];
    _cityTableView.backgroundColor = [UIColor tt_grayBgColor];
    [self.view addSubview:_cityTableView];
     self.cityTableView.tableFooterView = [[UIView alloc]init];//关键语句
}
#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([self.cityArray count]){
        return self.cityArray.count;
    }else{
        return 0;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"citycell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"citycell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.cityArray count]) {
      cityModel  = self.cityArray[indexPath.row];
      cell.textLabel.text = cityModel.name;
    }
    return cell;
}
#pragma mark-点击cell事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DistrictViewController *district = [[DistrictViewController alloc] init];
    if ([self.cityArray count]) {
       cityModel = self.cityArray[indexPath.row];
    }
    district.typestr = self.typeStr;
    district.areaModel = cityModel;
    
    NSString *string = [NSString stringWithFormat:@" %@",cityModel.name];
    district.areaString = [self.areaModel.name stringByAppendingString:string];
    [self.navigationController pushViewController:district animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}




@end
