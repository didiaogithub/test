//
//  SearchViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/24.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "OrderSearchViewController.h"
#import "OrderMessageTableViewCell.h"
#import "WxuserOrderTableViewCell.h"
#import "OrderModel.h"
#import "CKOrderDetailViewController.h"
#import "SearchNavView.h"
#import "orderFooterView.h"
#import "DetailLogisticsViewController.h"
#import "WxuserView.h"
#import "CKPayViewController.h"
#import "PayMoneyViewController.h"

static NSString *searchWxuserCell = @"WxuserCell";
@interface OrderSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SearchNavViewDelegate>
{
    OrderModel *_orderModel;
    Ordersheet *_orderDetailModel;
    UILabel *_orderNumberLable;  //订单编号
    UILabel *_orderStateLable;  //订单状态
    UILabel *_totalFeeLable; //订单总价格
    UILabel *_orderTime;  //下单时间
    NSString *_ckidString;
    NSString *_oidString;
    NSString *_yearStr;
    NSString *_monthStr;
    UIButton *searchButton;
    NSString *_isPopularizeSales;
    SearchNavView *_searchNavView;
    NSString *_isHasSearch;
}


@property (nonatomic, strong) orderFooterView *footerView;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *searchSourceArray;
@property (nonatomic, strong) NSMutableArray *detailArray;
@property (nonatomic, strong) NodataImageView *nodataImageView;
@property (nonatomic, strong) WxuserView *wxUserView;

@end

@implementation OrderSearchViewController

- (NodataImageView *)nodataImageView
{
    if(_nodataImageView == nil) {
        _nodataImageView = [[NodataImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64-49)];
    }
    return _nodataImageView;
}

