//
//  CKGoodsManagerCell.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/9.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKGoodsManagerCell.h"

@interface CKGoodsManagerCell ()
{
    
    UIView *_countView;
    UIButton *_topBigButton;
    
}

@property(nonatomic,assign)NSInteger section;

@property(nonatomic,assign)NSInteger indexRow;
@property(nonatomic,strong)GoodModel *goodModel;

@property (nonatomic, strong) UIButton * selectedButton;
@property (nonatomic, strong) UIImageView *iconImageView;
/**名称*/
@property (nonatomic, strong) UILabel *nameLable;
/**规格*/
@property (nonatomic, strong) UILabel *standardLable;
@property (nonatomic, strong) UILabel *textLable;
@property (nonatomic, strong) UILabel *priceLable;

@end

@implementation CKGoodsManagerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_selectedButton];
    [_selectedButton setImage:[UIImage imageNamed:@"giftwhite"] forState:UIControlStateNormal];
    [_selectedButton setImage:[UIImage imageNamed:@"pinkselected"] forState:UIControlStateSelected];
    [_selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    [_selectedButton addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.layer.borderColor = [UIColor tt_borderColor].CGColor;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        
        if ([UIScreen mainScreen].bounds.size.height <= 568) {
            make.left.equalTo(_selectedButton.mas_right).offset(5);
            make.size.mas_offset(CGSizeMake(65, 65));
        }else{
            make.left.equalTo(_selectedButton.mas_right).offset(13);
            make.size.mas_offset(CGSizeMake(100, 100));
        }
        make.bottom.mas_offset(-15);
    }];
    
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [self.contentView addSubview:_nameLable];
    _nameLable.numberOfLines = 0;
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(21));
        make.left.equalTo(_iconImageView.mas_right).offset(AdaptedWidth(8));
        make.right.mas_offset(-AdaptedWidth(10));
        
    }];
    //规格
    
    self.self.textLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    self.self.textLable.text = @"规格：";
    [self.contentView addSubview:self.self.textLable];
    
    [self.self.textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom).offset(AdaptedHeight(6));
        make.left.equalTo(_nameLable.mas_left);
    }];
    
    //规格内容
    _standardLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [self.contentView addSubview:_standardLable];
    _standardLable.text = @"150ml/瓶";
    [_standardLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.self.textLable.mas_top);
        make.left.equalTo(self.self.textLable.mas_right);
    }];
    
    //价格
    _priceLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_BoldTITLE_FONT];
    [self.contentView addSubview:_priceLable];
    _priceLable.text = @"¥0.00";
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.self.textLable.mas_left);
        make.height.mas_offset(AdaptedHeight(20));
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
    
    
    _topBigButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_topBigButton];
    [_topBigButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(_iconImageView.mas_left);
        make.right.mas_offset(0);
        make.bottom.mas_offset(-45);
    }];
    [_topBigButton addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)setBlock:(CarryBySelfBlock)block{
    _block = block;
    
}

#pragma mark-点击cell左侧按钮
- (void)clickSelect:(UIButton *)button {
    button.selected = !button.selected;
    _selectedButton.selected = _topBigButton.selected = button.selected;
    _goodModel.isSelect = _selectedButton.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(singleClickCell:goodsModel:)]){
        [self.delegate singleClickCell:self goodsModel:_goodModel];
    }
}

#pragma mark-刷新model数据
- (void)setModel:(GoodModel *)model {
    _goodModel = model;
    _selectedButton.selected = model.isSelect;
    _topBigButton.selected = model.isSelect;
    
    //商品图片
    NSString *goodUrl = [NSString stringWithFormat:@"%@", model.url];
    NSString *picUrl = [NSString loadImagePathWithString:goodUrl];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"waitgoods"]];
    // 名称
    NSString *name = [NSString stringWithFormat:@"%@", model.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _nameLable.text = name;
    
    //价格
    NSString *pricestr = [NSString stringWithFormat:@"%@", model.price];
    if (IsNilOrNull(pricestr)) {
        pricestr = @"";
    }
    _priceLable.text = [NSString stringWithFormat:@"¥%.2f", [pricestr doubleValue]];
    
    //规格
    NSString *spec = [NSString stringWithFormat:@"%@", model.spec];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }
    _standardLable.text = spec;
    
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //下分割线
    CGContextSetStrokeColorWithColor(context,[UIColor tt_lineBgColor].CGColor);
    CGContextStrokeRect(context,CGRectMake(0, rect.size.height-1, rect.size.width,1));
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
