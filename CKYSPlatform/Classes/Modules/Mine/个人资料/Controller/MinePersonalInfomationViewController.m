//
//  MinePersonalInfomationViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/4/3.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "MinePersonalInfomationViewController.h"
#import "LeftTextRightTextFieldView.h"
#import "LeftRightButtonView.h"
#import "AllInfoTableViewCell.h"
#import "SEXAlterVeiw.h"
#import "IdentityCardViewController.h"
#import "AddAddressViewController.h"
#import "UserModel.h"
#import "AddressModel.h"
#import "LeftTextRightSwitchView.h"
#import "ChangePasswordViewController.h"
#import <RongIMKit/RongIMKit.h> //融云
#import "CKInputWeChatAccountAlertView.h"

@interface MinePersonalInfomationViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate ,UIActionSheetDelegate,UIScrollViewDelegate,SEXAlterVeiwDelegate>
{
    UIView * personalView;
    NSString *_ckidString;
    NSString *_statusString;
    UIScrollView *_bankScrrollview;
    UIButton *_headImageButton;
    NSString *_getAddressIdStr;
    NSString *_passStr;
    NSString *_defaultIdstring;
    
    
    LeftTextRightTextFieldView *_nickNameView;
    LeftTextRightTextFieldView *_shopNameView;
    LeftTextRightTextFieldView *_phoneView;
    
    LeftTextRightTextFieldView *_realNameView;
    LeftTextRightTextFieldView *_cerNumberView;
    LeftTextRightTextFieldView *_weixinView;
    LeftTextRightTextFieldView *_fixNumberView;
    
    LeftRightButtonView *_cerPhotoView;
    LeftRightButtonView *_sexView;
    
    LeftTextRightSwitchView *_cerSwithView;
    LeftTextRightSwitchView *_weixinSwithView;
    LeftTextRightSwitchView *_phoneSwithView;
    //是否显示证书
    NSString *_isShowCertificate;
    NSString *_isShowWeiXinNumber;
    NSString *_isShowTelphone;
    NSString *_handUrlStr;
    NSString *_rightUrlStr;
    NSString *_backUrlStr;
    
    NSString *_sexString;
    SEXAlterVeiw *sexAlertView;
    NSString *_cerDomainName; //身份证前面的域名由后台决定
    UIButton *personalButton;
    UIImageView *rightImageView;
    
    BOOL _isOpen[10];
}

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) NSMutableArray *headImageArr;

@end

@implementation MinePersonalInfomationViewController

-(NSMutableArray *)headImageArr{
    if (_headImageArr == nil) {
        _headImageArr = [NSMutableArray array];
    }
    return _headImageArr;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店铺信息";
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    _statusString = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KStatus]];
    if (IsNilOrNull(_statusString)) {
        _statusString = @"";
    }
    [CKCNotificationCenter addObserver:self selector:@selector(identitysuccessNotification:) name:@"identitysuccess" object:nil];
    [self createViews];
    [self createBottomViews];
    [self getPersonalData];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RootNavigationBack"] style:UIBarButtonItemStylePlain target:self action:@selector(exitPersonalInfo)];
    left.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.leftBarButtonItem = left;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10;
        self.navigationItem.leftBarButtonItems = @[spaceItem, left];
    }
}

