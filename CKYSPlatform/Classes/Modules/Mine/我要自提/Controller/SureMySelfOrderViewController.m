//
//  SureMySelfOrderViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/16.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "SureMySelfOrderViewController.h"
#import "WriteOrderTableViewCell.h"
#import "AddressModel.h"
#import "MoneyCountView.h"
#import "AddAddressViewController.h"
#import "ChangeMyAddressViewController.h"
#import "AddAddressTableViewCell.h"
#import "TopTipView.h"
#import "CKConfirmOrderCell.h"
#import "PayMoneyViewController.h"
#import "CKRealnameIdentifyView.h"

@interface SureMySelfOrderViewController ()<UITableViewDelegate, UITableViewDataSource, MoneyCountViewDelegate, AddAddressTableViewCellDelegate, TopTipViewDelegate>
{
    MoneyCountView *_moneyCountView;
    NSString *_ckidString;
    NSString *_transAddressIdString;
    MessageAlert *_successAlertView;
    NSString *startTime;
    NSString *endTime;
}

@property (nonatomic, strong) UITableView *sureOrderTableView;
@property (nonatomic, strong) AddressModel *addressModel;
@property (nonatomic, strong) UIButton *selectedAddressButton;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) TopTipView *tipView;
@property (nonatomic, copy)   NSString *buyCount;

@end

@implementation SureMySelfOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"确认订单";
    
    self.buyCount = @"1";
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    
    self.addressModel = [[AddressModel alloc] init];

    
    [self createTableView];
    
    [self requestDefaultAddress];
    
    [self refreshAllPayMoney];
    
    NSLog(@"开始%@  结束%@",startTime,endTime);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTotalMoney:) name:@"GDConfrimOrderChangeBuyCount" object:nil];
    
}

#pragma mark - 点击加减号
-(void)changeTotalMoney:(NSNotification*)userInfo {
    NSDictionary *buyCountDic = userInfo.userInfo;
    NSString *count = [NSString stringWithFormat:@"%@", buyCountDic[@"BuyCount"]];
    self.buyCount = count;
    CKPickupGoodsModel *goodsM = self.dataArray.firstObject;
    NSString *money = [NSString stringWithFormat:@"%@", goodsM.price];
    if (IsNilOrNull(money)) {
        money = @"0";
    }
    
    double totalMoney = [money doubleValue] * [count integerValue];
    _moneyCountView.allMoneyLable.text = [NSString stringWithFormat:@"合计：¥%.2f", totalMoney];
}

-(void)refreshAllPayMoney{
     _moneyCountView.allMoneyLable.text = [NSString stringWithFormat:@"%@", self.allMoneyString];
}

- (void)createTableView {
    _moneyCountView = [[MoneyCountView alloc] initWithFrame:CGRectZero];
    _moneyCountView.delegate = self;
    _moneyCountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_moneyCountView];
    [_moneyCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10-BOTTOM_BAR_HEIGHT);
        make.height.mas_equalTo(50);
    }];
    
    NSString *payalertmsg = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"payalertmsg"]];
    CGSize s = [payalertmsg boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 87, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    _tipView = [[TopTipView alloc] initWithFrame:CGRectMake(0, 5+64+NaviAddHeight, SCREEN_WIDTH, s.height>=30 ? 14+s.height : 44)];
    _tipView.delegate = self;
    [self.view addSubview:_tipView];
    
    _sureOrderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_sureOrderTableView];
    [_sureOrderTableView setBackgroundColor:[UIColor tt_grayBgColor]];
    
    self.sureOrderTableView.rowHeight = UITableViewAutomaticDimension;
    self.sureOrderTableView.estimatedRowHeight = 44;
    _sureOrderTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _sureOrderTableView.delegate  = self;
    _sureOrderTableView.dataSource = self;
    [self.sureOrderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(CGRectGetMaxY(_tipView.frame));
        make.left.right.mas_offset(0);
        make.bottom.equalTo(_moneyCountView.mas_top);
    }];
    
    
    if (IsNilOrNull(payalertmsg)) {
        [self.tipView removeFromSuperview];
        [self.sureOrderTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(5+64+NaviAddHeight);
        }];
    }else{
        self.tipView.tipLabel.text = payalertmsg;
        [self.sureOrderTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(CGRectGetMaxY(_tipView.frame));
        }];
    }
}

