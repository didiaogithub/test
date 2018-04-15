//
//  CKSmallTipCell.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/2.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKSmallTipCell.h"

@interface CKSmallTipCell ()

@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *subTitlelable;
//@property (nonatomic, strong) UILabel *seePeoplelable;
//@property (nonatomic, strong) UIImageView *seeImageView;
@property (nonatomic, strong) UILabel *timelable;

@end

@implementation CKSmallTipCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.bottom.mas_offset(-AdaptedHeight(10));
    }];
    
    
    _pictureImageView = [[UIImageView alloc] init];
    [bankView addSubview:_pictureImageView];
    [_pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH);
        make.height.mas_offset(SCREEN_WIDTH/2);
    }];
    
    
    _titleLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM_BOLD(AdaptedWidth(15))];
    [bankView addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pictureImageView.mas_bottom).offset(AdaptedHeight(12));
        make.left.mas_offset(AdaptedWidth(10));
        make.right.mas_offset(-AdaptedWidth(10));
    }];
    
    //副标题
    _subTitlelable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(12))];
    [bankView addSubview:_subTitlelable];
    [_subTitlelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLable.mas_bottom).offset(AdaptedHeight(14));
        make.left.mas_offset(10);
        make.right.mas_offset(-8);
    }];
    
    //有多少人看
//    _seeImageView = [[UIImageView alloc] init];
//    [bankView addSubview:_seeImageView];
//    [_seeImageView setImage:[UIImage imageNamed:@"classesee"]];
//    _seeImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [_seeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_subTitlelable.mas_bottom).offset(AdaptedHeight(13));
//        make.left.equalTo(_subTitlelable.mas_left);
//        make.width.mas_offset(AdaptedWidth(20));
//        make.height.mas_offset(AdaptedHeight(20));
//        make.bottom.mas_offset(-AdaptedHeight(12));
//    }];
//
//    _seePeoplelable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
//    [bankView addSubview:_seePeoplelable];
//    [_seePeoplelable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(_seeImageView);
//        make.left.equalTo(_seeImageView.mas_right).offset(5);
//    }];
    
    //时间
    _timelable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [bankView addSubview:_timelable];
    _timelable.text = @"";
    [_timelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subTitlelable.mas_bottom).offset(AdaptedHeight(13));
        make.right.mas_offset(-8);
        make.height.mas_offset(AdaptedHeight(20));
        make.bottom.mas_offset(-AdaptedHeight(12));
    }];
}

- (void)refreshWithLessons:(CKSmallTipModel*)smallTipModel {
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@", smallTipModel.imgurl];
    NSString *picUrl = [NSString loadImagePathWithString:imageUrl];
    
    [_pictureImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"waitclass"]];
    
    NSString *title = [NSString stringWithFormat:@"%@", smallTipModel.title];
    NSString *teacher = [NSString stringWithFormat:@"%@", smallTipModel.teacher];
    NSString *viewPeople = [NSString stringWithFormat:@"%@", smallTipModel.viewed];
    if (IsNilOrNull(title)) {
        title = @"";
    }
    if (IsNilOrNull(teacher)) {
        teacher = @"";
    }
    if (IsNilOrNull(viewPeople)) {
        viewPeople = @"";
    }
    _titleLable.text = title;
    _subTitlelable.text = teacher;
//    _seePeoplelable.text = viewPeople;
    
    NSString *timestr = [NSString stringWithFormat:@"%@", smallTipModel.time];
    if(IsNilOrNull(timestr)){
        timestr = @"";
    }
    _timelable.text = timestr;
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
