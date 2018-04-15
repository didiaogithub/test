//
//  CKMyGrowupCell.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKMyGrowupCell.h"
#import "CKLevelShopPieView.h"
#import "CKLevelLineView.h"

@implementation CKMyGrowupCell

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


@interface CKMyGrowupTitleCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation CKMyGrowupTitleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {

    _titleLabel = [UILabel new];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self);
        make.left.mas_offset(AdaptedWidth(10));
    }];
    _lineLabel = [UILabel creatLineLable];
    [self addSubview:_lineLabel];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(AdaptedWidth(10));
        make.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(AdaptedHeight(1));
    }];
}

-(void)myGrowupData:(id)data {
    if (!data) {
        return;
    }
    _titleLabel.text = [data objectForKey:@"title"];
}

@end



@interface CKMyGrowupContentCell()<CKLevelLineDelegate>

@property (nonatomic, copy) NSString *type;

@end

@implementation CKMyGrowupContentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    
}

-(void)myGrowupData:(id)data {
    if (!data) {
        return;
    }
    _type = [data objectForKey:@"type"];
    
    if ([_type isEqualToString:@"levelLine"]) {
        CKLevelLineView *levelLine = [[CKLevelLineView alloc] initWithFrame:self.bounds];
        levelLine.delegate = self;
        [self addSubview:levelLine];
    }else if ([_type isEqualToString:@"shopPie"]){
        CKLevelShopPieView *shopPie = [[CKLevelShopPieView alloc] initWithFrame:self.bounds];
        [self addSubview:shopPie];
    }
}

-(void)clickLevelPoint:(NSInteger)index {

}


@end


@interface CKMyGrowupUpdateCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation CKMyGrowupUpdateCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    _titleLabel = [UILabel new];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.mas_offset(AdaptedWidth(10));
        make.width.mas_equalTo(AdaptedWidth(70));
    }];
    _timeLabel = [UILabel new];
    _timeLabel.text = [NSString stringWithFormat:@"%@", [NSDate date]];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-AdaptedWidth(10));
        make.bottom.top.mas_equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
    }];
}

-(void)myGrowupData:(id)data {
    if (!data) {
        return;
    }
    _titleLabel.text = [data objectForKey:@"title"];
}

@end
