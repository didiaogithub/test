//
//  PartnerIncomeViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "PartnerIncomeViewController.h"
#import "AllIncomeView.h"
#import "KKDatePickerView.h"
#import "RatioView.h"
#import "MonthAccountModel.h"
#import "LeftPicRightTextView.h"
#import "SalesBonusViewController.h"

@interface PartnerIncomeViewController ()<KKDatePickerViewDelegate,LeftPicRightTextViewDelegate>
@property(nonatomic,strong)NSArray *valueArray;
@property(nonatomic,strong)LeftPicRightTextView *customerShopView;
@property(nonatomic,strong)LeftPicRightTextView *hhSaleView;
@property(nonatomic,strong)AllIncomeView *allIncomeView;
@property(nonatomic,strong)RatioView *rationView;
@property(nonatomic,copy)NSString *ckidString;
@property(nonatomic,copy)NSString *yearStr;
@property(nonatomic,copy)NSString *monthStr;
@property(nonatomic,strong)MonthAccountModel *partnerModel;
@end

@implementation PartnerIncomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMonthData];
    [self createSiftButton];
    [self createViews];
}

/**创建筛选按钮*/
-(void)createSiftButton{
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"selectconditions"] style:UIBarButtonItemStylePlain target:self action:@selector(clickSiftButton)];
    right.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10;
        self.navigationItem.rightBarButtonItems = @[spaceItem, right];
    }
}
/**点击筛选按钮*/
-(void)clickSiftButton{
    KKDatePickerView *pickerView = [[KKDatePickerView alloc]initWithFrame:self.view.bounds];
    pickerView.delegate = self;
    [pickerView show];
}
/**点击pickerview代理方法*/
- (void)pickView:(NSString *)yes month:(NSString *)moth{
    NSLog(@"--年%@--月%@",yes,moth);
    _yearStr = yes;
    _monthStr = moth;
    _allIncomeView.monthLable.text = [NSString stringWithFormat:@"%@月",moth];
    _allIncomeView.yearLable.text = yes;
    NSInteger length = _allIncomeView.monthLable.text.length;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_allIncomeView.monthLable.text ];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:CHINESE_SYSTEM_BOLD(AdaptedHeight(74/2))
                          range:NSMakeRange(0, 2)];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:CHINESE_SYSTEM(AdaptedHeight(29/2))
                          range:NSMakeRange(length-1, 1)];
    _allIncomeView.monthLable.attributedText = AttributedStr;
    [self getMonthData];
}
-(void)createViews{
    _allIncomeView = [[AllIncomeView alloc] initWithFrame:CGRectZero andTypeStr:@"hh"];
    [self.view addSubview:_allIncomeView];
    [_allIncomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(65);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(92));
    }];
    
    _rationView = [[RatioView alloc] initWithFrame:CGRectZero andTypeStr:@"hh"];
    [self.view addSubview:_rationView];
    [_rationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allIncomeView.mas_bottom).offset(AdaptedHeight(10));
        make.left.right.equalTo(_allIncomeView);
        make.height.mas_offset(AdaptedHeight(140));
    }];
    
    //普通店铺销售奖励
    _customerShopView = [[LeftPicRightTextView alloc] initWithFrame:CGRectZero andTitle:@"普通店铺销售奖励费" andImage:@"littlemonth" isShowRight:NO andTag:2114];
    [self.view addSubview:_customerShopView];
    _customerShopView.delegate = self;
    [_customerShopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rationView.mas_bottom).offset(AdaptedHeight(10));
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(65));
    }];
 
    //合伙人销售业绩奖励
    _hhSaleView = [[LeftPicRightTextView alloc] initWithFrame:CGRectZero andTitle:@"合伙人销售业绩奖励" andImage:@"littlemonth" isShowRight:NO andTag:2115];
    [self.view addSubview:_hhSaleView];
    _hhSaleView.delegate = self;
    [_hhSaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_customerShopView.mas_bottom).offset(AdaptedHeight(10));
        make.left.right.height.equalTo(_customerShopView);
    }];
    
}

#pragma mark-获取月结数据
-(void)getMonthData{
    _ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
  
    NSString *getMonthAccountUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getMonthlyStatement_Url];
    
    NSString *nowString = [NSDate nowTime:@"yyyy-MM"];
    NSArray *timeArr = [nowString componentsSeparatedByString:@"-"];
    _yearStr = IsNilOrNull(_yearStr) ? [timeArr firstObject] : _yearStr;
    _monthStr = IsNilOrNull(_monthStr) ? [timeArr lastObject] : _monthStr;
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"year":_yearStr,@"month":_monthStr,DeviceId:uuid};
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:getMonthAccountUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        NSLog(@"月结的字典%@",dict);
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        self.partnerModel = [[MonthAccountModel alloc] init];
        [self.partnerModel setValuesForKeysWithDictionary:dict];
        [self refreshWithModel:self.partnerModel];

    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        //网络请求超时 可以显示默认数据
        NSArray *array = @[@"0",@"0"];
        [self.rationView.chartView updateChartByNumbers:array];
    }];
}
#pragma maerk-刷新顶部视图内容
-(void)refreshWithModel:(MonthAccountModel *)monthModel{
    NSString * totalMoney = [NSString stringWithFormat:@"%@",monthModel.totalMoney];
    if (IsNilOrNull(totalMoney)) {
        totalMoney = @"0.00";
    }
    double totalMoneyDouble = [totalMoney doubleValue];
    _allIncomeView.allValueLable.text = [NSString stringWithFormat:@"%.2f",totalMoneyDouble];
    
    
    NSString * saleReward = [NSString stringWithFormat:@"%@",monthModel.totalTeam];
    if (IsNilOrNull(saleReward)) { //产品销售奖励
        saleReward = @"0.00";
    }
    double saleRewardDouble = [saleReward doubleValue];
    _rationView.firstVlaueLable.text = [NSString stringWithFormat:@"%.2f",saleRewardDouble];
    
    
    //软件推广
    NSString * totalInvite = [NSString stringWithFormat:@"%@",monthModel.totalInvite];
    if (IsNilOrNull(totalInvite)) { //推荐费 软件推广
        totalInvite = @"0.00";
    }
    double totalInviteDouble = [totalInvite doubleValue];
    _rationView.threenValueLable.text = [NSString stringWithFormat:@"%.2f",totalInviteDouble];
    
    self.valueArray = @[saleReward,totalInvite];
    [self.rationView.chartView updateChartByNumbers:self.valueArray];
}
#pragma mark-点击底部普通店铺销售奖励 hh销售业绩奖励
-(void)monthDetailJumpWithTag:(NSInteger)tag{
    
     SalesBonusViewController *saleVc = [[SalesBonusViewController alloc] init];
    if(tag == 4){
       saleVc.typeStr = @"0";
    }else{
       saleVc.typeStr = @"1";
    }
    [self.navigationController pushViewController:saleVc animated:YES];

}

@end
