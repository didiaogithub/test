//
//  CKPickupMallSearchVC.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/2/26.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKPickupMallSearchVC.h"
#import "CKPickupMallCell.h"
#import "CKPickupGoodsModel.h"
#import "OrderBottomView.h"
#import "SureMySelfOrderViewController.h"
#import "SCGoodsDetailViewController.h"

@interface CKPickupMallSearchVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CKPickupMallCellDelegate, OrderBottomViewDelegate>
{
    UILabel *_countLable;
    NSString *_ckidString;
    NSString *_isHasSearch;
}

@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) UITableView *pickupTableView;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) OrderBottomView *bottomView;

@end

@implementation CKPickupMallSearchVC

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
    
    self.searchNavView.searchTextField.placeholder = @"请输入您要查询的商品名";
    
    [CKCNotificationCenter addObserver:self selector:@selector(isHasSearch) name:IsHasSearch object:nil];
    [self createTableView];
    
}
-(void)dealloc{
    [CKCNotificationCenter removeObserver:self name:IsHasSearch object:nil];
}
#pragma mark-是否已经搜索
-(void)isHasSearch{
    _isHasSearch = @"1";
    [self.pickupTableView reloadData];
    
}
#pragma mark-请求搜索商品数据
-(void)getSearchCarryBySelfData{
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    NSString *searchText = self.searchNavView.searchTextField.text;
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
    
    _pickupTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_pickupTableView];
    _pickupTableView.delegate = self;
    _pickupTableView.dataSource = self;
    _pickupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_pickupTableView setBackgroundColor:[UIColor tt_grayBgColor]];
    [_pickupTableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
            [self.pickupTableView reloadData];
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

#pragma mark-点击键盘上的搜索按钮
-(void)keyboardSearchWithString:(NSString *)searchStr{
    NSString *searchText = self.searchNavView.searchTextField.text;
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
