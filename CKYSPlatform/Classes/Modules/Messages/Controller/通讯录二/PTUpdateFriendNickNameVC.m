//
//  PTUpdateFriendNickNameVC.m
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/9.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "PTUpdateFriendNickNameVC.h"
#import "RCDUIBarButtonItem.h"
#import "CKGroupModel.h"

#define MAX_STARWORDS_LENGTH 16

@interface PTUpdateFriendNickNameVC ()<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *remarks;

@property(nonatomic, strong) NSString *displayName;

@end

@implementation PTUpdateFriendNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置备注";
    
    [self setNavigationButtons];
    
    [self initComponent];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f0f0f6"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.remarks];
}

- (void)initComponent {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.view addSubview:titleLabel];
    titleLabel.text = @"备注名";
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.right.mas_offset(-10);
        make.left.mas_offset(10);
        make.top.mas_offset(64+NaviAddHeight);
    }];
    
    UIView *inputView = [[UIView alloc] init];
    inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.right.mas_offset(0);
        make.top.equalTo(titleLabel.mas_bottom);
    }];
    
    self.remarks = [[UITextField alloc] init];
    self.remarks.delegate = self;
    self.remarks.font = [UIFont systemFontOfSize:16.f];
    self.remarks.textColor = [UIColor colorWithHexString:@"000000"];
    self.remarks.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.remarks.text = self.nickName;
    [inputView addSubview:self.remarks];
    
    [self.remarks mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.top.equalTo(inputView.mas_top);
    }];
}

- (void)setNavigationButtons {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(updateRemarkName)];
    rightButton.tintColor = [UIColor colorWithHexString:@"#333333"];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)updateRemarkName {

    [self.remarks resignFirstResponder];
    NSString *remarksStr = self.remarks.text;
    
    if ([remarksStr isEqualToString:self.nickName]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (IsNilOrNull(remarksStr)) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //进行网络请求更新名字
            [self modifyUserRemarkName];
        }
    }
}

- (void)modifyUserRemarkName {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Group/updateUserRemark"];
    NSDictionary *pramaDic = @{@"ckid":ckid, DeviceId:uuid, @"meid":self.meid, @"remark":self.remarks.text};
   
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *itemDic = json;
        if ([itemDic[@"code"] integerValue] != 200) {
            return ;
        }
        
        [CKCNotificationCenter postNotificationName:@"upateRemarkNameNoti" object:nil];
        
        if (self.remarkNameBlock) {
            self.remarkNameBlock(self.remarks.text);
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

//限制备注输入长度不能大于16
- (void)textFieldEditChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) // 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > MAX_STARWORDS_LENGTH) {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else {
        if (toBeString.length > MAX_STARWORDS_LENGTH) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1) {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            } else {
                NSRange rangeRange =
                [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
