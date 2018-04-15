//
//  SaveView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SaveView.h"

@implementation SaveView
-(instancetype)initWithFrame:(CGRect)frame andTitleStr:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        [self createUIWithTitle:title];
    }
    return self;
}
-(void)createUIWithTitle:(NSString *)title{
  
    //保存按钮
    _saveImageView = [[UIImageView alloc] init];
    [_saveImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [self addSubview:_saveImageView];
    _saveImageView.userInteractionEnabled = YES;
    _saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_saveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(AdaptedWidth(AdaptedWidth(20)));
        make.right.mas_offset(-AdaptedWidth(20));
        make.bottom.mas_offset(-AdaptedHeight(6));
        make.height.mas_offset(AdaptedHeight(40));

    }];

    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveImageView addSubview:_saveButton];
    _saveButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [_saveButton setTitle:title forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_saveImageView);
    }];
    [_saveButton addTarget:self action:@selector(clickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickSaveButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveInfo)]) {
        [self.delegate saveInfo];
    }
}
@end