#pragma mark - TopTipViewDelegate
- (void)topTipView:(TopTipView *)topView closeTip:(UIButton *)btn {
    [self.tipView removeFromSuperview];
    [self.sureOrderTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(5+64+NaviAddHeight);
    }];
}

#pragma mark - 请求默认地址数据
- (void)requestDefaultAddress {

    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"ckid":_ckidString, DeviceId:uuid};
    NSString *getDefaultAddressUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getDefaultAddress_Url];
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:getDefaultAddressUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
//            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        NSString *addressID = [NSString stringWithFormat:@"%@", dict[@"id"]];
        if (!IsNilOrNull(addressID) && ![addressID isEqualToString:@"0"]) {
            [self.addressModel setValuesForKeysWithDictionary:dict];
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            NSString *key = [NSString stringWithFormat:@"%@_%@", _ckidString, @"DefaultAddress"];
            NSString *filePath = [path stringByAppendingPathComponent:key];
            [NSKeyedArchiver archiveRootObject:self.addressModel toFile:filePath];
        }
        
        [self.sureOrderTableView reloadData];
    } failure:^(NSError *error) {
        self.addressModel = nil;
        [self.sureOrderTableView reloadData];
        [self.viewDataLoading stopAnimation];
    }];
    
}
#pragma mark-tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){//地址选择
        if (!IsNilOrNull(self.addressModel.ID)) {
            WriteOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WriteOrderTableViewCell"];
            if (cell  == nil) {
                cell = [[WriteOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WriteOrderTableViewCell"];
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
        CKConfirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKConfirmOrderCell"];
        if (cell == nil) {
            cell = [[CKConfirmOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKConfirmOrderCell"];
        }

        if ([self.dataArray count]) {
            self.goodOrderModel = [self.dataArray objectAtIndex:indexPath.row];
            [cell updateCellData:self.goodOrderModel showCount:self.showCount];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    if (section == 0){
        footerView.backgroundColor = [UIColor tt_grayBgColor];
        return footerView;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0){
       return AdaptedWidth(10);
    }else{
        return 0;
    }
}
/**没有默认地址时点击跳转*/
-(void)clickToAddressVC{
    ChangeMyAddressViewController *addressVC = [[ChangeMyAddressViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    [addressVC setAddressBlock:^(AddressModel *addressModel) {
        weakSelf.addressModel = addressModel;
        [weakSelf.sureOrderTableView reloadData];
    }];
    addressVC.pushString = @"1";  //从确认订单跳过去
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        ChangeMyAddressViewController *address = [[ChangeMyAddressViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        [address setAddressBlock:^(AddressModel *addressModel) {
            weakSelf.addressModel = addressModel;
            [weakSelf.sureOrderTableView reloadData];
        }];
        address.pushString = @"1";  //从确认订单跳过去
        
        [address setDeleteAddressIdWithBlock:^(NSString *deleteDefaultAddressId) {
            _transAddressIdString = [NSString stringWithFormat:@"%@", weakSelf.addressModel.ID];
            if ([_transAddressIdString isEqualToString:deleteDefaultAddressId]){
                [weakSelf requestDefaultAddress];
            }
        }];
        [self.navigationController pushViewController:address animated:YES];
    }
}

#pragma mark - 检测当前收货人是否实名认证（海外购的需要）
- (void)realNameIdentify {
    
    NSString *gettername = [NSString stringWithFormat:@"%@", self.addressModel.gettername];
    NSString *addressID = [NSString stringWithFormat:@"%@",self.addressModel.ID];
    NSDictionary *params = @{@"ckid":_ckidString, @"realname":gettername,@"addressid":addressID};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/OrderRealname/getRealname"];
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool getWithUrl:requestUrl params:params success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.viewDataLoading stopAnimation];
            return ;
        }
        
        CKRealnameIdentifyView *real = [[CKRealnameIdentifyView alloc] init];
        //如已实名认证，则返回idcardno，未实名认证返回空
        NSString *idcardno = [NSString stringWithFormat:@"%@", dict[@"idcardno"]];
        if (IsNilOrNull(idcardno)) {
            idcardno = @"";
            real.operationName = @"提交";
        }else{
            if (idcardno.length > 4) {
                if (![idcardno containsString:@"******"]) {
                    [KUserdefaults setObject:idcardno forKey:@"idcardno"];
                    [KUserdefaults synchronize];
                }
                NSString *prefixStr = [idcardno substringToIndex:3];
                NSString *subStr = [idcardno substringFromIndex:idcardno.length - 4];
                NSString *finalStr = [NSString stringWithFormat:@"%@***********%@", prefixStr, subStr];
                idcardno = finalStr;
                
            }
            real.operationName = @"确认";
        }
        
        __weak typeof(self) weakSelf = self;
        [real showAlert:gettername idNo:idcardno textFieldText:^(NSString *name, NSString *idNo) {
            NSLog(@"%@---%@", name, idNo);
            
            if (![idNo containsString:@"******"]) {
                [KUserdefaults setObject:idNo forKey:@"idcardno"];
                [KUserdefaults synchronize];
            }
            if (IsNilOrNull(name)) {
                [weakSelf showNoticeView:@"请输入收件人姓名"];
                return;
            }
            
            if (IsNilOrNull(idNo)) {
                [weakSelf showNoticeView:@"请输入收件人身份证号码"];
                return;
            }
            if ([idNo containsString:@"******"]) {
             idNo  =  [KUserdefaults objectForKey:@"idcardno"];
            }
            
            [weakSelf submitRealnameIdentify:name idcardNO:idNo addressID:addressID];
        }];
        
        
        [self.viewDataLoading stopAnimation];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [self.viewDataLoading stopAnimation];
    }];
}

#pragma mark - 提交实名认证
- (void)submitRealnameIdentify:(NSString*)realName idcardNO:(NSString*)idcardno addressID:(NSString *)addressid{
    NSDictionary *params = @{@"ckid":_ckidString, @"realname":realName, @"idcardno":idcardno,@"addressid":addressid};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/OrderRealname/addRealname"];
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:params success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            [self.viewDataLoading stopAnimation];
            return ;
        }
        
        self.addressModel.gettername = realName;
        [self.sureOrderTableView reloadData];
        //认证成功后再提交订单
        [self prepareSubmitOrder];
        
        [self.viewDataLoading stopAnimation];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [self.viewDataLoading stopAnimation];
    }];
}

#pragma mark - 立即购买
- (void)moneyCountViewButtonClicked {
    
    if(self.addressModel == nil){
        [self showNoticeView:@"请选择收货地址"];
        return;
    }
    
#warning testCode for oversean realname identify
    //测试实名认证
//    [self realNameIdentify];
//    return;
    
    BOOL isNeedRealName = NO;
    //先判断有没有海外商品
    for (CKPickupGoodsModel *goodsM in self.dataArray) {
        if ([goodsM.isoversea isEqualToString:@"1"]) {
            isNeedRealName = YES;
            break;
        }
    }
    
    if (isNeedRealName) {
        [self realNameIdentify];
    }else{
        [self prepareSubmitOrder];
    }
}

#pragma mark - 准备提交订单
- (void)prepareSubmitOrder {
    [MessageAlert shareInstance].isDealInBlock = YES;
    [[MessageAlert shareInstance] hiddenCancelBtn:NO];
    [[MessageAlert shareInstance] showCommonAlert:@"自提商品不退不换！\n您确认自提这些商品吗？" btnClick:^{
        NSString *addressId = nil;
        NSString *defaultAddressId = [NSString stringWithFormat:@"%@", self.addressModel.ID];
        if (IsNilOrNull(defaultAddressId)) {
            defaultAddressId = @"";
        }
        addressId = defaultAddressId;
        
        NSString *price = [NSString stringWithFormat:@"%@",self.goodOrderModel.price];
        if (IsNilOrNull(price)) {
            self.goodOrderModel.price = @"";
        }
        NSString *goodName = [NSString stringWithFormat:@"%@",self.goodOrderModel.name];
        if (IsNilOrNull(goodName)) {
            goodName = @"";
        }
        // 1.将数组转json字符串
        NSMutableArray *mutable_arr = [NSMutableArray array];
        if (self.showCount) {
            for (CKPickupGoodsModel *goodModel in self.dataArray) {
                // 从本地取出count值
                NSString *countStr = [NSString stringWithFormat:@"%@", goodModel.count];
                if (IsNilOrNull(countStr) || [countStr isEqualToString:@"0"]) {
                    countStr = @"1";
                }
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:goodModel.ID forKey:@"id"];
                [dict setValue:countStr forKey:@"count"];
                [mutable_arr addObject:dict];
            }
        }else{
            CKPickupGoodsModel *goodModel = self.dataArray.firstObject;
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:goodModel.ID forKey:@"id"];
            [dict setValue:self.buyCount forKey:@"count"];
            [mutable_arr addObject:dict];
        }
        
        NSString *jsonStr = [mutable_arr mj_JSONString];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:_ckidString forKey:@"ckid"];
        [parameters setObject:addressId forKey:@"addressid"];
        [parameters setObject:jsonStr forKey:@"goods"];
        
        NSString *uuid = DeviceId_UUID_Value;
        if (IsNilOrNull(uuid)){
            uuid = @"";
        }
        [parameters setObject:uuid forKey:DeviceId];
        
        NSString *itemCarOrderUrl = nil;
        //判断是可以支付还是只能自提的
        NSString *isPay = [NSString stringWithFormat:@"%@",self.goodOrderModel.ispay];
        if([isPay isEqualToString:@"1"]){ //可以支付的商品
            itemCarOrderUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ztzfOrder_UpGoods_Url];
            [self canPayGoodsRequestWithUrl:itemCarOrderUrl pramaDic:parameters];
        }else{  //只能自提的商品
            startTime = [NSDate dateNow];
            itemCarOrderUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, pickUpGoods_Url];
            [self getRequestWithUrl:itemCarOrderUrl pramaDic:parameters andName:goodName];
        }
    }];
}

