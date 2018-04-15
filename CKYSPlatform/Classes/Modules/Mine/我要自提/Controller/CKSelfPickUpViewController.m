//
//  CKSelfPickUpViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/2/26.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKSelfPickUpViewController.h"
#import "UIButton+XN.h"
#import "OrderBottomView.h"
#import "CKPickupMallCell.h"
#import "CKPickupGoodsModel.h"
#import "SCGoodsDetailViewController.h"
#import "SureMySelfOrderViewController.h"
#import "CKPickupMallSearchVC.h"

@interface CKSelfPickUpViewController ()<UITableViewDelegate, UITableViewDataSource, OrderBottomViewDelegate, CKPickupMallCellDelegate>

@property (nonatomic, strong) OrderBottomView *bottomView;
@property (nonatomic, strong) UITableView *pickupTableView;
@property (nonatomic, strong) NSMutableArray *pickupDataArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, copy)   NSString *ckidString;

@end

@implementation CKSelfPickUpViewController

- (NSMutableArray *)pickupDataArray {
    if (!_pickupDataArray) {
        _pickupDataArray = [NSMutableArray array];
    }
    return _pickupDataArray;
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponents];
    
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    NSString *key = [NSString stringWithFormat:@"%@_%@", _ckidString, @"selfCarryGoods"];
    NSMutableArray *cacheArray = [[XNArchiverManager shareInstance] xnUnarchiverObject:key];
    if (cacheArray.count > 0) {
        self.pickupDataArray = cacheArray;
        [self.pickupTableView reloadData];
        [self getCarryBySelfData:NO];
    }else{
        [self getCarryBySelfData:YES];
    }
}

- (void)initComponents {
    [self initNaviView];
    [self initTableView];
}

#pragma mark - 设置导航栏
- (void)initNaviView {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn setTitleColor:TitleColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"carraynavsearch"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"carraynavsearch"] forState:UIControlStateHighlighted];
    [btn layoutButtonWithEdgeInsetsStyle:XNButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [btn addTarget:self action:@selector(searchPickupMall) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = btn;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"自提商城" style:UIBarButtonItemStylePlain target:self action:nil];
    left.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RootNavigationBack"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackPop)];
    back.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItems = @[back, left];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navorder"] style:UIBarButtonItemStylePlain target:self action:@selector(checkMyOrderList)];
    right.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10;
        self.navigationItem.rightBarButtonItems = @[spaceItem, right];
    }
}

