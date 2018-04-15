//
//  CKSourceSearchViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/2/24.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKSourceSearchViewController.h"
#import "SearchNavView.h"
#import "HeaderModel.h"
#import "CKCHeaderTableViewCell.h"
#import "WebDetailViewController.h"

static NSString *searchSourceCell = @"searchSourceIndetifier";

@interface CKSourceSearchViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) HeaderModel *sourceModel;

@end

@implementation CKSourceSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchNavView.searchTextField.placeholder = @"请输入您要查询的素材";
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
}

#pragma mark-请求搜索素材中心数据
- (void)getSourceData {
    [self.searchSourceArray removeAllObjects];
    NSString *searchText = self.searchNavView.searchTextField.text;
    if (IsNilOrNull(searchText)) {
        searchText = @"";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSString *requesUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI, getTopHotNews_Url];;
    NSDictionary *pramaDic = @{@"id":@"0",@"keywords":searchText,@"pagesize":@"90000",@"type":@"3",DeviceId:uuid};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:requesUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        [CKCNotificationCenter postNotificationName:SearchSuccess object:@"YES"];
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        NSArray *newsArr = dict[@"news"];
        if (newsArr.count == 0) {
            self.nodataImageView.hidden = NO;
            [self.searchTableView tableViewDisplayView:self.nodataImageView ifNecessaryForRowCount:self.searchSourceArray.count];
        }else{
            self.nodataImageView.hidden = YES;
        }
        
        for (NSDictionary *newsDic in newsArr) {
            _sourceModel = [[HeaderModel alloc] init];
            [_sourceModel setValuesForKeysWithDictionary:newsDic];
            [self.searchSourceArray addObject:_sourceModel];
        }
        [self.searchTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark-点击键盘上的搜索按钮
-(void)keyboardSearchWithString:(NSString *)searchStr{
    NSString *searchText = self.searchNavView.searchTextField.text;
    if (IsNilOrNull(searchText)){
        [CKCNotificationCenter postNotificationName:SearchSuccess object:@"YES"];
        [self showNoticeView:@"请输入您要查询的素材"];
        return;
    }
    
    [self.searchSourceArray removeAllObjects];
    for (NSString *str in self.searchSourceArray)
    {
        if ([str isEqualToString:searchStr])
        {
            [self.searchSourceArray addObject:str];
        }
    }
    [self getSourceData];
}

#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CKCHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchSourceCell];
    if (cell == nil) {
        cell = [[CKCHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchSourceCell];
    }
    cell.backgroundColor = [UIColor tt_grayBgColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([self.searchSourceArray count]){
        _sourceModel = self.searchSourceArray[indexPath.row];
        [cell refreshWithHeaderModel:_sourceModel];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.searchSourceArray count]) {
        self.sourceModel = self.searchSourceArray[indexPath.row];
    }
    NSString *title = [NSString stringWithFormat:@"%@",self.sourceModel.title];
    if(IsNilOrNull(title)){
        title = @"";
    }
    NSString *headImageUrl = [NSString stringWithFormat:@"%@",self.sourceModel.imgurl];
    NSString *headUrl = [NSString loadImagePathWithString:headImageUrl];
    if(IsNilOrNull(headUrl)){
        headUrl = @"";
    }
    NSString *info = [NSString stringWithFormat:@"%@",self.sourceModel.info];
    if(IsNilOrNull(info)){
        info = @"";
    }
    //详情Url
    NSString *detailUrl = [NSString stringWithFormat:@"%@",self.sourceModel.url];
    if (IsNilOrNull(detailUrl)){
        detailUrl = @"";
    }
    WebDetailViewController *sourcedetail = [[WebDetailViewController alloc] init];
    sourcedetail.typeString = @"source";
    sourcedetail.detailUrl = detailUrl;
    sourcedetail.shareTitle = title;
    sourcedetail.shareDescrip = info;
    sourcedetail.imgUrl = headUrl;
    [self.navigationController pushViewController:sourcedetail animated:YES];
}

@end
