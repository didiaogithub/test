//
//  CKdlbGoodsCell.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/10/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKdlbGoodsCell.h"

@interface CKdlbGoodsCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;
/**名称*/
@property (nonatomic, strong) UILabel *nameLable;
/**价格*/
@property (nonatomic, strong) UILabel *priceLable;
/**数量*/
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UIButton *focusBtn; // 放大点击区域

//@property (nonatomic, strong) UIView *maskView;
//
//@property (nonatomic, strong) UILabel *markLabel;

@end

@implementation CKdlbGoodsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_selectedButton];
    [_selectedButton setImage:[UIImage imageNamed:@"giftwhite"] forState:UIControlStateNormal];
    [_selectedButton setImage:[UIImage imageNamed:@"pinkselected"] forState:UIControlStateSelected];
    [_selectedButton addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    
    _goodsImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_goodsImageView];
    _goodsImageView.userInteractionEnabled = YES;
    _goodsImageView.layer.borderWidth = 1;
    _goodsImageView.layer.borderColor = [UIColor tt_borderColor].CGColor;
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.equalTo(_selectedButton.mas_right).offset(10);
        make.size.mas_offset(CGSizeMake(100, 100));
    }];
    
    
    _focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_focusBtn];
    [_focusBtn addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_offset(0);
        make.right.equalTo(_goodsImageView.mas_left);
    }];
    
    
//    _maskView = [UIView new];
//    _maskView.backgroundColor = [UIColor grayColor];
//    _maskView.alpha = 0.25;
//    [_goodsImageView addSubview:_maskView];
//    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.mas_offset(0);
//        make.height.mas_equalTo(25);
//    }];
//    _markLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_NAMETITLE_FONT];
//    _markLabel.text = @"正式创客";
//    [_goodsImageView addSubview:_markLabel];
//    [_markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.mas_offset(0);
//        make.height.mas_equalTo(25);
//    }];
    
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [self.contentView addSubview:_nameLable];
    _nameLable.text = @"测试礼包";
    _nameLable.numberOfLines = 0;
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.left.equalTo(_goodsImageView.mas_right).offset(10);
        make.right.mas_offset(-10);
    }];
    
    //价格
    _priceLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [self.contentView addSubview:_priceLable];
    _priceLable.text = @"¥12000.00";
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLable.mas_left);
        make.height.mas_offset(25);
        make.bottom.equalTo(_goodsImageView.mas_bottom);
        make.right.mas_offset(-65);
    }];
    
    _countLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [self.contentView addSubview:_countLabel];
    _countLabel.text = @"数量:1";
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_offset(25);
        make.bottom.equalTo(_goodsImageView.mas_bottom);
        make.right.mas_offset(-10);
    }];
    
    UILabel *line = [UILabel creatLineLable];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(1);
    }];

}

#pragma mark-点击cell左侧按钮
-(void)clickSelect:(UIButton *)button
{
    button.selected = !button.selected;
    _selectedButton.selected = _focusBtn.selected = button.selected;
    _goodModel.isSelect = _selectedButton.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(dlbGoodsSelected:anRow:andSection:)]){
        [self.delegate dlbGoodsSelected:_goodModel anRow:self.indexRow andSection:self.section];
    }
}

-(void)refreshUIWithGoodsModel:(CKdlbGoodsModel*)model {
    _goodModel = model;
    _selectedButton.selected = model.isSelect;
    _focusBtn.selected = model.isSelect;

    NSString *goodUrl = [NSString stringWithFormat:@"%@",model.path];
    NSString *picUrl = [NSString loadImagePathWithString:goodUrl];
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"waitgoods"]];
    
    NSString *name = [NSString stringWithFormat:@"%@",model.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _nameLable.text = name;
    
    //价格
    NSString *pricestr = [NSString stringWithFormat:@"%@",model.price];
    if (IsNilOrNull(pricestr)) {
        pricestr = @"";
    }
    double priceDouble = [pricestr doubleValue];
    _priceLable.text = [NSString stringWithFormat:@"¥%.2f",priceDouble];
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
