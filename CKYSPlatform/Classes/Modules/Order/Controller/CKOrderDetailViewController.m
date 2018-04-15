//
//  CKOrderDetailViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/6.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKOrderDetailViewController.h"
#import "DetailLogisticsViewController.h"
#import "CKOrderDetailModel.h"
#import "CKOrderDetailCell.h"
#import "ChatMessageViewController.h"

static NSString *checkOrderDetailCell = @"OrderDetailAddressTableViewCell";

@interface CKOrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource, CKOriginalOrderInfoCellDelegate, CKChangeOrderInfoCellDelegate>

@property (nonatomic, strong) UITableView *checkOrderTableView;
@property (nonatomic, strong) NSMutableArray *tableDataArr;
@property (nonatomic, strong) Ordersheet *detailModel;
@property (nonatomic, strong) CKOrderDetailModel *orderDetailModel;
@property (nonatomic, strong) UIButton *originalOrderBtn;

@end

@implementation CKOrderDetailViewController

-(NSMutableArray *)tableDataArr {
    if (_tableDataArr == nil) {
        _tableDataArr = [NSMutableArray array];
    }
    return _tableDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    
    [self initComponents];
    //请求订单详情数据
    [self requestOrderDetailData];
    
    [CKCNotificationCenter addObserver:self selector:@selector(hiddenChangeAddressBtn) name:@"HideUpdateAddressFuncNoti" object:nil];

}

