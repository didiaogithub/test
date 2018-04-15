//
//  CKModifySharePersonViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/27.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKModifySharePersonViewController.h"
#import "LoginViewController.h"
#import "AddressModel.h"
#import "CKConfrimRegistMsgViewController.h"
#import "CKChooseJoinGoodsVC.h"
#import "CKConfirmRegisterOrderVC.h"
#import "CKOrderinfoModel.h"

@interface CKModifySharePersonViewController ()

@property (nonatomic, strong) UITextField *inviteCodeTextF;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation CKModifySharePersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"输入邀请码";
    [self initComponent];
}

#pragma mark - 输入邀请码UI
- (void)initComponent {
    
    self.inviteCodeTextF = [[UITextField alloc]initWithFrame:CGRectZero];
    self.inviteCodeTextF.placeholder = @"请输入邀请码";
    [self.view addSubview:self.inviteCodeTextF];
    if (self.inviteCodeTextF.text) {
        [KUserdefaults setObject:self.inviteCodeTextF.text forKey:@"invitecode"];
    }
    [KUserdefaults synchronize];
    [self.inviteCodeTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-20);
        make.left.mas_offset(20);
        make.height.mas_equalTo(44);
        make.top.mas_offset(30+64+NaviAddHeight);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#e4e4e4"];
    [self.view addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inviteCodeTextF.mas_bottom).offset(1);
        make.height.mas_equalTo(1);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
    }];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.confirmButton];
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.backgroundColor = [UIColor redColor];
    [self.confirmButton addTarget:self action:@selector(confrimInviteCode) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-20);
        make.left.mas_offset(20);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.inviteCodeTextF.mas_bottom).offset(20);
    }];
    
    UILabel *expLabel = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:13]];
    expLabel.text = @"邀请码详细规则";
    [self.view addSubview:expLabel];
    [expLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-20);
        make.left.mas_offset(20);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.confirmButton.mas_bottom).offset(50);
    }];
    
    UILabel *ruleLabel = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]];
    ruleLabel.numberOfLines = 0;
    ruleLabel.text = @"1.邀请码为专属码，请和您的分享人确认邀请码；\n2.分享人登录创客APP，在个人中心内查看邀请码。";
    [self.view addSubview:ruleLabel];
    [ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-20);
        make.left.mas_offset(20);
        make.height.mas_equalTo(70);
        make.top.equalTo(expLabel.mas_bottom).offset(2);
    }];
    
}

- (void)confrimInviteCode {
    if (!IsNilOrNull(self.inviteCodeTextF.text)) {
        //检查邀请码是否有效
        [self checkInvitecode];
        
    }else{
        [self.viewDataLoading showNoticeView:@"请输入邀请码"];
    }
}

#pragma mark - 检查邀请码是否可用
- (void)checkInvitecode {
    
    NSString *unionid = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:Kunionid]];
    if (IsNilOrNull(self.inviteCodeTextF.text)) {
        [self showNoticeView:@"请输入邀请码"];
        return;
    }

    NSDictionary *params = @{@"invitecode":self.inviteCodeTextF.text, @"unionid":unionid};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Join/checkInvitecode"];
    
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
        
        [KUserdefaults setObject:self.inviteCodeTextF.text forKey:@"invitecode"];
        [self checkRegistStatus];
        
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


