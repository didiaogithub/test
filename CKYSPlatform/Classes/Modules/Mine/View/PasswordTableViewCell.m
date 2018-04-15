//
//  PasswordTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/31.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "PasswordTableViewCell.h"

@implementation PasswordTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTableView];
    }
    return self;
}
-(void)createTableView{
    
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(3);
        make.right.mas_offset(-3);
        make.bottom.mas_offset(0);
    }];
    
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [bankView addSubview:bankImageView];
    [bankImageView setImage:[UIImage resizedImage:@"shadowbank"]];
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bankView);
    }];
    
    _leftLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_SUBTITLE_FONT];
    [bankView addSubview:_leftLable];
    _leftLable.text = @"修改密码";
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.bottom.mas_offset(-10);
        make.height.mas_offset(20);
        make.left.mas_offset(8);
        make.right.mas_offset(-8);
    }];



}

@end
