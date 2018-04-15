//
//  CKSearchView.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/11/10.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKSearchView.h"

@interface CKSearchView ()<UITextFieldDelegate>


@end

@implementation CKSearchView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [self addSubview:bankImageView];
    bankImageView.userInteractionEnabled = YES;
    [bankImageView setImage:[UIImage imageNamed:@"searchvcbank"]];
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(35);
    }];
    
    _searchTextField = [[UITextField alloc] init];
    _searchTextField.backgroundColor = [UIColor clearColor];
    _searchTextField.placeholder = @"请输入您要查询的姓名或电话号码";
    _searchTextField.returnKeyType = UIReturnKeySearch;
    [_searchTextField setValue:MAIN_TITLE_FONT forKeyPath:@"_placeholderLabel.font"];
    _searchTextField.delegate = self;
    [bankImageView addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_offset(0);
        make.left.mas_offset(15);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_searchTextField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchKeyWords:)]) {
        [self.delegate searchKeyWords:textField.text];
    }
    return YES;
}

@end
