//
//  CKChooseJoinGoodsVC.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/18.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKChooseJoinGoodsVC.h"
#import "CKdlbGoodsCell.h"
#import "CKdlbGoodsModel.h"
#import "CKConfirmRegisterOrderVC.h"
#import "WebDetailViewController.h"

@interface CKChooseJoinGoodsVC ()<UITableViewDelegate, UITableViewDataSource, CKdlbGoodsCellDelegate>

@property (nonatomic, strong) UITableView *goodsTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *ckGoodsArray;
@property (nonatomic, strong) NSMutableArray *fxGoodsArray;
@property (nonatomic, assign) BOOL ckSpread; //展示或者隐藏更多礼包
@property (nonatomic, strong) UIImageView *spreadView;
@property (nonatomic, strong) UILabel *spreadLabel;

@end

@implementation CKChooseJoinGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"礼包列表";
    
    _ckSpread = NO;
    
    [self initComponents];
    
    [self requestData];
}

-(void)initComponents {
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:confirmBtn];
    [confirmBtn setBackgroundColor:[UIColor tt_redMoneyColor]];
    confirmBtn.layer.cornerRadius = 20.0;
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(enterToConfirmOrder) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.right.mas_offset(-25);
        make.left.mas_offset(25);
        if (IPHONE_X) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
        }else{
            make.bottom.equalTo(self.view.mas_bottom).offset(-15);
        }
    }];
    
    self.goodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - NaviAddHeight-15-BOTTOM_BAR_HEIGHT) style:UITableViewStyleGrouped];
    self.goodsTableView.delegate = self;
    self.goodsTableView.dataSource = self;
    if (@available(iOS 11.0, *)){
        self.goodsTableView.estimatedSectionFooterHeight = 0.1;
        self.goodsTableView.estimatedSectionHeaderHeight = 0.1;
    }
    self.goodsTableView.backgroundColor = [UIColor tt_grayBgColor];
    [self.view addSubview:self.goodsTableView];
    self.goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.goodsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
        make.right.left.mas_offset(0);
        make.bottom.equalTo(confirmBtn.mas_top).offset(-15);
    }];
}

-(void)requestData {
    
    _selectedArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    _ckGoodsArray = [NSMutableArray array];
    _fxGoodsArray = [NSMutableArray array];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetRegistItem];
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:nil success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:[NSString stringWithFormat:@"%@", dict[@"codeinfo"]]];
            return;
        }else{
            NSArray *ckitemlist = dict[@"ckitemlist"];
            for (NSDictionary *goodsDic in ckitemlist) {
                CKdlbGoodsModel *goodsM = [[CKdlbGoodsModel alloc] init];
                [goodsM setValuesForKeysWithDictionary:goodsDic];
                if ([self.showAllTypeDLB isEqualToString:@"NO"]) {
                    NSString *isdlbtype = [NSString stringWithFormat:@"%@", goodsM.isdlbtype];
                    if(![isdlbtype isEqualToString:@"3"]){
                        [_ckGoodsArray addObject:goodsM];
                    }
                }else{
                    [_ckGoodsArray addObject:goodsM];
                }
            }
            if (_ckGoodsArray.count > 0) {
                [self.dataArray addObject:_ckGoodsArray];
            }
            
            if ([self.showAllTypeDLB isEqualToString:@"YES"]) {
                NSArray *fxitemlist = dict[@"fxitemlist"];
                for (NSDictionary *goodsDic in fxitemlist) {
                    CKdlbGoodsModel *goodsM = [[CKdlbGoodsModel alloc] init];
                    [goodsM setValuesForKeysWithDictionary:goodsDic];
                    [_fxGoodsArray addObject:goodsM];
                }
            }
    
            if (_fxGoodsArray.count > 0) {
                [self.dataArray addObject:_fxGoodsArray];
            }
            [self.goodsTableView reloadData];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.showAllTypeDLB isEqualToString:@"NO"]) {
        //分销升级的，只有创客大礼包
        return 1;
    }else{
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([self.showAllTypeDLB isEqualToString:@"NO"]) {
        //分销升级的，只有创客大礼包，过滤分销礼包，零风险礼包，全部显示，不用展开隐藏
        return _ckGoodsArray.count;
    }else{//正常的礼包列表
        return [self numberOfRows:section];
    }
}

