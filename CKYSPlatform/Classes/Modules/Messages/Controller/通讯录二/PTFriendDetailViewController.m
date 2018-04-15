//
//  PTFriendDetailViewController.m
//  ProjectTemplate
//
//  Created by ForgetFairy on 2018/3/9.
//  Copyright © 2018年 ForgetFairy. All rights reserved.
//

#import "PTFriendDetailViewController.h"
#import "PTUpdateFriendNickNameVC.h"
//#import <RongCallKit/RongCallKit.h>
//#import <RongIMKit/RongIMKit.h>
//#import <RongIMLib/RCUserInfo.h>
#import "ChatMessageViewController.h"
#import "CKGroupModel.h"


@interface PTFriendDetailViewController () <UIActionSheetDelegate>

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) UIView *infoView;
@property(nonatomic, strong) UIImageView *headImgView;
@property(nonatomic, strong) UILabel *remarkNameLabel;
@property(nonatomic, strong) UILabel *phoneLabel;
//@property(nonatomic, strong) UILabel *nickNameLabel;
@property(nonatomic, strong) UIButton *conversationBtn;
@property(nonatomic, strong) UIView *remarksView;

@end

@implementation PTFriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"详细资料";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f0f0f6"];
    [self initComponents];
}

- (void)initComponents {
    self.infoView = [[UIView alloc] init];
    self.infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(85);
        make.top.mas_offset(64+NaviAddHeight);
    }];
    
    self.headImgView = [[UIImageView alloc] init];
    self.headImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 55*0.5;
    [self refreshHeadImage];
    [self.infoView addSubview:self.headImgView];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(55);
        make.top.left.mas_offset(10);
    }];
    
    self.remarkNameLabel = [[UILabel alloc] init];
    if (!IsNilOrNull(self.contactorModel.remark)) {
        self.remarkNameLabel.text = self.contactorModel.remark;
    }else{
        if (IsNilOrNull(self.contactorModel.name)) {
            self.remarkNameLabel.text = @"";
        }else{
            self.remarkNameLabel.text = self.contactorModel.name;
        }
    }
    
    [self.infoView addSubview:self.remarkNameLabel];
    [self.remarkNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.height.mas_equalTo(25);
        make.right.mas_offset(-10);
        make.top.equalTo(self.headImgView.mas_top).offset(0);
    }];
    
    self.phoneLabel = [[UILabel alloc] init];
    if (!IsNilOrNull(self.contactorModel.mobile)) {
        self.phoneLabel.text = [NSString stringWithFormat:@"电话:%@", self.contactorModel.mobile];
    }else{
        self.phoneLabel.text = @"电话:";
    }
    
    [self.infoView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.height.mas_equalTo(25);
        make.right.mas_offset(-10);
        make.bottom.equalTo(self.headImgView.mas_bottom).offset(0);
    }];
    
    //修改备注
    self.remarksView = [[UIView alloc] init];
    self.remarksView.userInteractionEnabled = YES;
    self.remarksView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.remarksView];
    [self.remarksView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.right.mas_offset(0);
        make.top.equalTo(self.infoView.mas_bottom).offset(20);
    }];
    
    UITapGestureRecognizer *clickRemarksView =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoRemarksView:)];
    [self.remarksView addGestureRecognizer:clickRemarksView];
    
    UILabel *remarkLabel = [[UILabel alloc] init];
    remarkLabel.font = [UIFont systemFontOfSize:16.f];
    remarkLabel.textColor = [UIColor colorWithHexString:@"000000"];
    [self.remarksView addSubview:remarkLabel];
    remarkLabel.text = @"设置备注";
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(10);
        make.right.mas_offset(-60);
    }];
    
    UIImageView *rightArrow = [[UIImageView alloc] init];
    rightArrow.translatesAutoresizingMaskIntoConstraints = NO;
    rightArrow.image = [UIImage imageNamed:@"rightarrow"];
    [self.remarksView addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.remarksView.mas_centerY);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(20);
        make.right.mas_offset(-10);
    }];
    
    
    self.conversationBtn = [[UIButton alloc] init];
    self.conversationBtn.backgroundColor = [UIColor colorWithHexString:@"0099ff"];
    [self.conversationBtn setTitle:@"发起会话" forState:UIControlStateNormal];
    [self.conversationBtn addTarget:self
                             action:@selector(btnConversation:)
                   forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.conversationBtn];
    [self.conversationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.remarksView.mas_bottom).offset(20);
    }];
    
    self.conversationBtn.layer.masksToBounds = YES;
    self.conversationBtn.layer.cornerRadius = 5.f;
    self.conversationBtn.layer.borderWidth = 0.5;
    self.conversationBtn.layer.borderColor = [[UIColor colorWithHexString:@"0181dd"] CGColor];
    
    NSString *ckid = IsNilOrNull(KCKidstring) ? @"" : KCKidstring;
    if ([self.contactorModel.meid isEqualToString:ckid]) {
        self.remarksView.hidden = YES;
        self.conversationBtn.hidden = YES;
    }else{
        self.remarksView.hidden = NO;
        self.conversationBtn.hidden = NO;
    }
}

- (void)refreshHeadImage {
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.contactorModel.head] placeholderImage:[UIImage imageNamed:@"name"]];
}

#pragma mark - 发起单聊
- (void)btnConversation:(id)sender {
    ChatMessageViewController *chatMessage = [[ChatMessageViewController alloc] init];
    chatMessage.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatMessage.targetId = self.contactorModel.meid;
    chatMessage.headUrl = self.contactorModel.head;
    chatMessage.titleString = self.remarkNameLabel.text;
    
    [self.navigationController pushViewController:chatMessage animated:NO];
}

#pragma mark - 修改备注
- (void)gotoRemarksView:(id)sender {
    PTUpdateFriendNickNameVC *vc = [[PTUpdateFriendNickNameVC alloc] init];
    vc.nickName = self.remarkNameLabel.text;
    vc.meid = self.contactorModel.meid;
    vc.remarkNameBlock = ^(NSString *name) {
        self.remarkNameLabel.text = name;
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        RLMResults *result = [CKGroupInfoModel allObjects];
        if (result.count > 0) {
            [realm beginWriteTransaction];
            for (CKGroupInfoModel *infoM in result) {
                CKGroupInfoModel *infoModel = [[CKGroupInfoModel alloc] init];
                infoModel = infoM;
                if ([self.contactorModel.meid isEqualToString:infoM.meid]) {
                    infoModel.remark = name;
                }
                [CKGroupInfoModel createOrUpdateInRealm:realm withValue:infoModel];
            }
            [realm commitWriteTransaction];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
