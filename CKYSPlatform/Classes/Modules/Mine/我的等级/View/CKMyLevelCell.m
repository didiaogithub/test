//
//  CKMyLevelCell.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/6.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKMyLevelCell.h"

@implementation CKMyLevelCell

-(void)fillData:(id)data {
    
}

-(void)callWithParameter:(id)parameter {
    
}

+(CGFloat)computeHeight:(id)data {
    return 0;
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



@interface CKMyLevelHeaderCell()

@property (nonatomic, strong) UIImageView *headerImgV;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation CKMyLevelHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    self.backgroundColor = [UIColor redColor];
    
    _headerImgV = [UIImageView new];
    _headerImgV.image = [UIImage imageNamed:@"fratures1"];
    [self addSubview:_headerImgV];
    
    [_headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(15));
        make.centerX.mas_equalTo(self);
        make.width.height.mas_equalTo(AdaptedWidth(70));
    }];
    
    _levelLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [self addSubview:_levelLabel];
    _levelLabel.text = @"团队领袖2级";
    [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerImgV.mas_bottom).offset(AdaptedHeight(5));
        make.centerX.mas_equalTo(self.headerImgV);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(AdaptedHeight(20));
    }];
    
    NSArray *titleArr = @[@"基础创客层",@"团队领袖层",@"事业合伙人"];
    NSArray *imageArr = @[@"fratures1",@"fratures3",@"fratures2"];
    
    
    for (int i = 0; i < titleArr.count; i++){
        
        UIView *bgview = [UIView new];
        [self addSubview:bgview];
        [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.levelLabel.mas_bottom).offset(AdaptedHeight(5));
            make.left.mas_equalTo(i*SCREEN_WIDTH / 3.0f);
            make.width.mas_equalTo(SCREEN_WIDTH / 3.0f);
            make.bottom.mas_equalTo(self);
        }];
        
        UIImageView *imageView = [UIImageView new];
        imageView.userInteractionEnabled = YES;
        [bgview addSubview:_imageV = imageView];
        [imageView setImage:[UIImage imageNamed:imageArr[i]]];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgview.mas_centerX);
            make.top.equalTo(self.levelLabel.mas_bottom).offset(AdaptedHeight(5));
            make.width.mas_equalTo(AdaptedWidth(50));
            make.height.mas_equalTo(AdaptedWidth(50));
        }];
        UILabel *titleLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
        [bgview addSubview:_titleLabel = titleLabel];
        titleLabel.text = titleArr[i];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageV.mas_bottom).offset(AdaptedHeight(5));
            make.centerX.mas_equalTo(self.imageV);
            make.width.mas_equalTo(SCREEN_WIDTH/3);
            make.bottom.mas_offset(-AdaptedHeight(5));
        }];
    }

}

@end


@interface CKMyLevelTitleCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation CKMyLevelTitleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    _titleLabel = [UILabel configureLabelWithTextColor:[UIColor tt_monthLittleBlackColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    _lineLabel = [UILabel creatLineLable];
    [self addSubview:_lineLabel];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(AdaptedHeight(1));
    }];
}

-(void)myLevelData:(id)data {
    if (!data) {
        return;
    }
    _titleLabel.text = [data objectForKey:@"title"];
}

@end



@interface CKMyLevelDetailCell()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CKMyLevelDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    NSArray *titleArr = @[@"基础创客层",@"团队领袖层",@"事业合伙人"];
    NSArray *imageArr = @[@"fratures1",@"fratures3",@"fratures2"];
    
    
    for (int i = 0; i < titleArr.count; i++){
        
        UIView *bgview = [UIView new];
        [self addSubview:bgview];
        [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedHeight(5));
            make.left.mas_equalTo(i*SCREEN_WIDTH / 3.0f);
            make.width.mas_equalTo(SCREEN_WIDTH / 3.0f);
            make.bottom.mas_equalTo(self);
        }];
        
        UILabel *titleLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
        [bgview addSubview:_titleLabel = titleLabel];
        titleLabel.text = titleArr[i];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedHeight(5));
            make.left.mas_equalTo(bgview);
            make.width.mas_equalTo(SCREEN_WIDTH/3);
            make.height.mas_offset(AdaptedHeight(20));
        }];
        
        UIImageView *imageView = [UIImageView new];
        imageView.userInteractionEnabled = YES;
        [bgview addSubview:_imageV = imageView];
        [imageView setImage:[UIImage imageNamed:imageArr[i]]];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgview.mas_centerX);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(AdaptedHeight(5));
            make.width.mas_equalTo(AdaptedWidth(50));
            make.height.mas_equalTo(AdaptedWidth(50));
        }];
    }
}

-(void)myLevelData:(id)data {
    if (!data) {
        return;
    }
    _titleLabel.text = [data objectForKey:@"title"];
}

@end


@interface CKMyLevelRightCell()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIImageView *arrowV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation CKMyLevelRightCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    
    _imageV = [UIImageView new];
    _imageV.image = [UIImage imageNamed:@"fratures1"];
    [self addSubview:_imageV];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(AdaptedWidth(10));
        make.width.height.mas_equalTo(AdaptedHeight(40));
    }];
    
    _arrowV = [UIImageView new];
    UIImage *img = [UIImage imageNamed:@"rightarrow"];
    _arrowV.image = img;
    [self addSubview:_arrowV];
    [_arrowV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(AdaptedWidth(-10));
        make.width.mas_equalTo(AdaptedHeight(10));
        make.height.mas_equalTo(AdaptedHeight(15.5));
    }];
    
    _titleLabel = [UILabel configureLabelWithTextColor:[UIColor tt_monthLittleBlackColor]textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(AdaptedWidth(10));
        make.right.equalTo(self.arrowV.mas_left);
        make.bottom.equalTo(self.mas_centerY);
        make.top.mas_equalTo(self);
    }];
    
    _detailLabel = [UILabel configureLabelWithTextColor:[UIColor tt_monthLittleBlackColor]textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [self addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(AdaptedWidth(10));
        make.right.equalTo(self.arrowV.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.mas_equalTo(self);
    }];
    
    _lineLabel = [UILabel creatLineLable];
    [self addSubview:_lineLabel];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_offset(AdaptedWidth(10));
        make.right.mas_offset(-AdaptedWidth(10));
        make.height.mas_equalTo(AdaptedHeight(1));
    }];
}

-(void)myLevelData:(id)data {
    if (!data) {
        return;
    }
    _titleLabel.text = [data objectForKey:@"title"];
    _detailLabel.text = @"创客云商创客云商创客云商";
}

@end

