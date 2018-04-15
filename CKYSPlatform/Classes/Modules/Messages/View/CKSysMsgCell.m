//
//  CKSysMsgCell.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKSysMsgCell.h"

@implementation CKSysMsgCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
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
    [_headImageView setImage:[UIImage imageNamed:@"name"]];
    _headImageView.layer.cornerRadius = AdaptedWidth(50)/2;
    _headImageView.clipsToBounds = YES;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bankView.mas_centerY);
        make.left.mas_offset(AdaptedWidth(10));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(50), AdaptedWidth(50)));
    }];
    
    _redLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:CHINESE_SYSTEM(AdaptedHeight(9))];
    [bankView addSubview:_redLable];
    _redLable.backgroundColor = [UIColor tt_redMoneyColor];
    _redLable.layer.cornerRadius = AdaptedWidth(16)/2;
    _redLable.clipsToBounds = YES;
    _redLable.hidden = YES;
    [_redLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(5));
        make.left.equalTo(_headImageView.mas_left).offset(AdaptedWidth(38));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(16), AdaptedWidth(16)));
    }];
    
    _timeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_SUBTITLE_FONT];
    [bankView addSubview:_timeLable];
    [_timeLable  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(18));
        make.right.mas_offset(-AdaptedWidth(10));
        make.width.mas_equalTo(AdaptedWidth(130));
    }];


    //顾客姓名
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BoldTITLE_FONT];
    [bankView addSubview:_nameLable];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(12));
        if (SCREEN_HEIGHT <= 568) {
            make.left.equalTo(_headImageView.mas_right).offset(AdaptedWidth(12));
        }else{
            make.left.equalTo(_headImageView.mas_right).offset(AdaptedWidth(20));
        }
        make.right.equalTo(_timeLable.mas_left).offset(-AdaptedWidth(2));
    }];
    
    
    
    _messageLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(13))];
    [bankView addSubview:_messageLable];
    [_messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_nameLable.mas_left);
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    bottomLineLable = [UILabel creatLineLable];
    [self.contentView addSubview:bottomLineLable];
    [bottomLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_messageLable.mas_bottom).offset(AdaptedHeight(10));
        make.bottom.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 1.5));
    }];
    
}

-(void)refreshWithModel:(CKSysMsgListModel *)messageModel iconName:(NSInteger)type {
    NSString *notreadcount = [NSString stringWithFormat:@"%ld",messageModel.notreadnum];
    NSString *msgContent = [NSString stringWithFormat:@"%@",messageModel.msg];
    if (IsNilOrNull(notreadcount)) {
        notreadcount = @"0";
    }
    //未读消息数量
    if(![notreadcount isEqualToString:@"0"]){
        _redLable.hidden = NO;
        _redLable.text = notreadcount;
        
        if(notreadcount.length > 1 && notreadcount.length < 3){
            [_redLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_offset(AdaptedWidth(18));
            }];
        }else if(notreadcount.length > 2){
            [_redLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_offset(AdaptedWidth(20));
            }];
        }
        
    }else{
        _redLable.hidden = YES;
    }
    NSString *timestr = [NSString stringWithFormat:@"%@",messageModel.msgtime];
    if (IsNilOrNull(timestr)) {
        timestr = @"";
    }
    
    //type:2：订单消息 0：开店提现 7：云豆库提现 6：产品库提现
    if (type == 0) {
        _headImageView.image = [UIImage imageNamed:@"openShopNotice"];
    }else if(type == 2){
        _headImageView.image = [UIImage imageNamed:@"orderNotice"];
    }else if(type == 6){
        _headImageView.image = [UIImage imageNamed:@"productNotice"];
    }else if(type == 7){
        _headImageView.image = [UIImage imageNamed:@"cloudBeanNotice"];
    }else{
        _headImageView.image = [UIImage imageNamed:@"name"];
    }
    
    NSString *name = [NSString stringWithFormat:@"%@", messageModel.title];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _nameLable.text = name;
    _timeLable.text = [NSString stringWithFormat:@"%@", timestr];
    _messageLable.text = msgContent;
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
