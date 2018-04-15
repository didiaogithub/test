//
//  CKOrderDetailCell.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/27.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKOrderDetailCell.h"
#import "ChangeMyAddressViewController.h"
#import "CKOrderDetailViewController.h"
#import "CKOrderDetailModel.h"
#import "CKAddressViewController.h"
#import "AddressModel.h"

@implementation CKOrderDetailCell

-(void)fillData:(id)data {
    
}

-(void)callWithParameter:(id)parameter {
    
}

+(CGFloat)computeHeight:(id)data {
    return 0;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end



@implementation CKLogisticsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor colorWithHexString:@"#e22319"]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    _leftImgageView = [[UIImageView alloc] init];
    [bankView addSubview:_leftImgageView];
    [_leftImgageView setImage:[UIImage imageNamed:@"物流"]];
    [_leftImgageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(25);
        make.left.mas_offset(AdaptedWidth(31));
        make.size.mas_offset(CGSizeMake(48, 40));
        make.bottom.mas_offset(-40);
    }];
    
    _logistLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_logistLable];
    _logistLable.text = @"暂无物流信息！";
    [_logistLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftImgageView.mas_top);
        make.right.mas_offset(-AdaptedWidth(40));
        make.left.equalTo(_leftImgageView.mas_right).offset(AdaptedWidth(16));
        
    }];
    
    //右侧箭头
    _rightImageView = [[UIImageView alloc] init];
    [bankView addSubview:_rightImageView];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_rightImageView setImage:[UIImage imageNamed:@"logistright"]];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(43));
        make.right.mas_offset(-AdaptedWidth(20));
        make.width.mas_offset(AdaptedWidth(10));
        make.height.mas_offset(AdaptedHeight(20));
    }];
//    _rightImageView.hidden = YES;
    
    _timeLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_timeLable];
    _timeLable.text = @"   ";
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logistLable.mas_bottom).offset(AdaptedHeight(5));
        make.left.equalTo(_logistLable.mas_left);
//        make.bottom.mas_offset(-AdaptedHeight(40));
        make.right.equalTo(_logistLable.mas_right);
    }];
//    _timeLable.hidden = YES;
}

-(void)fillData:(id)data {
    
    NSDictionary *dict = data;
    NSDictionary *orderDict = [dict objectForKey:@"data"];
    
    NSString *lastlogisticsmsg = [NSString stringWithFormat:@"%@", [orderDict objectForKey:@"lastlogisticsmsg"]];
    NSString *lastlogisticstime = [NSString stringWithFormat:@"%@", [orderDict objectForKey:@"lastlogisticstime"]];
    
    if (IsNilOrNull(lastlogisticsmsg)) {
        _logistLable.text = @"暂无物流信息！";
        _timeLable.hidden = YES;
        _rightImageView.hidden = YES;
        [_logistLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_leftImgageView.mas_top).offset(AdaptedHeight(12));
        }];
    }else{
        _logistLable.numberOfLines = 0;
        _logistLable.text = lastlogisticsmsg;
        _timeLable.text = lastlogisticstime;
        _logistLable.hidden = NO;
        _timeLable.hidden = NO;
        _rightImageView.hidden = NO;
    }
}

@end


@implementation CKOrderNameCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    
    _bankView = [[UIView alloc] init];
    [self.contentView addSubview:_bankView];
    _bankView.backgroundColor = [UIColor whiteColor];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(0);
    }];
    
    //昵称
    _nickNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BoldTITLE_FONT];
    _nickNameLable.text = @" ";
    [_bankView addSubview:_nickNameLable];
    
    [_nickNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(31));
        make.bottom.mas_offset(AdaptedHeight(0));
    }];
}

-(void)fillData:(id)data {
    if (data == nil) {
        return;
    }
    NSDictionary *dict = data;
    
    NSDictionary *detailDict = [dict objectForKey:@"data"];
    
    NSString *nickName = [NSString stringWithFormat:@"%@", [detailDict objectForKey:@"smallname"]];
    if (IsNilOrNull(nickName)) {
        nickName = @"";
    }
    _nickNameLable.text = [NSString stringWithFormat:@"下单用户:%@",nickName];

}

@end

