//
//  RCDEditGroupNameViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/3/28.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDEditGroupNameViewController.h"
#import "RCDCommonDefine.h"
#import "RCDUIBarButtonItem.h"
#import "CKGroupModel.h"

@interface RCDEditGroupNameViewController ()

@property(nonatomic, strong) RCDUIBarButtonItem *rightBtn;

@end

@implementation RCDEditGroupNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改群名称";
    [self initSubViews];
}

- (void)initSubViews {
    CGFloat screenWidth = RCDscreenWidth;

    // backgroundView
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10+64+NaviAddHeight, screenWidth, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];

    // groupNameTextField
    self.view.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:244 / 255.0 alpha:1];
    CGFloat groupNameTextFieldWidth = screenWidth - 8 - 8;
    self.groupNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, 10+64+NaviAddHeight, groupNameTextFieldWidth, 44)];
    self.groupNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.groupNameTextField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.groupNameTextField];
    _groupNameTextField.delegate = self;
    self.groupNameTextField.text = self.groupName;
    [self.groupNameTextField becomeFirstResponder];
    //自定义rightBarButtonItem
    self.rightBtn = [[RCDUIBarButtonItem alloc] initWithbuttonTitle:@"保存" titleColor:[UIColor colorWithHexString:@"#62b900"] buttonFrame:CGRectMake(0, 0, 50, 30) target:self action:@selector(clickDone:)];
    [self.rightBtn buttonIsCanClick:YES
                        buttonColor:[UIColor colorWithHexString:@"#62b900"]
                      barButtonItem:self.rightBtn];
    self.navigationItem.rightBarButtonItems = [self.rightBtn setTranslation:self.rightBtn translation:-11];
}

- (void)clickDone:(id)sender {
    NSString *nameStr = [_groupNameTextField.text copy];
    nameStr = [nameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    //群组名称需要大于2位
    if ([nameStr length] == 0) {
        [self showNoticeView:@"群组名称不能为空"];
        return;
    }
    //群组名称需要小于15个字
    if ([nameStr length] > 15) {
        [self showNoticeView:@"群组名称不能超过15个字"];
        return;
    }
    
    [self updateGroupName:nameStr];
}

#pragma mark - 更新群名称
- (void)updateGroupName:(NSString*)nameStr {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Group/updateGroupInfo"];
    NSDictionary *pramaDic = @{@"ckid":ckid, @"groupid":self.groupId, @"groupname":nameStr, @"groupnotice":self.annoucemnet};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *itemDic = json;
        if ([itemDic[@"code"] integerValue] != 200) {
            [self showNoticeView:[NSString stringWithFormat:@"%@", itemDic[@"codeinfo"]]];
            return ;
        }
        if (self.groupNameBlock) {
            self.groupNameBlock(nameStr);
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            RLMResults *result = [CKGroupModel objectsWhere:[NSString stringWithFormat:@"groupid = '%@'", self.groupId]];
            CKGroupModel *groupM = [[CKGroupModel alloc] init];
            groupM = result.firstObject;
            groupM.groupname = nameStr;
            [CKGroupModel createOrUpdateInRealm:realm withValue:groupM];
            [realm commitWriteTransaction];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
    [self.rightBtn buttonIsCanClick:YES buttonColor:[UIColor colorWithHexString:@"#62b900"] barButtonItem:self.rightBtn];
    return YES;
}

@end