#pragma mark - 准备提交订单
- (void)getRequestWithUrl:(NSString *)orderUrl pramaDic:(NSDictionary *)pramaDic andName:(NSString *)namestr{
    
    NSInteger time = ([startTime integerValue] - [endTime integerValue])/60;
    if ([endTime intValue] > 0) {
        if (time < 1){ //小于1分钟限制自提
            [self showNoticeView:@"您的操作太快,稍后再试"];
            return;
        }
    }
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:orderUrl params:pramaDic success:^(id json) {
        
        endTime = [NSDate dateNow];
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] intValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        _successAlertView = [MessageAlert shareInstance];
        _successAlertView.isDealInBlock = YES;
        [_successAlertView showAlert:@"您已自提成功，请注意查收！" btnClick:^{
            
        }];
        [_successAlertView hiddenCancelBtn:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}

#pragma mark-选择好可以支付的商品 先生成订单  再去支付
-(void)canPayGoodsRequestWithUrl:(NSString *)orderUrl pramaDic:(NSDictionary *)pramaDic{
    [HttpTool postWithUrl:orderUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] intValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        NSString *payfee = [NSString stringWithFormat:@"%@",dict[@"payfee"]];
        NSString *oid = [NSString stringWithFormat:@"%@",dict[@"oid"]];
        if (IsNilOrNull(payfee)) {
            payfee = @"";
        }
        if (IsNilOrNull(oid)) {
            oid = @"";
        }
        //成功之后  生成 总金额 和订单 去支付
        PayMoneyViewController *payMoney = [[PayMoneyViewController alloc] init];
        payMoney.payfeeStr = payfee;
        payMoney.oidStr = oid;
        payMoney.type = @"ziti";
        [self presentViewController:[[RootNavigationController alloc] initWithRootViewController:payMoney] animated:YES completion:^{
             [self.navigationController popViewControllerAnimated:YES];
        } ];
    } failure:^(NSError *error) {
        NSLog(@"自提支付报错%@",error.localizedDescription);
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}


@end
