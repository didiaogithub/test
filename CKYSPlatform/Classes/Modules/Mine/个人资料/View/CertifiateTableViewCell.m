//
//  CertifiateTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/28.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "CertifiateTableViewCell.h"

@implementation CertifiateTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
   
    _showLeftLable = [UILabel configureLabelWithTextColor:SubTitleColor textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [self.contentView addSubview:_showLeftLable];
    [_showLeftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        
        make.bottom.mas_offset(-15);
    }];
    
    _showSwitch = [[UISwitch alloc] init];
    [self.contentView addSubview:_showSwitch];
    _showSwitch.on = YES;
    _showSwitch.onTintColor = [UIColor redColor];
    // 控件大小，不能设置frame，只能用缩放比例
    _showSwitch.transform = CGAffineTransformMakeScale(1, 1);
    [_showSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(8);
        make.right.mas_offset(-30);
        make.size.mas_offset(CGSizeMake(50, 30));
        make.bottom.mas_offset(-8);
    }];

}
@end