-(void)exitPersonalInfo {
    
    NSArray *vcArray = self.navigationController.viewControllers;
    if (vcArray.count > 1) {
        if ([vcArray objectAtIndex:vcArray.count-1] == self) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

/**身份证信息更新  如果为1  则视为已上传*/
-(void)identitysuccessNotification:(NSNotification *)notice{
    NSString *string = [NSString stringWithFormat:@"%@",notice.object];
    if ([string isEqualToString:@"1"]) {
        _cerPhotoView.rightLable.text = @"已上传";
        _cerPhotoView.rightLable.textColor = TitleColor;
    }else{
        _cerPhotoView.rightLable.text = @"未上传";
        _cerPhotoView.rightLable.textColor = SubTitleColor;
    }
}

#pragma mark-/**获取个人资料信息*/
-(void)getPersonalData{
    NSString *getPersonalInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getPersonalInfo_Url];
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"ckid":_ckidString,DeviceId:uuid};
    [[UIApplication sharedApplication].keyWindow addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:getPersonalInfoUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        self.userModel = [[UserModel alloc] init];
        [self.userModel setValuesForKeysWithDictionary:dict];
        
        NSString *addressIdstring = [NSString stringWithFormat:@"%@",dict[@"addressid"]];
        if (IsNilOrNull(addressIdstring)) {
            _getAddressIdStr = @"";
        }else{
            _getAddressIdStr = addressIdstring;
        }
        [self refreshViewsWithModel:self.userModel];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
#pragma mark-给控件赋值
-(void)refreshViewsWithModel:(UserModel *)userModel{
    
    _cerDomainName = [NSString stringWithFormat:@"%@",userModel.photodomain];
    if (IsNilOrNull(_cerDomainName)){
        _cerDomainName = @"";
    }
    NSString *headPath = [NSString stringWithFormat:@"%@",userModel.headfile];
    
    NSString *picUrl = [NSString loadImagePathWithString:headPath];
//    [_headImageButton sd_setImageWithURL:[NSURL URLWithString:picUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"name"] options:SDWebImageRefreshCached];
    [_headImageButton sd_setImageWithURL:[NSURL URLWithString:picUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"name"]];


    //最上面的赋值
    NSString *smallname = [NSString stringWithFormat:@"%@",userModel.smallname];
    if (IsNilOrNull(smallname)) {
        smallname = @"";
    }
     _nickNameView.rightTextField.text = smallname;

    NSString *shopNmae = [NSString stringWithFormat:@"%@",userModel.shopname];
    if(IsNilOrNull(shopNmae)){
       shopNmae = @"";
    }
     _shopNameView.rightTextField.text = shopNmae;

       //电话
    NSString *mobileLocal = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:Kmobile]];
    if (IsNilOrNull(mobileLocal)) {
        mobileLocal = @"";
    }
    NSString *mobile = [NSString stringWithFormat:@"%@",userModel.mobile];
    if (!IsNilOrNull(mobile)) {
        _phoneView.rightTextField.text = mobile;
    }else{
         _phoneView.rightTextField.text = mobileLocal;
    }
    
    //第二段赋值
    
    //真实姓名
    NSString *realname = [NSString stringWithFormat:@"%@",userModel.realname];
    if (!IsNilOrNull(realname)) {
        _realNameView.rightTextField.text = realname;
    }else{
        _realNameView.rightTextField.text = @"";
    }
    //身份证号
    NSString *IDNo = [NSString stringWithFormat:@"%@",userModel.IDNo];
    if (!IsNilOrNull(IDNo)) {
        _cerNumberView.rightTextField.text = IDNo;
    }else{
        _cerNumberView.rightTextField.text = @"";
    }
    //证件照
    NSString *IDimgHand = [NSString stringWithFormat:@"%@",userModel.IDimgHand];
    NSString *IDimgBack = [NSString stringWithFormat:@"%@",userModel.IDimgBack];
    NSString *IDimgFront = [NSString stringWithFormat:@"%@",userModel.IDimgFront];
    if((!IsNilOrNull(IDimgHand)) && (!IsNilOrNull(IDimgBack)) && (!IsNilOrNull(IDimgFront)) ){
        _cerPhotoView.rightLable.text =  @"已上传";
        _cerPhotoView.rightLable.textColor = TitleColor;
    }else{
        _cerPhotoView.rightLable.text =  @"未上传";
        _cerPhotoView.rightLable.textColor = SubTitleColor;
    }
    //微信号
    NSString *WXAccount = [NSString stringWithFormat:@"%@",userModel.WXAccount];
    if (!IsNilOrNull(WXAccount)) {
        _weixinView.rightTextField.text = WXAccount;
    }else{
        _weixinView.rightTextField.text = @"";
    }
    
    NSString *telephone = [NSString stringWithFormat:@"%@",userModel.telephone];
    //固话
    if (!IsNilOrNull(telephone)) {
        _fixNumberView.rightTextField.text = telephone;
    }else{
        _fixNumberView.rightTextField.text = @"";
    }
    //性别
    NSString *sex = [NSString stringWithFormat:@"%@",userModel.sex];
    if (!IsNilOrNull(sex)) {
        if([sex isEqualToString:@"male"]){
            _sexView.rightLable.text = @"男";
            _sexString = @"male";
        }else if([sex isEqualToString:@"female"]){
            _sexView.rightLable.text = @"女";
            _sexString = @"female";
        }else{
            _sexView.rightLable.text = @"保密";
            _sexString = @"unknow";
        }
        _sexView.rightLable.textColor = TitleColor;
    }
    //第三段赋值
    NSString *showCertificates = [NSString stringWithFormat:@"%@",userModel.showCertificates];
    //显示资质证书
    if ([showCertificates isEqualToString:@"1"]) {
        [_cerSwithView.showSwitch setOn:YES];
        _isShowCertificate = @"1";
    }else{
        _isShowCertificate = @"2";
        [_cerSwithView.showSwitch setOn:NO];
    }
    //是否显示微信号

    NSString *showWX = [NSString stringWithFormat:@"%@",userModel.showWX];
    if ([showWX isEqualToString:@"1"]) {
        _isShowWeiXinNumber = @"1";
        [_weixinSwithView.showSwitch setOn:YES];
    }else{
        _isShowWeiXinNumber = @"2";
        [_weixinSwithView.showSwitch setOn:NO];
    }
    //是否显示手机号码
    NSString *showMobile = [NSString stringWithFormat:@"%@",userModel.showMobile];
    if ([showMobile isEqualToString:@"1"]) {
        _isShowTelphone = @"1";
        [_phoneSwithView.showSwitch setOn:YES];
    }else{
        _isShowTelphone = @"2";
        [_phoneSwithView.showSwitch setOn:NO];
    }

}