#pragma mark - 搜索商品
- (void)searchPickupMall {
    CKPickupMallSearchVC *search = [[CKPickupMallSearchVC alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - 返回上一级
- (void)goBackPop {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 进入订单列表
- (void)checkMyOrderList {
    //自提商城进入订单要选中我的订单，其他情况查看消费者订单
    [CKCNotificationCenter postNotificationName:@"SelfPickupMallEnterOrderNoti" object:@{@"enterType":@"SelfPickupMall"}];
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTableView {
    //创建bottomView
    _bottomView = [[OrderBottomView alloc] init];
    _bottomView.delegate = self;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
        make.height.mas_equalTo(50);
    }];
    
    self.pickupTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.pickupTableView.delegate = self;
    self.pickupTableView.dataSource = self;
    self.pickupTableView.backgroundColor = [UIColor tt_grayBgColor];
    self.pickupTableView.rowHeight = UITableViewAutomaticDimension;
    self.pickupTableView.estimatedRowHeight = 44;
    self.pickupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.pickupTableView];
    [self.pickupTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 请求自提商城数据
- (void)getCarryBySelfData:(BOOL)showLoading {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getGoodsList_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString,DeviceId:uuid};
    if (showLoading == YES) {
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *itemDic = json;
        if ([itemDic[@"code"] integerValue] != 200) {
            return ;
        }
        [self.pickupDataArray removeAllObjects];
        NSArray *itemArr = itemDic[@"items"];
        for (NSDictionary *goodDic in itemArr) {
            CKPickupGoodsModel *goodsModel = [[CKPickupGoodsModel alloc] init];
            [goodsModel setValuesForKeysWithDictionary:goodDic];
            [self.pickupDataArray addObject:goodsModel];
        }
        
        [[XNArchiverManager shareInstance] xnArchiverObject:self.pickupDataArray archiverName:[NSString stringWithFormat:@"%@_%@", _ckidString, @"selfCarryGoods"]];
        
        [self.pickupTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pickupDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CKPickupMallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKPickupMallCell"];
    if (!cell) {
        cell = [[CKPickupMallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKPickupMallCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    if ([self.pickupDataArray count] > 0) {
        CKPickupGoodsModel *goodsModel = self.pickupDataArray[indexPath.row];
        [cell updateCellData:goodsModel];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([UIScreen mainScreen].bounds.size.height <= 568) {
        return 95;
    }else{
        return 130;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CKPickupGoodsModel *goodsM = self.pickupDataArray[indexPath.row];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    [tempArr addObject:goodsM];
    
    NSString *priceDoubleStr = [NSString stringWithFormat:@"%@", goodsM.price];
    NSString *priceStr = [NSString reviseString:priceDoubleStr];
    NSString *localCountStr = [NSString stringWithFormat:@"%@", goodsM.count];
    if (IsNilOrNull(localCountStr)) {
        localCountStr = @"1";
    }
    NSInteger count = [localCountStr integerValue];
    NSDecimalNumber *num = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    num = SNAdd(SNMul(@(count),priceStr), num);
    NSString *result = [NSString stringWithFormat:@"%@", num];
    
    SCGoodsDetailViewController *goodsDetail = [[SCGoodsDetailViewController alloc] init];
    goodsDetail.goodsId = goodsM.ID;
    goodsDetail.allMoneyString = [NSString stringWithFormat:@"合计：￥%.2f", [result doubleValue]];
    goodsDetail.tempArray = tempArr;
    
    [self.navigationController pushViewController:goodsDetail animated:YES];
}

#pragma mark - CKPickupMallCellDelegate
- (void)cKPickupMallCell:(CKPickupMallCell *)pickupMallCell didSelectAtIndexPath:(NSIndexPath *)indexPath goodsModel:(CKPickupGoodsModel *)goodsModel {
    
    NSLog(@"单选传过来的 名字 %@数量%@ ", goodsModel.name, goodsModel.count);
    NSMutableArray *array =  [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i<self.pickupDataArray.count; i++) {
        goodsModel  = [self.pickupDataArray objectAtIndex:i];
        if (goodsModel.isSelect){
            [array addObject:goodsModel];
            if (array.count == self.pickupDataArray.count) {
                _bottomView.allSelectedButton.selected = YES;
            }
        }else{
            _bottomView.allSelectedButton.selected = NO;
        }
    }
    goodsModel = self.pickupDataArray[indexPath.row];
    [self calculatePrice:goodsModel];
}

#pragma mark - 计算总价格
- (void)calculatePrice:(CKPickupGoodsModel*)goodsModel {
    NSDecimalNumber *num = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSString *result = nil;
    for (int i=0; i<self.pickupDataArray.count; i++) {
        goodsModel = [self.pickupDataArray objectAtIndex:i];
        NSString *priceDoubleStr = [NSString stringWithFormat:@"%@", goodsModel.price];
        NSString *priceStr = [NSString reviseString:priceDoubleStr];
        
        NSString *localCountStr = [NSString stringWithFormat:@"%@",  goodsModel.count];
        if (IsNilOrNull(localCountStr)) {
            localCountStr = @"1";
        }
        NSInteger count = [localCountStr integerValue];
        if (goodsModel.isSelect) {
            num = SNAdd(SNMul(@(count),priceStr), num);
            result = [NSString stringWithFormat:@"%@",num];
            NSLog(@"数量===%ld  价格===%@  合计金额===%@",count,priceStr,num);
        }
    }
    if (IsNilOrNull(result)) {
        result = @"0.00";
    }
    double priceDouble = [result doubleValue];
    _bottomView.realPayMoneyLable.text = [NSString stringWithFormat:@"合计：￥%.2f", priceDouble];
}

#pragma mark-点击bottomView代理方法全选788  点击立即购买 789
- (void)bottomViewButtonClicked:(UIButton *)button {
    switch (button.tag -788) {
        case 0: //全选
        {
            button.selected = !button.selected;
            for (int i =0; i<self.pickupDataArray.count; i++) {
                CKPickupGoodsModel *goodsModel = [self.pickupDataArray objectAtIndex:i];
                goodsModel.isSelect = button.isSelected;
                [self calculatePrice:goodsModel];
                NSLog(@"全选按钮传过来的 名字 %@数量%@ ", goodsModel.name, goodsModel.count);
            }
            [self.pickupTableView reloadData];
        }
            break;
        case 1: //立即购买
        {
            [self.selectedArray removeAllObjects];
            for (int i = 0;i<self.pickupDataArray.count;i++) {
                CKPickupGoodsModel *goodsModel = [self.pickupDataArray objectAtIndex:i];
                if (goodsModel.isSelect) {//选中
                    [self.selectedArray addObject:goodsModel];
                }
            }
            if (![self.selectedArray count]) {
                [self showNoticeView:@"请先选择商品"];
                return;
            }
            NSMutableArray *mutable_arr = [NSMutableArray array];
            for (CKPickupGoodsModel *goodsModel in self.selectedArray) {
                [mutable_arr addObject:goodsModel.ispay];
            }
            NSLog(@"%@",mutable_arr);
            //如果选择2种 及2种以上商品
            if (mutable_arr.count > 1) {
                for (int i=0;i<mutable_arr.count;i++) {
                    
                    NSString *firstStr = [NSString stringWithFormat:@"%@",mutable_arr[0]];
                    NSString *secondStr = [NSString stringWithFormat:@"%@",mutable_arr[i]];
                    if (![firstStr isEqualToString:secondStr]) {
                        //说明选择了混合商品 提示不能选择混合商品  所选商品中包含需线上支付的商品
                        MessageAlert *alert = [MessageAlert shareInstance];
                        [alert hiddenCancelBtn:YES];
                        [alert showMsgAlert:CKYSmsgpick btnClick:^{}];
                        
                        return;
                    }
                }
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                for (CKPickupGoodsModel *goodsModel in self.selectedArray) {
                    [tempArr addObject:goodsModel];
                }
                
                SureMySelfOrderViewController *sureMySelf = [[SureMySelfOrderViewController alloc]init];
                sureMySelf.allMoneyString = _bottomView.realPayMoneyLable.text;
                sureMySelf.dataArray = tempArr;
                sureMySelf.showCount = YES;
                [self.navigationController pushViewController:sureMySelf animated:YES];
            }else{   //以下是如果选择了一种商品
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                for (CKPickupGoodsModel *goodsModel in self.selectedArray) {
                    [tempArr addObject:goodsModel];
                }
                SureMySelfOrderViewController *sureMySelf = [[SureMySelfOrderViewController alloc]init];
                sureMySelf.allMoneyString = _bottomView.realPayMoneyLable.text;
                sureMySelf.dataArray = tempArr;
                sureMySelf.showCount = YES;
                [self.navigationController pushViewController:sureMySelf animated:YES];
            }
        }
            break;
        default:
            break;
    }
    
}

@end
