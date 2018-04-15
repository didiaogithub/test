//
//  IdentityCardViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/28.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "IdentityCardViewController.h"
#import "CardView.h"
@interface IdentityCardViewController ()<CardViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate ,UIActionSheetDelegate>
{
    BOOL one;
    BOOL two;
    BOOL threen;
    NSString *_ckidString;
    NSString *_handStr;
    NSString *_rightStr;
    NSString *_backStr;
    NSInteger index;
    UIButton *_saveButton;
    NSString *_handPhotoStr;
    NSString *_rightPhotoStr;
    NSString *_backPhotoStr;
}

@property(nonatomic, strong) UIImagePickerController *imagePicker;
@property(nonatomic,strong)NSMutableArray *handPhotoArr;
@property(nonatomic,strong)NSMutableArray *rightPhotoArr;
@property(nonatomic,strong)NSMutableArray *backPhotoArr;
@property(nonatomic,strong)CardView *cardView;
@end

@implementation IdentityCardViewController
-(NSMutableArray *)handPhotoArr{
    if (_handPhotoArr == nil) {
        _handPhotoArr = [[NSMutableArray alloc] init];
    }
    return _handPhotoArr;
}
-(NSMutableArray *)rightPhotoArr{
    if (_rightPhotoArr == nil) {
        _rightPhotoArr = [[NSMutableArray alloc] init];
    }
    return _rightPhotoArr;
}
-(NSMutableArray *)backPhotoArr{
    if (_backPhotoArr == nil) {
        _backPhotoArr = [[NSMutableArray alloc] init];
    }
    return _backPhotoArr;
}

-(CardView *)cardView{
    if (_cardView == nil) {
        if (@available(iOS 11.0, *)) {
            _cardView = [[CardView alloc] initWithFrame:CGRectMake(0, 64+AdaptedHeight(10)+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-AdaptedHeight(70)-NaviAddHeight-BOTTOM_BAR_HEIGHT)];
        }else{
            _cardView = [[CardView alloc] initWithFrame:CGRectMake(0, AdaptedHeight(10), SCREEN_WIDTH, SCREEN_HEIGHT-AdaptedHeight(70))];
        }
        _cardView.delegate = self;
    }
    return _cardView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"证件照";
    [self createViews];
    if (self.handUrlStr){
        NSString *handPicUrl = nil;
        if([self.handUrlStr hasPrefix:@"http"] || [self.handUrlStr hasPrefix:@"https"]){
            handPicUrl = self.handUrlStr;
        }else{
            handPicUrl = [self.domainName stringByAppendingString:self.handUrlStr];
        }
        [self.cardView.handCardButton sd_setImageWithURL:[NSURL URLWithString:handPicUrl] forState:UIControlStateNormal];
    }
    
    if (self.rightUrlStr){
        NSString *rightPicUrl = nil;
        if([self.rightUrlStr hasPrefix:@"http"] || [self.rightUrlStr hasPrefix:@"https"]){
            rightPicUrl = self.rightUrlStr;
        }else{
            rightPicUrl = [self.domainName stringByAppendingString:self.rightUrlStr];
        }
        [self.cardView.rightCardButton sd_setImageWithURL:[NSURL URLWithString:rightPicUrl] forState:UIControlStateNormal];
    }
    if (self.bankUrlStr){
        NSString *backPicUrl = nil;
        if([self.bankUrlStr hasPrefix:@"http"] || [self.bankUrlStr hasPrefix:@"https"]){
            backPicUrl = self.bankUrlStr;
        }else{
            backPicUrl = [self.domainName stringByAppendingString:self.bankUrlStr];
        }
        [self.cardView.backCardButton sd_setImageWithURL:[NSURL URLWithString:backPicUrl] forState:UIControlStateNormal];
    }
}
-(void)createViews{
    [self.view addSubview:self.cardView];
    
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [self.view addSubview:bankImageView];
    [bankImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(AdaptedWidth(35));
        make.right.mas_offset(-AdaptedWidth(35));
        make.bottom.equalTo(self.view.mas_bottom).offset(-10-BOTTOM_BAR_HEIGHT);
        make.height.mas_offset(40);
    }];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_saveButton];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    _saveButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bankImageView);
    }];
    [_saveButton addTarget:self action:@selector(saveCardImage) forControlEvents:UIControlEventTouchUpInside];
  
}
#pragma mark-cardview代理方法
-(void)addCardPhotoWithButtonTag:(NSInteger)buttonTag{
    if (buttonTag == 120) {
        one = YES;
    }else if (buttonTag == 121){
        two = YES;
    }else{
        threen = YES;
    }
    [self addCardPhoto];

}
-(void)addCardPhoto{
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
#pragma mark --- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * oldImage = nil;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        oldImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //将图片保存到相册的方法的参数说明：image:需要保存的图片，self：代理对象，@selector :完成后执行的方法
    }else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        oldImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    UIImageWriteToSavedPhotosAlbum(oldImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}
