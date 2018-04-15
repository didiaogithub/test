//
//  CityTableViewCell.m
//  MySelectCityDemo
//
//  Created by ZJ on 15/10/28.
//  Copyright © 2015年 WXDL. All rights reserved.
//

#import "CityTableViewCell.h"
@implementation CityTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0  blue:245/255.0  alpha:1];
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_locationButton];
    [_locationButton setTitleColor:[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1] forState:0];
    [_locationButton addTarget:self action:@selector(clickLocationButton) forControlEvents:UIControlEventTouchUpInside];
    [_locationButton setBackgroundColor:[UIColor whiteColor]];
    
    _locationButton.layer.borderWidth = 0.5;
    _locationButton.layer.borderColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
    _locationButton.layer.cornerRadius = 5;
    
    [_locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        make.bottom.mas_offset(-15);
        make.width.mas_offset(SCREEN_WIDTH/3-30);
        make.height.mas_offset(45);
    }];
    
}
-(void)refreshCurrentCity:(NSString *)currentStr{
    [_locationButton setTitle:currentStr forState:UIControlStateNormal];

}
-(void)setTransBlock:(selectedBlock)transBlock{
    _transBlock = transBlock;
}
-(void)clickLocationButton{
    if (self.transBlock) {
        self.transBlock(self.provinceStr);
    }

}
@end
