//
//  CKNoticeCell.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKNoticeCell.h"
#import "CKSysMsgModel.h"

@interface CKNoticeCell()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *msgTypeLabel;
@property (nonatomic, strong) UIView *separatLine;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *contentLabel;


@end

@implementation CKNoticeCell

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
    _separatLine.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:_separatLine];
    [_separatLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_msgTypeLabel.mas_bottom).offset(-0.5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.equalTo(@0.5);
    }];
    
    _contentLabel = [UILabel new];
    _contentLabel.backgroundColor = [UIColor whiteColor];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = @"";
    [_bgView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_msgTypeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
//        make.height.equalTo(@70);
    }];

}

-(void)fillNoticeData:(id)data {
    CKSysMsgModel *sysModel = data;
    _timeLabel.text = [NSString stringWithFormat:@"  %@  ", sysModel.time];
    _msgTypeLabel.text = [NSString stringWithFormat:@"%@", sysModel.title];
//    _contentLabel.text = [NSString stringWithFormat:@"%@", sysModel.msg];
    NSString *msgContent = [NSString stringWithFormat:@"%@", sysModel.msg];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:msgContent];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 6;
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle};
    
    [attributedString addAttributes:dict range:NSMakeRange(0, [msgContent length])];
    _contentLabel.attributedText = attributedString;
    
}

+(CGFloat)computeHeight:(id)data {

    NSString *str = data;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 6;
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    CGFloat dat = 10;
    if (size.height > SCREEN_HEIGHT * 0.5) {
        dat = dat + 30;
    }
    
    if (SCREEN_HEIGHT <= 568 && SCREEN_HEIGHT > 480) {
        return  AdaptedHeight(size.height + 95 + 24 + dat);
    }else if (SCREEN_HEIGHT <= 480) {
        return  AdaptedHeight(size.height + 95 + 24 + dat+20);
    }else{
        return  AdaptedHeight(size.height + 95 + 14);
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