@implementation CKOrderGetterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    
    _bankView = [[UIView alloc] init];
    _bankView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bankView];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(0);
    }];
    //收货人
    _getterLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BoldTITLE_FONT];
    _getterLable.text = @"收货人:";
    [_bankView addSubview:_getterLable];
    [_getterLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(31));
        make.bottom.mas_offset(AdaptedHeight(0));
    }];
    
    //联系电话
    _telPhoneLable = [UILabel configureLabelWithTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:MAIN_BoldTITLE_FONT];
    _telPhoneLable.text = @" ";
    [_bankView addSubview:_telPhoneLable];
    [_telPhoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_getterLable.mas_top);
        make.left.equalTo(_getterLable.mas_right).offset(AdaptedWidth(15));
        make.bottom.mas_offset(AdaptedHeight(0));
    }];
}

-(void)fillData:(id)data {
    if (data == nil) {
        return;
    }
    NSDictionary *dict = data;
    
    NSDictionary *detailDict = [dict objectForKey:@"data"];
    NSString *gettername = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"gettername"]];
    NSString *gettermobile = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"gettermobile"]];

    NSString *orderType = [dict objectForKey:@"orderType"];
    NSString *favormoney = [dict objectForKey:@"favormoney"];

    if([orderType isEqualToString:@"WXUSER"]) {
        if (IsNilOrNull(favormoney) || [favormoney isEqualToString:@"0"] || [favormoney isEqualToString:@"0.00"]) {
            if (IsNilOrNull(gettername)) {
                gettername = @"";
            }
            _getterLable.text = [NSString stringWithFormat:@"收货人:%@",gettername];
            
            if (IsNilOrNull(gettermobile)) {
                gettermobile = @"";
            }
            _telPhoneLable.text = gettermobile;
        }else{
            if (IsNilOrNull(gettername)) {
                gettername = @"";
                _getterLable.text = [NSString stringWithFormat:@"收货人:%@", gettername];
            }else{
                if (gettername.length > 0) {
                    gettername = [gettername substringToIndex:1];
                }
                _getterLable.text = [NSString stringWithFormat:@"收货人:%@**", gettername];
            }
            if (IsNilOrNull(gettermobile)) {
                gettermobile = @"";
                _telPhoneLable.text = gettermobile;
            }else{
                if (gettermobile.length > 2) {
                    gettermobile = [gettermobile substringToIndex:2];
                }
                _telPhoneLable.text = [NSString stringWithFormat:@"%@********", gettermobile];
            }
        }
    }else{
        if (IsNilOrNull(gettername)) {
            gettername = @"";
        }
        _getterLable.text = [NSString stringWithFormat:@"收货人:%@",gettername];
        
        if (IsNilOrNull(gettermobile)) {
            gettermobile = @"";
        }
        _telPhoneLable.text = gettermobile;
    }
}

@end


@implementation CKOrderAddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    
    _bankView = [[UIView alloc] init];
    _bankView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bankView];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(0);
    }];
    //地址图标
    _addressImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_addressImageView];
    UIImage *headimage = [UIImage imageNamed:@"定位"];
    _addressImageView.image = [headimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //详细地址
    _addressDetailLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    _addressDetailLable.text = @" ";
    _addressDetailLable.numberOfLines = 0;
    [_bankView addSubview:_addressDetailLable];
    
    //定位图片
    [_addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bankView.mas_centerY);
        make.left.mas_offset(AdaptedWidth(10));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(14), AdaptedHeight(17)));
    }];
    
    //详细地址
    [_addressDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bankView.mas_centerY);
        make.left.mas_offset(AdaptedWidth(31));
        make.right.mas_offset(AdaptedWidth(-10));
        make.height.mas_equalTo(AdaptedWidth(44));
    }];
}

-(void)fillData:(id)data {
    if (data == nil) {
        return;
    }
    NSDictionary *dict = data;
    
    NSString *type = [dict objectForKey:@"type"];
    if ([type isEqualToString:@"default"]) {
        NSDictionary *detailDict = [dict objectForKey:@"data"];
        NSString *getteraddress = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"getteraddress"]];
        _addressDetailLable.text = getteraddress;
    }else if([type isEqualToString:@"changed"]){
        _addressDetailLable.text = [dict objectForKey:@"data"];;
    }
}

@end


