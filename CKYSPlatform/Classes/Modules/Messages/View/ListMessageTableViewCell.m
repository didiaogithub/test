//
//  ListMessageTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/7/5.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "ListMessageTableViewCell.h"

@implementation ListMessageTableViewCell
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

    //顾客姓名
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BoldTITLE_FONT];
    [bankView addSubview:_nameLable];
    _nameLable.numberOfLines = 0;
    CGFloat w = [UIScreen mainScreen].bounds.size.height;
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(12));
        make.left.equalTo(_headImageView.mas_right).offset(AdaptedWidth(21));
        if (w<568) {
            make.right.mas_offset(-AdaptedWidth(130));
        }else{
            make.right.mas_offset(-AdaptedWidth(125));
        }
    }];

    
    _timeLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_SUBTITLE_FONT];
    [bankView addSubview:_timeLable];
    [_timeLable  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLable.mas_centerY);
        make.right.mas_offset(-AdaptedWidth(10));
        make.left.equalTo(_nameLable.mas_right).offset(AdaptedWidth(5));
    }];



    _messageLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(13))];
    [bankView addSubview:_messageLable];
    [_messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_nameLable.mas_left);
    }];
   
    bottomLineLable = [UILabel creatLineLable];
    [self.contentView addSubview:bottomLineLable];
    [bottomLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_messageLable.mas_bottom).offset(AdaptedHeight(10));
        make.bottom.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 1.5));
        make.bottom.mas_offset(0);
    }];
    
}

-(void)refreshWithModel:(MessageModel *)messageModel{
        NSString *notreadcount = [NSString stringWithFormat:@"%ld",messageModel.notreadcount];
        NSString *smallname = [NSString stringWithFormat:@"%@",messageModel.smallname];
        if (IsNilOrNull(notreadcount)) {
            notreadcount = @"0";
        }
        if (IsNilOrNull(smallname)) {
            smallname = @"";
            [_messageLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_headImageView.mas_top).offset(AdaptedHeight(30));
            }];
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
        NSString *timestr = [NSString stringWithFormat:@"%@",messageModel.lastmsgtime];
        if (IsNilOrNull(timestr)) {
            timestr = @"";
        }
        NSString *msgContent = [NSString stringWithFormat:@"%@",messageModel.lastmsg];
        if (IsNilOrNull(msgContent)) {
            msgContent = @"";
        }
        NSString *headUrl = [NSString stringWithFormat:@"%@",messageModel.headurl];
        NSString *picUrl = [NSString loadImagePathWithString:headUrl];

        [_headImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"name"]];

        _nameLable.text = smallname;
        _timeLable.text = timestr;
        _messageLable.text = msgContent;
}
@end
