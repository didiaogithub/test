//
//  BirthplaceViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/3.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "BirthplaceViewController.h"
#import "SelectedProviceViewController.h"
#import "AddressModel.h"
@interface BirthplaceViewController ()<UITextFieldDelegate>
{
    UIButton *_saveButton;
    NSString *_ckidString;
    UITextField *_contentTextfield;
    
    UITextField *_nameTextFiedld;//联系人
    UITextField *_telePhoneFiedld;//联系电话
    UILabel *_cityLabel;  //省市区 地址
    UITextField *_detailedAddressFiedld;//详细地址
    AddressModel *_addressModel;
    NSString *_addressStr;
    UITextField *_cityTextField;

}
@property(nonatomic,strong)UILabel *cityLable;
@end

@implementation BirthplaceViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.areaNameStr) {
        _cityLable.text = self.areaNameStr;
    }
}
-(id)init{
    if (self = [super init]) {
         [CKCNotificationCenter addObserver:self selector:@selector(transName:) name:@"bank" object:nil];
    }
    return self;
}
-(void)transName:(NSNotification *)notice{
    NSLog(@"%@",notice.object);
    self.areaNameStr = notice.object;
}
-(void)dealloc{
    [CKCNotificationCenter removeObserver:self name:@"bank" object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收货地址";
    [self createViews];
    [self getAddressInfo];
   
}
#pragma mark-通过id获取地址
-(void)getAddressInfo{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getAddressById_Url];
    NSDictionary *pramaDic = @{@"id":self.addressIdString};
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *code  = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        _addressModel = [[AddressModel alloc] init];
        [_addressModel setValuesForKeysWithDictionary:dict];
        [self refreshWithModel:_addressModel];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];


}
-(void)refreshWithModel:(AddressModel *)addressModel{
    NSString *name = [NSString stringWithFormat:@"%@",addressModel.gettername];
    NSString *mobile = [NSString stringWithFormat:@"%@",addressModel.gettermobile];
    NSString *threeAddress = [NSString stringWithFormat:@"%@",addressModel.address];
    NSString *detailAddress = [NSString stringWithFormat:@"%@",addressModel.homeaddress];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    if (IsNilOrNull(mobile)) {
        mobile = @"";
    }
    if (IsNilOrNull(threeAddress)) {
        threeAddress = @"";
    }
    if (IsNilOrNull(detailAddress)) {
        detailAddress = @"";
    }
     _addressStr = [NSString stringWithFormat:@"%@ %@",threeAddress,detailAddress];
    _nameTextFiedld.text = name;
    _telePhoneFiedld.text = mobile;
    if (self.areaNameStr) {
         _cityLabel.text = self.areaNameStr;
    }else{
         _cityLabel.text = threeAddress;
    }
   
    _detailedAddressFiedld.text = detailAddress;
    
   
}
/**创建views*/
-(void)createViews{
    
    __weak BirthplaceViewController *place = self;
    
    UIView *bankView = [[UIView alloc] init];
    [self.view addSubview:bankView];
    bankView.layer.cornerRadius = 5;
    bankView.backgroundColor = [UIColor whiteColor];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(place.view).offset(64+5);
        make.left.equalTo(place.view).offset(5);
        make.right.equalTo(place.view).offset(-5);
        make.height.mas_offset(204*SCREEN_HEIGHT_SCALE);
    }];
    float h = 0;
    NSArray * titleArr = @[@"收件人：",@"手机号码：",@"所在地区：",@"详细地址："];
    for (int i = 0; i<4; i++) {
        UIButton * addressButton = [[UIButton alloc] initWithFrame:CGRectMake(10, h, SCREEN_WIDTH-30, 50)];
        [addressButton setTitle:titleArr[i] forState:UIControlStateNormal];
        addressButton.titleLabel.font = [UIFont systemFontOfSize:16];
        addressButton.backgroundColor = [UIColor whiteColor];
        addressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [addressButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        addressButton.tag = 100+i;
        [addressButton addTarget:self action:@selector(editAddressMsgClick:) forControlEvents:UIControlEventTouchUpInside];
        [bankView addSubview:addressButton];
        
        if (i != 0) {
            UILabel *lineL = [UILabel creatLineLable];
            lineL.frame = CGRectMake(5, h+1, SCREEN_WIDTH-20, 1);
            [bankView addSubview:lineL];
        }
        _contentTextfield = [[UITextField alloc] initWithFrame:CGRectMake(85,0, SCREEN_WIDTH-110,50)];
        _contentTextfield.delegate = self;
        _contentTextfield.tag = 200+i;
        _contentTextfield.textColor = [UIColor grayColor];
        _contentTextfield.font = [UIFont systemFontOfSize:15];
        _contentTextfield.textAlignment = NSTextAlignmentLeft;
        [addressButton addSubview:_contentTextfield];
        
        if (addressButton.tag == 102) {
            _cityLabel = [UILabel configureLabelWithTextColor:[UIColor grayColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
            _cityLabel.frame = CGRectMake(85, 5, SCREEN_WIDTH-135, 40);
            [addressButton addSubview:_cityLabel];
        }
        if(_contentTextfield.tag == 202){
            _cityLabel.text = @"请选择";
            _cityLabel.textColor = [UIColor lightGrayColor];
            
        }else if (_contentTextfield.tag == 203){
            _contentTextfield.placeholder = @"街道，楼牌号";
        }
        switch (i) {
            case 0:
                _nameTextFiedld = _contentTextfield;
                break;
            case 1:
                _telePhoneFiedld = _contentTextfield;
                break;
            case 2:
                _contentTextfield.enabled = NO;
                _cityTextField = _contentTextfield;
                
                break;
            case 3:
                _detailedAddressFiedld = _contentTextfield;
                break;
            default:
                break;
        }
        h+=51;
    }

    //    //保存按钮
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_saveButton];
        _saveButton.layer.cornerRadius = 5;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        _saveButton.backgroundColor = [UIColor tt_redMoneyColor];
        [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankView.mas_bottom).offset(15);
            make.left.equalTo(bankView.mas_left);
            make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - 10, 50*SCREEN_HEIGHT_SCALE));
        }];
    
        [_saveButton addTarget:self action:@selector(clickSaveButton) forControlEvents:UIControlEventTouchUpInside];

    
}
/**点击保存按钮*/
-(void)clickSaveButton{
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    
    if (_nameTextFiedld.text ==nil||[_nameTextFiedld.text isKindOfClass:[NSNull class]])
    {
        _nameTextFiedld.text = @"";
    }
    
    if (_cityTextField.text ==nil||[_cityTextField.text isKindOfClass:[NSNull class]])
    {
        _cityLabel.text = @"";
    }else{
        _cityLabel.text = self.areaNameStr;
    }
    if (_detailedAddressFiedld.text ==nil||[_detailedAddressFiedld.text isKindOfClass:[NSNull class]])
    {
        _detailedAddressFiedld.text = @"";
    }
    else{
        if (_nameTextFiedld.text.length == 0)
        {
            [self showNoticeView:@"请输入联系人"];
            return;
        }
        if(_telePhoneFiedld.text.length == 0){
            [self showNoticeView:@"请输入联系电话"];
            return;
        }
        
        if ([_telePhoneFiedld.text hasPrefix:@"1"]) {
            if(![NSString isMobile:_telePhoneFiedld.text]){
                [self showNoticeView:CheckMsgPhoneError];
                _telePhoneFiedld.text = @"";
                return;
            }
        }
        
        if (_cityLabel.text.length == 0)
        {
            [self showNoticeView:@"请选择所在地区"];
            return;
        }
        if (_detailedAddressFiedld.text.length == 0)
        {
            [self showNoticeView:@"请输入详细地址"];
            return;
        }
    
        NSString *uuid = DeviceId_UUID_Value;
        if (IsNilOrNull(uuid)){
            uuid = @"";
        }

    NSString *requestUrl  = [NSString stringWithFormat:@"%@%@",WebServiceAPI,addAddress_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"gettername":_nameTextFiedld.text,@"mobile":_telePhoneFiedld.text,@"address":_cityLable.text,@"homeaddress":_detailedAddressFiedld.text,DeviceId:uuid};
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        NSString *defaultIdString = [NSString stringWithFormat:@"%@",dict[@"id"]];
         _placeBlock(_addressStr,defaultIdString);
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];

    }

    
}
-(void)setPlaceBlock:(TransBlock)placeBlock{
    _placeBlock = placeBlock;
}
#pragma mark-点击选择省市区三级按钮
-(void)editAddressMsgClick:(UIButton *)button{
    if (button.tag == 102) {
        SelectedProviceViewController *selecteProvice = [[SelectedProviceViewController alloc] init];
        selecteProvice.typeString = @"1";
        [self.navigationController pushViewController:selecteProvice animated:YES];
        
    }
}

@end