- (void)createCheckBtn {
    self.originalOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.originalOrderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    if (IPHONE_X) {
        self.originalOrderBtn.frame = CGRectMake(SCREEN_WIDTH - 90, self.view.frame.size.height *0.5 - 110, 90, 30);
    }else if (iphone6Plus){
        self.originalOrderBtn.frame = CGRectMake(SCREEN_WIDTH - 90, self.view.frame.size.height *0.5 - 75, 90, 30);
    }else if (iphone6){
        self.originalOrderBtn.frame = CGRectMake(SCREEN_WIDTH - 90, self.view.frame.size.height *0.5 - 63, 90, 29);
    }else{
        self.originalOrderBtn.frame = CGRectMake(SCREEN_WIDTH - 90, self.view.frame.size.height *0.5 - 32, 90, 25);
        self.originalOrderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    
    [self.originalOrderBtn setTitle:@"查看原订单" forState:UIControlStateNormal];
    [self.originalOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.originalOrderBtn addTarget:self action:@selector(checkOriginalOrder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.originalOrderBtn];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.originalOrderBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.originalOrderBtn.bounds;
    maskLayer.path = path.CGPath;
    self.originalOrderBtn.layer.mask = maskLayer;
    self.originalOrderBtn.layer.backgroundColor = [UIColor colorWithRed:226/255.0 green:35/255.0 blue:26/255.0 alpha:0.8].CGColor;
}

#pragma mark - 查看原订单
- (void)checkOriginalOrder:(UIButton*)sender {
    if ([sender.titleLabel.text isEqualToString:@"查看原订单"]) {
        [sender setTitle:@"关闭原订单" forState:UIControlStateNormal];
        
//        NSMutableArray *tempArray = [NSMutableArray array];
//        CKOldDetailModel *oldDetailM = [[CKOldDetailModel alloc] init];
//        oldDetailM.orderno = @"dd12345678";
//        oldDetailM.ordermoney = @"¥92256.99";
//        [tempArray addObject:oldDetailM];
//
//        CKOldDetailModel *oldDetailM1 = [[CKOldDetailModel alloc] init];
//        oldDetailM1.orderno = @"ff12345678";
//        oldDetailM1.ordermoney = @"¥85556.99";
//        [tempArray addObject:oldDetailM1];
//
//        CKOldDetailModel *oldDetailM2 = [[CKOldDetailModel alloc] init];
//        oldDetailM2.orderno = @"ee12345678";
//        oldDetailM2.ordermoney = @"¥67756.99";
//        [tempArray addObject:oldDetailM2];
        

        for (NSInteger i = 0; i < self.orderDetailModel.olddetailArry.count; i++) {
            CellModel *originalM = [self createCellModel:[CKOriginalOrderInfoCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.orderDetailModel.olddetailArry,@"data", [NSString stringWithFormat:@"%ld", i], @"tag", nil] height:50];
            originalM.delegate = self;
            
            SectionModel *section31 = [self createSectionModel:@[originalM] headerHeight:0.0001 footerHeight:0.0001];
            [self.tableDataArr insertObject:section31 atIndex:self.tableDataArr.count - 1];
        }
        
        for (NSInteger i = 0; i < self.orderDetailModel.newdetailArry.count; i++) {
            CellModel *originalM = [self createCellModel:[CKChangeOrderInfoCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.orderDetailModel.newdetailArry, @"data", [NSString stringWithFormat:@"%ld", i], @"tag", nil] height:50];
            originalM.delegate = self;
            
            CGFloat headerHeight = i==0 ? 10:0.0001;
            
            SectionModel *section31 = [self createSectionModel:@[originalM] headerHeight:headerHeight footerHeight:0.0001];
            [self.tableDataArr insertObject:section31 atIndex:self.tableDataArr.count - 1];
        }
    }else{
        [sender setTitle:@"查看原订单" forState:UIControlStateNormal];
        
        //删除原订单cell
        NSMutableArray *tempArray = [self.tableDataArr copy];
        for (SectionModel *sModel in tempArray) {
            for (CellModel *item in sModel.cells) {
                if ([item.className isEqualToString:NSStringFromClass([CKOriginalOrderInfoCell class])] || [item.className isEqualToString:NSStringFromClass([CKOriginalOrderGoodsCell class])] || [item.className isEqualToString:NSStringFromClass([CKChangeOrderInfoCell class])] || [item.className isEqualToString:NSStringFromClass([CKChangOrderGoodsCell class])]) {
                    [self.tableDataArr removeObject:sModel];
                }
            }
        }
    }
    [self.checkOrderTableView reloadData];
}

#pragma mark - CKOriginalOrderInfoCellDelegate
- (void)showOriginalOrderDetail:(CKOriginalOrderInfoCell *)originalOrderInfoCell index:(NSInteger)index {
    
    NSLog(@"展开%ld--- %@", index, originalOrderInfoCell);
    
    NSMutableArray *tempArray = [NSMutableArray array];
    CKOldDetailModel *oldDetailM = [[CKOldDetailModel alloc] init];
    oldDetailM = self.orderDetailModel.olddetailArry[index];
    
    for (NSInteger i = 0; i < oldDetailM.goodsArray.count; i++) {
        CellModel *originalM = [self createCellModel:[CKOriginalOrderGoodsCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:oldDetailM.goodsArray[i],@"data", nil] height:40];
        originalM.delegate = self;
        [tempArray addObject:originalM];
    }
    
    //获取要添加的index
    NSMutableArray *indexArr = [NSMutableArray array];
    for (NSInteger i = 0; i<self.tableDataArr.count; i++) {
        SectionModel *sModel = self.tableDataArr[i];
        for (CellModel *item in sModel.cells) {
            if ([item.className isEqualToString:NSStringFromClass([CKOriginalOrderInfoCell class])]) {
                [indexArr addObject:[NSString stringWithFormat:@"%ld", i]];
            }
        }
    }

    NSInteger insertIndex = [[indexArr objectAtIndex:index] integerValue] + 1;
    
    SectionModel *section31 = [self createSectionModel:tempArray headerHeight:0.0001 footerHeight:0.0001];
    [self.tableDataArr insertObject:section31 atIndex:insertIndex];
    [self.checkOrderTableView reloadData];
}

- (void)closeOriginalOrderDetail:(CKOriginalOrderInfoCell *)originalOrderInfoCell index:(NSInteger)index {
    NSLog(@"收缩%ld--- %@", index, originalOrderInfoCell);
    
    //删除原订单cell
    CKOldDetailModel *oldDetailM = self.orderDetailModel.olddetailArry[index];
    NSMutableArray *tempArray = [self.tableDataArr copy];
    for (SectionModel *sModel in tempArray) {
        for (CellModel *item in sModel.cells) {
            if ([item.className isEqualToString:NSStringFromClass([CKOriginalOrderGoodsCell class])]) {
                NSDictionary *dict = item.userInfo;
                CKGoodsDetailModel *goodsM = dict[@"data"];
                if ([oldDetailM.goodsArray containsObject:goodsM]) {
                    [self.tableDataArr removeObject:sModel];
                }
            }
        }
    }
    
    [self.checkOrderTableView reloadData];
}


#pragma mark - CKChangeOrderInfoCellDelegate
- (void)showChangeOrderDetail:(CKChangeOrderInfoCell *)changeOrderInfoCell index:(NSInteger)index {
    NSLog(@"展开%ld--- %@", index, changeOrderInfoCell);
    
    CKChangeDetailModel *changeModel = [[CKChangeDetailModel alloc] init];
    changeModel = self.orderDetailModel.newdetailArry[index];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger i = 0; i < changeModel.goodsArray.count; i++) {
        CellModel *originalM = [self createCellModel:[CKChangOrderGoodsCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:changeModel.goodsArray[i],@"data", nil] height:40];
        originalM.delegate = self;
        [tempArray addObject:originalM];
    }
    
    //获取要添加的index
    NSMutableArray *indexArr = [NSMutableArray array];
    for (NSInteger i = 0; i<self.tableDataArr.count; i++) {
        SectionModel *sModel = self.tableDataArr[i];
        for (CellModel *item in sModel.cells) {
            if ([item.className isEqualToString:NSStringFromClass([CKChangeOrderInfoCell class])]) {
                [indexArr addObject:[NSString stringWithFormat:@"%ld", i]];
            }
        }
    }
    
    NSInteger insertIndex = [[indexArr objectAtIndex:index] integerValue] + 1;
    
    SectionModel *section31 = [self createSectionModel:tempArray headerHeight:0.0001 footerHeight:0.0001];
    [self.tableDataArr insertObject:section31 atIndex:insertIndex];
    [self.checkOrderTableView reloadData];
}

- (void)closeChangeOrderDetail:(CKChangeOrderInfoCell *)changeOrderInfoCell index:(NSInteger)index {
    NSLog(@"收缩%ld--- %@", index, changeOrderInfoCell);
    
    //删除原订单cell
    CKChangeDetailModel *changeModel = self.orderDetailModel.newdetailArry[index];
    NSMutableArray *tempArray = [self.tableDataArr copy];
    for (SectionModel *sModel in tempArray) {
        for (CellModel *item in sModel.cells) {
            if ([item.className isEqualToString:NSStringFromClass([CKChangOrderGoodsCell class])]) {
                NSDictionary *dict = item.userInfo;
                CKGoodsDetailModel *goodsM = dict[@"data"];
                if ([changeModel.goodsArray containsObject:goodsM]) {
                    [self.tableDataArr removeObject:sModel];
                }
            }
        }
    }
    
    [self.checkOrderTableView reloadData];
}

#pragma mark - 请求订单详情数据
- (void)requestOrderDetailData {
    
    [self.tableDataArr removeAllObjects];
    NSString *ckidString = KCKidstring;
    if (IsNilOrNull(ckidString)) {
        ckidString = @"";
    }
    
    NSString *oidString = [NSString stringWithFormat:@"%@",self.orderModel.oid];
    if (IsNilOrNull(oidString)){
        oidString = @"";
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSString *orderDetailUrl = @"";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *homeLoginStatus = [KUserdefaults objectForKey:KHomeLoginStatus];
    if(!IsNilOrNull(homeLoginStatus)){
        orderDetailUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getOrderDetail_Url];
        [params setObject:ckidString forKey:@"ckid"];
        [params setObject:oidString forKey:@"oid"];
        [params setObject:uuid forKey:@"deviceid"];
    }else{
        [params setObject:oidString forKey:@"oid"];
        orderDetailUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Regist/getOrderInfo"];
    }
    
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:orderDetailUrl params:params success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        _orderDetailModel = [[CKOrderDetailModel alloc] init];
        [_orderDetailModel setValuesForKeysWithDictionary:dict];
        _orderDetailModel.olddetailArry = [NSMutableArray array];
        _orderDetailModel.newdetailArry = [NSMutableArray array];
        for (NSDictionary *oldDict in dict[@"olddetail"]) {
            CKOldDetailModel *oldDetailM = [[CKOldDetailModel alloc] init];
            [oldDetailM setValuesForKeysWithDictionary:oldDict];
            oldDetailM.goodsArray = [NSMutableArray array];
            for (NSDictionary *goodsDict in oldDict[@"goodsdetail"]) {
                CKGoodsDetailModel *goodsM = [[CKGoodsDetailModel alloc] init];
                [goodsM setValuesForKeysWithDictionary:goodsDict];
                [oldDetailM.goodsArray addObject:goodsM];
            }
            [_orderDetailModel.olddetailArry addObject:oldDetailM];
        }
        
        for (NSDictionary *newDict in dict[@"newdetail"]) {
            CKChangeDetailModel *newDetailM = [[CKChangeDetailModel alloc] init];
            [newDetailM setValuesForKeysWithDictionary:newDict];
            newDetailM.goodsArray = [NSMutableArray array];
            for (NSDictionary *goodsDict in newDict[@"goodsdetail"]) {
                CKGoodsDetailModel *goodsM = [[CKGoodsDetailModel alloc] init];
                [goodsM setValuesForKeysWithDictionary:goodsDict];
                [newDetailM.goodsArray addObject:goodsM];
            }
            [_orderDetailModel.newdetailArry addObject:newDetailM];
        }
        
        //创建查看原订单按钮
        NSArray *olddetail = [dict objectForKey:@"olddetail"];
        if ([olddetail count] > 0) {
            [self createCheckBtn];
        }
        
        
        [self bindData:dict];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)bindData:(NSDictionary *)dict {
    
    CellModel *logisticsModel = [self createCellModel:[CKLogisticsCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", nil] height:106];
    SectionModel *section0 = [self createSectionModel:@[logisticsModel] headerHeight:0.0001 footerHeight:0.0001];
    [self.tableDataArr addObject:section0];
    
    if ([_typeString isEqualToString:@"WXUSER"]) {
        CellModel *buyerModel = [self createCellModel:[CKOrderNameCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", nil] height:30*SCREEN_WIDTH/375.0f];
        SectionModel *section1 = [self createSectionModel:@[buyerModel] headerHeight:0.0001 footerHeight:0.0001];
        [self.tableDataArr addObject:section1];
    }
    
    CellModel *getterModel = [self createCellModel:[CKOrderGetterCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict, @"data", _typeString, @"orderType", self.orderModel.favormoney, @"favormoney", nil] height:30*SCREEN_WIDTH/375.0f];
    SectionModel *section11 = [self createSectionModel:@[getterModel] headerHeight:0.0001 footerHeight:0.0001];
    [self.tableDataArr addObject:section11];
    
    CellModel *addressModel = [self createCellModel:[CKOrderAddressCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", @"default", @"type", nil] height:44*SCREEN_WIDTH/375.0f];
    SectionModel *section12 = [self createSectionModel:@[addressModel] headerHeight:0.0001 footerHeight:0.0001];
    [self.tableDataArr addObject:section12];
    
    if ([_typeString isEqualToString:@"CK"]) {
        
        NSString *isNeedRealName = @"noneed";
        //先判断有没有海外商品
        for (Ordersheet *orderSheetM in self.dataArray) {
            if ([orderSheetM.isoversea isEqualToString:@"1"]) {
                isNeedRealName = @"need";
                break;
            }
            isNeedRealName = @"noneed";
        }
        
        //测试代码
//        isNeedRealName = @"need";
        
        NSString *orderID = [NSString stringWithFormat:@"%@", self.orderModel.oid];
        NSString *orderNo = [NSString stringWithFormat:@"%@", self.orderModel.no];
        
        if ([self.orderstatusString isEqualToString:@"1"]) {
            CellModel *changeAddressModel = [self createCellModel:[CKOrderChangeAddressCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", orderID, @"oid", self.orderstatusString, @"orderStatus", orderNo, @"orderNo", isNeedRealName, @"isNeedRealName", nil] height:40];
            SectionModel *section13 = [self createSectionModel:@[changeAddressModel] headerHeight:0.0001 footerHeight:0.0001];
            [self.tableDataArr addObject:section13];
        }
        
        NSInteger limitTime = [[dict objectForKey:@"limittime"] integerValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
        
        NSString *paytime = [dict objectForKey:@"paytime"];
        NSString *ordertime = [dict objectForKey:@"ordertime"];
        
        NSDate *payDate;
        if (!IsNilOrNull(paytime)) {
            payDate = [dateFormatter dateFromString:paytime];
        }else{
            payDate = [dateFormatter dateFromString:ordertime];
        }
        NSTimeInterval pay = [payDate timeIntervalSince1970];
        
        NSString *systime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"systime"]];
        
        NSTimeInterval value = [systime longLongValue] - pay;
        
        CGFloat second = [[NSString stringWithFormat:@"%.2f",value] floatValue];//秒
        NSLog(@"间隔------%f秒",second);
        
        
        if ([self.orderstatusString isEqualToString:@"2"] && second < (limitTime*60) && limitTime > 0) {
            CellModel *changeAddressModel = [self createCellModel:[CKOrderChangeAddressCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", orderID, @"oid", self.orderstatusString, @"orderStatus", orderNo, @"orderNo", isNeedRealName, @"isNeedRealName", nil] height:40];
            SectionModel *section13 = [self createSectionModel:@[changeAddressModel] headerHeight:0.0001 footerHeight:0.0001];
            [self.tableDataArr addObject:section13];
        }
    }
    
    
    CellModel *bottomModel = [self createCellModel:[CKOrderSpaImageCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", nil] height:3];
    SectionModel *section14 = [self createSectionModel:@[bottomModel] headerHeight:0.0001 footerHeight:10];
    [self.tableDataArr addObject:section14];
    
    for (Ordersheet *orderSheetM in self.dataArray) {
        
        CellModel *goodsModel = [self createCellModel:[CKGoodDetailCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:orderSheetM,@"data", self.orderModel,@"orderModel", nil] height:130];
        SectionModel *section2 = [self createSectionModel:@[goodsModel] headerHeight:0.0001 footerHeight:0.0001];
        [self.tableDataArr addObject:section2];
    }
    
    NSString *orderNo = [NSString stringWithFormat:@"%@", self.orderModel.no];
    if (IsNilOrNull(orderNo)) {
        orderNo = @"";
    }
    
    CellModel *payInfoModel = [self createCellModel:[CKOrderPaymentCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", orderNo, @"orderNo", _typeString, @"orderType", self.orderModel.favormoney, @"favormoney", self.orderstatusString, @"orderStatus", self.orderModel.money, @"money", self.orderModel.ordermoney, @"orderMoney", nil] height:[CKOrderPaymentCell computeHeight:[NSDictionary dictionaryWithObjectsAndKeys:_typeString, @"orderType", self.orderModel.favormoney, @"favormoney", nil]]];
    SectionModel *section31 = [self createSectionModel:@[payInfoModel] headerHeight:0.0001 footerHeight:0.0001];
    [self.tableDataArr addObject:section31];
    
    
    CellModel *infoModel = [self createCellModel:[CKOrderInfoCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dict,@"data", orderNo, @"orderNo", _typeString, @"orderType", self.orderModel.favormoney, @"favormoney", self.orderstatusString, @"orderStatus", self.orderModel.money, @"money", self.orderModel.ordermoney, @"orderMoney", nil] height:200];
    SectionModel *section3 = [self createSectionModel:@[infoModel] headerHeight:10 footerHeight:0.0001];
    [self.tableDataArr addObject:section3];
    
    [self.checkOrderTableView reloadData];
    
}

-(void)reloadOrderWithNewAdress:(AddressModel*)addressModel {
    
    NSInteger index = 0;
    NSInteger getterIndex = 0;
    
    for (NSInteger i = 0; i < self.tableDataArr.count; i++) {
        SectionModel *section = self.tableDataArr[i];
        for (NSInteger j = 0; j < section.cells.count; j++) {
            CellModel *cell = section.cells[j];
            if ([cell.className isEqualToString:@"CKOrderGetterCell"]) {
                getterIndex = i;
            }
            if ([cell.className isEqualToString:@"CKOrderAddressCell"]) {
                index = i;
            }
        }
    }
    
    NSDictionary *getterDic = @{@"gettername": addressModel.gettername, @"gettermobile": addressModel.gettermobile};
    
    CellModel *getterModel = [self createCellModel:[CKOrderGetterCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:getterDic,@"data", nil] height:30*SCREEN_WIDTH/375.0f];
    SectionModel *section11 = [self createSectionModel:@[getterModel] headerHeight:0.0001 footerHeight:0.0001];
    
    
    NSString *address = [NSString stringWithFormat:@"%@%@", addressModel.address, addressModel.homeaddress];
    
    CellModel *addressM = [self createCellModel:[CKOrderAddressCell class] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:address,@"data", @"changed", @"type", nil] height:44*SCREEN_WIDTH/375.0f];
    SectionModel *section12 = [self createSectionModel:@[addressM] headerHeight:0.0001 footerHeight:0.0001];
    
    if (getterIndex != 0) {
        [self.tableDataArr replaceObjectAtIndex:getterIndex withObject:section11];
    }
    
    if (index != 0) {
        [self.tableDataArr replaceObjectAtIndex:index withObject:section12];
    }
    [self.checkOrderTableView reloadData];
}

-(void)hiddenChangeAddressBtn {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.tableDataArr.count; i++) {
        SectionModel *section = self.tableDataArr[i];
        for (NSInteger j = 0; j < section.cells.count; j++) {
            CellModel *cell = section.cells[j];
            if ([cell.className isEqualToString:@"CKOrderChangeAddressCell"]) {
                index = i;
            }
        }
    }
    
    if (index != 0) {
        [self.tableDataArr removeObjectAtIndex:index];
        [self.checkOrderTableView reloadData];
    }
}

#pragma mark - 联系用户
- (void)contactUser {
    
    ChatMessageViewController *chatMessage = [[ChatMessageViewController alloc] init];
    chatMessage.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatMessage.targetId = self.orderModel.meid;
//    chatMessage.headUrl = _messageModel.headurl;
    //设置聊天会话界面要显示的标题
    chatMessage.titleString = self.orderModel.buyername;
    [self.navigationController pushViewController:chatMessage animated:NO];
    
}

- (void)initComponents {
    
    if ([self.typeString isEqualToString:@"WXUSER"]) {
        UIButton *contactUser = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.view addSubview:contactUser];
        contactUser.backgroundColor = [UIColor tt_bigRedBgColor];
        [contactUser setTitle:@"联系用户" forState:UIControlStateNormal];
        [contactUser setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contactUser addTarget:self action:@selector(contactUser) forControlEvents:UIControlEventTouchUpInside];
        [contactUser mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.mas_offset(-BOTTOM_BAR_HEIGHT);
            make.height.mas_equalTo(44);
        }];
        
        if (IsNilOrNull(self.orderModel.meid)) {
            contactUser.hidden = YES;
        }else{
            contactUser.hidden = NO;
        }
    }
    
    
    
    if (@available(iOS 11.0, *)){
        if ([self.typeString isEqualToString:@"WXUSER"]) {
            _checkOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-BOTTOM_BAR_HEIGHT - 44) style:UITableViewStyleGrouped];
        }else{
            _checkOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-BOTTOM_BAR_HEIGHT) style:UITableViewStyleGrouped];
        }
        
        if(IsNilOrNull(self.orderModel.meid) && [self.typeString isEqualToString:@"WXUSER"]){
            _checkOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-BOTTOM_BAR_HEIGHT ) style:UITableViewStyleGrouped];
        }
    }else{
        if ([self.typeString isEqualToString:@"WXUSER"]) {
            _checkOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 + 64, SCREEN_WIDTH, SCREEN_HEIGHT-44 - 64) style:UITableViewStyleGrouped];
        }else{
            _checkOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        }
    }
    
    [self.view addSubview:_checkOrderTableView];
    _checkOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _checkOrderTableView.backgroundColor = [UIColor tt_grayBgColor];
    self.checkOrderTableView.rowHeight = UITableViewAutomaticDimension;
    self.checkOrderTableView.estimatedRowHeight = 60;
    if (@available(iOS 11.0, *)) {
        self.checkOrderTableView.estimatedSectionHeaderHeight = 0.1;
        self.checkOrderTableView.estimatedSectionFooterHeight = 0.1;
    }
    _checkOrderTableView.dataSource = self;
    _checkOrderTableView.delegate = self;
    
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
    if(_tableDataArr){
        return _tableDataArr.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SectionModel *s = _tableDataArr[section];
    if(s.cells) {
        return s.cells.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModel *s = _tableDataArr[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    
    CKOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:item.reuseIdentifier];
    if(!cell) {
        cell = [[NSClassFromString(item.className) alloc] initWithStyle:item.style reuseIdentifier:item.reuseIdentifier];
    }
    cell.selectionStyle = item.selectionStyle;
    cell.accessoryType = item.accessoryType;
    cell.delegate = item.delegate;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModel *s = _tableDataArr[indexPath.section];
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
    SectionModel *s = _tableDataArr[indexPath.section];
    CellModel *item = s.cells[indexPath.row];
    return item.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SectionModel *s = _tableDataArr[section];
    return s.headerhHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SectionModel *s = _tableDataArr[section];
    return s.footerHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        NSString *lastlogisticsmsg = [NSString stringWithFormat:@"%@", _orderDetailModel.lastlogisticsmsg];
        if (!IsNilOrNull(lastlogisticsmsg)){
            NSString *oidString = [NSString stringWithFormat:@"%@", self.orderModel.oid];
            //点击进入物流详情
            DetailLogisticsViewController *detailLogist = [[DetailLogisticsViewController alloc] init];
            detailLogist.oidString = oidString;
            [self.navigationController pushViewController:detailLogist animated:YES];
        }
    }
}

-(void)dealloc {
    [CKCNotificationCenter removeObserver:self name:@"HideUpdateAddressFuncNoti" object:nil];
}

@end
