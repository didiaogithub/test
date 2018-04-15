//
//  CarrySelfSearchViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/12/3.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "CarrySelfSearchViewController.h"
#import "CKPickupMallCell.h"
#import "CKPickupGoodsModel.h"
#import "OrderBottomView.h"
#import "SureMySelfOrderViewController.h"
#import "SearchNavView.h"
#import "SCGoodsDetailViewController.h"

@interface CarrySelfSearchViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CKPickupMallCellDelegate, OrderBottomViewDelegate, SearchNavViewDelegate>
{
    
    UILabel *_countLable;
    NSString *_ckidString;
    SearchNavView *_searchNavView;
     NSString *_isHasSearch;
}

@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NodataImageView *nodataImageView;
@property (nonatomic, strong) OrderBottomView *bottomView;

@end

@implementation CarrySelfSearchViewController

- (NodataImageView *)nodataImageView {
    if(_nodataImageView == nil) {
        _nodataImageView = [[NodataImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64-49)];
    }
    return _nodataImageView;
}

- (NSMutableArray *)searchArray {
    if (_searchArray == nil) {
        _searchArray = [[NSMutableArray alloc] init];
    }
    return _searchArray;
}

- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搜索";
    [CKCNotificationCenter addObserver:self selector:@selector(isHasSearch) name:IsHasSearch object:nil];
    [self createOtherViews];
    [self createTableView];
    
}
-(void)dealloc{
    [CKCNotificationCenter removeObserver:self name:IsHasSearch object:nil];
}
#pragma mark-是否已经搜索
-(void)isHasSearch{
    _isHasSearch = @"1";
    [self.searchTableView reloadData];
    
}
#pragma mark-请求搜索商品数据
-(void)getSearchCarryBySelfData{
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    NSString *searchText = _searchNavView.searchTextField.text;
    if (IsNilOrNull(searchText)) {
        searchText = @"";
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *requesUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,searchGoods_Url];
    NSDictionary *pramaDic = @{@"keywords":searchText,@"ckid":_ckidString,DeviceId:uuid};
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:requesUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        
        [CKCNotificationCenter postNotificationName:SearchSuccess object:@"YES"];
        [CKCNotificationCenter postNotificationName:IsHasSearch object:nil];
        NSDictionary *itemDic = json;
        if ([itemDic[@"code"] integerValue]!=200) {
            [self showNoticeView:itemDic[@"codeinfo"]];
            return ;
        }
        NSArray *itemArr = itemDic[@"items"];
        for (NSDictionary *listDic in itemArr) {
            CKPickupGoodsModel *goodsModel = [[CKPickupGoodsModel alloc] init];
            [goodsModel setValuesForKeysWithDictionary:listDic];
            [self.searchArray addObject:goodsModel];
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

-(void)createTableView{
    
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
    
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_searchTableView];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_searchTableView setBackgroundColor:[UIColor tt_grayBgColor]];
    [_searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([_isHasSearch isEqualToString:@"1"]){
        [tableView tableViewDisplayView:self.nodataImageView ifNecessaryForRowCount:self.searchArray.count];
    }
   return self.searchArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CKPickupMallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKPickupMallCell"];
    if (!cell) {
        cell = [[CKPickupMallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKPickupMallCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    if ([self.searchArray count] > 0) {
        CKPickupGoodsModel *goodsModel = self.searchArray[indexPath.row];
        [cell updateCellData:goodsModel];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([UIScreen mainScreen].bounds.size.height <= 568) {
        return 95;
    }else{
        return 130;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CKPickupGoodsModel *goodsM = self.searchArray[indexPath.row];
    
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
    for (int i = 0; i<self.searchArray.count; i++) {
        goodsModel  = [self.searchArray objectAtIndex:i];
        if (goodsModel.isSelect){
            [array addObject:goodsModel];
            if (array.count == self.searchArray.count) {
                _bottomView.allSelectedButton.selected = YES;
            }
        }else{
            _bottomView.allSelectedButton.selected = NO;
        }
    }
    goodsModel = self.searchArray[indexPath.row];
    [self calculatePrice:goodsModel];
}

#pragma mark - 计算总价格
- (void)calculatePrice:(CKPickupGoodsModel*)goodsModel {
    NSDecimalNumber *num = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSString *result = @"";
    for (int i=0; i<self.searchArray.count; i++) {
        goodsModel = [self.searchArray objectAtIndex:i];
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

#pragma mark - 点击bottomView代理方法全选788  点击立即购买 789
- (void)bottomViewButtonClicked:(UIButton *)button {
    switch (button.tag -788) {
        case 0: //全选
        {
            button.selected = !button.selected;
            for (int i =0; i<self.searchArray.count; i++) {
                CKPickupGoodsModel *goodsModel = [self.searchArray objectAtIndex:i];
                goodsModel.isSelect = button.isSelected;
                [self calculatePrice:goodsModel];
                NSLog(@"全选按钮传过来的 名字 %@数量%@ ", goodsModel.name, goodsModel.count);
            }
            [self.searchTableView reloadData];
        }
            break;
        case 1: //立即购买
        {
            [self.selectedArray removeAllObjects];
            for (int i = 0;i<self.searchArray.count;i++) {
                CKPickupGoodsModel *goodsModel = [self.searchArray objectAtIndex:i];
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
                for (CKPickupGoodsModel *goodModel in self.selectedArray) {
                    [tempArr addObject:goodModel];
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

#pragma mark-创建搜索栏
-(void)createOtherViews {
    if (@available(iOS 11.0, *)) {
        _searchNavView = [[SearchNavView alloc] init];
        [self.view addSubview:_searchNavView];
        _searchNavView.searchTextField.placeholder = @"请输入您要查询的商品名";
        _searchNavView.delegate = self;
        [_searchNavView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_offset(0);
            make.height.mas_offset(64);
        }];
    }else{
        _searchNavView = [[SearchNavView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _searchNavView.searchTextField.placeholder = @"请输入您要查询的商品名";
        _searchNavView.delegate = self;
    }
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = _searchNavView;
}

#pragma mark-/**返回上一页*/
-(void)poptoLastPage{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-点击键盘上的搜索按钮
-(void)keyboardSearchWithString:(NSString *)searchStr{
    NSString *searchText = _searchNavView.searchTextField.text;
    if (IsNilOrNull(searchText)){
        [CKCNotificationCenter postNotificationName:SearchSuccess object:@"YES"];
        [self showNoticeView:@"请输入您要查询的商品名"];
        return;
    }
    [self.searchArray removeAllObjects];
    for (NSString *str in self.searchArray)
    {
        if ([str isEqualToString:searchStr])
        {
            [self.searchArray addObject:str];
        }
    }
    [self getSearchCarryBySelfData];
    
}


@end