-(void)createBottomViews{
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:saveButton];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    saveButton.backgroundColor = CKYS_Color(248, 0, 0);
    saveButton.layer.cornerRadius = 22.0;
    saveButton.layer.masksToBounds = YES;
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.height.mas_offset(44);
        make.bottom.mas_offset(-10);
        
    }];
    //点击保存 判断必填项
    [saveButton addTarget:self action:@selector(clickTosaveInfo) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - 保存店铺信息
-(void)clickTosaveInfo{
    
    //店铺审核通过后不再校验身份证和电话  因为之前老创客身份证都不正确
    if (![_statusString isEqualToString:@"PAY"]) {
        
        if ([_phoneView.rightTextField.text hasPrefix:@"1"]) {
            if(![NSString isMobile:_phoneView.rightTextField.text]){
                [self showNoticeView:CheckMsgPhoneError];
                return;
            }
        }
    
        if(IsNilOrNull(_realNameView.rightTextField.text)){
            [self showNoticeView:CheckMsgNameNull];
            return;
        }
        if (IsNilOrNull(_cerNumberView.rightTextField.text)) {
            [self showNoticeView:@"请您输入证件号"];
            return;
        }
        //证件照是否上传
        NSString *cerPhotoStr = _cerPhotoView.rightLable.text;
        if (IsNilOrNull(cerPhotoStr) || [cerPhotoStr isEqualToString:@"未上传"]){
            [self showNoticeView:@"请添加证件照"];
            return;
        }
    }
    
    NSString *savePersonalInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,savePersonalInfo_Url];
    
    if(IsNilOrNull(_isShowCertificate)){
        _isShowCertificate = @"1";
    }
    if(IsNilOrNull(_isShowWeiXinNumber)){
        _isShowWeiXinNumber = @"1";
    }
    //如果要显示微信号
    if ([_isShowWeiXinNumber isEqualToString:@"1"]) {
        if (IsNilOrNull(_weixinView.rightTextField.text)) {
            
            CKInputWeChatAccountAlertView *popView = [[CKInputWeChatAccountAlertView alloc]initWithTitle:@"完善微信号" textFieldInitialValue:@"" textFieldTextMaxLength:20 textFieldText:^(NSString *textFieldText) {
                NSLog(@"string%@", textFieldText);
                _weixinView.rightTextField.text = textFieldText;
            }];
            [popView show];
            return;
        }
    }else{
        if (IsNilOrNull(_weixinView.rightTextField.text)) {
            _weixinView.rightTextField.text = @"";
        }
    }
    if(IsNilOrNull(_isShowTelphone)){
        _isShowTelphone = @"1";
    }
    if (IsNilOrNull(_sexString)) {
        _sexString = @"";
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSDictionary *appDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [appDic objectForKey:@"CFBundleShortVersionString"];
    NSString *devicetype = [NSString stringWithFormat:@"ios%@", version];
    
    NSDictionary *paramaDic = @{@"shopname":_shopNameView.rightTextField.text,@"smallname":_nickNameView.rightTextField.text,@"showCertificates":_isShowCertificate,@"showWX":_isShowWeiXinNumber,@"showMobile":_isShowTelphone,@"realname":_realNameView.rightTextField.text,@"IDNo":_cerNumberView.rightTextField.text,@"WXAccount":_weixinView.rightTextField.text,@"mobile":_phoneView.rightTextField.text,@"telephone":_fixNumberView.rightTextField.text,@"sex":_sexString,@"ckid":_ckidString,DeviceId:uuid, @"devicetype": devicetype};
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool uploadWithUrl:savePersonalInfoUrl andImages:self.headImageArr andPramaDic:paramaDic completion:^(NSString *url, NSError *error) {
        
        NSLog(@"%@",error.localizedDescription);
    } success:^(id responseObject) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict  = responseObject;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        NSLog(@"上传的图片%@ ",self.headImageArr);
        [self showNoticeView:@"个人信息保存成功"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeProfileSuccessNotification" object:nil];
        
        if (!IsNilOrNull(_shopNameView.rightTextField.text)) {
            [KUserdefaults setObject:_shopNameView.rightTextField.text forKey:KshopName];
        }

        
        [self updateQRCodeImg];
        //点击完保存 调用设置默认地址
//        [self setMyDefaultAddress];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } fail:^(NSError *error){
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        
    }];


}
#pragma mark-创建视图
-(void)createViews {
    
    _bankScrrollview = [[UIScrollView alloc] init];
    [self.view addSubview:_bankScrrollview];
    [_bankScrrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        if (@available(iOS 11.0, *)) {
            make.top.mas_offset(64+NaviAddHeight);
        }else{
            make.top.mas_offset(0);
        }
        make.height.mas_offset(SCREEN_HEIGHT - 64);
    }];
    
    _bankScrrollview.scrollEnabled = YES;
    _bankScrrollview.bounces = NO;
    _bankScrrollview.delegate = self;
    _bankScrrollview.showsHorizontalScrollIndicator = NO;
    _bankScrrollview.showsVerticalScrollIndicator = NO;
    
    //第一块个人信息
    UIView *headView = [[UIView alloc] init];
    [_bankScrrollview addSubview:headView];
    [headView setBackgroundColor:[UIColor whiteColor]];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.right.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH);
        make.height.mas_offset(AdaptedHeight(210));
    }];
    
    float headSize,coredius = 0;
    if (iphone4) {
        headSize = AdaptedWidth(50);
        coredius = AdaptedWidth(50)/2;
    }else{
        headSize = AdaptedWidth(60);
        coredius = AdaptedWidth(60)/2;
    }
    //头像按钮
    _headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:_headImageButton];
    [_headImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(5));
        make.right.mas_offset(-AdaptedWidth(30));
        make.size.mas_offset(CGSizeMake(headSize,headSize));
        
    }];
    
    _headImageButton.layer.cornerRadius = coredius;
    _headImageButton.clipsToBounds = YES;
    [_headImageButton addTarget:self action:@selector(changeHeadImageWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //店铺头像 lable
    UILabel *headLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [headView addSubview:headLable];
    headLable.text = @"店铺头像";
    [headLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_headImageButton);
        make.left.mas_offset(AdaptedWidth(10));
    }];
    
    
    
    //昵称
    _nickNameView = [[LeftTextRightTextFieldView alloc] init];
    [headView addSubview:_nickNameView];
    _nickNameView.rightButton.hidden = YES;
    _nickNameView.leftLable.text = @"昵称";
    _nickNameView.rightTextField.placeholder = @"请输入昵称";
    [_nickNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(AdaptedHeight(70));
        make.height.mas_offset(AdaptedHeight(45));
    }];

    
    //店铺
    _shopNameView = [[LeftTextRightTextFieldView alloc] init];
    [headView addSubview:_shopNameView];
    _shopNameView.rightButton.hidden = YES;
    _shopNameView.leftLable.text = @"店铺名称";
    _shopNameView.rightTextField.placeholder = @"请输入店铺名称";
    [_shopNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_nickNameView);
        make.top.equalTo(_nickNameView.mas_bottom);
    }];

 
    //电话
    _phoneView = [[LeftTextRightTextFieldView alloc] init];
    [headView addSubview:_phoneView];
    _phoneView.rightButton.hidden = YES;
    _phoneView.leftLable.text = @"店铺电话";
    _phoneView.rightTextField.placeholder = @"请输入店铺电话";
    [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_nickNameView);
        make.top.equalTo(_shopNameView.mas_bottom);
    }];

    
    //第二块
    personalView = [[UIView alloc] init];
    [_bankScrrollview addSubview:personalView];
    [personalView setBackgroundColor:[UIColor whiteColor]];
    [personalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(AdaptedHeight(10));
        make.left.right.width.equalTo(headView);
        make.height.mas_offset(AdaptedHeight(370));
    }];
    UILabel *headerLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [personalView addSubview:headerLable];
    headerLable.text  = @"个人信息";
    [headerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(AdaptedWidth(10));
        make.height.mas_offset(AdaptedHeight(45));
        make.width.mas_offset(SCREEN_WIDTH);
    }];
    
    
    personalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [personalView addSubview:personalButton];
    [personalButton setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
    [personalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(45));
        make.right.mas_offset(-AdaptedWidth(30));
    }];

    
    UIButton *headerButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [personalView addSubview:headerButton];
    [headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerLable);
    }];
    [headerButton addTarget:self action:@selector(clickheadButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //真实姓名
    _realNameView = [[LeftTextRightTextFieldView alloc] init];
    [personalView addSubview:_realNameView];
    _realNameView.rightButton.tag = 1000;
    _realNameView.leftLable.attributedText = [NSString attributedStrWthStr:@"*真实姓名"];
    _realNameView.rightTextField.placeholder  = @"未填写";
    [_realNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(45));
        make.height.mas_offset(AdaptedHeight(45));
        make.left.right.mas_offset(0);
    }];
    [_realNameView.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //身份证号
    _cerNumberView = [[LeftTextRightTextFieldView alloc] init];
    [personalView addSubview:_cerNumberView];
    _cerNumberView.rightButton.tag = 1001;
    _cerNumberView.leftLable.attributedText = [NSString attributedStrWthStr:@"*身份证号"];
    _cerNumberView.rightTextField.placeholder  = @"未填写";
    [_cerNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_realNameView.mas_bottom);
        make.height.mas_offset(AdaptedHeight(45));
        make.left.right.mas_offset(0);
    }];
    
     [_cerNumberView.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //证件照
    _cerPhotoView = [[LeftRightButtonView alloc] init];
    [personalView addSubview:_cerPhotoView];
    _cerPhotoView.rightButton.tag = 1002;
    _cerPhotoView.leftLable.attributedText = [NSString attributedStrWthStr:@"*证件照"];
    _cerPhotoView.rightLable.text = @"未填写";
    [_cerPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cerNumberView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(45));
    }];
    [_cerPhotoView.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];

    
    //微信号
    _weixinView = [[LeftTextRightTextFieldView alloc] init];
    [personalView addSubview:_weixinView];
    _weixinView.leftLable.text = @"微信号";
    _weixinView.rightTextField.placeholder  = @"未填写";
    [_weixinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cerPhotoView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(45));
    }];

    
    //固话
    _fixNumberView = [[LeftTextRightTextFieldView alloc] init];
    [personalView addSubview:_fixNumberView];
    _fixNumberView.leftLable.text = @"固话";
    _fixNumberView.rightTextField.placeholder  = @"未填写";
    [_fixNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weixinView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(45));
    }];
    
    
    
    //性别
    _sexView = [[LeftRightButtonView alloc] init];
    [personalView addSubview:_sexView];
    _sexView.rightButton.tag = 1005;
    _sexView.leftLable.text = @"性别";
    _sexView.rightLable.text = @"未填写";
    [_sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fixNumberView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(45));
    }];
    [_sexView.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //第三块
    UIView *setupCerView = [[UIView alloc] init];
    [_bankScrrollview addSubview:setupCerView];
    [setupCerView setBackgroundColor:[UIColor whiteColor]];
    [setupCerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personalView.mas_bottom).offset(AdaptedHeight(10));
        make.left.right.width.equalTo(headView);
        make.height.mas_offset(AdaptedHeight(135));
    }];

    _cerSwithView = [[LeftTextRightSwitchView alloc] init];
    [setupCerView addSubview:_cerSwithView];
    _cerSwithView.showSwitch.tag = 2000;
    _cerSwithView.showLeftLable.text = @"显示资质证书";
    [_cerSwithView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(45));
    }];
    
    _weixinSwithView = [[LeftTextRightSwitchView alloc] init];
    [setupCerView addSubview:_weixinSwithView];
    _weixinSwithView.showSwitch.tag = 2001;
    _weixinSwithView.showLeftLable.text = @"显示微信号";
    [_weixinSwithView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.height.equalTo(_cerSwithView);
        make.top.equalTo(_cerSwithView.mas_bottom);
    }];
    
    _phoneSwithView = [[LeftTextRightSwitchView alloc] init];
    [setupCerView addSubview:_phoneSwithView];
    _phoneSwithView.topLineLable.hidden = YES;
    _phoneSwithView.showSwitch.tag = 2002;
    _phoneSwithView.showLeftLable.text = @"显示手机号";
    [_phoneSwithView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weixinSwithView.mas_bottom);
        make.right.left.height.equalTo(_cerSwithView);
        make.bottom.mas_offset(0);
    }];
    
    [_cerSwithView.showSwitch addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
    [_weixinSwithView.showSwitch addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
    [_phoneSwithView.showSwitch addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
    
    //第四块
    UIView *passWordView = [[UIView alloc] init];
    [_bankScrrollview addSubview:passWordView];
    [passWordView setBackgroundColor:[UIColor whiteColor]];
    [passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(setupCerView.mas_bottom).offset(AdaptedHeight(10));
        make.left.right.width.equalTo(headView);
        make.height.mas_offset(AdaptedHeight(45));
        make.bottom.mas_offset(-20);
    }];

    UILabel *leftLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [passWordView addSubview:leftLable];
    leftLable.text = @"修改密码";
    [leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(AdaptedWidth(10));
    }];
    
    rightImageView = [[UIImageView alloc] init];
    [passWordView addSubview:rightImageView];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightImageView setImage:[UIImage imageNamed:@"rightarrow"]];
    [rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(13));
        make.bottom.mas_offset(-AdaptedHeight(13));
        make.right.mas_offset(-AdaptedWidth(30));
    }];
    
    UIButton *passWordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [passWordView addSubview:passWordButton];
    [passWordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(passWordView);
    }];
    [passWordButton addTarget:self action:@selector(clickPassWordButton) forControlEvents:UIControlEventTouchUpInside];
    
    _bankScrrollview.contentSize = CGSizeMake(SCREEN_WIDTH-6,SCREEN_HEIGHT+700);
    
    void(^stateBlock)(NSString * imageName,BOOL buttonState,BOOL viewState) = ^(NSString * imageName,BOOL buttonState,BOOL viewState){
        if(imageName){
            [personalButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
        _realNameView.rightButton.hidden = buttonState;
        _cerNumberView.rightButton.hidden = buttonState;
    
        _realNameView.hidden = viewState;
        _cerNumberView.hidden = viewState;
        _cerPhotoView.hidden = viewState;
        _weixinView.hidden = viewState;
        _fixNumberView.hidden = viewState;
        _sexView.hidden = viewState;
    };
    if ([_statusString isEqualToString:@"PAY"]) {
           stateBlock(@"rightarrow",NO,YES);

            [personalView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(AdaptedHeight(45));
            }];
    }else{
        stateBlock(@"bottomarrow",YES,NO);
        [personalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(AdaptedHeight(370));
        }];

    }
    _weixinView.rightButton.hidden = YES;
    _fixNumberView.rightButton.hidden = YES;
    
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    }];

}
-(void)clickheadButton:(UIButton *)button{
    [self updatePersonalViewHeightWith:button];
}
-(void)updatePersonalViewHeightWith:(UIButton *)button{
    button.selected = !button.selected;
    
    void(^stateBlock)(NSString * imageName,BOOL viewState) = ^(NSString * imageName,BOOL viewState){
        if(imageName){
            [personalButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
       
        _realNameView.hidden = viewState;
        _cerNumberView.hidden = viewState;
        _cerPhotoView.hidden = viewState;
        _weixinView.hidden = viewState;
        _fixNumberView.hidden = viewState;
        _sexView.hidden = viewState;

    };

    if([_statusString isEqualToString:@"PAY"]){
        if (button.selected == YES){
            [personalView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(AdaptedHeight(370));
            }];
            stateBlock(@"bottomarrow",NO);
        }else{
            [personalView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(AdaptedHeight(45));
            }];
             stateBlock(@"rightarrow",YES);
        }
    }else{
        if (button.selected == YES){
            [personalView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(AdaptedHeight(45));
            }];
            stateBlock(@"rightarrow",YES);
        }else{
            [personalView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(AdaptedHeight(370));
            }];
            stateBlock(@"bottomarrow",NO);
        }
    }

    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark-点击证件照 2或者 性别6
