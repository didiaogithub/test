//
//  AllPresaleShopTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/10.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "AllPresaleShopTableViewCell.h"

@implementation AllPresaleShopTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTopViews];
    }
    return self;
}
-(void)createTopViews{
    
    UIView*bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(2);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    _headImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_headImageView];
    [_headImageView setImage:[UIImage imageNamed:@"name"]];
    _headImageView.layer.cornerRadius = AdaptedWidth(40)/2;
    _headImageView.clipsToBounds = YES;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(20));
        make.left.mas_offset(AdaptedWidth(10));
        make.width.mas_offset(AdaptedWidth(40));
        make.height.mas_offset(AdaptedWidth(40));
        make.bottom.mas_offset(-AdaptedHeight(20));
    }];
    
    //姓名
    _topLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_topLable];
    _topLable.text = @"姓名：";
    [_topLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(18));
        make.left.equalTo(_headImageView.mas_right).offset(AdaptedWidth(8));
    }];
    
    //时间 或者 邀请码文字
    _leftTextLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_leftTextLable];
    _leftTextLable.text = @"开店时间：";
    [_leftTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_topLable.mas_left);
        make.bottom.mas_offset(-AdaptedHeight(18));
    }];
    
    //底下一行
    _bottomLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM(15)];
    [self.contentView addSubview:_bottomLable];

    [_bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftTextLable.mas_top);
        make.left.equalTo(_leftTextLable.mas_right);
        make.bottom.equalTo(_leftTextLable.mas_bottom);
    }];

    
    //复制按钮
    _codeCopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_codeCopyButton];
    _codeCopyButton.hidden = YES;
    _codeCopyButton.tag = 1200;
    [_codeCopyButton setTitle:@"复制" forState:UIControlStateNormal];
    _codeCopyButton.titleLabel.font = ALL_ALERT_FONT;
    [_codeCopyButton setTitleColor:[UIColor tt_blueColor] forState:UIControlStateNormal];
    [_codeCopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomLable.mas_top);
        make.left.equalTo(_bottomLable.mas_right).offset(AdaptedWidth(10));
        make.bottom.equalTo(_bottomLable.mas_bottom);
    }];
    [_codeCopyButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //右侧按钮
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_rightButton];
    _rightButton.layer.cornerRadius = 5;
    _rightButton.clipsToBounds = YES;
    
    _rightButton.titleLabel.font = CHINESE_SYSTEM_BOLD(15);
    _rightButton.tag = 1201;
    [_rightButton.titleLabel setNumberOfLines:3];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightButton.backgroundColor = [UIColor tt_greenColor];

    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(8));
        make.right.mas_offset(-10);
        make.bottom.mas_offset(-AdaptedHeight(8));
        make.width.mas_offset(60);
    }];
    [_rightButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightButton.backgroundColor = [UIColor greenColor];


}
-(void)refreshWithModel:(PresaleDetailModel *)presaleModel{
    NSString *path = [NSString stringWithFormat:@"%@",presaleModel.headurl];
    NSString *picUrl = [NSString loadImagePathWithString:path];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"name"]];

    //姓名或者状态
    NSString *nameStr = [NSString stringWithFormat:@"%@",presaleModel.realname];
    if (IsNilOrNull(nameStr)) {
        nameStr = @"";
    }
    //开店时间
    NSString *joinTimeStr = [NSString stringWithFormat:@"%@",presaleModel.jointime];
    if (IsNilOrNull(joinTimeStr)) {
        joinTimeStr = @"";
    }
    //邀请码
    NSString *preyqcodeStr = [NSString stringWithFormat:@"%@",presaleModel.preyqcode];
    if (IsNilOrNull(preyqcodeStr)) {
        preyqcodeStr = @"";
    }
    
    /**以下姓名 和状态之间空格 是为了 和时间保持一致 不要轻易去掉空格  */
    
    //预售店铺状态
    NSString *statusString = [NSString stringWithFormat:@"%@",presaleModel.status];
    //已售出   //显示姓名 开店时间 //右侧显示已完成图片不能点击
    if([statusString isEqualToString:@"已开通"]){
        //显示
        [_rightButton setImage:[UIImage imageNamed:@"shopsuccess"] forState:UIControlStateNormal];
        [_rightButton setBackgroundColor:[UIColor whiteColor]];
        //隐藏
        _codeCopyButton.hidden = YES;
        _rightButton.userInteractionEnabled = NO;
        //赋值
        _topLable.text = [NSString stringWithFormat:@"姓       名: %@",nameStr];
        _leftTextLable.text = @"开店时间: ";
        _bottomLable.text =  joinTimeStr;
    }else if([statusString isEqualToString:@"待开通"]){
    //待开通   //显示姓名 开店时间 //右侧显示待开通 可点击 弹框 确认开通
        //显示  右侧显示文字待开通
        [_rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_rightButton setBackgroundColor:[UIColor tt_greenColor]];
        NSString *typeStr = @"待开通";
        NSString *verText = [typeStr VerticalString];
        [_rightButton setTitle:verText forState:UIControlStateNormal];
         //隐藏
        _codeCopyButton.hidden = YES;
        _rightButton.userInteractionEnabled = YES;
        //赋值
         _topLable.text = [NSString stringWithFormat:@"姓       名: %@",nameStr];
        _leftTextLable.text = @"开店时间: ";
        //第二行
        _bottomLable.text =  @"-";
    }else if([statusString isEqualToString:@"未出售"]){
    //显示状态 邀请码 //右侧显示待出售不可点击 复制按钮直接复制二维码
        //显示
         [_rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        NSString *typeStr = @"待出售";
        NSString *verText = [typeStr VerticalString];
        [_rightButton setTitle:verText forState:UIControlStateNormal];
        [_rightButton setBackgroundColor:[UIColor darkGrayColor]];
        //隐藏
        _codeCopyButton.hidden = NO;
        _codeCopyButton.userInteractionEnabled = YES;
        _rightButton.userInteractionEnabled = YES;
        //赋值
       _leftTextLable.text = @"邀  请  码: ";
        _topLable.text = @"状       态: 未出售";
        _bottomLable.text = preyqcodeStr;
    }else if([statusString isEqualToString:@"已回收"]){
        //显示
        [_rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        NSString *typeStr = @"已回收";
        NSString *verText = [typeStr VerticalString];
        [_rightButton setTitle:verText forState:UIControlStateNormal];
        [_rightButton setBackgroundColor:[UIColor tt_redMoneyColor]];
        [_rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //隐藏
        _codeCopyButton.hidden = NO;
        _codeCopyButton.userInteractionEnabled = NO;
        _rightButton.userInteractionEnabled = NO;
        //赋值
        _topLable.text = @"状       态: 已回收";
        _leftTextLable.text = @"邀  请  码:";
        _bottomLable.text = preyqcodeStr;

    }
}
#pragma mark-点击右侧按钮
-(void)clickButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickDeatailButton:Index:andSection:)]) {
        [self.delegate clickDeatailButton:button Index:self.index andSection:self.section];
    }

}
@end
