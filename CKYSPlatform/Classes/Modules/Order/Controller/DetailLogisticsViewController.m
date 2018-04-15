//
//  DetailLogisticsViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/21.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "DetailLogisticsViewController.h"
#import "LogistModel.h"

#import "DetailLogistTableViewCell.h"
@interface DetailLogisticsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *headerView;
    LogistModel *_logistModel;
}
@property(nonatomic,strong)UITableView *logistTableView;
@property(nonatomic,strong)NSMutableArray *logistArray;
@end

@implementation DetailLogisticsViewController
-(NSMutableArray *)logistArray{
    if (_logistArray == nil) {
        _logistArray = [[NSMutableArray alloc] init];
    }
    return _logistArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"物流信息";
    [self createTableView];
    [self createLogistData];
}
#pragma mark-请求物流信息
-(void)createLogistData{
    NSString *ckidString = KCKidstring;
    if (IsNilOrNull(ckidString)){
        ckidString = @"";
    }
    NSString *orderDetailUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getLogisticsInfo_Url];
    NSString *oidstr = [NSString stringWithFormat:@"%@",self.oidString];
    if (IsNilOrNull(oidstr)){
        self.oidString = @"";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"ckid":ckidString,@"oid":oidstr,DeviceId:uuid};
    [HttpTool postWithUrl:orderDetailUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        NSArray *listArr = dict[@"list"];
        if (listArr.count == 0) {
            return;
        }
        for (NSDictionary *listDic in listArr) {
            _logistModel = [[LogistModel alloc] init];
            [_logistModel setValuesForKeysWithDictionary:listDic];
            [self.logistArray addObject:_logistModel];
        }
  
        [self.logistTableView reloadData];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

- (void)createTableView {

    _logistTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        _logistTableView.frame = CGRectMake(5, 64+5+NaviAddHeight, SCREEN_WIDTH - 10, SCREEN_HEIGHT-69 -NaviAddHeight-BOTTOM_BAR_HEIGHT);
    }else{
        _logistTableView.frame = CGRectMake(5, 5+NaviAddHeight, SCREEN_WIDTH - 10, SCREEN_HEIGHT-5);
    }
    _logistTableView.delegate  = self;
    _logistTableView.dataSource = self;
    _logistTableView.layer.cornerRadius = 5;
    _logistTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.logistTableView.rowHeight = UITableViewAutomaticDimension;
    self.logistTableView.estimatedRowHeight = 44;
    [self.view addSubview:_logistTableView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(5, 64+5, SCREEN_WIDTH - 10, 45)];
    UILabel *titleLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    titleLable.frame = CGRectMake(20,15, 100, 15);
    [headerView addSubview:titleLable];
    titleLable.text = @"物流追踪";
    
    UILabel *lineLable = [UILabel creatLineLable];
    [headerView addSubview:lineLable];
    lineLable.frame = CGRectMake(10,44, SCREEN_WIDTH - 30, 1);
    self.logistTableView.tableHeaderView = headerView;
    
    
}

#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.logistArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailLogistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailLogistTableViewCell"];
    if (cell == nil) {
        cell = [[DetailLogistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailLogistTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == 0){
        [cell.verticalLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(20);
        }];
        [cell.imageViewR mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.verticalLable.mas_top);
            make.left.mas_offset(20.5);
            make.size.mas_offset(CGSizeMake(20, 20));
        }];
        [cell.imageViewR setImage:[UIImage imageNamed:@"logist_green"]];
    }else{
        [cell.verticalLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
        }];
        [cell.imageViewR mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.verticalLable.mas_top).offset(20);
            make.left.mas_offset(25);
            make.size.mas_offset(CGSizeMake(10, 10));
        }];
        [cell.imageViewR setImage:[UIImage imageNamed:@"logist_grey"]];
    }
    
    NSInteger count = self.logistArray.count;
    if(count-1 == indexPath.row){
        [cell.verticalLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.imageViewR.mas_top);
        }];
        cell.bottomLable.hidden = YES;
    }else{
        [cell.verticalLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(0);
        }];
        cell.bottomLable.hidden = NO;
    }
    if ([self.logistArray count]) {
        _logistModel = self.logistArray[indexPath.row];
        [cell refreshWithLogistModel:_logistModel];
    }
    return cell;
}

#pragma mark-点击cell事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