#pragma mark - 检测注册状态
- (void)checkRegistStatus {
    /*
     invitecode 新增参数
     操作：用户点击购买礼包
     
     根据用户unoinid查询ck表和大礼包订单，
     返回
     a：有未支付订单，已确认信息（已注册）
     orderstatus     0
     dlbtype        B/D
     ckid          12345
     orderinfo[]   不为空
     b：无订单，已确认信息（已注册分销）
     orderstatus     0
     dlbtype        空
     ckid        12345（分销）
     orderinfo[]    空
     c：有未支付订单，未确认信息（未注册）
     orderstatus     0
     dlbtype        B/D
     ckid            空
     orderinfo[]   不为空
     d：无订单，未确认信息（未注册）
     orderstatus     0
     dlbtype         空
     ckid            空
     orderinfo[]     空
     e：已支付，未确认信息（未注册）
     orderstatus     1
     dlbtype        B/D
     ckid           空
     orderinfo[]    空
     
     f：有未支付订单（已注册分销）分销升级创客未支付
     orderstatus     0
     dlbtype        空
     ckid        12345（分销）
     orderinfo[]    不为空
     
     g：无订单，已确认信息
     orderstatus     0
     dlbtype        B/D
     ckid        12345
     orderinfo     空
     
     */
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetRegistStatus];
    NSString *unionid = [KUserdefaults objectForKey:Kunionid];
    if (IsNilOrNull(unionid)) {
        return;
    }
    NSDictionary *params = @{@"unionid": unionid};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:params success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            if ([dict[@"code"] integerValue] == 2002 || [dict[@"code"] integerValue] == 2005) {
                
                [KUserdefaults setObject:@"-1" forKey:Kckid];
                [KUserdefaults setObject:@"" forKey:KMineLoginStatus];
                [KUserdefaults setObject:@"" forKey:KHomeLoginStatus];
                
                LoginViewController *login = [[LoginViewController alloc] init];
                [self  presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
                }];
            }else{
                [self showNoticeView:[NSString stringWithFormat:@"%@", dict[@"codeinfo"]]];
                return;
            }
        }else{
            NSString *orderstatus = [NSString stringWithFormat:@"%@", dict[@"orderstatus"]];
            NSString *ckid = [NSString stringWithFormat:@"%@", dict[@"ckid"]];
            NSString *dlbtype = [NSString stringWithFormat:@"%@", dict[@"dlbtype"]];
            
            if (IsNilOrNull(ckid)) {
                ckid = @"";
            }
            [KUserdefaults setObject:ckid forKey:Kckid];
            
            //orderinfo有值是返回的是字典，没有值是返回的是空串
            NSDictionary *orderinfoDic = [[NSDictionary alloc] init];
            NSMutableArray *orderinfo = [NSMutableArray array];
            id orderinfoC = dict[@"orderinfo"];
            if ([orderinfoC isKindOfClass:[NSString class]]) {
                NSLog(@"WTF");
            }else if ([orderinfoC isKindOfClass:[NSDictionary class]]){
                orderinfoDic = dict[@"orderinfo"];
                if (orderinfoDic != nil) {
                    
                    [orderinfo addObject:orderinfoDic];
                    
                    AddressModel *addressModel = [[AddressModel alloc] init];
                    addressModel.gettername = [NSString stringWithFormat:@"%@", orderinfoDic[@"gettername"]];
                    addressModel.gettermobile = [NSString stringWithFormat:@"%@", orderinfoDic[@"gettermobile"]];
                    if (!IsNilOrNull(addressModel.gettermobile)) {
                        [KUserdefaults setObject:addressModel.gettermobile forKey:@"Kgettermobile"];
                    }
                    NSString *address = [NSString stringWithFormat:@"%@", orderinfoDic[@"getteraddress"]];
                    NSArray *arr = [address componentsSeparatedByString:@" "];
                    NSRange range = [address rangeOfString:arr.lastObject];
                    addressModel.address = [address substringToIndex:range.location];
                    addressModel.homeaddress = arr.lastObject;
                    NSString *unionid = [KUserdefaults objectForKey:Kunionid];
                    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
                    NSString *filePath = [path stringByAppendingPathComponent:unionid];
                    [NSKeyedArchiver archiveRootObject:addressModel toFile:filePath];
                }
            }
            
            if([orderstatus isEqualToString:@"1"]){//e
                //弹出确认信息页面
                CKConfrimRegistMsgViewController *regist = [[CKConfrimRegistMsgViewController alloc] init];
                [self.navigationController pushViewController:regist animated:YES];
            }else{
                if (IsNilOrNull(dlbtype)) {
                    if (!IsNilOrNull(ckid)) {
                        if (orderinfo.count == 0) {//b
                            //创客升级，礼包列表只显示创客礼包
                            CKChooseJoinGoodsVC *chooseDLB = [[CKChooseJoinGoodsVC alloc] init];
                            chooseDLB.ckid = ckid;
                            chooseDLB.showAllTypeDLB = @"NO";
                            [self.navigationController pushViewController:chooseDLB animated:YES];
                        }else{//f
                            //创客升级,有未支付订单，进入确认订单页面，更换商品只显示创客礼包，不显示分销和零风险礼包
                            CKConfirmRegisterOrderVC *confirmOrder = [[CKConfirmRegisterOrderVC alloc]init];
                            CKOrderinfoModel *orderM = [[CKOrderinfoModel alloc] init];
                            for (NSDictionary *dict in orderinfo) {
                                [orderM setValuesForKeysWithDictionary:dict];
                            }
                            confirmOrder.totalMoney = [NSString stringWithFormat:@"%.2f", [orderM.price doubleValue]];
                            confirmOrder.orderinfoArray = orderinfo;
                            confirmOrder.fromVC = @"MainPageVC";
                            confirmOrder.ckid = ckid;
                            confirmOrder.showAllTypeDLB = @"NO";
                            [self.navigationController pushViewController:confirmOrder animated:YES];
                        }
                    }else{//d
                        //新用户购买
                        CKChooseJoinGoodsVC *chooseDLB = [[CKChooseJoinGoodsVC alloc] init];
                        chooseDLB.showAllTypeDLB = @"YES";
                        [self.navigationController pushViewController:chooseDLB animated:YES];
                    }
                }else{
                    if (!IsNilOrNull(ckid)) {
                        if ([orderinfo count] == 0) {//g
                            CKChooseJoinGoodsVC *chooseDLB = [[CKChooseJoinGoodsVC alloc] init];
                            chooseDLB.showAllTypeDLB = @"YES";
                            chooseDLB.ckid = ckid;
                            [self.navigationController pushViewController:chooseDLB animated:YES];
                        }else{
                            CKConfirmRegisterOrderVC *confirmOrder = [[CKConfirmRegisterOrderVC alloc]init];
                            CKOrderinfoModel *orderM = [[CKOrderinfoModel alloc] init];
                            for (NSDictionary *dict in orderinfo) {
                                [orderM setValuesForKeysWithDictionary:dict];
                            }
                            confirmOrder.totalMoney = [NSString stringWithFormat:@"%.2f", [orderM.price doubleValue]];
                            confirmOrder.orderinfoArray = orderinfo;
                            confirmOrder.fromVC = @"MainPageVC";
                            //有未支付订单，有ck信息，支付完成不跳确认信息页面
                            confirmOrder.ckid = ckid;
                            confirmOrder.showAllTypeDLB = @"YES";
                            [self.navigationController pushViewController:confirmOrder animated:YES];
                        }
                    }else{
                        CKConfirmRegisterOrderVC *confirmOrder = [[CKConfirmRegisterOrderVC alloc]init];
                        CKOrderinfoModel *orderM = [[CKOrderinfoModel alloc] init];
                        for (NSDictionary *dict in orderinfo) {
                            [orderM setValuesForKeysWithDictionary:dict];
                        }
                        confirmOrder.totalMoney = [NSString stringWithFormat:@"%.2f", [orderM.price doubleValue]];
                        confirmOrder.orderinfoArray = orderinfo;
                        confirmOrder.fromVC = @"MainPageVC";
                        //有未支付订单，没有ck信息，支付完成进入确认信息页面
                        confirmOrder.showAllTypeDLB = @"YES";
                        [self.navigationController pushViewController:confirmOrder animated:YES];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        NSLog(@"%@", error);
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

@end