-(NSMutableArray *)detailArray{
    if (_detailArray == nil) {
        _detailArray = [[NSMutableArray alloc] init];
    }
    return _detailArray;
}
-(NSMutableArray *)searchSourceArray{
    if (_searchSourceArray == nil) {
        _searchSourceArray = [[NSMutableArray alloc] init];
    }
    return _searchSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"搜索";
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
    _orderModel = [[OrderModel alloc] init];
    [CKCNotificationCenter addObserver:self selector:@selector(isHasSearch) name:IsHasSearch object:nil];
    _isPopularizeSales = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    [self createOtherViews];
    [self createTableView];
}
#pragma mark-是否已经搜索
-(void)isHasSearch{
    _isHasSearch = @"1";
    [self.searchTableView reloadData];
    
}
#pragma mark-请求我的订单页面数据
-(void)createSerachMyOrderData{
    [self.searchSourceArray removeAllObjects];
    //    下单类型（CK：创客自提订单  WXUSER：商城订单）
    
    if (IsNilOrNull(_oidString)) {
        _oidString = @"";
    }
    if(IsNilOrNull(self.buyertype)){
        self.buyertype = @"";
    }
    if (IsNilOrNull(_yearStr)) {
        _yearStr = @"";
    }
    if (IsNilOrNull(_monthStr)) {
        _monthStr = @"";
    }
    if (IsNilOrNull(self.statusString)) {
        self.statusString = @"";
    }
    if (IsNilOrNull(_isPopularizeSales)) {
        _isPopularizeSales = @"";
    }
    
    NSString *searchText = _searchNavView.searchTextField.text;
    if (IsNilOrNull(searchText)) {
        searchText = @"";
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSString *requestUrl = @"";
    NSDictionary *params = [NSDictionary dictionary];
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if(!IsNilOrNull(homeLoginStatus)){
        requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getMyOrders_Url];
        params = @{@"ckid":_ckidString, @"pagesize":@"10000", @"tgid":_isPopularizeSales, @"oid":_oidString, @"orderstatus":self.statusString, @"buyertype":self.buyertype, @"keywords":searchText, @"year":_yearStr, @"month":_monthStr, DeviceId:uuid};
    }else{
        requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Regist/getOrders"];
        
        NSString *unionid = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:Kunionid]];
        params = @{@"unionid":unionid, @"pagesize":@"10000", @"tgid":_isPopularizeSales, @"oid":_oidString, @"orderstatus":self.statusString, @"buyertype":self.buyertype, @"keywords":searchText, @"year":_yearStr, @"month":_monthStr, DeviceId:uuid};
    }
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:requestUrl params:params success:^(id json) {
        [self.viewDataLoading stopAnimation];
        [CKCNotificationCenter postNotificationName:SearchSuccess object:@"YES"];
        [CKCNotificationCenter postNotificationName:IsHasSearch object:nil];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        NSArray *listArr = dict[@"list"];
        for (NSDictionary *listOrderDic in listArr) {
            OrderModel *orderM = [[OrderModel alloc] init];;
            [orderM setValuesForKeysWithDictionary:listOrderDic];
            NSArray *ordersheetArr = listOrderDic[@"ordersheet"];
            if (ordersheetArr.count > 0) {
                
                for (NSInteger i = 0; i<ordersheetArr.count; i++) {
                    Ordersheet *orderSheet = [[Ordersheet alloc] init];
                    NSDictionary *dic = ordersheetArr[i];
                    [orderSheet setValuesForKeysWithDictionary:dic];
                    orderSheet.sheetKey = [NSString stringWithFormat:@"%@_%@_%ld",orderSheet.oid, orderSheet.itemid, i];
                    [orderM.orderArray addObject:orderSheet];
                }
            }
            [self.searchSourceArray addObject:orderM];
        }
    
        if ([self.searchSourceArray count] == 0) {
            [self.view addSubview:self.nodataImageView];
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

/**创建搜索框*/
-(void)createOtherViews{
    
    if (@available(iOS 11.0, *)) {
        _searchNavView = [[SearchNavView alloc] init];
        [self.view addSubview:_searchNavView];
        _searchNavView.searchTextField.placeholder = @"订单号、收件人姓名、电话等";
        _searchNavView.delegate = self;
        [_searchNavView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_offset(0);
            make.height.mas_offset(64);
        }];
    }else{
        _searchNavView = [[SearchNavView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _searchNavView.searchTextField.placeholder = @"订单号、收件人姓名、电话等";
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
        [self showNoticeView:@"请输入您要查询的内容"];
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
    [self createSerachMyOrderData];
    
}
-(void)createTableView{
    if (@available(iOS 11.0, *)) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-65-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    }else{
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1,SCREEN_WIDTH, SCREEN_HEIGHT-1) style:UITableViewStylePlain];
    }
    [self.view addSubview:_searchTableView];
    _searchTableView.rowHeight = UITableViewAutomaticDimension;
    _searchTableView.estimatedRowHeight = 44;
    _searchTableView.backgroundColor = [UIColor tt_gradientTitleColor];
    if (@available(iOS 11.0, *)) {
        _searchTableView.estimatedSectionFooterHeight = 0.001;
        _searchTableView.estimatedSectionHeaderHeight = 0.001;
    }
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.backgroundColor = [UIColor whiteColor];
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_searchTableView setBackgroundColor:[UIColor tt_grayBgColor]];
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([_isHasSearch isEqualToString:@"1"]){
       [tableView tableViewDisplayView:self.nodataImageView ifNecessaryForRowCount:self.searchSourceArray.count];
    }
    return self.searchSourceArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([_buyertype isEqualToString:@"CK"]){
        _orderModel = self.searchSourceArray[section];
        return _orderModel.orderArray.count;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if([self.buyertype isEqualToString:@"CK"]){
        OrderMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderMessageTableViewCell"];
        if (cell == nil) {
            cell = [[OrderMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderMessageTableViewCell"];
        }
        if ([self.searchSourceArray count]) {
            _orderModel = self.searchSourceArray[indexPath.section];
            if(_orderModel.orderArray.count > 0){
                _orderDetailModel = _orderModel.orderArray[indexPath.row];
                [cell refreshWithModel:_orderDetailModel];

            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        WxuserOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchWxuserCell];
        if (cell == nil) {
            cell = [[WxuserOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchWxuserCell];
        }
        if ([self.searchSourceArray count]){
            _orderModel = self.searchSourceArray[indexPath.section];
            [cell refreshWithModel:_orderModel];
        }
        cell.backgroundColor = [UIColor tt_grayBgColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([_buyertype isEqualToString:@"CK"]){
        return 40;
    }else{
        return 0.0001;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    _orderNumberLable = [UILabel configureLabelWithTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [headerView addSubview:_orderNumberLable];
    _orderNumberLable.text = @"订单编号：";
    [_orderNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(19);
        make.left.mas_offset(10);
        make.width.mas_offset(SCREEN_WIDTH*2/3);
        make.bottom.mas_offset(-10);
    }];
    
    
    _orderStateLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM(15)];
    [headerView addSubview:_orderStateLable];
    [_orderStateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_orderNumberLable);
        make.right.mas_offset(-AdaptedWidth(18));
    }];
    
    if ([self.searchSourceArray count]) {
        _orderModel = self.searchSourceArray[section];
        [self refreshWithStatusLableWithorderModel:_orderModel];
    }
    return headerView;
}
/**刷新段头上订单状态*/
-(void)refreshWithStatusLableWithorderModel:(OrderModel *)ordeModel{

    _orderNumberLable.text = [NSString stringWithFormat:@"订单编号：%@",ordeModel.no];
    if ([ordeModel.orderstatus isEqualToString:@"0"] || [ordeModel.orderstatus isEqualToString:@"2"]) {//已取消 已付款
        if([ordeModel.orderstatus isEqualToString:@"0"]){
            _orderStateLable.text = @"已取消";
        }else if([ordeModel.orderstatus isEqualToString:@"2"]){
            _orderStateLable.text = @"待发货";
            
        }
    }else if([ordeModel.orderstatus isEqualToString:@"1"]){//未付款
        _orderStateLable.text = @"待付款";
    }else if ([ordeModel.orderstatus isEqualToString:@"3"]||[ordeModel.orderstatus isEqualToString:@"4"]||[ordeModel.orderstatus isEqualToString:@"5"]||[ordeModel.orderstatus isEqualToString:@"6"]){//已收货
        if([ordeModel.orderstatus isEqualToString:@"3"]){
            _orderStateLable.text = @"已收货";
        }else if([ordeModel.orderstatus isEqualToString:@"4"]){
            _orderStateLable.text = @"正在退货";
            
        }else if([ordeModel.orderstatus isEqualToString:@"5"]){
            _orderStateLable.text = @"退货成功";
        }else if([ordeModel.orderstatus isEqualToString:@"6"]){
            _orderStateLable.text = @"已完成";
            
        }
        
    }else if ([ordeModel.orderstatus isEqualToString:@"7"]){//已发货
        _orderStateLable.text = @"已发货";
    }
    
}

#pragma mark-段尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.searchSourceArray count]) {
        _orderModel = self.searchSourceArray[section];
    }
    NSString *statustr = [NSString stringWithFormat:@"%@",_orderModel.orderstatus];
    if ([self.buyertype isEqualToString:@"CK"]){
        if([statustr isEqualToString:@"0"] || [statustr isEqualToString:@"2"]){
            return  AdaptedHeight(55);
        }else{
            return  AdaptedHeight(110);
        }
    }else{
        return  AdaptedHeight(40);
    }
}
#pragma mark-创建段尾UI
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if ([self.searchSourceArray count]) {
        _orderModel = self.searchSourceArray[section];
    }
    NSString *statustr = [NSString stringWithFormat:@"%@",_orderModel.orderstatus];
    if ([self.buyertype isEqualToString:@"CK"]){
        if ([statustr isEqualToString:@"0"] || [statustr isEqualToString:@"2"]){
            _wxUserView = [[WxuserView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,AdaptedHeight(55)) andTypeStr:self.buyertype];
        }else{
            _footerView = [[orderFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,AdaptedHeight(110)) andType:statustr andTypeStr:_buyertype];
            _footerView.rightButton.tag = 170+section;
        }
    }else{
        _wxUserView = [[WxuserView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,AdaptedHeight(55))  andTypeStr:self.buyertype];
    }
    [_footerView.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self refreshFooterData:_orderModel];
    if ([self.buyertype isEqualToString:@"CK"]){
        if ([statustr isEqualToString:@"0"] || [statustr isEqualToString:@"2"]) {
            return _wxUserView;
        }else{
            return _footerView;
        }
    }else{
        return _wxUserView;
    }
}
-(void)refreshFooterData:(OrderModel *)orderModel
{
    NSString *allMoney = [NSString stringWithFormat:@"%@", orderModel.ordermoney];
    NSString *timeStr = [NSString stringWithFormat:@"%@",orderModel.time];
    if (IsNilOrNull(timeStr)){
        timeStr = @"下单时间:";
    }
    NSString *status = [NSString stringWithFormat:@"%@",orderModel.orderstatus];
    if (IsNilOrNull(status)){
        status = @"";
    }
    
    float moneyfloat = [allMoney floatValue];
    if ([_buyertype isEqualToString:@"WXUSER"]){
        //微信用户除了7的状态下
        _wxUserView.orderTimeLable.text = [NSString stringWithFormat:@"下单时间:%@",timeStr];
    }else{
        if ([status isEqualToString:@"0"] || [status isEqualToString:@"2"]) {
            _wxUserView.priceLable.text = [NSString stringWithFormat:@"合计：¥%.2f(含运费¥%@)",moneyfloat,@"0.00"];
            _wxUserView.orderTimeLable.text = [NSString stringWithFormat:@"下单时间:%@",timeStr];
        }else{
            _footerView.priceLable.text = [NSString stringWithFormat:@"合计：¥%.2f(含运费¥%@)",moneyfloat,@"0.00"];
            _footerView.orderTimeLable.text = [NSString stringWithFormat:@"下单时间:%@",timeStr];
            
        }
    }

}


#pragma mark-查看物流  去支付
-(void)clickRightButton:(UIButton *)button{
    NSInteger index = button.tag - 170;
    if ([self.searchSourceArray count]) {
        _orderModel = self.searchSourceArray[index];
    }
    NSString *status = [NSString stringWithFormat:@"%@",_orderModel.orderstatus];
    NSString *no = [NSString stringWithFormat:@"%@", _orderModel.no];
    if ([status isEqualToString:@"1"]) { //未付款
            //成功之后  生成 总金额 和订单 去支付
            NSString *payfeeStr = [NSString stringWithFormat:@"%@",_orderModel.money];
            NSString *oidStr = [NSString stringWithFormat:@"%@",_orderModel.oid];
            if (IsNilOrNull(payfeeStr)) {
                payfeeStr = @"";
            }
            if (IsNilOrNull(oidStr)) {
                oidStr = @"";
            }
        if ([no containsString:@"dlb"]) {
            CKPayViewController *payMoney = [[CKPayViewController alloc] init];
            payMoney.payfee = payfeeStr;
            payMoney.orderId = oidStr;
            payMoney.ckid = _ckidString;
            payMoney.fromVC = @"CKOrderList";
            [self.navigationController pushViewController:payMoney animated:YES];
        }else{
            PayMoneyViewController *payMoney = [[PayMoneyViewController alloc] init];
            payMoney.payfeeStr = payfeeStr;
            payMoney.oidStr = oidStr;
            payMoney.type = @"ziti";
            [self presentViewController:[[RootNavigationController alloc] initWithRootViewController:payMoney] animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }else if ([status isEqualToString:@"7"]){  //已发货查看物流
        NSString *oidString = [NSString stringWithFormat:@"%@",_orderModel.oid];
        //点击进入物流详情
        DetailLogisticsViewController *detailLogist = [[DetailLogisticsViewController alloc] init];
        detailLogist.oidString = oidString;
        [self.navigationController pushViewController:detailLogist animated:YES];
    }else{
         //只有我的订单显示 删除订单
            [self deleteMyorderByModel:_orderModel andIndex:index];
    }
    
}
#pragma mark-删除订单
-(void)deleteMyorderByModel:(OrderModel *)orderModel andIndex:(NSInteger)index{
    
    [MessageAlert shareInstance].isDealInBlock = YES;
    [[MessageAlert shareInstance] hiddenCancelBtn:NO];
    [[MessageAlert shareInstance] showCommonAlert:@"确定要删除该订单？" btnClick:^{
       NSString * deletIdStr = [NSString stringWithFormat:@"%@",orderModel.oid];
        if (IsNilOrNull(deletIdStr)){
            deletIdStr = @"";
        }
        NSString *uuid = DeviceId_UUID_Value;
        if (IsNilOrNull(uuid)){
            uuid = @"";
        }
        NSDictionary * pramaDic = @{@"ckid":_ckidString,@"orderid":deletIdStr,DeviceId:uuid};
        NSString *deleteUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,deleteOrder_Url];
        [HttpTool postWithUrl:deleteUrl params:pramaDic success:^(id json) {
            //删除成功之后删除数组数据
            NSDictionary *dict = json;
            if ([dict[@"code"] integerValue] != 200) {
                [self showNoticeView:dict[@"codeinfo"]];
                return ;
            }
            
            if ([self.searchSourceArray count]) {
                [self.searchSourceArray removeObjectAtIndex:index];
                [self.searchTableView reloadData];
            }
        } failure:^(NSError *error) {
            if (error.code == -1009) {
                [self showNoticeView:NetWorkNotReachable];
            }else{
                [self showNoticeView:NetWorkTimeout];
            }
        }];

    }];
    
}

/**点击进入详情*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.searchSourceArray count]) {
        _orderModel = self.searchSourceArray[indexPath.section];
        _orderDetailModel = _orderModel.orderArray[indexPath.row];
        
    }
    CKOrderDetailViewController *checkOrder = [[CKOrderDetailViewController alloc] init];
    checkOrder.orderModel = _orderModel;
    checkOrder.dataArray = _orderModel.orderArray;
    checkOrder.orderstatusString = _orderModel.orderstatus;
    checkOrder.typeString = _buyertype;
    [self.navigationController pushViewController:checkOrder animated:YES];
}

-(void)dealloc{
    [CKCNotificationCenter removeObserver:self name:IsHasSearch object:nil];
}

@end
