//
//  CurrentTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/20.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CurrentTableViewCell.h"

@implementation CurrentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSString *)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUIWithType:type];
    }
    return self;
}
-(void)createUIWithType:(NSString *)typestr{
    _currentCityLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BODYTITLE_FONT];
    [self.contentView addSubview:_currentCityLable];
    [_currentCityLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(10);
        make.bottom.mas_offset(0);
    }];
    
    
    _rightImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_rightImageView];
    [_rightImageView setImage:[UIImage imageNamed:@"address"]];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(13);
        make.bottom.mas_offset(-13);
        make.right.mas_offset(-10);
        make.width.mas_offset(26);
        make.height.mas_offset(24);
    }];
    
    _rightLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    [self.contentView addSubview:_rightLable];
    _rightLable.text = @"选择城市";
    [_rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(-40);
        make.width.mas_offset(70);
    }];
    
    if ([typestr isEqualToString:@"0"]){
        _rightLable.hidden = NO;
    }else{
       _rightLable.hidden = YES;

    }
}
-(void)refreshWithCurrentStr:(NSString *)cityString{
    _currentCityLable.text = [NSString stringWithFormat:@"当前:%@",cityString];
    
    
    
    

}
-(void)refreshWithModel:(SelecteAreaModel *)provinceModel{
    NSString *name = [NSString stringWithFormat:@"%@",provinceModel.name];
    if (IsNilOrNull(name)) {
        name = @"";
    }
    _currentCityLable.text = name;

}
@end