/**拍照上传时，先保存图片到图库，再上传*/
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //旋转图片
    UIImage *imageScale = [UIImage fixOrientation:image];
    if (one == YES) {
        
        self.cardView.handCardButton.hidden = NO;
        one = NO;
        [self.cardView.handCardButton setImage:imageScale forState:UIControlStateNormal];
        //将照片存到数组
        [self.handPhotoArr addObject:imageScale];
         [self updatePhotoDataWithImage:imageScale andTypeStr:@"0" andPhotoArr:self.handPhotoArr];
        _handStr = @"yes";
        index = 0;
    }else if (two == YES){  //身份证正面
        two = NO;
        
        [self.cardView.rightCardButton setImage:imageScale forState:UIControlStateNormal];
        [self.rightPhotoArr addObject:imageScale];
        [self updatePhotoDataWithImage:imageScale andTypeStr:@"1" andPhotoArr:self.rightPhotoArr];
        _rightStr = @"yes";
        index = 1;
        

    }else if (threen == YES){  //身份证反面

        threen = NO;
        [self.cardView.backCardButton setImage:imageScale forState:UIControlStateNormal];
        [self.backPhotoArr addObject:imageScale];
        [self updatePhotoDataWithImage:imageScale andTypeStr:@"2" andPhotoArr:self.backPhotoArr];
       _backStr = @"yes";
        index = 2;
    }
}
-(void)setCerBlock:(CerUrlBlock)cerBlock{
    _cerBlock = cerBlock;
}
#pragma mark-单个上传身份证
-(void)updatePhotoDataWithImage:(UIImage *)photoImage andTypeStr:(NSString *)typestr andPhotoArr:(NSMutableArray *)photoArr{
    NSString *ckidStr = KCKidstring;
    if (IsNilOrNull(ckidStr)){
        ckidStr = @"";
    }
    NSString *dateStr = [NSDate dateNow];
    NSString *nameStr = [ckidStr stringByAppendingString:[NSString stringWithFormat:@"_%@",dateStr]];
    NSDictionary *pramaDic = @{@"name":nameStr,@"ckid":ckidStr,@"file":photoImage};
    NSString *photoImageUrl = [NSString stringWithFormat:@"%@%@",UploadPicAndPhoto_Url,uploadPhoto_Url];
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    self.viewDataLoading.progressLable.text = @"上传中";
    //保存头像
    [HttpTool uploadWithUrl:photoImageUrl andImages:photoArr andPramaDic:pramaDic completion:^(NSString *url, NSError *error) {
        NSLog(@"正在上传");
        
    } success:^(id responseObject) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        NSString *pathStr = [NSString stringWithFormat:@"%@",dict[@"path"]];
        if (IsNilOrNull(pathStr)) {
            pathStr = @"";
        }
        if([typestr isEqualToString:@"0"]){
            _handPhotoStr = pathStr;
        }else if ([typestr isEqualToString:@"1"]){
            _rightPhotoStr = pathStr;
        }else{
            _backPhotoStr = pathStr;
        }
        
    } fail:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
#pragma mark-/**保存按钮的代理方法*/
-(void)saveCardImage{
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    if (IsNilOrNull(self.handUrlStr)) {
        self.handUrlStr = @"";
    }
    if (IsNilOrNull(self.rightUrlStr)) {
        self.rightUrlStr = @"";
    }
    if (IsNilOrNull(self.bankUrlStr)) {
        self.bankUrlStr = @"";
    }
    
    //如果三张照片都存在
    if ((self.handUrlStr && self.handUrlStr.length > 0) && (self.rightUrlStr && self.rightUrlStr.length > 0) && (self.bankUrlStr && self.bankUrlStr.length > 0)) {
        if ((![_handStr isEqualToString:@"yes"]) && (![_rightStr isEqualToString:@"yes"]) && (![_backStr isEqualToString:@"yes"])){
            [self showNoticeView:@"照片信息未更改，无法保存"];
            return;
        }
    }else{
        //如果第一次上传
            if (IsNilOrNull(_handPhotoStr)){
                [self showNoticeView:@"请添加手持身份证"];
                return;
            }
            if (IsNilOrNull(_rightPhotoStr)){
                [self showNoticeView:@"请添加身份证正面照"];
                return;
            }
            if (IsNilOrNull(_backPhotoStr)){
                [self showNoticeView:@"请添加身份证反面照"];
                return;
            }
     
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    if(IsNilOrNull(_handPhotoStr)){
        _handPhotoStr = self.handUrlStr;
    }
    if(IsNilOrNull(_rightPhotoStr)){
        _rightPhotoStr = self.rightUrlStr;
    }
    if(IsNilOrNull(_backPhotoStr)){
        _backPhotoStr = self.bankUrlStr;
    }
    
    NSString *saveIDInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,saveIDPhoto_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"handImgFile":_handPhotoStr,@"frontImgFile":_rightPhotoStr,@"backImgFile":_backPhotoStr,DeviceId:uuid};
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:saveIDInfoUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        //身份证上传成功后发出通知  改成已上传
        [CKCNotificationCenter postNotificationName:@"identitysuccess" object:@"1"];
        [self showNoticeView:@"身份证上传成功"];
        if(_cerBlock){
            _cerBlock(_handPhotoStr,_rightPhotoStr,_backPhotoStr);
        }
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
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
