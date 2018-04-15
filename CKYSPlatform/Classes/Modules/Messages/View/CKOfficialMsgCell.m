//
//  CKOfficialMsgCell.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/23.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKOfficialMsgCell.h"

@interface CKOfficialMsgCell()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *msgTypeLabel;
@property (nonatomic, strong) UIView *separatLine;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *rightArrow;

@end

@implementation CKOfficialMsgCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponents];
    }
    return self;
}

-(void)initComponents {
    self.backgroundColor = [UIColor tt_grayBgColor];
    
    _timeLabel = [UILabel new];
    _timeLabel.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    _timeLabel.text = @"";
    _timeLabel.layer.cornerRadius = 3.0f;
    _timeLabel.layer.masksToBounds = YES;
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor whiteColor];
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(AdaptedHeight(20));
    }];
    
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 5.0f;
    _bgView.layer.masksToBounds = YES;
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
    }];
    
    _msgTypeLabel = [UILabel new];
    _msgTypeLabel.backgroundColor = [UIColor whiteColor];
    _msgTypeLabel.text = @"";
    _msgTypeLabel.font = [UIFont systemFontOfSize:15];
    _msgTypeLabel.textColor = [UIColor colorWithHexString:@"#1b1b1b"];
    [_bgView addSubview:_msgTypeLabel];
    [_msgTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(AdaptedHeight(40));
    }];
    
    _separatLine = [UIView new];
    _separatLine.backgroundColor = [UIColor tt_lineBgColor];
    [_bgView addSubview:_separatLine];
    [_separatLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_msgTypeLabel.mas_bottom).offset(-0.5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.equalTo(@0.5);
    }];
    
    _rightArrow = [UIImageView new];
    UIImage *arrow = [UIImage imageNamed:@"rightarrow"];
    _rightArrow.image = arrow;
    [_bgView addSubview:_rightArrow];
    [_rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_msgTypeLabel.mas_bottom).offset(AdaptedHeight(35));
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(AdaptedHeight(10));
        make.height.mas_equalTo(AdaptedHeight(15.5));
    }];
    
    _contentLabel = [UILabel new];
    _contentLabel.backgroundColor = [UIColor whiteColor];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines = 2;
    [_bgView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_msgTypeLabel.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.equalTo(_rightArrow.mas_left).offset(-5);
        make.height.mas_equalTo(AdaptedHeight(70));
    }];
    
}

-(void)refreshWithModel:(CKOfficialMsgModel *)messageModel iconName:(NSInteger)type {
    NSString *msgContent = [NSString stringWithFormat:@"%@",messageModel.msg];
    NSString *timestr = [NSString stringWithFormat:@"%@",messageModel.time];
//    if (IsNilOrNull(timestr)) {
//        timestr = @"";
//    }
    
    _msgTypeLabel.text = [NSString stringWithFormat:@"%@", messageModel.title];
    
    if (IsNilOrNull(timestr)) {
        _timeLabel.hidden = YES;
    }else{
        _timeLabel.hidden = NO;
        _timeLabel.text = [NSString stringWithFormat:@"  %@  ", timestr];
    }
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:msgContent];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [msgContent length])];
    _contentLabel.attributedText = attributedString;
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
