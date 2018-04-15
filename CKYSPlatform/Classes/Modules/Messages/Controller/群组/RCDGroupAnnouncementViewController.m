//
//  RCDGroupAnnouncementViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/7/14.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDGroupAnnouncementViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "CKGroupModel.h"

@interface RCDGroupAnnouncementViewController ()

@property(nonatomic, strong) UIButton *rightBtn;

@property(nonatomic, strong) UILabel *rightLabel;

@property(nonatomic) CGFloat heigh;

@end

@implementation RCDGroupAnnouncementViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 34)];
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(22.5, 0, 50, 34)];
    self.rightLabel.text = @"保存";
    [self.rightBtn addSubview:self.rightLabel];
    [self.rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    [self.rightLabel setTextColor:[UIColor colorWithHexString:@"#62b900"]];

    self.navigationItem.rightBarButtonItem = rightButton;

    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.title = @"群公告"; 
    
    self.AnnouncementContent = [[UITextViewAndPlaceholder alloc] initWithFrame:CGRectZero];
    self.AnnouncementContent.delegate = self;
    self.AnnouncementContent.font = [UIFont systemFontOfSize:16.f];
    self.AnnouncementContent.textColor = [UIColor colorWithHexString:@"000000"];
    
    if (![self.annoucemnet isEqualToString:@"未设置"]) {
        self.AnnouncementContent.text = self.annoucemnet;
    }else{
        self.AnnouncementContent.myPlaceholder = @"请编辑群公告";
    }
    
    if (@available (iOS 11.0, *)) {
        self.AnnouncementContent.frame =
        CGRectMake(4.5, 8 + (64+NaviAddHeight), self.view.frame.size.width - 5,
                   self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 90);
    }else{
        self.AnnouncementContent.frame =
        CGRectMake(4.5, 8, self.view.frame.size.width - 5,
                   self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 90);
    }
    
    self.heigh = self.AnnouncementContent.frame.size.height;
    [self.view addSubview:self.AnnouncementContent];
    
    [self.AnnouncementContent becomeFirstResponder];
}

- (void)clickRightBtn:(id)sender {

    BOOL isEmpty = [self isEmpty:self.AnnouncementContent.text];
    if (isEmpty == YES) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if ([self.annoucemnet isEqualToString:self.AnnouncementContent.text]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else{
        [self updateGroupAnnounce];
    }
}

#pragma mark - 更改群公告
- (void)updateGroupAnnounce {
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Ckapp3/Group/updateGroupInfo"];
    NSDictionary *pramaDic = @{@"ckid":ckid, @"groupid":self.groupId, @"groupname":self.groupName, @"groupnotice":self.AnnouncementContent.text};
    
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *itemDic = json;
        if ([itemDic[@"code"] integerValue] != 200) {
            [self showNoticeView:[NSString stringWithFormat:@"%@", itemDic[@"codeinfo"]]];
            return ;
        }
        if (self.groupAnnounceBlock) {
            self.groupAnnounceBlock(self.AnnouncementContent.text);
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            RLMResults *result = [CKGroupModel objectsWhere:[NSString stringWithFormat:@"groupid = '%@'", self.groupId]];
            CKGroupModel *groupM = [[CKGroupModel alloc] init];
            groupM = result.firstObject;
            groupM.groupnotice = self.AnnouncementContent.text;
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

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number == 0) {
        
    }
    if (number > 0) {
        

        CGRect frame = self.AnnouncementContent.frame;

        CGSize maxSize = CGSizeMake(frame.size.width, MAXFLOAT);

        CGFloat height = [self.AnnouncementContent.text
                             boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.AnnouncementContent.font} context:nil]
                             .size.height;
        frame.size.height = height;
    }
    if (number > 500) {
        textView.text = [textView.text substringToIndex:500];
    }
}



//判断内容是否全部为空格  yes 全部为空格  no 不是
- (BOOL)isEmpty:(NSString *)str {

    if (!str) {
        return YES;
    } else {
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];

        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];

        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

@end