-(void)clickRightButton:(UIButton *)button{
    NSInteger tag = button.tag - 1000;
    if (tag == 0 || tag == 1) {
        _realNameView.rightTextField.enabled = NO;
         _cerNumberView.rightTextField.enabled = NO;
        _realNameView.rightButton.hidden = NO;
        _realNameView.rightButton.hidden = NO;
        if ([_statusString isEqualToString:@"PAY"]) {
            [self showNoticeView:CheckMsgCanNotChange];
            return;
        }
    }else if (tag == 2) { //证件照
//        店铺开通以后 姓名  身份证号码  证件照不可以修改
        if ([_statusString isEqualToString:@"PAY"]) {
            [self showNoticeView:CheckMsgCanNotChange];
            return;
        }
        IdentityCardViewController *cardVc = [[IdentityCardViewController alloc] init];
        
        [cardVc setCerBlock:^(NSString *handUrl, NSString *rightUrl, NSString *backUrl) {
            if(!IsNilOrNull(handUrl)){
             _handUrlStr = handUrl;
            }
            if(!IsNilOrNull(rightUrl)){
              _rightUrlStr = rightUrl;
            }
            if(!IsNilOrNull(backUrl)){
              _backUrlStr = backUrl;
            }
        }];
        //如果请求到 请求的图片没有域名
        NSString *handPicUrl = self.userModel.IDimgHand;
        NSString *rightPicUrl = self.userModel.IDimgFront;
        NSString *backPickUrl = self.userModel.IDimgBack;
        
        //手持身份证
        if (!IsNilOrNull(handPicUrl) && !IsNilOrNull(_handUrlStr)){
             cardVc.handUrlStr = _handUrlStr;
        }else{
            if(IsNilOrNull(handPicUrl)){
                cardVc.handUrlStr = _handUrlStr;
            }else{
                cardVc.handUrlStr = handPicUrl;
            }
        }
        
        //身份证正面
        if (!IsNilOrNull(rightPicUrl) && !IsNilOrNull(_rightUrlStr)){
            cardVc.rightUrlStr = _rightUrlStr;
        }else{
            if(IsNilOrNull(rightPicUrl)){
                cardVc.rightUrlStr = _rightUrlStr;
            }else{
                cardVc.rightUrlStr = rightPicUrl;
            }
        }
        
        //身份证反面
        if (!IsNilOrNull(backPickUrl) && !IsNilOrNull(_backUrlStr)){
            cardVc.bankUrlStr = _backUrlStr;
        }else{
            if(IsNilOrNull(backPickUrl)){
                cardVc.bankUrlStr = _backUrlStr;
            }else{
                cardVc.bankUrlStr = backPickUrl;
            }
        }
        cardVc.domainName = _cerDomainName;
        [self.navigationController pushViewController:cardVc animated:YES];
        
    }else if (tag == 5){
        //选择性别
        [self selecteSex:tag];
        
    }else if (tag == 6){
        
        if ([_statusString isEqualToString:@"PAY"]) {
            [self showNoticeView:CheckMsgCanNotChange];
            return;
        }
        
        if (_realNameView.rightTextField.text == nil || [_realNameView.rightTextField.text isEqualToString:@""]) {
            [self showNoticeView:@"请先填写真实姓名"];
            return;
        }
        if (_phoneView.rightTextField.text == nil || [_phoneView.rightTextField.text isEqualToString:@""]) {
            [self showNoticeView:CheckMsgPhoneNull];
            return;
        }
    }
}
#pragma mark - 点击开关
-(void)clickSwitch:(UISwitch *)cerswitch{
    NSInteger tag = cerswitch.tag - 2000;
    //    是否显示资质证书（2：不显示 1：显示）
    if (tag == 0) {
        if (cerswitch.on){
            _isShowCertificate = @"1";
        }else{
            _isShowCertificate = @"2";
        }
        
    }else if (tag == 1){
        if (cerswitch.on) {
            _isShowWeiXinNumber = @"1";
        }else{
            _isShowWeiXinNumber = @"2";
        }
    }else{
        if (cerswitch.on) {
            _isShowTelphone = @"1";
        }else{
            _isShowTelphone = @"2";
        }
    }
    
}

