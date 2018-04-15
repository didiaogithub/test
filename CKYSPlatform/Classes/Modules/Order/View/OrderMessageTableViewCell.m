//
//  OrderMessageTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/7/6.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "OrderMessageTableViewCell.h"

@interface OrderMessageTableViewCell()
{
    UILabel *secondLineLable;
    UILabel *firstLineLable;
    UIView *_bankView;
    NSString *statusNameString;
    NSString *leftCancelString;
    NSString *rightStatusString;
    NSString *modelStatus;
    NSString *itemIdString;
    NSString *commentString;
    UILabel *lineLable;
}

/** 订单号*/
@property(nonatomic,strong)UILabel *orderNumberLable;
/** 订单状态*/
@property(nonatomic,strong)UILabel *orderStateLable;
/**购买商品图标*/
@property(nonatomic,strong)UIImageView *goodsImageView;
/**商品描述*/
@property(nonatomic,strong)UILabel *descriptionLable;
/**商品数量*/
@property(nonatomic,strong)UILabel *numberLable;
/**商品价格*/
@property(nonatomic,strong)UILabel *priceLable;
/**总金额*/
@property(nonatomic,strong)UILabel *totalFeeLable;
/**下单时间*/
@property(nonatomic,strong)UILabel *timeLable;

@end

@implementation OrderMessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    //底层view
    _bankView = [[UIView alloc] init];
    [self.contentView addSubview:_bankView];
    [_bankView setBackgroundColor:[UIColor whiteColor]];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    UILabel *bankLable = [[UILabel alloc] init];
    [_bankView addSubview:bankLable];
    bankLable.backgroundColor = [UIColor tt_littleGrayBgColor];
    [bankLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_bankView);
        make.left.mas_offset(3);
        make.right.mas_offset(-3);
    }];

    
    //左边商品图标
    _goodsImageView = [[UIImageView alloc] init];
    _goodsImageView.layer.borderColor = [UIColor tt_borderColor].CGColor;
    _goodsImageView.layer.borderWidth = 1;
    [_bankView addSubview:_goodsImageView];
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(7));
        make.left.mas_offset(AdaptedWidth(10));
        make.size.mas_offset(CGSizeMake(AdaptedWidth(80), AdaptedWidth(80)));
    }];
    
    lineLable = [[UILabel alloc] init];
    lineLable.backgroundColor = [UIColor whiteColor];
    [_bankView addSubview:lineLable];
   
    _descriptionLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT]; //15
    [_bankView addSubview:_descriptionLable];
   
   
     //数量
    _numberLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [_bankView addSubview:_numberLable];
    
    
    //商品单价
    _priceLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:CHINESE_SYSTEM_BOLD(AdaptedHeight(15))]; //14
    [_bankView addSubview:_priceLable];
    
    
    [_descriptionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsImageView.mas_top);
        make.left.equalTo(_goodsImageView.mas_right).offset(AdaptedWidth(10));
        make.right.mas_offset(-AdaptedWidth(120));
        
    }];
    
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descriptionLable.mas_top);
        make.right.mas_offset(-AdaptedWidth(10));
        make.left.equalTo(_descriptionLable.mas_right).offset(10);
    }];
    
    [_numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLable.mas_bottom).offset(AdaptedHeight(15));
        make.right.equalTo(_priceLable.mas_right);
        
    }];
    
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsImageView.mas_bottom).offset(AdaptedHeight(7));
        make.left.right.mas_offset(0);
        make.height.mas_offset(3);
        make.bottom.mas_offset(0);
    }];
}

-(void)refreshWithModel:(Ordersheet *)model {
    self.detailModel = model;
    NSString *url = [NSString stringWithFormat:@"%@",model.url];
    NSString *picUrl = [NSString loadImagePathWithString:url];
  
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"waitgoods"]];
    NSString *name = [NSString stringWithFormat:@"%@",model.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _descriptionLable.text = name;
     itemIdString = [NSString stringWithFormat:@"%@",model.itemid];
    _descriptionLable.numberOfLines = 0;
   
    //数量
    NSString *countStr = [NSString stringWithFormat:@"%@",model.count];
    if (IsNilOrNull(countStr)) {
        countStr = @"";
    }
    _numberLable.text = [NSString stringWithFormat:@"x%@",countStr];
   
    
    //价格
    NSString *priceStr = [NSString stringWithFormat:@"%@",model.price];
    if (IsNilOrNull(priceStr)) {
        priceStr = @"0.00";
    }
    _priceLable.text = [NSString stringWithFormat:@"¥%@",priceStr];
}


@end
