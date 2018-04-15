//
//  CKConfirmRegisterOrderVC.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKConfirmRegisterOrderVC.h"
#import "CKDLBAddressCell.h"
#import "AddressModel.h"
#import "CKBottomView.h"
#import "AddAddressTableViewCell.h"
#import "CKdlbGoodsModel.h"
#import "CKConfirmRegisterOrderCell.h"
#import "CKAddressViewController.h"
#import "CKChooseJoinGoodsVC.h"
#import "CKOrderinfoModel.h"
#import "CKPayViewController.h"
#import "ChangeMyAddressViewController.h"
#import "XWAlterVeiw.h"
#import "CKOrderinfoModel.h"

@interface CKConfirmRegisterOrderVC ()<UITableViewDelegate, UITableViewDataSource, CKBottomViewDelegate, AddAddressTableViewCellDelegate, XWAlterVeiwDelegate>

@property (nonatomic, strong) CKBottomView *bottomeView;
@property (nonatomic, strong) UITableView *sureOrderTableView;
@property (nonatomic, strong) AddressModel *addressModel;
@property (nonatomic, strong) UIButton *selectedAddressButton;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) MessageAlert *successAlertView;
@property (nonatomic, strong) CKdlbGoodsModel *goodsM;

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *goodsName;

@end

@implementation CKConfirmRegisterOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"确认订单";
    
    if (!IsNilOrNull(self.ckid)) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *key = [NSString stringWithFormat:@"%@_%@", self.ckid, @"DefaultAddress"];
        NSString *defaultAddressPath = [path stringByAppendingPathComponent:key];
        AddressModel *addressM = [NSKeyedUnarchiver unarchiveObjectWithFile:defaultAddressPath];
        if (addressM != nil) {
            self.addressModel = addressM;
        }else{
            NSString *unionid = [KUserdefaults objectForKey:Kunionid];
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            NSString *filePath = [path stringByAppendingPathComponent:unionid];
            AddressModel *addressModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            if (addressModel != nil) {
                _addressModel = addressModel;
            }else{
                [self requestDefaultAddress];
            }
        }
    }else{
        NSString *unionid = [KUserdefaults objectForKey:Kunionid];
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *filePath = [path stringByAppendingPathComponent:unionid];
        AddressModel *addressModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (addressModel != nil) {
            _addressModel = addressModel;
        }
    }
    
    //说明是从首页直接跳转进来的
    if (self.dataArray.count > 0) {
        _goodsM = self.dataArray.firstObject;
        
        self.goodsName = [NSString stringWithFormat:@"%@", _goodsM.name];
        self.goodsId = [NSString stringWithFormat:@"%@", _goodsM.goodsId];

        
    }else{
        if (_orderinfoArray.count > 0) {
            NSDictionary *dict = _orderinfoArray.firstObject;
            CKOrderinfoModel *orderM = [[CKOrderinfoModel alloc] init];
            [orderM setValuesForKeysWithDictionary:dict];
            
            _goodsM = [[CKdlbGoodsModel alloc] init];
            _goodsM.goodsId = orderM.itemid;
            _goodsM.name = orderM.name;
            _goodsM.path = orderM.path;
            _goodsM.price = orderM.price;
            
            _addressModel = [[AddressModel alloc] init];
            _addressModel.gettername = orderM.gettername;
            _addressModel.gettermobile = orderM.gettermobile;
            NSArray *arr = [orderM.getteraddress componentsSeparatedByString:@" "];
            NSRange range = [orderM.getteraddress rangeOfString:arr.lastObject];
            _addressModel.address = [orderM.getteraddress substringToIndex:range.location];
            _addressModel.homeaddress = arr.lastObject;
            
            self.goodsName = [NSString stringWithFormat:@"%@", orderM.name];
            self.goodsId = [NSString stringWithFormat:@"%@", orderM.itemid];
            
            
        }
    }
    
    
    [self createTableView];
    [self refreshAllPayMoney];
}

-(void)refreshAllPayMoney{
    _bottomeView.moneyLable.text = [NSString stringWithFormat:@"合计:¥%@", self.totalMoney];
}