#pragma mark-选择性别
-(void)selecteSex:(NSInteger)tag{
    sexAlertView = [[SEXAlterVeiw alloc]init];
    sexAlertView.delegate = self;
    [sexAlertView show];
}
#pragma mark-选择性别代理方法
-(void)selectedSexClickedWithTag:(UIButton *)button{
    button.selected = !button.selected;
    if(button.tag == 10000){ //选择男
        button.selected = YES;
        _sexView.rightLable.text = @"男";
        _sexString = @"male";
        
    }else if (button.tag == 10001){
        button.selected = YES;
         _sexView.rightLable.text = @"女";
        _sexString = @"female";
        
    }else if (button.tag == 10002){
        button.selected = YES;
         _sexView.rightLable.text = @"保密";
        _sexString = @"unknow";
        
    }
    _sexView.rightLable.textColor = TitleColor;
}

/**设置默认地址*/
-(void)setMyDefaultAddress{
    if(IsNilOrNull(_defaultIdstring)){
        _defaultIdstring = @"";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *setDefaultUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,setDefaultAddress_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"id":_defaultIdstring,DeviceId:uuid};
    [HttpTool postWithUrl:setDefaultUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            NSLog(@"%@",dict[@"codeinfo"]);
            return ;
        }
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}
#pragma mark-点击上传头像方法
-(void)changeHeadImageWithButton:(UIButton *)button{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //处理点击拍照
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Test on real device, camera is not available in simulator" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePicker animated:YES completion:nil];
        
        
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //处理点击从相册选取
        // 跳转到相机或相册页面
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        _imagePicker.editing = YES;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if (@available(iOS 11, *)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
    
}

#pragma mark --- 选择照片代理方法UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * oldImage = nil;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        oldImage = [info objectForKey:UIImagePickerControllerEditedImage];
        //将图片保存到相册的方法的参数说明：image:需要保存的图片，self：代理对象，@selector :完成后执行的方法
    }else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        oldImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    
    [self uploadImage:oldImage];

    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**拍照上传时，先保存图片到图库，再上传*/