-(NSInteger)numberOfRows:(NSInteger)section {
    //正常的礼包列表
    if (section == 0) {
        if (_ckSpread == YES) {
            return _ckGoodsArray.count;
        }else{
            if (_ckGoodsArray.count < 2) {
                return _ckGoodsArray.count;
            }else{
                return 2;
            }
        }
    }else{
        return _fxGoodsArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CKdlbGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKdlbGoodsCell"];
    if (cell == nil) {
        cell = [[CKdlbGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKdlbGoodsCell"];
    }
    cell.delegate = self;
    cell.section = indexPath.section;
    cell.indexRow = indexPath.row;
    CKdlbGoodsModel *goodsM = [[CKdlbGoodsModel alloc] init];
    NSArray *goodsArray = self.dataArray[indexPath.section];
    goodsM = goodsArray[indexPath.row];
    [cell refreshUIWithGoodsModel:goodsM];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 90;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.showAllTypeDLB isEqualToString:@"NO"]) {
        //分销升级的，只有创客大礼包，不显示展开，收缩
        return 0.001;
    }else{
        if (section == 0) {
            if (_ckGoodsArray.count > 2) {
                return 55;
            }else{
                return 0.001;
            }
        }else{
            return 0.001;
        }
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 79)];
    [headerView addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(view.frame) - AdaptedWidth(110)*0.5, 18, AdaptedWidth(110), AdaptedHeight(42))];
        [view addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"ckjoin"];
    }else{
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(view.frame) - AdaptedWidth(115)*0.5, 18, AdaptedWidth(115), AdaptedHeight(42))];
        [view addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"fxjoin"];
    }
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    if (section == 0) {
        if ([self.showAllTypeDLB isEqualToString:@"NO"]) {
            return view;
        }else{
            if (_ckGoodsArray.count > 2) {
                view.backgroundColor = [UIColor whiteColor];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spreadCKsection)];
                [view addGestureRecognizer:tap];
                
                _spreadView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5 - 15, 10, 30, 15)];
                _spreadView.userInteractionEnabled = YES;
                [view addSubview:_spreadView];
                
                _spreadLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:15]];
                _spreadLabel.frame = CGRectMake(0, 25, SCREEN_WIDTH, 25);
                [view addSubview:_spreadLabel];
                
                if (_ckSpread == NO) {
                    _spreadView.image = [UIImage imageNamed:@"downArrow"];
                    _spreadLabel.text = @"展开查看更多";
                }else{
                    _spreadView.image = [UIImage imageNamed:@"upArrow"];
                    _spreadLabel.text = @"点击隐藏";
                }
            }else{
                return view;
            }
        }
    }
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *goodsArray = self.dataArray[indexPath.section];
    CKdlbGoodsModel *goodsM = goodsArray[indexPath.row];
    WebDetailViewController *giftDetail = [[WebDetailViewController alloc] init];
    [self.navigationController pushViewController:giftDetail animated:YES];
    giftDetail.detailUrl = goodsM.url;
    giftDetail.typeString = @"gift";
}

-(void)spreadCKsection {
    _ckSpread = !_ckSpread;
    [self.goodsTableView reloadData];
}

-(void)dlbGoodsSelected:(CKdlbGoodsModel *)goodModel anRow:(NSInteger)indexRow andSection:(NSInteger)section {
    NSLog(@"选择的礼包名字:%@, section:%ld, row:%ld", goodModel.name, section, indexRow);
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        NSMutableArray *goodsArray = self.dataArray[i];
        for (NSInteger j = 0; j < goodsArray.count; j++) {
            CKdlbGoodsModel *goodsM = [goodsArray objectAtIndex:j];
            if ([goodsM.goodsId isEqualToString:goodModel.goodsId]) {
                goodsM.isSelect = YES;
            }else{
                goodsM.isSelect = NO;
            }
        }
    }
    [self.goodsTableView reloadData];
}

-(void)enterToConfirmOrder {
    
    [self.selectedArray removeAllObjects];
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        NSMutableArray *goodsArray = self.dataArray[i];
        for (NSInteger j = 0; j < goodsArray.count; j++) {
            CKdlbGoodsModel *goodsM = [goodsArray objectAtIndex:j];
            if (goodsM.isSelect) {//选中
                [self.selectedArray addObject: goodsM];
            }
        }
    }
    
    if (self.selectedArray.count == 0) {
        [self showNoticeView:@"请先选择商品"];
        return;
    }
    
    if ([self.fromVC isEqualToString:@"CKConfirmRegisterOrderVC"]) {
        if (self.changeGoodsBlock != nil) {
            CKdlbGoodsModel *goodsM = self.selectedArray.firstObject;
            NSString *priceStr = [NSString stringWithFormat:@"%@", goodsM.price];
            double price = [priceStr doubleValue];
            NSString *totalMoney = [NSString stringWithFormat:@"%.2f", price];
            NSString *itemid = [NSString stringWithFormat:@"%@", goodsM.goodsId];
            NSString *goodsName = [NSString stringWithFormat:@"%@", goodsM.name];
            self.changeGoodsBlock(self.selectedArray, totalMoney, itemid, goodsName);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        CKConfirmRegisterOrderVC *confirmOrder = [[CKConfirmRegisterOrderVC alloc]init];
        confirmOrder.fromVC = @"CKChooseJoinGoodsVC";
        confirmOrder.dataArray = self.selectedArray;
        CKdlbGoodsModel *goodsM = self.selectedArray.firstObject;
        NSString *priceStr = [NSString stringWithFormat:@"%@", goodsM.price];
        double price = [priceStr doubleValue];
        confirmOrder.totalMoney = [NSString stringWithFormat:@"%.2f", price];
        confirmOrder.ckid = self.ckid;
        confirmOrder.showAllTypeDLB = self.showAllTypeDLB;
        [self.navigationController pushViewController:confirmOrder animated:YES];
    }
}

-(void)changeGoods:(ChangeDLBBlock)changeGoodsBlock {
    _changeGoodsBlock = changeGoodsBlock;
}

@end