@implementation CKOrderChangeAddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    _bankView = [[UIView alloc] init];
    _bankView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bankView];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(-0.5);
        make.left.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(0);
    }];
    //修改地址按钮
    _changeAdrrBtn = [UIButton new];
    _changeAdrrBtn.hidden = NO;
    _changeAdrrBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_changeAdrrBtn setTitle:@"修改地址" forState:UIControlStateNormal];
    [_changeAdrrBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    _changeAdrrBtn.layer.borderWidth = 0.5f;
    _changeAdrrBtn.layer.borderColor = TitleColor.CGColor;
    _changeAdrrBtn.layer.cornerRadius = 10.0f;
    _changeAdrrBtn.layer.masksToBounds = YES;
    [_changeAdrrBtn addTarget:self action:@selector(changeAdrress) forControlEvents:UIControlEventTouchUpInside];
    [_bankView addSubview:_changeAdrrBtn];

    [_changeAdrrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(1);
        make.bottom.mas_offset(-10);
        make.right.mas_offset(AdaptedWidth(-10));
        make.width.mas_equalTo(80);
    }];
}

-(void)fillData:(id)data {
    if (data == nil) {
        return;
    }
    NSDictionary *dict = data;
    _oidStr = [NSString stringWithFormat:@"%@", [dict objectForKey:@"oid"]];
    _orderStatus = [NSString stringWithFormat:@"%@", [dict objectForKey:@"orderStatus"]];
    self.orderNo = [NSString stringWithFormat:@"%@", [dict objectForKey:@"orderNo"]];
    //是否需要实名认证
    self.isNeedRealName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"isNeedRealName"]];

    NSDictionary *dataDict = dict[@"data"];
    _paytime = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"paytime"]];
    _ordertime = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"ordertime"]];
    self.limitTime = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"limittime"]];

    self.systime = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"systime"]];
    
    self.gettername = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"gettername"]];
    self.gettermobile = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"gettermobile"]];
    
    NSString *getteraddress = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"getteraddress"]];
    NSArray *arr = [getteraddress componentsSeparatedByString:@" "];
    self.address = arr.firstObject;
    self.homeaddress = arr.lastObject;
    
    
}

-(void)changeAdrress {
    
    NSInteger limitTime = [self.limitTime integerValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";

    NSDate *payDate;
    if (!IsNilOrNull(self.paytime)) {
        payDate = [dateFormatter dateFromString:self.paytime];
    }else{
        payDate = [dateFormatter dateFromString:self.ordertime];
    }
    NSTimeInterval pay = [payDate timeIntervalSince1970];

    NSTimeInterval value = [self.systime longLongValue] - pay;
    CGFloat second = [[NSString stringWithFormat:@"%.2f",value] floatValue];//秒
    NSLog(@"间隔------%f秒",second);
    
    CKOrderDetailViewController *checkOrderVC;
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[CKOrderDetailViewController class]]) {
            checkOrderVC = (CKOrderDetailViewController*)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    
    if (value > limitTime*60 && [_orderStatus isEqualToString:@"2"]) {
        [checkOrderVC hiddenChangeAddressBtn];
    }else{
        
        if ([self.orderNo containsString:@"dlb"]) {
            CKAddressViewController *modifyAddress = [[CKAddressViewController alloc] init];
            modifyAddress.addressModel = [[AddressModel alloc] init];
            modifyAddress.addressModel.gettername = self.gettername;
            modifyAddress.addressModel.gettermobile = self.gettermobile;
            modifyAddress.addressModel.address = self.address;
            modifyAddress.addressModel.homeaddress = self.homeaddress;

            [modifyAddress setAddressBlock:^(AddressModel *addressM) {
                [checkOrderVC reloadOrderWithNewAdress:addressM];
            }];
            modifyAddress.pushString = @"CKOrderDetail";
            modifyAddress.oidString = _oidStr;
            [checkOrderVC.navigationController pushViewController:modifyAddress animated:YES];
        }else{
            ChangeMyAddressViewController *address = [[ChangeMyAddressViewController alloc] init];
            [address setAddressBlock:^(AddressModel *addressModel) {
                NSLog(@"%@", addressModel);
                [checkOrderVC reloadOrderWithNewAdress:addressModel];
            }];
            address.pushString = @"CKOrderDetail";
            address.oidString = _oidStr;
            address.isOversea = self.isNeedRealName;
            [checkOrderVC.navigationController pushViewController:address animated:YES];
        }
    }
}

@end

#pragma mark - 分隔彩线
@implementation CKOrderSpaImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    _bankView = [[UIView alloc] init];
    [self.contentView addSubview:_bankView];
    _bankView.backgroundColor = [UIColor whiteColor];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(0);
    }];
    //底边
    _bottomImageView = [[UIImageView alloc] init];
    [_bankView addSubview:_bottomImageView];
    [_bottomImageView setImage:[UIImage imageNamed:@"分隔彩线"]];
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
        make.height.mas_offset(3);
    }];
}

