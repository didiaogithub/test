//
//  CKMessageCenterTableViewCell.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/17.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKMessageCenterTableViewCell.h"

@interface CKMessageCenterTableViewCell()

/**群组头像*/
@property (nonatomic, strong) UIImageView *headImageView;
/**群组名称*/
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation CKMessageCenterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    
    _headImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_headImageView];
    _headImageView.layer.borderWidth = 1;
    _headImageView.layer.borderColor = [UIColor tt_headBoderColor].CGColor;
    [_headImageView setImage:[UIImage imageNamed:@"群组"]];
    _headImageView.layer.cornerRadius = 25.0f;
    _headImageView.clipsToBounds = YES;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(50, 50));
    }];
    
    
    _nameLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BoldTITLE_FONT];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.numberOfLines = 0;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(_headImageView.mas_right).offset(20);
        make.right.mas_offset(-10);
    }];
    
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [self.contentView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)updateCellWithData:(CKGroupModel *)groupModel {
    _headImageView.image = [UIImage imageNamed:@"群组"];
    NSString *goupname = [NSString stringWithFormat:@"%@", groupModel.groupname];
    if (IsNilOrNull(goupname)) {
        goupname = @"";
    }
    _nameLabel.text = goupname;
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


@interface CKMessageCenterUserMsgListCell()

/**顾客头像*/
@property (nonatomic, strong) UIImageView *headImageView;
/**顾客姓名*/
@property (nonatomic, strong) UILabel *nameLabel;
/**顾客消息*/
@property (nonatomic, strong) UILabel *messageLable;
/**时间*/
@property (nonatomic, strong) UILabel *timeLable;
/**未读消息数*/
@property (nonatomic, strong) UILabel *notReadLable;

@end

@implementation CKMessageCenterUserMsgListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    _headImageView = [[UIImageView alloc] init];
    [bankView addSubview:_headImageView];
    _headImageView.layer.borderWidth = 1;
    _headImageView.layer.borderColor = [UIColor tt_headBoderColor].CGColor;
    [_headImageView setImage:[UIImage imageNamed:@"name"]];
    _headImageView.layer.cornerRadius = AdaptedWidth(50)/2;
    _headImageView.clipsToBounds = YES;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bankView.mas_centerY);
        make.left.mas_offset(AdaptedWidth(10));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(50), AdaptedWidth(50)));
    }];
    
    
    self.notReadLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM(AdaptedHeight(9))];
    [bankView addSubview:self.notReadLable];
    self.notReadLable.backgroundColor = [UIColor tt_redMoneyColor];
    self.notReadLable.layer.cornerRadius = 16*0.5;
    self.notReadLable.clipsToBounds = YES;
    self.notReadLable.hidden = YES;
    self.notReadLable.text = @"9";
    self.notReadLable.textColor = [UIColor whiteColor];
    [self.notReadLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(5));
        make.left.equalTo(_headImageView.mas_left).offset(AdaptedWidth(35));
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    //顾客姓名
    _nameLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    [bankView addSubview:_nameLabel];
    _nameLabel.numberOfLines = 1;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(12));
        make.left.equalTo(_headImageView.mas_right).offset(10);
        make.right.mas_offset(-130);
    }];
    
    
    _timeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:11]];
    [bankView addSubview:_timeLable];
    [_timeLable  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel.mas_centerY);
        make.right.mas_offset(-5);
        make.left.equalTo(_nameLabel.mas_right).offset(5);
    }];
    
    
    _messageLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(13))];
    [bankView addSubview:_messageLable];
    [_messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_nameLabel.mas_left);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [self.contentView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)updateCellWithData:(CKUserMsgListModel *)msgModel {
    
    NSString *timestr = [NSString stringWithFormat:@"%@",  msgModel.lastmsgtime];
    if (IsNilOrNull(timestr)) {
        timestr = @"";
    }
    NSString *msgContent = [NSString stringWithFormat:@"%@", msgModel.lastmsg];
    if (IsNilOrNull(msgContent)) {
        msgContent = @"";
    }
    NSString *headUrl = [NSString stringWithFormat:@"%@", msgModel.head];
    NSString *picUrl = [NSString loadImagePathWithString:headUrl];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"name"]];
    
    if (!IsNilOrNull(msgModel.remark)) {
        self.nameLabel.text = msgModel.remark;
    }else{
        if (!IsNilOrNull(msgModel.name)) {
            self.nameLabel.text = msgModel.name;
        }else{
            self.nameLabel.text = @"";
        }
    }
    _timeLable.text = timestr;
    _messageLable.text = msgContent;
    
    NSString *ifread = [NSString stringWithFormat:@"%@", msgModel.ifread];
    if ([ifread isEqualToString:@"0"]) {
        NSString *notreadnum = [NSString stringWithFormat:@"%@", msgModel.notreadnum];
        if ([notreadnum integerValue] > 0) {
            self.notReadLable.hidden = NO;
            [self.notReadLable mas_updateConstraints:^(MASConstraintMaker *make) {
                if (notreadnum.length > 2) {
                    make.width.mas_equalTo(27);
                }else{
                    make.width.mas_equalTo(16);
                }
            }];
            self.notReadLable.text = notreadnum;
        }else{
            self.notReadLable.hidden = YES;
        }
    }else{
        self.notReadLable.hidden = YES;
    }
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
