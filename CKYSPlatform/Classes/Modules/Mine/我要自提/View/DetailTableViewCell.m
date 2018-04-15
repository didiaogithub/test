//
//  DetailTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/21.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "DetailTableViewCell.h"
@interface DetailTableViewCell ()
{
    UILabel *_rightLine;
    UILabel *horizalLable;
    UILabel *textLable;

}

@end
@implementation DetailTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(-5);
        
    }];
    //名称
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_nameLable];
    _nameLable.numberOfLines = 0;
    _nameLable.text = @"";
    [_nameLable sizeToFit];
    
    
    //右边的线
    _rightLine = [UILabel creatLineLable];
    [bankView addSubview:_rightLine];
    
    //分享按钮
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_shareButton];
    [_shareButton setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    
    //当前价格
    _priceLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(17))];
    [bankView addSubview:_priceLable];
    _priceLable.text = @"¥0.00";
    
    //原价
    _originalPriceLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_originalPriceLable];
    _originalPriceLable.text = @"";
    
    //横线
    horizalLable = [UILabel creatLineLable];
    [bankView addSubview:horizalLable];
    
    //规格
    textLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(AdaptedWidth(17))];
    [bankView addSubview:textLable];
    textLable.text = @"规格：";
    
    //保湿补水
    _standardLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_standardLable];
    _standardLable.text = @"保湿补水";
    CGSize nameSize = [_nameLable.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH*3/4, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(5);
        make.width.mas_offset(SCREEN_WIDTH*3/4);
        make.height.mas_offset(nameSize.height);
    }];
   
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(8);
        make.left.equalTo(_nameLable.mas_right);
        make.size.mas_offset(CGSizeMake(1, 50));
    }];
    
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_top);
        make.left.equalTo(_rightLine.mas_right);
        make.right.mas_offset(-10);
        make.height.equalTo(_rightLine.mas_height);
    }];


    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom).offset(5);
        make.left.equalTo(_nameLable.mas_left);
        make.height.mas_offset(18);
        
    }];
    
    [_originalPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLable.mas_top).offset(1);
        make.left.equalTo(_priceLable.mas_right).offset(8);
        make.height.mas_offset(15);
    }];
    
    [horizalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_originalPriceLable.mas_top).offset(7.5);
        make.left.equalTo(_originalPriceLable.mas_left);
        make.width.equalTo(_originalPriceLable.mas_width);
        make.height.mas_offset(1);
    }];

    
    [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLable.mas_bottom).offset(5);
        make.left.equalTo(_priceLable.mas_left);
        make.bottom.mas_offset(-15);
    }];
    
    [_standardLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLable.mas_top);
        make.left.equalTo(textLable.mas_right);
        make.bottom.equalTo(textLable.mas_bottom);
    }];
    
    

}
@end