@end


@interface CKGoodDetailCell ()

@property (nonatomic, strong) UILabel *goodsPriceL;//价格
@property (nonatomic, strong) UILabel *goodsNameL;//名称
@property (nonatomic, strong) UILabel *goodsCountL;//数量
@property (nonatomic, strong) UILabel *goodsSpecL;//规格
@property (nonatomic, strong) UIImageView *goodsImageView;//商品图片

@end

@implementation CKGoodDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTopViews];
    }
    return self;
}

- (void)createTopViews {
    
    self.goodsImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.goodsImageView];
    self.goodsImageView.layer.borderColor = [UIColor tt_borderColor].CGColor;
    self.goodsImageView.layer.borderWidth = 1;
    self.goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(AdaptedWidth(28));
        make.size.mas_offset(CGSizeMake(100, 100));
    }];
    
    //价格
    self.goodsPriceL = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:15]];
    [self.contentView addSubview:self.goodsPriceL];
    self.goodsPriceL.text = @"¥0.00";
    [self.goodsPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_top);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(25);
    }];
    
    self.goodsNameL = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:self.goodsNameL];
    self.goodsNameL.numberOfLines = 0;
    [self.goodsNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_top);
        make.left.equalTo(self.goodsImageView.mas_right).offset(10);
        make.right.equalTo(self.goodsPriceL.mas_left).offset(-10);
    }];
    
    
    self.goodsSpecL = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:self.goodsSpecL];
    self.goodsSpecL.text = @"规格";
    self.goodsSpecL.numberOfLines = 0;
    [self.goodsSpecL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodsImageView.mas_bottom);
        make.left.equalTo(self.goodsImageView.mas_right).offset(10);
        make.height.mas_equalTo(25);
        make.right.mas_offset(-80);
    }];
    
    self.goodsCountL = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self.contentView addSubview:self.goodsCountL];
    self.goodsCountL.text = @"1";
    [self.goodsCountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.left.equalTo(self.goodsSpecL.mas_right).offset(10);
        make.height.mas_equalTo(25);
        make.bottom.equalTo(self.goodsImageView.mas_bottom);
    }];
    
    
    UILabel *bottomLine = [UILabel creatLineLable];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_offset(1);
        make.bottom.mas_offset(0);
    }];
}

#pragma mark - 刷新model数据
-(void)fillData:(id)data {
    if (data == nil) {
        return;
    }
    
    
    Ordersheet *detailModel = [data objectForKey:@"data"];
    NSString *url = [NSString stringWithFormat:@"%@", detailModel.url];
    NSString *picUrl = [NSString loadImagePathWithString:url];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"waitgoods"]];
    
    NSString *name = [NSString stringWithFormat:@"%@", detailModel.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    self.goodsNameL.text = name;
    
    NSString *number = [NSString stringWithFormat:@"%@", detailModel.count];
    if (IsNilOrNull(number)) {
        number = @"";
    }
    self.goodsCountL.text = [NSString stringWithFormat:@"x%@", number];
    
    NSString *price = [NSString stringWithFormat:@"%@", detailModel.price];
    if (IsNilOrNull(price)) {
        price = @"";
    }
    self.goodsPriceL.text = [NSString stringWithFormat:@"¥%@", price];
    CGSize textSize = [self.goodsPriceL.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    [self.goodsPriceL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(textSize.width+20);
    }];
    
    
    NSString *spec = [NSString stringWithFormat:@"%@", detailModel.spec];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }
    self.goodsSpecL.text = [NSString stringWithFormat:@"规格:%@", spec];
}

@end



@interface CKOrderPaymentCell ()

/**创客 or 消费者*/
@property (nonatomic, copy)   NSString *typeString;
@property (nonatomic, strong) UILabel *orderPriceLable;
@property (nonatomic, strong) UILabel *orderPriceText;
@property (nonatomic, strong) UILabel *textTransfree;
@property (nonatomic, strong) UILabel *transfeeNumberLable;
@property (nonatomic, strong) UILabel *realMoneyText;
@property (nonatomic, strong) UILabel *realMoneyLable;
@property (nonatomic, strong) UILabel *orderDicountL;
@property (nonatomic, strong) UILabel *orderDicoutLabel;
@property (nonatomic, strong) UIView *bankView;
@end

