//
//  CKPickupMallCell.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/2/26.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKPickupMallCell.h"

@interface CKPickupMallCell()

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *specLabel;/**规格*/
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *countView;/**数量*/
@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UIButton *reduceButton;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation CKPickupMallCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponents];
    }
    return self;
}

- (void)initComponents{
    //选择框
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_selectBtn];
    [_selectBtn setImage:[UIImage imageNamed:@"giftwhite"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"pinkselected"] forState:UIControlStateSelected];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    [_selectBtn addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    //商品图片
    _goodsImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_goodsImageView];
    _goodsImageView.userInteractionEnabled = YES;
    _goodsImageView.layer.borderWidth = 1;
    _goodsImageView.layer.borderColor = [UIColor tt_borderColor].CGColor;
    _goodsImageView.contentMode = UIViewContentModeScaleToFill;
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        if ([UIScreen mainScreen].bounds.size.height <= 568) {
            make.left.equalTo(_selectBtn.mas_right).offset(5);
            make.size.mas_offset(CGSizeMake(65, 65));
        }else{
            make.left.equalTo(_selectBtn.mas_right).offset(13);
            make.size.mas_offset(CGSizeMake(100, 100));
        }
    }];
    
    //商品名称
    _nameLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.numberOfLines = 0;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(21));
        make.left.equalTo(_goodsImageView.mas_right).offset(8);
        make.right.mas_offset(-10);
    }];
    
    //规格
    _specLabel = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [self.contentView addSubview:_specLabel];
    _specLabel.text = @"规格：";
    [_specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(AdaptedHeight(6));
        make.left.equalTo(_nameLabel.mas_left);
    }];
    
    //价格
    _priceLabel = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_BoldTITLE_FONT];
    [self.contentView addSubview:_priceLabel];
    _priceLabel.text = @"¥0.00";
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_specLabel.mas_left);
        make.height.mas_offset(AdaptedHeight(20));
        make.bottom.equalTo(_goodsImageView.mas_bottom);
    }];
    
    
    _countView = [[UIView alloc] init];
    [self.contentView addSubview:_countView];
    [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        if ([UIScreen mainScreen].bounds.size.height <= 568) {
            make.bottom.equalTo(_goodsImageView.mas_bottom).offset(10);
        }else{
            make.bottom.equalTo(_goodsImageView.mas_bottom);
        }
        make.size.mas_offset(CGSizeMake(110, 30));
    }];
    
    //减号按钮
    _reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_countView addSubview:_reduceButton];
    _reduceButton.tag = 1111;
    [_reduceButton setImage:[UIImage imageNamed:@"reducewhite"] forState:UIControlStateNormal];
    
    [_reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_offset(0);
        make.width.mas_offset(35);
    }];
    [_reduceButton addTarget:self action:@selector(clickCountButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //数字
    _countLabel = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [_countView addSubview:_countLabel];
    _countLabel.text = @"1";
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(33);
        make.size.mas_offset(CGSizeMake(40, 30));
    }];
    
    
    //加号按钮
    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_countView addSubview:_plusButton];
    _plusButton.tag = 1112;
    
    [_plusButton setImage:[UIImage imageNamed:@"pluswhite"] forState:UIControlStateNormal];
    
    [_plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_reduceButton.mas_top);
        make.left.equalTo(_countLabel.mas_right);
        make.size.equalTo(_reduceButton);
    }];
    [_plusButton addTarget:self action:@selector(clickCountButton:) forControlEvents:UIControlEventTouchUpInside];
    
    float H = _reduceButton.imageView.frame.origin.y;
    float bottomH = 30-_reduceButton.imageView.size.height-H;
    
    UIImageView *boderImageView = [[UIImageView alloc] init];
    [_countView addSubview:boderImageView];
    [boderImageView setImage:[UIImage imageNamed:@"numberborder"]];
    [boderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(H);
        make.left.equalTo(_reduceButton.mas_right);
        make.right.equalTo(_plusButton.mas_left);
        make.bottom.mas_offset(-bottomH);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [self.contentView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - 点击减号 和   加号 按钮
- (void)clickCountButton:(UIButton *)button {
    
    if (button.tag == 1111) { //减号
        if ((self.chooseCount - 1) <= 0 || self.chooseCount == 0) {
            self.chooseCount = 1;
        }else{
            self.chooseCount  = self.chooseCount -1;
        }
    }else{
        if (self.chooseCount  > 100 || self.chooseCount == 100) {
            self.chooseCount  = 99;
        }else{
            self.chooseCount  = self.chooseCount +1;
        }
    }
    _countLabel.text = [NSString stringWithFormat:@"%zd",self.chooseCount];
    _goodsModel.count = [NSString stringWithFormat:@"%zd", self.chooseCount];
    _goodsModel.isSelect = _selectBtn.selected;

    if (self.delegate && [self.delegate respondsToSelector:@selector(cKPickupMallCell:didSelectAtIndexPath:goodsModel:)]) {
        [self.delegate cKPickupMallCell:self didSelectAtIndexPath:self.indexPath goodsModel:_goodsModel];
    }
}

#pragma mark - 点击cell左侧按钮
-(void)clickSelect:(UIButton *)button {
    button.selected = !button.selected;
    _selectBtn.selected = button.selected;
    _goodsModel.isSelect = _selectBtn.selected;
    
    if (self.chooseCount > 0) {
        _goodsModel.count = [NSString stringWithFormat:@"%zd", self.chooseCount];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cKPickupMallCell:didSelectAtIndexPath:goodsModel:)]) {
        [self.delegate cKPickupMallCell:self didSelectAtIndexPath:self.indexPath goodsModel:_goodsModel];
    }
}

#pragma mark - 刷新cell数据
- (void)updateCellData:(CKPickupGoodsModel *)goodsModel {
    
    _goodsModel = goodsModel;
    _selectBtn.selected = goodsModel.isSelect;
    //商品图片
    NSString *goodUrl = [NSString stringWithFormat:@"%@", goodsModel.url];
    NSString *picUrl = [NSString loadImagePathWithString:goodUrl];
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"waitgoods"]];
    // 名称
    NSString *name = [NSString stringWithFormat:@"%@", goodsModel.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _nameLabel.text = name;
    
    //价格
    NSString *pricestr = [NSString stringWithFormat:@"%@", goodsModel.price];
    if (IsNilOrNull(pricestr)) {
        pricestr = @"";
    }
    double priceDouble = [pricestr doubleValue];
    NSLog(@"自提价格%zd", priceDouble);
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f", priceDouble];
    NSString *countStr = [NSString stringWithFormat:@"%@",  goodsModel.count];
    if (IsNilOrNull(countStr)) {
        countStr = @"1";
    }
    if ([countStr isEqualToString:@"0"]) {
        countStr = @"1";
    }
    _countLabel.text = countStr;
    self.chooseCount = [countStr integerValue];
    
    //自提商城规格
    NSString *spec = [NSString stringWithFormat:@"%@", goodsModel.spec];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }
    _specLabel.text = [NSString stringWithFormat:@"规格：%@", spec];;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
