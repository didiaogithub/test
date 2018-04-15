//
//  CKTrainsExamViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/16.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKTrainsExamViewController.h"
#import "CKProcessView.h"
#import "CKQuestionCell.h"
#import "CKExamResultView.h"
#import "CKExamModel.h"
#import "FFWarnAlertView.h"

@interface CKTrainsExamViewController ()<UITableViewDelegate, UITableViewDataSource, CKAnswerCellDelegate, CKExamResultVieDelegate, FFWarnAlertViewDelegate>

@property (nonatomic, strong) CKProcessView *progressView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentQuestionNo;
@property (nonatomic, assign) NSInteger totalQestionNo;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) NSMutableArray *selectedAnswerArray;
@property (nonatomic, strong) CKExamResultView *resultView;//考核结果页面
@property (nonatomic, strong) CKExamModel *examM;
@property (nonatomic, strong) UIButton *getNumBtn;

@end

@implementation CKTrainsExamViewController

- (NSMutableArray *)selectedAnswerArray {
    if (!_selectedAnswerArray) {
        _selectedAnswerArray = [NSMutableArray array];
    }
    return _selectedAnswerArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"礼包销售权考核";
    self.view.backgroundColor = [UIColor whiteColor];

    self.currentQuestionNo = 0;
    self.totalQestionNo = 0;
    //请求试题数据
    [self requestQuestionData];
    
    
    
//    _getNumBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    _getNumBtn.frame=CGRectMake(10, 200, 300, 50);
//    _getNumBtn.backgroundColor = [UIColor greenColor];
//    [_getNumBtn setTitle:@"考试剩余时间:0" forState:UIControlStateNormal];
//    [_getNumBtn addTarget:self action:@selector(getNumBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_getNumBtn];
}

//暂时不做考试时间的限制，如果有加上此方法
- (void)getNumBtnAction{
    
    __block NSInteger second = 5;
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second > 0) {
                [_getNumBtn setTitle:[NSString stringWithFormat:@"考试剩余时间:%ld", second] forState:UIControlStateNormal];
                second--;
            } else {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timer);
                [_getNumBtn setTitle:@"考试剩余时间:0" forState:UIControlStateNormal];
                
                FFWarnAlertView *alertV = [[FFWarnAlertView alloc] init];
                alertV.titleLable.text = @"很遗憾，考试时间到了";
                alertV.delegate = self;
                [alertV showFFWarnAlertView];
            }
        });
    });
    //启动源
    dispatch_resume(timer);
}