@implementation CKOrderPaymentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    self.bankView = [[UIView alloc] init];
    [self.contentView addSubview:self.bankView];
    [self.bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    //运费
    self.textTransfree = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.bankView addSubview:self.textTransfree];
    self.textTransfree.text = @"运费:";
    [self.textTransfree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(AdaptedWidth(28));
        make.height.mas_equalTo(20);
    }];
    
    _transfeeNumberLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self.bankView addSubview:_transfeeNumberLable];
    _transfeeNumberLable.text = @"¥0.00";
    [_transfeeNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textTransfree.mas_centerY);
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    //订单总额
    self.orderPriceText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.bankView addSubview:self.orderPriceText];
    self.orderPriceText.text = @"订单总额:";
    [self.orderPriceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textTransfree.mas_bottom).offset(8);
        make.left.mas_offset(AdaptedWidth(28));
        make.height.mas_equalTo(20);
    }];
    //订单总价
    _orderPriceLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self.bankView addSubview:_orderPriceLable];
    _orderPriceLable.text = @"¥0.00";
    [_orderPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderPriceText.mas_centerY);
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    //商品优惠
    self.orderDicoutLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.bankView addSubview:self.orderDicoutLabel];
    self.orderDicoutLabel.text = @"商品优惠:";
    self.orderDicoutLabel.hidden = YES;
    [self.orderDicoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderPriceText.mas_bottom).offset(8);
        make.left.mas_offset(AdaptedWidth(28));
        make.height.mas_offset(20);
    }];

    _orderDicountL = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self.bankView addSubview:_orderDicountL];
    _orderDicountL.text = @"¥0.00";
    self.orderDicountL.hidden = YES;
    [_orderDicountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderDicoutLabel.mas_centerY);
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    
    //实际付款
    self.realMoneyText = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.bankView addSubview:self.realMoneyText];
    self.realMoneyText.text = @"实际付款:";
    [self.realMoneyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderPriceText.mas_bottom).offset(8);
        make.left.mas_offset(AdaptedWidth(28));
        make.height.mas_offset(20);
    }];
    
    _realMoneyLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentRight font:MAIN_BoldTITLE_FONT];
    [self.bankView addSubview:_realMoneyLable];
    _realMoneyLable.text = @"¥0.00";
    [_realMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.realMoneyText.mas_centerY);
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    //分割线
    UILabel *middleLine = [UILabel creatLineLable];
    [self.bankView addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
}

+(CGFloat)computeHeight:(id)data {
    if (data == nil) {
        return 28*3+20;
    }
    
    NSDictionary *dict = data;
    NSString *favormoney = [dict objectForKey:@"favormoney"];
    NSString *orderType = [dict objectForKey:@"orderType"];
    if ([orderType isEqualToString:@"WXUSER"]) {//消费者订单
        if (IsNilOrNull(favormoney) || [favormoney isEqualToString:@"0"] || [favormoney isEqualToString:@"0.00"]) {//没有使用优惠券
            return 28*3+20;
        }else{
            return 28*4+20;
        }
    }else{
        return 28*3+20;
    }
}

