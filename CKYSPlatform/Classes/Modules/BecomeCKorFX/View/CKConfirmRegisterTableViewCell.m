//
//  CKConfirmRegisterTableViewCell.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/14.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKConfirmRegisterTableViewCell.h"

@implementation CKConfirmRegisterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

@implementation CKConfirmRegisterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {

    self.registTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    
    self.registTextField.backgroundColor = [UIColor whiteColor];
//    self.registTextField.delegate = self;
    [self.contentView addSubview:self.registTextField];
    [self.registTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.left.mas_offset(10);
        make.height.mas_equalTo(49);
        make.top.mas_offset(0);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [self.contentView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.height.mas_equalTo(1);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
}

- (void)setPlaceHolder:(NSString*)text {
    self.registTextField.placeholder = text;
}

- (void)setTextFieldText:(NSString*)text {
    self.registTextField.text = text;
}

@end


@implementation CKConfirmRegisterTipCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"*非大陆手机用户请在手机号码前输入国际电话区号。例如香港手机用户：0852手机号码";
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = [UIColor tt_monthGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.left.mas_offset(10);
        make.bottom.top.mas_offset(0);
    }];
}

@end

@implementation CKIdentifyCodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    self.registTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    self.registTextField.backgroundColor = [UIColor whiteColor];
    self.registTextField.placeholder = @"请输入验证码";
    [self.contentView addSubview:self.registTextField];
    [self.registTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-SCREEN_WIDTH*0.5);
        make.left.mas_offset(10);
        make.height.mas_equalTo(49);
        make.top.mas_offset(0);
    }];
    
    _countDownCode = [[STCountDownButton alloc]init];
    [self.contentView addSubview:_countDownCode];
    //设置背景颜色
    _countDownCode.backgroundColor = [UIColor clearColor];
    //设置倒计时时长
    [_countDownCode setSecond:60];
    //设置字体大小
    _countDownCode.titleLabel.font = MAIN_TITLE_FONT;
    //设置字体颜色
    [_countDownCode setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
    [_countDownCode addTarget:self action:@selector(startCountDown:)
             forControlEvents:UIControlEventTouchUpInside];
    [_countDownCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.width.mas_offset(120);
        make.height.mas_equalTo(40);
        make.top.mas_offset(5);
    }];
    
    UILabel *sepLineLabel = [UILabel creatLineLable];
    [self.contentView addSubview:sepLineLabel];
    [sepLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-5);
        make.top.mas_offset(5);
        make.right.equalTo(_countDownCode.mas_left).offset(5);
        make.width.mas_equalTo(1);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [self.contentView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.height.mas_equalTo(1);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
}

- (void)startCountDown:(STCountDownButton *)button {
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(vertifyPhoneNo:button:)]) {
        [self.delegate vertifyPhoneNo:self button:button];
    }
}

@end


@implementation CKIdCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    self.updateIDLabel = [[UILabel alloc] init];
    self.updateIDLabel.text = @"请上传证件照";
    self.updateIDLabel.textColor = [UIColor colorWithHexString:@"#C7C7CD"];
//    tipLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.updateIDLabel];
    [self.updateIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.left.mas_offset(10);
        make.height.mas_equalTo(49);
        make.top.mas_offset(0);
    }];
    
    UILabel *lineLabel = [UILabel creatLineLable];
    [self.contentView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.height.mas_equalTo(1);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
}

@end