-(void)createTableView {
    _bottomeView = [[CKBottomView alloc] init];
    _bottomeView.delegate = self;
    [self.view addSubview:_bottomeView];
    [_bottomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
        make.height.mas_equalTo(50);
    }];
    
    _sureOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1+64,  SCREEN_WIDTH, SCREEN_HEIGHT - 1- 64 - 50) style:UITableViewStyleGrouped];
    [self.view addSubview:_sureOrderTableView];
    [_sureOrderTableView setBackgroundColor:[UIColor tt_grayBgColor]];
    self.sureOrderTableView.rowHeight = UITableViewAutomaticDimension;
    self.sureOrderTableView.estimatedRowHeight = 44;
    if (@available(iOS 11.0, *)){
        self.sureOrderTableView.estimatedSectionHeaderHeight = 0.1;
        self.sureOrderTableView.estimatedSectionFooterHeight = 0.1;
    }
    _sureOrderTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _sureOrderTableView.delegate  = self;
    _sureOrderTableView.dataSource = self;
    [_sureOrderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.equalTo(_bottomeView.mas_top);
        make.top.equalTo(self.view.mas_top).offset(65+NaviAddHeight);
    }];
}

#pragma mark-tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){//地址选择
        if (self.addressModel != nil) {
            CKDLBAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKDLBAddressCell"];
            if (cell  == nil) {
                cell = [[CKDLBAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKDLBAddressCell"];
            }
            [cell refreshWithAddressModel:self.addressModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            AddAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddAddressTableViewCell"];
            if (cell  == nil) {
                cell = [[AddAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddAddressTableViewCell"];
            }
            cell.delegate = self;
            return cell;
        }
    }else{//商品 名称  数量  价格
        CKConfirmRegisterOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKConfirmRegisterOrderCell"];
        if (cell == nil) {
            cell = [[CKConfirmRegisterOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKConfirmRegisterOrderCell"];
        }
        
        [cell refreshUIWithGoodsModel:_goodsM];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self changeAddress];
    }
}

#pragma mark - 没有收货地址时点击跳转添加地址，支持修改
-(void)clickToAddressVC {
    [self changeAddress];
}

-(void)changeAddress {
    __weak typeof(self) wSelf = self;
    
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if (IsNilOrNull(homeLoginStatus)) {
        CKAddressViewController *modifyAddress = [[CKAddressViewController alloc] init];
        modifyAddress.addressModel = self.addressModel;
        [modifyAddress setAddressBlock:^(AddressModel *addressM) {
            wSelf.addressModel = addressM;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [wSelf.sureOrderTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:modifyAddress animated:YES];
    }else{
        if (!IsNilOrNull(self.ckid)) {
            ChangeMyAddressViewController *addressVC = [[ChangeMyAddressViewController alloc] init];
            [addressVC setAddressBlock:^(AddressModel *addressModel) {
                wSelf.addressModel = addressModel;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [wSelf.sureOrderTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            addressVC.pushString = @"1";  //从确认订单跳过去
            [self.navigationController pushViewController:addressVC animated:YES];
        }else{
            CKAddressViewController *modifyAddress = [[CKAddressViewController alloc] init];
            modifyAddress.addressModel = self.addressModel;
            [modifyAddress setAddressBlock:^(AddressModel *addressM) {
                wSelf.addressModel = addressM;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [wSelf.sureOrderTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [self.navigationController pushViewController:modifyAddress animated:YES];
        }
    }
}

-(void)bottomViewClickWithIndex:(NSInteger)index {
    if (index == 0) {
        if(self.addressModel == nil){
            [self showNoticeView:@"请添加收货地址"];
        }else{
            [self submitOrder];
        }
    }else{
        if ([self.fromVC isEqualToString:@"CKChooseJoinGoodsVC"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            CKChooseJoinGoodsVC *chooseDLB = [[CKChooseJoinGoodsVC alloc] init];
            
            [chooseDLB changeGoods:^(NSMutableArray *dataArray, NSString *totalMoney, NSString *itemid, NSString *goodsName) {
                
                __weak typeof(self) wSelf = self;
                wSelf.totalMoney = totalMoney;
                [wSelf refreshAllPayMoney];
                
                if ([wSelf.fromVC isEqualToString:@"MainPageVC"]) {
                    
                    wSelf.dataArray = dataArray;
                    wSelf.goodsM = dataArray.firstObject;
                    NSString *itemid = [NSString stringWithFormat:@"%@", wSelf.goodsM.goodsId];
                    NSString *name = [NSString stringWithFormat:@"%@", wSelf.goodsM.name];
                    NSString *price = [NSString stringWithFormat:@"%@", wSelf.goodsM.price];
                    NSDictionary *dic = @{@"itemid":itemid, @"name":name, @"price":price};
                    [_orderinfoArray insertObject:dic atIndex:0];
                    
                    
                }else{
                    wSelf.dataArray = dataArray;
                    wSelf.goodsM = dataArray.firstObject;
                }
                
                [wSelf.sureOrderTableView reloadData];
                
            }];
            chooseDLB.ckid = self.ckid;
            chooseDLB.showAllTypeDLB = self.showAllTypeDLB;
            chooseDLB.fromVC = @"CKConfirmRegisterOrderVC";
            [self.navigationController pushViewController:chooseDLB animated:YES];
        }
    }
}

#pragma mark - 生成订单
-(void)submitOrder {
    
    NSString *goodsName = @"";
    if (self.orderinfoArray.count > 0 && [self.fromVC isEqualToString:@"MainPageVC"]) {//有订单
        NSDictionary *dict = _orderinfoArray.firstObject;
        CKOrderinfoModel *orderM = [[CKOrderinfoModel alloc] init];
        [orderM setValuesForKeysWithDictionary:dict];
        NSString *dlbOrderItemID = [NSString stringWithFormat:@"%@", orderM.itemid];
        if (!IsNilOrNull(self.goodsId) && !IsNilOrNull(dlbOrderItemID) && ![self.goodsId isEqualToString:dlbOrderItemID]) {
            goodsName = [NSString stringWithFormat:@"%@礼包订单将变更为\"已取消\"状态", self.goodsName];
            XWAlterVeiw *alertView = [[XWAlterVeiw alloc]init];
            alertView.delegate = self;
            alertView.titleLable.text = goodsName;
            [alertView show];
        }else{
           [self processSubmitOrder];
        }
    }else{
        CKdlbGoodsModel *goodsM = self.dataArray.firstObject;
        NSString *dlbOrderItemID = [NSString stringWithFormat:@"%@", goodsM.goodsId];
        if (!IsNilOrNull(self.goodsId) && !IsNilOrNull(dlbOrderItemID) && ![self.goodsId isEqualToString:dlbOrderItemID]) {
            goodsName = [NSString stringWithFormat:@"%@礼包订单将变更为\"已取消\"状态", self.goodsName];
            XWAlterVeiw *alertView = [[XWAlterVeiw alloc]init];
            alertView.delegate = self;
            alertView.titleLable.text = goodsName;
            [alertView show];
        }else{
            [self processSubmitOrder];
        }
    }
}

-(void)subuttonClicked {
    [self processSubmitOrder];
}

-(void)processSubmitOrder {
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    
    NSString *dlbItemId = @"";
    NSString *dlbItemName = @"";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *unionid = [KUserdefaults objectForKey:Kunionid];
    NSString *smallname = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:KnickName]];
    [params setObject:unionid forKey:@"unionid"];
    [params setObject:smallname forKey:@"smallname"];

    if (self.orderinfoArray.count > 0 && [self.fromVC isEqualToString:@"MainPageVC"]) {//有订单
        
        NSDictionary *dict = _orderinfoArray.firstObject;
        CKOrderinfoModel *orderM = [[CKOrderinfoModel alloc] init];
        [orderM setValuesForKeysWithDictionary:dict];
        NSString *orderid = [NSString stringWithFormat:@"%@", orderM.orderid];
        if (!IsNilOrNull(orderid)) {
            [params setObject:orderid forKey:@"orderid"];
        }
        NSString *goodsId = [NSString stringWithFormat:@"%@", orderM.itemid];
        if (!IsNilOrNull(goodsId)) {
            [params setObject:goodsId forKey:@"id"];
        }
        
        dlbItemId = [NSString stringWithFormat:@"%@", orderM.itemid];
        dlbItemName = [NSString stringWithFormat:@"%@", orderM.name];
        
    }else{
        CKdlbGoodsModel *goodsM = self.dataArray.firstObject;
        NSString *goodsId = [NSString stringWithFormat:@"%@", goodsM.goodsId];
        if (!IsNilOrNull(goodsId)) {
            [params setObject:goodsId forKey:@"id"];
        }
        
        dlbItemId = [NSString stringWithFormat:@"%@", goodsM.goodsId];
        dlbItemName = [NSString stringWithFormat:@"%@", goodsM.name];
    }
    
    NSString *gettername = [NSString stringWithFormat:@"%@", _addressModel.gettername];
    if (!IsNilOrNull(gettername)) {
        [params setObject:gettername forKey:@"gettername"];
    }
    NSString *gettermobile = [NSString stringWithFormat:@"%@", _addressModel.gettermobile];
    if (!IsNilOrNull(gettermobile)) {
        [params setObject:gettermobile forKey:@"gettermobile"];
    }
    
    NSString *address = [NSString stringWithFormat:@"%@", _addressModel.address];
    NSString *homeaddress = [NSString stringWithFormat:@"%@", _addressModel.homeaddress];
    
    NSString *district = [address stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *detailAdrress = [homeaddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *getteraddress = [NSString stringWithFormat:@"%@ %@", district, detailAdrress];
    if (!IsNilOrNull(getteraddress)) {
        [params setObject:getteraddress forKey:@"getteraddress"];
    }
    
    NSString *invitecode = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:@"invitecode"]];
    if (IsNilOrNull(invitecode)) {
        invitecode = @"";
    }
    [params setObject:invitecode forKey:@"invitecode"];  // 新增参数invitecode
    NSString *addOrderUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, SubmitRegistOrder];
    [HttpTool postWithUrl:addOrderUrl params:params success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] intValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        NSString *orderid = [NSString stringWithFormat:@"%@",dict[@"orderid"]];
        if (IsNilOrNull(orderid)) {
            return;
        }
        
        if (!IsNilOrNull(orderid)) {
            [KUserdefaults setObject:orderid forKey:DLBORDERID];
        }
        if (!IsNilOrNull(self.totalMoney)) {
            [KUserdefaults setObject:self.totalMoney forKey:DLBORDERMoney];
        }
        
        //重新下单后要保存礼包itemid和名字
        self.goodsId = dlbItemId;
        self.goodsName = dlbItemName;
        
        
        CKPayViewController *payMoney = [[CKPayViewController alloc] init];
        payMoney.payfee = self.totalMoney;
        payMoney.orderId = orderid;
        payMoney.ckid = self.ckid;
        payMoney.addressMobile = gettermobile;
        [self.navigationController pushViewController:payMoney animated:YES];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)requestDefaultAddress {
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if (IsNilOrNull(homeLoginStatus)) {
        return;//未登录请求默认地址会报9001
    }
    NSDictionary *pramaDic = @{@"ckid": self.ckid, DeviceId:uuid};
    NSString *getDefaultAddressUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getDefaultAddress_Url];
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:getDefaultAddressUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            
            NSString *unionid = [KUserdefaults objectForKey:Kunionid];
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            NSString *filePath = [path stringByAppendingPathComponent:unionid];
            AddressModel *addressModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            if (addressModel != nil) {
                _addressModel = addressModel;
            }
            [self.sureOrderTableView reloadData];
            
        }else{
            NSString *addressID = [NSString stringWithFormat:@"%@", dict[@"id"]];
            if (!IsNilOrNull(addressID) && ![addressID isEqualToString:@"0"]) {
                self.addressModel = [[AddressModel alloc] init];
                [self.addressModel setValuesForKeysWithDictionary:dict];
                NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
                NSString *key = [NSString stringWithFormat:@"%@_%@", self.ckid, @"DefaultAddress"];
                NSString *filePath = [path stringByAppendingPathComponent:key];
                [NSKeyedArchiver archiveRootObject:self.addressModel toFile:filePath];
                [self.sureOrderTableView reloadData];
            }else{
                NSString *unionid = [KUserdefaults objectForKey:Kunionid];
                NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
                NSString *filePath = [path stringByAppendingPathComponent:unionid];
                AddressModel *addressModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
                if (addressModel != nil) {
                    _addressModel = addressModel;
                }
                [self.sureOrderTableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        NSString *unionid = [KUserdefaults objectForKey:Kunionid];
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *filePath = [path stringByAppendingPathComponent:unionid];
        AddressModel *addressModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (addressModel != nil) {
            _addressModel = addressModel;
        }
        [self.sureOrderTableView reloadData];
    }];
}

@end