-(void)fillData:(id)data {
    
    if (data == nil) {
        return;
    }
    
    NSDictionary *dict = data;
    
    NSDictionary *detailDict = [dict objectForKey:@"data"];
    
    NSString *orderType = [dict objectForKey:@"orderType"];
    NSString *favormoney = [dict objectForKey:@"favormoney"];
    NSString *orderStatus = [dict objectForKey:@"orderStatus"];
    NSString *money = [dict objectForKey:@"money"];
    NSString *orderMoney = [dict objectForKey:@"orderMoney"];
    
    
    if ([orderType isEqualToString:@"WXUSER"]) {//消费者订单
        if (IsNilOrNull(favormoney) || [favormoney isEqualToString:@"0"] || [favormoney isEqualToString:@"0.00"]) {//没有使用优惠券
            _orderDicoutLabel.hidden = YES;
            _orderDicountL.hidden = YES;
            [self.realMoneyText mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.orderPriceText.mas_bottom).offset(8);
                make.left.mas_offset(AdaptedWidth(28));
                make.height.mas_offset(20);
            }];
        }else{//有使用优惠券
            _orderDicountL.text = [NSString stringWithFormat:@"-¥%.2f", [favormoney doubleValue]];
            _orderDicoutLabel.hidden = NO;
            _orderDicountL.hidden = NO;
            [self.realMoneyText mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.orderDicoutLabel.mas_bottom).offset(8);
                make.left.mas_offset(AdaptedWidth(28));
                make.height.mas_offset(20);
            }];
        }
    }else{
        _orderDicoutLabel.hidden = YES;
        _orderDicountL.hidden = YES;
        [self.realMoneyText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.orderPriceText.mas_bottom).offset(8);
            make.left.mas_offset(AdaptedWidth(28));
            make.height.mas_offset(20);
        }];
    }
    
    
    CKOrderDetailModel *infoModel = [[CKOrderDetailModel alloc] init];
    [infoModel setValuesForKeysWithDictionary:detailDict];
    
    //运费
    NSString *tranfee = [NSString stringWithFormat:@"%@", infoModel.transfee];
    if (IsNilOrNull(tranfee)) {
        tranfee = @"0.00";
    }
    _transfeeNumberLable.text = [NSString stringWithFormat:@"¥%.2f", [tranfee doubleValue]];
    
    //订单总价
    if (IsNilOrNull(orderMoney)) {
        orderMoney = @"0.00";
    }
    _orderPriceLable.text = [NSString stringWithFormat:@"¥%.2f", [orderMoney doubleValue]];
    
    //实际价格
    if (IsNilOrNull(money)) {
        money = @"0.00";
    }
    _realMoneyLable.text =[NSString stringWithFormat:@"¥%.2f", [money doubleValue]];
    if ([orderStatus isEqualToString:@"1"] || [orderStatus isEqualToString:@"0"]) {//未付款
        self.realMoneyText.text = @"应付款:";
    }else{
        self.realMoneyText.text = @"实际付款:";
    }
}

@end


@interface CKOrderInfoCell ()

@property (nonatomic, strong) UILabel *orderMessageLable;

@end

@implementation CKOrderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    _orderMessageLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_orderMessageLable];
    _orderMessageLable.text = @"订单号:\n物流公司:\n物流单号:\n下单日期:\n支付日期:\n发货日期:\n";
    //mark 富文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_orderMessageLable.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_orderMessageLable.text length])];
    _orderMessageLable.attributedText = attributedString;
    _orderMessageLable.numberOfLines = 0;
    
    [_orderMessageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.mas_offset(30);
        make.bottom.mas_offset(-10);
    }];
}

-(void)fillData:(id)data {

    if (data == nil) {
        return;
    }
    
    NSDictionary *dict = data;
    
    NSDictionary *detailDict = [dict objectForKey:@"data"];
    
    CKOrderDetailModel *infoModel = [[CKOrderDetailModel alloc] init];
    [infoModel setValuesForKeysWithDictionary:detailDict];

    NSString *transNo = [NSString stringWithFormat:@"%@",  infoModel.transno];
    NSString *ordertime = [NSString stringWithFormat:@"%@", infoModel.ordertime];
    NSString *paytime = [NSString stringWithFormat:@"%@",infoModel.paytime];
    NSString *tranName = [NSString stringWithFormat:@"%@", infoModel.transname];
    NSString *shipTime = [NSString stringWithFormat:@"%@", infoModel.shiptime];
    
    if (IsNilOrNull(transNo)) {
        transNo = @"暂无信息";
    }
    if (IsNilOrNull(ordertime)) {
        ordertime = @"暂无信息";
    }
    if (IsNilOrNull(paytime)) {
        paytime = @"暂无信息";
    }
    if (IsNilOrNull(tranName)) {
        tranName = @"暂无信息";
    }
    
    NSString *orderNo = [dict objectForKey:@"orderNo"];
    
    if (IsNilOrNull(orderNo)) {
        orderNo = @"暂无信息";
    }
    if (IsNilOrNull(shipTime)) {
        shipTime = @"暂无信息";
    }
    _orderMessageLable.text = [NSString stringWithFormat:@"订单号:%@\n物流公司:%@\n物流单号:%@\n下单日期:%@\n支付日期:%@\n发货日期:%@\n", orderNo, tranName, transNo, ordertime, paytime, shipTime];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_orderMessageLable.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_orderMessageLable.text length])];
    _orderMessageLable.attributedText = attributedString;
    _orderMessageLable.numberOfLines = 0;

}

@end


#pragma mark - 原订单信息
@interface CKOriginalOrderInfoCell ()

