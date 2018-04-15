//
//  CKClassSearchViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/2/24.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKClassSearchViewController.h"
#import "CollegeTableViewCell.h"
#import "ClassDetailViewController.h"
#import "ClassModel.h"

@interface CKClassSearchViewController ()<UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) UITableView *searchTableView;
//@property (nonatomic, strong) NSMutableArray *searchSourceArray;
@property (nonatomic, strong) ClassModel *classModel;

@end

@implementation CKClassSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchNavView.searchTextField.placeholder = @"请输入您要查询的课程";    
    
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
}

#pragma mark - 请求搜索课程数据
- (void)getSchoolLessonsData {
    [self.searchSourceArray removeAllObjects];
    NSString *searchText = self.searchNavView.searchTextField.text;
    if (IsNilOrNull(searchText)) {
        searchText = @"";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSString *requesUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, searchLessons_Url];;
    NSDictionary *pramaDic = @{@"keywords":searchText, DeviceId:uuid};
    
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
        
        
        NSArray *lessonsArr = dict[@"lessons"];
        if (lessonsArr.count == 0) {
            self.nodataImageView.hidden = NO;
            [self.searchTableView tableViewDisplayView:self.nodataImageView ifNecessaryForRowCount:self.searchSourceArray.count];
        }else{
            self.nodataImageView.hidden = YES;
        }
        
        for (NSDictionary *lessonsDic in lessonsArr) {
            _classModel = [[ClassModel alloc] init];
            [_classModel setValuesForKeysWithDictionary:lessonsDic];
            [self.searchSourceArray addObject:_classModel];
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

#pragma mark - SearchNavViewDelegate
#pragma mark - 点击键盘上的搜索按钮
-(void)keyboardSearchWithString:(NSString *)searchStr{
    NSString *searchText = self.searchNavView.searchTextField.text;
    if (IsNilOrNull(searchText)){
        [CKCNotificationCenter postNotificationName:SearchSuccess object:@"YES"];
        [self showNoticeView:@"请输入您要查询的课程"];
        return;
    }
    
    [self.searchSourceArray removeAllObjects];
    for (NSString *str in self.searchSourceArray){
        if ([str isEqualToString:searchStr]){
            [self.searchSourceArray addObject:str];
        }
    }
    [self getSchoolLessonsData];
}

#pragma mark-tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CollegeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollegeTableViewCell"];
    if (cell == nil) {
        cell = [[CollegeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CollegeTableViewCell"];
    }
    cell.backgroundColor = [UIColor tt_grayBgColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.searchSourceArray count]) {
        _classModel = self.searchSourceArray[indexPath.row];
        [cell refreshWithLessons:_classModel];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.searchSourceArray count]) {
        _classModel = self.searchSourceArray[indexPath.row];
    }
    
    NSString *detailUrl = [NSString stringWithFormat:@"%@",_classModel.url];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", WebServiceAPI, setViewed];
    NSDictionary *params = @{@"type": @"course", @"id": _classModel.classId};
    [HttpTool postWithUrl:urlStr params:params success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"点击了一次");
        }
    } failure:^(NSError *error) {
        
    }];
    
    NSString *getReadUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetLessonReadNum];
    NSDictionary *readDict = @{@"type": @"course", @"id": _classModel.classId};
    [HttpTool postWithUrl:getReadUrl params:readDict success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"最新阅读量");
            _classModel.viewed = [NSString stringWithFormat:@"%@",dict[@"viewed"]];
            [self.searchTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            ClassDetailViewController *classDetail = [[ClassDetailViewController alloc] init];
            classDetail.viewsString = [NSString stringWithFormat:@"%@",dict[@"viewed"]];
            classDetail.detailUrl = detailUrl;
            classDetail.sortID = _classModel.sortID;
            [self.navigationController pushViewController:classDetail animated:YES];
        }
    } failure:^(NSError *error) {
        ClassDetailViewController *classDetail = [[ClassDetailViewController alloc] init];
        classDetail.viewsString = _classModel.viewed;
        classDetail.detailUrl = detailUrl;
        classDetail.sortID = _classModel.sortID;
        [self.navigationController pushViewController:classDetail animated:YES];
    }];
}

@end