-(void)uploadImage:(UIImage*)image {
    //旋转图片
    UIImage *imageSales = [UIImage fixOrientation:image];
    //显示头像
    [_headImageButton setImage:imageSales forState:UIControlStateNormal];
    [self.headImageArr addObject:imageSales];
    NSString *headDicUrl = [NSString stringWithFormat:@"%@%@",UploadPicAndPhoto_Url,uploadPic_Url];
//    name=ckid_时间戳
    NSString *ckidStr = KCKidstring;
    if (IsNilOrNull(ckidStr)){
        ckidStr = @"";
    }
    NSString *dateStr = [NSDate dateNow];
    NSString *nameStr = [ckidStr stringByAppendingString:[NSString stringWithFormat:@"_%@",dateStr]];
    NSDictionary *pramaDic = @{@"name":nameStr,@"ckid":ckidStr,@"file":imageSales};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    self.viewDataLoading.progressLable.text = @"上传中";
    
    //保存头像
    [HttpTool uploadWithUrl:headDicUrl andImages:self.headImageArr andPramaDic:pramaDic completion:^(NSString *url, NSError *error) {
        NSLog(@"正在上传");
        
    } success:^(id responseObject) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeHeadIconSuccessNotification" object:nil];
        [self updateQRCodeImg];
        
    } fail:^(NSError *error){
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}


//更改图像成功或者更改个人信息成功调用更新二维码接口
-(void)updateQRCodeImg {

    NSString *updateUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/CkInfo/updateQRCodeImg"];
    NSString *tgidString = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    if (IsNilOrNull(tgidString)) {
        tgidString = @"0";
    }
    NSString *ckidString = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    
    NSDictionary *pramaDic = @{@"ckid": ckidString, @"tgid": tgidString};
    [HttpTool getWithUrl:updateUrl params:pramaDic success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark-修改密码
-(void)clickPassWordButton{
    ChangePasswordViewController *changePassword = [[ChangePasswordViewController alloc] init];
    [self.navigationController pushViewController:changePassword animated:YES];

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewDataLoading stopAnimation];
}

@end