@property (nonatomic, strong) UIImageView *markImgView;
@property (nonatomic, strong) UILabel *orderNoLable;
@property (nonatomic, strong) UILabel *orderMoneyLabel;
@property (nonatomic, strong) UIButton *rightArrowBtn;

@end

@implementation CKOriginalOrderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    
    UILabel *line = [UILabel creatLineLable];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_offset(0);
        make.left.mas_offset(30);
        make.height.mas_equalTo(1);
    }];
    
    self.markImgView = [UIImageView new];
    self.markImgView.image = [UIImage imageNamed:@"originOrder"];
    [self.contentView addSubview:self.markImgView];
    [self.markImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.orderNoLable = [UILabel new];
    self.orderNoLable.text = @" ";
    self.orderNoLable.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.orderNoLable];
    [self.orderNoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(30);
        make.height.mas_equalTo(30);
    }];


    self.rightArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightArrowBtn setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
    [self.rightArrowBtn addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightArrowBtn];
    [self.rightArrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.right.mas_offset(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];

    self.orderMoneyLabel = [UILabel new];
    self.orderMoneyLabel.text = @" ";
    self.orderMoneyLabel.font = [UIFont systemFontOfSize:13];
    self.orderMoneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.orderMoneyLabel];
    [self.orderMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.rightArrowBtn.mas_left).offset(-5);
        make.left.equalTo(self.orderNoLable.mas_right);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)fillData:(id)data {
    
    NSString *tag = data[@"tag"];
    NSArray *array = data[@"data"];
    NSInteger i = [tag integerValue];
    
    if (0 == i) {
        self.markImgView.hidden = NO;
        self.orderNoLable.textColor = [UIColor colorWithHexString:@"#333333"];
        self.orderMoneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }else{
        self.markImgView.hidden = YES;
        self.orderNoLable.textColor = [UIColor colorWithHexString:@"#666666"];
        self.orderMoneyLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    
    CKOldDetailModel *oldDetailM = array[i];
    self.orderNoLable.text = oldDetailM.orderno;
    self.orderMoneyLabel.text = oldDetailM.ordermoney;
    
    self.rightArrowBtn.tag = 6666+i;
}

- (void)showDetail {
    
    NSLog(@"self.rightArrowBtn:%@", self.rightArrowBtn);
    self.rightArrowBtn.selected = !self.rightArrowBtn.selected;
    if (self.rightArrowBtn.selected) {
        [self.rightArrowBtn setImage:[UIImage imageNamed:@"bottomarrow"] forState:UIControlStateNormal];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showOriginalOrderDetail:index:)]) {
            [self.delegate showOriginalOrderDetail:self index:self.rightArrowBtn.tag-6666];
        }
        
    }else{
        [self.rightArrowBtn setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(closeOriginalOrderDetail:index:)]) {
            [self.delegate closeOriginalOrderDetail:self index:self.rightArrowBtn.tag-6666];
        }
    }
}

@end


//原订单商品信息
@interface CKOriginalOrderGoodsCell ()

@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *buyCountLable;

@end

@implementation CKOriginalOrderGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    
    self.buyCountLable = [UILabel new];
    self.buyCountLable.text = @"x1";
    self.buyCountLable.textAlignment = NSTextAlignmentRight;
    self.buyCountLable.textColor = [UIColor colorWithHexString:@"#777777"];
    self.buyCountLable.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.buyCountLable];
    [self.buyCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.mas_offset(-10);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    
    self.goodsNameLabel = [UILabel new];
    self.goodsNameLabel.text = @" ";
    self.goodsNameLabel.textColor = [UIColor colorWithHexString:@"#777777"];
    self.goodsNameLabel.font = [UIFont systemFontOfSize:13];
    self.goodsNameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.goodsNameLabel];
    [self.goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(30);
        make.right.equalTo(self.buyCountLable.mas_left).offset(-15);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)fillData:(id)data {
    
    CKGoodsDetailModel *goodsM = data[@"data"];
    self.goodsNameLabel.text = goodsM.name;
    self.buyCountLable.text = [NSString stringWithFormat:@"x%@", goodsM.num];
}

