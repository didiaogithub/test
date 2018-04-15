//
//  DistrictViewController.m
//  TinyShoppingCenter
//
//  Created by 庞宏侠 on 16/9/14.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "DistrictViewController.h"
#import "BirthplaceViewController.h"
#import "AddAddressViewController.h"
#import "CKAddressViewController.h"

@interface DistrictViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SelecteAreaModel *districtModel;

}
@property(nonatomic,strong)UITableView *districtTableView;
@property(nonatomic,strong)NSMutableArray *districtArray;


@end

@implementation DistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择地区";
    [self createTableView];
    [self createCollectedListData];
}
-(NSMutableArray *)districtArray{
    if (_districtArray == nil) {
        _districtArray = [[NSMutableArray alloc] init];
    }
    return _districtArray;
}

#pragma mark-地区列表数据
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
    
    NSString *districtUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getArea_Url];
    [HttpTool postWithUrl:districtUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        NSArray *districtArr = dict[@"arealist"];
        if (districtArr.count == 0) {
            return;
        }
        for (NSDictionary *districtDict in districtArr) {
            districtModel = [[SelecteAreaModel alloc] init];
            [districtModel setValuesForKeysWithDictionary:districtDict];
            [self.districtArray addObject:districtModel];
        }
        [self.districtTableView reloadData];
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
        _districtTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+2+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-2-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    }else{
        _districtTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 2, SCREEN_WIDTH, SCREEN_HEIGHT-2) style:UITableViewStylePlain];
    }
    _districtTableView.delegate  = self;
    _districtTableView.dataSource = self;
    _districtTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _districtTableView.separatorColor = [UIColor tt_lineBgColor];
    _districtTableView.backgroundColor = [UIColor tt_grayBgColor];
    [self.view addSubview:_districtTableView];
    self.districtTableView.tableFooterView  = [[UIView alloc] init];
}
#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([self.districtArray count]){
      return self.districtArray.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.districtArray count]) {
        districtModel  = self.districtArray[indexPath.row];
        cell.textLabel.text = districtModel.name;
    }
    return cell;
}
#pragma mark-点击cell事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.districtArray count]) {
        districtModel  = self.districtArray[indexPath.row];
    }
    
    NSString *string = [NSString stringWithFormat:@" %@",districtModel.name];
    NSString *areaStr = [self.areaString stringByAppendingString:string];

    if ([self.typestr isEqualToString:@"1"]) {// 从我的信息页面所在地跳转
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if([controller isKindOfClass:[BirthplaceViewController class]]){
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else if ([self.typestr isEqualToString:@"2"]) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if([controller isKindOfClass:[AddAddressViewController class]]){
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else if ([self.typestr isEqualToString:@"3"]) {//注册时选地址
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if([controller isKindOfClass:[CKAddressViewController class]]){
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
    [CKCNotificationCenter postNotificationName:@"bank" object:areaStr];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
@end