#pragma mark - FFWarnAlertViewDelegate
- (void)didClickWarnAlertView:(FFWarnAlertView *)warnAlertView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 返回首页
- (void)exitExam:(CKExamResultView *)examResultView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initComponents {
    //进度条
    self.progressView=[[CKProcessView alloc]initWithFrame:CGRectZero title:@"礼包销售权考核" totalNo:[NSString stringWithFormat:@"%ld", self.totalQestionNo]];
    self.progressView.frame = CGRectMake(0, 64, self.view.frame.size.width, 30+30+20+20);
    if (IPHONE_X) {
        self.progressView.frame = CGRectMake(0, NaviHeight+30, self.view.frame.size.width, 30+30+20+20);
    }
    [self.view addSubview:self.progressView];
    
    
    //table
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.progressView.frame)+20, self.view.frame.size.width, SCREEN_HEIGHT-CGRectGetMaxY(self.progressView.frame)-20-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //footeview
    self.currentQuestionNo = 0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = view;
    
    self.lastBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 70-40+10, self.view.frame.size.width*0.5-30 , 40)];
    self.lastBtn.backgroundColor = [UIColor tt_redMoneyColor];
    self.lastBtn.layer.cornerRadius = 20.0;
    self.lastBtn.layer.masksToBounds = YES;
    [self.lastBtn setTitle:@"上一题" forState:UIControlStateNormal];
    [self.lastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.lastBtn addTarget:self action:@selector(lastQuestions:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.lastBtn];
    
    
    self.nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.5+15, 70-40+10, self.view.frame.size.width*0.5-30 , 40)];
    self.nextBtn.backgroundColor = [UIColor tt_redMoneyColor];
    self.nextBtn.layer.cornerRadius = 20.0;
    self.nextBtn.layer.masksToBounds = YES;
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextQuestions:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.nextBtn];
    
    if (self.currentQuestionNo == 0) {
        self.nextBtn.frame = CGRectMake(15, 70-40+10, self.view.frame.size.width-30 , 40);
        if (self.totalQestionNo <=1) {
            [self.nextBtn setTitle:@"完成" forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 下一题
-(void)nextQuestions:(UIButton*)sender {
    NSLog(@"%@", sender.titleLabel.text);
    
    CKQuestionModel *questionM = self.examM.questionArray[self.currentQuestionNo];

    BOOL isSelected = NO;
    for (NSInteger j = 0; j < questionM.optionArray.count; j++) {
        CKOptionModel *optionM = [[CKOptionModel alloc] init];
        optionM = questionM.optionArray[j];
        if (optionM.isSelected) {
            isSelected = YES;
            break;
        }else{
            isSelected = NO;
        }
    }
    
    if (!isSelected) {
        FFWarnAlertView *alertV = [[FFWarnAlertView alloc] init];
        alertV.titleLable.text = @"请您至少选择一个答案";
        [alertV showFFWarnAlertView];
        return;
    }
    
    if ([self.nextBtn.titleLabel.text isEqualToString:@"完成"]) {
        [self submitAnswers];
    }else{
        [self.progressView progressIncrease];
        
        self.currentQuestionNo += 1;
        NSLog(@"%ld", self.currentQuestionNo);
        if (self.currentQuestionNo >= self.totalQestionNo-1) {
            self.currentQuestionNo = self.totalQestionNo-1;
            
            self.nextBtn.frame = CGRectMake(self.view.frame.size.width*0.5+15, 70-40+10, self.view.frame.size.width*0.5-30 , 40);
            [self.nextBtn setTitle:@"完成" forState:UIControlStateNormal];
        }else{
            
            self.nextBtn.frame = CGRectMake(self.view.frame.size.width*0.5+15, 70-40+10, self.view.frame.size.width*0.5-30 , 40);
            [self.nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - 上一题
-(void)lastQuestions:(UIButton*)sender {
    
    [self.progressView progressReduce];
    
    NSLog(@"%@", sender.titleLabel.text);
    self.currentQuestionNo -= 1;
    if (self.currentQuestionNo <= 0) {
        self.currentQuestionNo = 0;
    }
    if (self.currentQuestionNo == 0) {
        self.nextBtn.frame = CGRectMake(15, 70-40+10, self.view.frame.size.width-30 , 40);
        [self.nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
    }else{
        self.nextBtn.frame = CGRectMake(self.view.frame.size.width*0.5+15, 70-40+10, self.view.frame.size.width*0.5-30 , 40);
        [self.nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

#pragma mark - answerCellDelegate,选中或者取消选中答案

- (void)didSelectAnswerOption:(CKAnswerCell*)answerCell selectedIndex:(NSInteger)selectedIndex optionModel:(CKOptionModel*)optionModel {
    
    NSLog(@"第%ld题 选择了选项：%ld", self.currentQuestionNo+1, selectedIndex+1);

    CKQuestionModel *questionM = self.examM.questionArray[self.currentQuestionNo];    
    NSString *questionTypeName = questionM.questionTypeName;
    
    if ([questionTypeName isEqualToString:@"单选题"]) {
        for (NSInteger i = 0; i < questionM.optionArray.count; i++) {
            CKOptionModel *optionM = [[CKOptionModel alloc] init];
            optionM = questionM.optionArray[i];
            
            if ([optionM.selectvalue isEqualToString:optionModel.selectvalue]) {
                
            }else{
                optionM.isSelected = NO;
            }
        }
    }
    
    [self.tableView reloadData];
    
    NSString *questionid = [NSString stringWithFormat:@"%@", questionM.questionid];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSString stringWithFormat:@"%ld", selectedIndex+1] forKey:[NSString stringWithFormat:@"%@", questionid]];
    
    //要再增加复选的判断
    NSMutableArray *tempArray = [self.selectedAnswerArray copy];
    for (NSDictionary *answerDict in tempArray) {
        if ([answerDict.allKeys.firstObject isEqualToString:[NSString stringWithFormat:@"%@", questionid]]) {
            if ([questionTypeName isEqualToString:@"单选题"]) {
                [self.selectedAnswerArray removeObject:answerDict];
                [dict setObject:[NSString stringWithFormat:@"%ld", selectedIndex+1] forKey:answerDict.allKeys.firstObject];
            }
        }
    }
    
    [self.selectedAnswerArray addObject:dict];
    
    NSLog(@"%@", self.selectedAnswerArray);
//    if (![self.selectedAnswerArray containsObject:dict]) {
//        [self.selectedAnswerArray addObject:dict];
//    }
}


//- (void)didSelectAnswerOption:(CKQuestionCell *)answerCell selectedIndex:(NSInteger)selectedIndex {
//    NSLog(@"第%ld题 选择了选项：%ld", self.currentQuestionNo+1, selectedIndex+1);
//
//    CKQuestionModel *questionM = self.examM.questionArray[self.currentQuestionNo];
//    NSString *questionid = [NSString stringWithFormat:@"%@", questionM.questionid];
//
//    NSString *questionTypeName = questionM.questionTypeName;
//
//    if ([questionTypeName isEqualToString:@"单选题"]) {
//        for (NSInteger i = 0; i < questionM.optionArray.count; i++) {
//            CKOptionModel *optionM = [[CKOptionModel alloc] init];
//            optionM = questionM.optionArray[i];
//            if (selectedIndex == i) {
//                optionM.isSelected = YES;
//            }else{
//                optionM.isSelected = NO;
//            }
//        }
//    }
//
//    [self.tableView reloadData];
//
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:[NSString stringWithFormat:@"%ld", selectedIndex+1] forKey:[NSString stringWithFormat:@"%@", questionid]];
//
//    if (![self.selectedAnswerArray containsObject:dict]) {
//        [self.selectedAnswerArray addObject:dict];
//    }
//
//}
//
//- (void)dissSelectAnswerOption:(CKQuestionCell *)answerCell selectedIndex:(NSInteger)selectedIndex {
//
//    NSLog(@"第%ld题 取消了选项：%ld", self.currentQuestionNo+1, selectedIndex+1);
//
//    CKQuestionModel *questionM = self.examM.questionArray[self.currentQuestionNo];
//    NSString *questionid = [NSString stringWithFormat:@"%@", questionM.questionid];
//
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:[NSString stringWithFormat:@"%ld", selectedIndex+1] forKey:[NSString stringWithFormat:@"%@", questionid]];
//
//    if ([self.selectedAnswerArray containsObject:dict]) {
//        [self.selectedAnswerArray removeObject:dict];
//    }
//}

#pragma mark - 提交答案
- (void)submitAnswers {
    NSLog(@"所选答案:%@", self.selectedAnswerArray);
    
    NSMutableArray *questionresultlist = [NSMutableArray array];

    
    NSMutableArray *allkeysArr = [NSMutableArray array];
    NSMutableArray *allValuesArr = [NSMutableArray array];

    for (NSDictionary *answerDict in self.selectedAnswerArray) {
        [allkeysArr addObject:answerDict.allKeys.firstObject];
        [allValuesArr addObject:answerDict.allValues.firstObject];
    }
    
    NSMutableArray *finalAnswerArr = [NSMutableArray array];
    //循环问题列表
    for (CKQuestionModel *questionM in self.examM.questionArray) {
        NSMutableArray *valueArr = [NSMutableArray array];
        for (NSInteger i = 0; i < allkeysArr.count; i++) {
            NSString *key = allkeysArr[i];
            if ([questionM.questionid isEqualToString:key]) {
                NSString *value = allValuesArr[i];
                int optionAscii = [value intValue]+64;
                NSString *option =[NSString stringWithFormat:@"%c", optionAscii];
                [valueArr addObject:option];
            }
        }
        
        NSArray *result = [valueArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2]; //升序
        }];
        NSString *valueStr = @"";
        for (NSString *s in result) {
            valueStr = [NSString stringWithFormat:@"%@%@", valueStr, s];
        }
        [finalAnswerArr addObject:@{questionM.questionid :valueStr}];
        NSString *questionid = [NSString stringWithFormat:@"%@", questionM.questionid];
        NSString *score = [NSString stringWithFormat:@"%@", questionM.score];

        NSDictionary *resultDict = @{@"questionid": questionid, @"questionanswer":valueStr, @"score":score};
        [questionresultlist addObject:resultDict];
    }
    NSLog(@"finalAnswerArr:%@", finalAnswerArr);
    NSLog(@"%@", questionresultlist);
    
    
    NSString *ruequestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Exam/addExamResult"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:KCKidstring forKey:@"ckid"];
    NSString *levelid = [NSString stringWithFormat:@"%@", self.examM.levelid];
    NSString *examid = [NSString stringWithFormat:@"%@", self.examM.examid];
    NSString *examscore = [NSString stringWithFormat:@"%@", self.examM.examscore];
    if (!IsNilOrNull(levelid)) {
        [paramDict setValue:levelid forKey:@"levelid"];
    }
    if (!IsNilOrNull(examid)) {
        [paramDict setValue:examid forKey:@"examid"];
    }
    if (!IsNilOrNull(examscore)) {
        [paramDict setValue:examscore forKey:@"examscore"];
    }

    NSString *s = [questionresultlist mj_JSONString];
    [paramDict setValue:s forKey:@"questionresultlist"];
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:ruequestUrl params:paramDict success:^(id json) {
        
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@", dict[@"code"]];
        if ([code integerValue] != 200) {
            [self.viewDataLoading stopAnimation];
            [self showNoticeView:dict[@"codeinfo"]];
        }else{
            NSString *ispass = [NSString stringWithFormat:@"%@", dict[@"ispass"]];
            BOOL passExam = NO;
            if ([ispass isEqualToString:@"0"]) {
                passExam = NO;
                [CKCNotificationCenter postNotificationName:@"NotPassExamNotification" object:nil];
            }else{
                passExam = YES;
                [CKCNotificationCenter postNotificationName:@"PassExamNotification" object:nil];
            }
            NSString *examscore = [NSString stringWithFormat:@"%@", dict[@"examscore"]];
            self.resultView = [[CKExamResultView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64- NaviAddHeight-BOTTOM_BAR_HEIGHT) score:examscore passOrNot:passExam];
            self.resultView.delegate = self;
            [self.view addSubview:self.resultView];
            
        }
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
    
}

#pragma mark - 请求试题数据
- (void)requestQuestionData {
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Exam/getExam"];
    [HttpTool getWithUrl:urlStr params:@{@"ckid": KCKidstring} success:^(id json) {
        //倒计时考试时间
//        [self getNumBtnAction];
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@", dict[@"code"]];
        if ([code integerValue] != 200) {
            [self.viewDataLoading stopAnimation];
            [self showNoticeView:dict[@"codeinfo"]];
            return;
        }
        
        CKExamModel *examM = [[CKExamModel alloc] init];
        [examM setValuesForKeysWithDictionary:dict];
        examM.levelid = [NSString stringWithFormat:@"%@", dict[@"levelid"]];
        examM.levelno = [NSString stringWithFormat:@"%@", dict[@"levelno"]];
        examM.questioncount = [NSString stringWithFormat:@"%@", dict[@"questioncount"]];
        examM.questionArray = [NSMutableArray array];
        for (NSDictionary *questionDict in dict[@"questionlist"]) {
            CKQuestionModel *questionM = [[CKQuestionModel alloc] init];
            [questionM setValuesForKeysWithDictionary:questionDict];
            questionM.optionArray = [NSMutableArray array];
            for (NSDictionary *optionDict in questionDict[@"questionselect"]) {
                CKOptionModel *optionM = [[CKOptionModel alloc] init];
                [optionM setValuesForKeysWithDictionary:optionDict];
                optionM.isSelected = NO;
                [questionM.optionArray addObject:optionM];
            }
            [examM.questionArray addObject:questionM];
        }
        self.totalQestionNo = examM.questionArray.count;
        
        if (examM.questionArray.count > 0) {
            [self initComponents];
        }
        
        
        [self bindData:self.examM = examM];
        
        [self.viewDataLoading stopAnimation];
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 绑定数据
- (void)bindData:(id)data {
    
    CKExamModel *examM = [[CKExamModel alloc] init];
    examM = data;
    for (CKQuestionModel *questionM in examM.questionArray) {
        
        NSMutableArray *tempArray = [NSMutableArray array];
        CellModel *questionModel = [self createCellModel:[CKQuestionCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:questionM.question,@"data", nil] height:[CKQuestionCell computeHeight:questionM.question]];
        
        [tempArray addObject:questionModel];
        
        for (NSInteger i = 0; i < questionM.optionArray.count; i++) {
            CKOptionModel *optionM = questionM.optionArray[i];
            CellModel *answerModel = [self createCellModel:[CKAnswerCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:optionM, @"data", [NSString stringWithFormat:@"%ld", i], @"optionIndex", questionM.questionTypeName, @"questionTypeName", nil] height:[CKAnswerCell computeHeight:optionM]];
            answerModel.delegate = self;
            [tempArray addObject:answerModel];
        }
        SectionModel *section0 = [self createSectionModel:tempArray headerHeight:0.1 footerHeight:0.1];
        [self.dataArray addObject:section0];
        
    }
    
    [self.tableView reloadData];
}

-(CellModel*)createCellModel:(Class)cls userInfo:(id)userInfo height:(CGFloat)height {
    CellModel *model = [[CellModel alloc] init];
    model.selectionStyle = UITableViewCellSelectionStyleNone;
    model.userInfo = userInfo;
    model.height = height;
    model.className = NSStringFromClass(cls);
    return model;
}

-(SectionModel*)createSectionModel:(NSArray<CellModel*>*)items headerHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight {
    SectionModel *model = [SectionModel sectionModelWithTitle:nil cells:items];
    model.headerhHeight = headerHeight;
    model.footerHeight = footerHeight;
    return model;
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SectionModel *s = _dataArray[self.currentQuestionNo];
    if(s.cells) {
        return s.cells.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionModel *s = _dataArray[self.currentQuestionNo];
    CellModel *item = s.cells[indexPath.row];
    CKTestCell *cell = [tableView dequeueReusableCellWithIdentifier:item.reuseIdentifier];
    if(!cell) {
        cell = [[NSClassFromString(item.className) alloc] initWithStyle:item.style reuseIdentifier:item.reuseIdentifier];
    }
    cell.selectionStyle = item.selectionStyle;
    cell.accessoryType = item.accessoryType;
    cell.delegate = item.delegate;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionModel *s = _dataArray[self.currentQuestionNo];
    CellModel *item = s.cells[indexPath.row];
    
    if(item.title) {
        cell.textLabel.text = item.title;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithRed:0.294 green:0.298 blue:0.302 alpha:1.00];
    }
    if(item.subTitle) {
        cell.detailTextLabel.text = item.subTitle;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.294 green:0.298 blue:0.302 alpha:1.00];
    }
    
    SEL selector = NSSelectorFromString(@"fillData:");
    if([cell respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
        [cell performSelector:selector withObject:item.userInfo];
#pragma clang diagnostic pop
    }
}

#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionModel *s = _dataArray[self.currentQuestionNo];
    CellModel *item = s.cells[indexPath.row];
    return item.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SectionModel *s = _dataArray[section];
    return s.headerhHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SectionModel *s = _dataArray[section];
    return s.footerHeight;
}

@end
