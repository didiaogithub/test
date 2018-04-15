//
//  CKConfirmOrderCell.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/10.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKConfirmOrderCell.h"

@interface CKConfirmOrderCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
/**名称*/
@property (nonatomic, strong) UILabel *nameLable;
/**规格*/
@property (nonatomic, strong) UILabel *textLable;
@property (nonatomic, strong) UILabel *standardLable;
@property (nonatomic, strong) UILabel *priceLable;
@property (nonatomic, strong) UILabel *goodsCountL;
@property (nonatomic, strong) UIView *countView;
@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UILabel *countLable;
@property (nonatomic, strong) UIButton *reduceButton;
@property (nonatomic, strong) UILabel *buyNumberLabel;
@property (nonatomic, strong) UILabel *lineLable;


@end

@implementation CKConfirmOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    
    
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.layer.borderColor = [UIColor tt_borderColor].CGColor;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.left.mas_offset(10);
        if ([UIScreen mainScreen].bounds.size.height <= 568) {
            make.size.mas_offset(CGSizeMake(65, 65));
        }else{
            make.size.mas_offset(CGSizeMake(100, 100));
        }
        make.bottom.mas_offset(-15-50);
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
    
    self.textLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    self.textLable.text = @"规格：";
    [self.contentView addSubview:self.textLable];
    
    [self.textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom).offset(AdaptedHeight(6));
        make.left.equalTo(_nameLable.mas_left);
    }];
    
    //规格内容
    _standardLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_NAMETITLE_FONT];
    [self.contentView addSubview:_standardLable];
    _standardLable.text = @"";
    [_standardLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLable.mas_top);
        make.left.equalTo(self.textLable.mas_right);
    }];
    
    //价格
    _priceLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:MAIN_BoldTITLE_FONT];
    [self.contentView addSubview:_priceLable];
    _priceLable.text = @"¥0.00";
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLable.mas_left);
        make.height.mas_offset(AdaptedHeight(20));
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
    
    //数量
    _goodsCountL = [UILabel configureLabelWithTextColor:[UIColor tt_monthGrayColor] textAlignment:NSTextAlignmentRight font:MAIN_BoldTITLE_FONT];
    [self.contentView addSubview:_goodsCountL];
    _goodsCountL.hidden = YES;
    _goodsCountL.text = @"数量：";
    [_goodsCountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-AdaptedWidth(10));
        make.height.mas_offset(AdaptedHeight(20));
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
    
    
    self.lineLable = [UILabel creatLineLable];
    [self.contentView addSubview:self.lineLable];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(10);
        make.left.right.mas_offset(0);
        make.height.mas_offset(1);
    }];
    
    _buyNumberLabel =  [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    _buyNumberLabel.text = @"购买数量:";
    [self.contentView addSubview:_buyNumberLabel];
    [_buyNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(11);
        make.left.mas_offset(10);
        make.bottom.mas_offset(-10);
        make.height.equalTo(@(30));
        make.width.mas_equalTo(120);
    }];

    
    _countView = [[UIView alloc] init];
    [self.contentView addSubview:_countView];
    _countView.layer.cornerRadius = 15;
    _countView.layer.borderWidth = 1;
    _countView.layer.borderColor = CKYS_Color(130, 130, 130).CGColor;
    [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.centerY.equalTo(_buyNumberLabel.mas_centerY);
        make.size.mas_offset(CGSizeMake(110, 30));
    }];
    
    //减号按钮
    _reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_countView addSubview:_reduceButton];
    _reduceButton.tag = 1111;
    [_reduceButton setTitle:@"-" forState:UIControlStateNormal];
    [_reduceButton setTitleColor:CKYS_Color(130, 130, 130) forState:UIControlStateNormal];
    [_reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(35, 30));
    }];
    [_reduceButton addTarget:self action:@selector(clickCountButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //数字
    _countLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [_countView addSubview:_countLable];
    _countLable.text = @"1";
    _countLable.layer.borderWidth = 1;
    _countLable.layer.borderColor = CKYS_Color(130, 130, 130).CGColor;
    [_countLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(33);
        make.size.mas_offset(CGSizeMake(40, 30));
    }];
    
    //加号按钮
    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_countView addSubview:_plusButton];
    _plusButton.tag = 1112;
    [_plusButton setTitle:@"+" forState:UIControlStateNormal];
    [_plusButton setTitleColor:CKYS_Color(130, 130, 130) forState:UIControlStateNormal];
    [_plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_reduceButton.mas_top);
        make.left.equalTo(_countLable.mas_right);
        make.size.equalTo(_reduceButton);
    }];
    [_plusButton addTarget:self action:@selector(clickCountButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 点击减号 和 加号 按钮
-(void)clickCountButton:(UIButton *)button{
    
    if (self.chooseCount == 0) {
        self.chooseCount = 1;
    }
    
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
    _countLable.text = [NSString stringWithFormat:@"%zd",self.chooseCount];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GDConfrimOrderChangeBuyCount" object:nil userInfo:@{@"BuyCount":_countLable.text}];
}

#pragma mark-刷新model数据
- (void)updateCellData:(CKPickupGoodsModel*)model showCount:(BOOL)showCount {
    _goodModel = model;
    //商品图片
    
    NSString *goodUrl = [NSString stringWithFormat:@"%@",model.url];
    NSString *picUrl = [NSString loadImagePathWithString:goodUrl];
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"waitgoods"]];
    // 名称
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
    NSLog(@"自提价格%zd",priceDouble);
    
    _priceLable.text = [NSString stringWithFormat:@"¥%.2f",priceDouble];
    
    if (showCount) {
        NSString *countStr = [NSString stringWithFormat:@"%@", model.count];
        if (IsNilOrNull(countStr) || [countStr isEqualToString:@"0"]) {
            countStr = @"1";
        }
        _goodsCountL.hidden = NO;
        _goodsCountL.text = [NSString stringWithFormat:@"数量：%@", countStr];
        
        _buyNumberLabel.hidden = YES;
        _countView.hidden = YES;
        self.lineLable.hidden = YES;
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-15);
        }];
    }else{
        _goodsCountL.hidden = YES;
        _buyNumberLabel.hidden = NO;
        _countView.hidden = NO;
        self.lineLable.hidden = NO;
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-15-50);
        }];
    }
    
    
    //自提商城规格
    NSString *spec = [NSString stringWithFormat:@"%@",model.spec];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }
    _standardLable.text = spec;
    
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    //    CGContextSetStrokeColorWithColor(context, AllSeperoteLineColor.CGColor);
    //    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
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
