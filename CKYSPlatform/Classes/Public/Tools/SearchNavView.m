//
//  SearchNavView.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/4/5.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SearchNavView.h"

@implementation SearchNavView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        [CKCNotificationCenter addObserver:self selector:@selector(searchSucess:) name:SearchSuccess object:nil];
    }
    return self;
}

-(void)searchSucess:(NSNotification *)notice{
    NSString *string = [NSString stringWithFormat:@"%@",notice.object];
    if ([string isEqualToString:@"YES"]){
        _searchButton.userInteractionEnabled = YES;
    }
}
-(void)createUI{
//    [self setBackgroundColor:[UIColor whiteColor]];

    //搜索文字
    _searchLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:NAV_BAR_FONT];
    [self addSubview:_searchLable];
    _searchLable.text = @"搜索";
    [_searchLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.mas_offset(0);
        make.width.mas_offset(45);
        make.height.mas_offset(40);
    }];

    
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [self addSubview:bankImageView];
    bankImageView.userInteractionEnabled = YES;
    [bankImageView setImage:[UIImage imageNamed:@"searchvcbank"]];
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_searchLable.mas_right);
        make.right.mas_offset(-AdaptedWidth(46));
        make.height.mas_offset(35);
    }];
 
    _searchTextField = [[UITextField alloc] init];
    _searchTextField.backgroundColor = [UIColor clearColor];
    _searchTextField.placeholder = @"请输入您要搜索的内容";
    _searchTextField.returnKeyType = UIReturnKeySearch;
    [_searchTextField setValue:MAIN_TITLE_FONT forKeyPath:@"_placeholderLabel.font"];
    _searchTextField.delegate = self;
    [bankImageView addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_offset(0);
        make.left.mas_offset(15);
    }];
    
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_cancelButton];
    _cancelButton.tag = 450;
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = MAIN_TITLE_FONT;
    [_cancelButton setTitleColor:SubTitleColor forState:UIControlStateNormal];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_offset(AdaptedWidth(30));
        make.height.mas_offset(40);
    }];
    [_cancelButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark-返回按钮点击
-(void)clickBackButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(poptoLastPage)]) {
        [self.delegate poptoLastPage];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_searchTextField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardSearchWithString:)]) {
        [self.delegate keyboardSearchWithString:textField.text];
    }
    return YES;
}

-(void)dealloc{
    [CKCNotificationCenter removeObserver:self];
}

@end