+ (CGFloat)computeHeight:(id)data {
    if (!data) {
        return 40;
    }
    CKGoodsDetailModel *goodsM = data;
    NSString *name = [NSString stringWithFormat:@"%@", goodsM.name];
    CGFloat h = [name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 115, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size.height;
    return h+15;
}

@end


#pragma mark - 换货订单信息
@interface CKChangeOrderInfoCell ()

@property (nonatomic, strong) UIImageView *markImgView;
@property (nonatomic, strong) UILabel *orderNoLable;
@property (nonatomic, strong) UILabel *orderMoneyLabel;
@property (nonatomic, strong) UIButton *rightArrowBtn;

@end

@implementation CKChangeOrderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    
    UILabel *line = [UILabel creatLineLable];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_offset(0);
        make.left.mas_offset(30);
        make.height.mas_equalTo(1);
    }];
    
    self.markImgView = [UIImageView new];
    self.markImgView.image = [UIImage imageNamed:@"order_changeGoods"];
    [self.contentView addSubview:self.markImgView];
    [self.markImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.orderNoLable = [UILabel new];
    self.orderNoLable.text = @" ";
    self.orderNoLable.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.orderNoLable];
    [self.orderNoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(30);
        make.height.mas_equalTo(30);
    }];
    
    
    self.rightArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightArrowBtn setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
    [self.rightArrowBtn addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightArrowBtn];
    [self.rightArrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.right.mas_offset(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    self.orderMoneyLabel = [UILabel new];
    self.orderMoneyLabel.text = @" ";
    self.orderMoneyLabel.font = [UIFont systemFontOfSize:13];
    self.orderMoneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.orderMoneyLabel];
    [self.orderMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.rightArrowBtn.mas_left).offset(-5);
        make.left.equalTo(self.orderNoLable.mas_right);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)fillData:(id)data {
    
    NSString *tag = data[@"tag"];
    NSArray *array = data[@"data"];
    NSInteger i = [tag integerValue];
    
    if (0 == i) {
        self.markImgView.hidden = NO;
        self.orderNoLable.textColor = [UIColor colorWithHexString:@"#333333"];
        self.orderMoneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }else{
        self.markImgView.hidden = YES;
        self.orderNoLable.textColor = [UIColor colorWithHexString:@"#666666"];
        self.orderMoneyLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    
    CKOldDetailModel *oldDetailM = array[i];
    self.orderNoLable.text = oldDetailM.orderno;
    self.orderMoneyLabel.text = oldDetailM.ordermoney;
    
    self.rightArrowBtn.tag = 7777+i;
}

- (void)showDetail {
    
    NSLog(@"self.rightArrowBtn:%@", self.rightArrowBtn);
    self.rightArrowBtn.selected = !self.rightArrowBtn.selected;
    if (self.rightArrowBtn.selected) {
        [self.rightArrowBtn setImage:[UIImage imageNamed:@"bottomarrow"] forState:UIControlStateNormal];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showChangeOrderDetail:index:)]) {
            [self.delegate showChangeOrderDetail:self index:self.rightArrowBtn.tag-7777];
        }
        
    }else{
        [self.rightArrowBtn setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(closeChangeOrderDetail:index:)]) {
            [self.delegate closeChangeOrderDetail:self index:self.rightArrowBtn.tag-7777];
        }
    }
}

@end

//换货订单商品信息
@interface CKChangOrderGoodsCell ()

@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *buyCountLable;

@end

@implementation CKChangOrderGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    
    self.buyCountLable = [UILabel new];
    self.buyCountLable.text = @"x1";
    self.buyCountLable.textAlignment = NSTextAlignmentRight;
    self.buyCountLable.textColor = [UIColor colorWithHexString:@"#777777"];
    self.buyCountLable.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.buyCountLable];
    [self.buyCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.mas_offset(-10);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    
    self.goodsNameLabel = [UILabel new];
    self.goodsNameLabel.text = @" ";
    self.goodsNameLabel.textColor = [UIColor colorWithHexString:@"#777777"];
    self.goodsNameLabel.font = [UIFont systemFontOfSize:13];
    self.goodsNameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.goodsNameLabel];
    [self.goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(30);
        make.right.equalTo(self.buyCountLable.mas_left).offset(-15);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)fillData:(id)data {
    
    CKGoodsDetailModel *goodsM = data[@"data"];
    self.goodsNameLabel.text = goodsM.name;
    self.buyCountLable.text = [NSString stringWithFormat:@"x%@", goodsM.num];
}

+ (CGFloat)computeHeight:(id)data {
    if (!data) {
        return 40;
    }
    CKGoodsDetailModel *goodsM = data;
    NSString *name = [NSString stringWithFormat:@"%@", goodsM.name];
    CGFloat h = [name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 115, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size.height;
    return h+15;
}

@end
