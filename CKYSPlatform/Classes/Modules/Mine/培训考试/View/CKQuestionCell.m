//
//  CKQuestionCell.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/22.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKQuestionCell.h"

@implementation CKTestCell

-(void)fillData:(id)data {
    
}

-(void)callWithParameter:(id)parameter {
    
}

+(CGFloat)computeHeight:(id)data {
    return 0;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


@interface CKQuestionCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *questionLabel;

@end

@implementation CKQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    self.backgroundColor = [UIColor whiteColor];
    
    self.bgView = [UIView new];
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
    }];
    
    
    self.questionLabel = [UILabel new];
    [self.bgView addSubview:self.questionLabel];
    self.questionLabel.text = @"1、类人胶原蛋白是谁带领点点滴滴";
    self.questionLabel.numberOfLines = 0;
    self.questionLabel.font = [UIFont systemFontOfSize:15];
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.top.mas_offset(10);
    }];
}

-(void)fillData:(id)data {
    if (!data) {
        return;
    }
    NSString *question = [NSString stringWithFormat:@"%@", data[@"data"]];
    self.questionLabel.text = question;
}

+(CGFloat)computeHeight:(id)data {
    
    NSString *question = data;
    CGSize s = [question boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;

    return 10+s.height;
}

@end


@interface CKAnswerCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, copy)   NSString *questionTypeName;
@property (nonatomic, strong) CKOptionModel *optionModel;

@end

@implementation CKAnswerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    self.backgroundColor = [UIColor whiteColor];
    
    self.bgView = [UIView new];
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
    }];
    
    
    self.selectBtn = [[UIButton alloc] init];
    [self.selectBtn setImage:[UIImage imageNamed:@"selectedgray"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"selectedred"] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(selectAnswer) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.top.mas_offset(20);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    
    self.answerLabel = [UILabel new];
    [self.bgView addSubview:self.answerLabel];
    self.answerLabel.text = @" ";
    self.answerLabel.numberOfLines = 0;
    self.answerLabel.font = [UIFont systemFontOfSize:13];
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn.mas_right).offset(10);
        make.right.mas_offset(-10);
        make.top.equalTo(self.selectBtn.mas_top);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAnswer)];
    [self.contentView addGestureRecognizer:tap];
}

-(void)fillData:(id)data {
    if (!data) {
        return;
    }
    NSDictionary *dataDic = data;
    
    
    NSString *optionIndex = dataDic[@"optionIndex"];
    self.selectBtn.tag = 666+[optionIndex integerValue];
    
    CKOptionModel *optionM = dataDic[@"data"];
    
    self.optionModel = optionM;
    self.selectBtn.selected = optionM.isSelected;
    
    self.questionTypeName = dataDic[@"questionTypeName"];
    
    if ([self.questionTypeName isEqualToString:@"多选题"]) {
        [self.selectBtn setImage:[UIImage imageNamed:@"multiUnSelected"] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"multiSelected"] forState:UIControlStateSelected];
        
    }else{
        [self.selectBtn setImage:[UIImage imageNamed:@"selectedgray"] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"selectedred"] forState:UIControlStateSelected];
    }
    
    
    CGFloat h = 0;
    CGSize s = [optionM.selectcontent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    if (s.height < 30) {
        h += 30 + 10;
    }else{
        h += s.height + 10;
    }
    
    self.answerLabel.text = optionM.selectcontent;
    
    [self.answerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn.mas_right).offset(10);
        make.right.mas_offset(-10);
        make.top.equalTo(self.selectBtn.mas_top);
        if (s.height < 30) {
            make.height.mas_equalTo(30);
        }else{
            make.height.mas_equalTo(s.height+10);
        }
    }];
    
}

- (void)selectAnswer {
//    self.selectBtn.selected = !self.selectBtn.selected;
//    self.optionModel.isSelected = self.selectBtn.selected;
    
    self.optionModel.isSelected = !self.optionModel.isSelected;

    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectAnswerOption:selectedIndex:optionModel:)]) {
        [self.delegate didSelectAnswerOption:self selectedIndex:self.selectBtn.tag-666 optionModel:self.optionModel];
    }
}

+(CGFloat)computeHeight:(id)data {
    if (!data) {
        return 30;
    }
    CKOptionModel *optionM = data;
    CGSize s = [optionM.selectcontent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    if (s.height < 30) {
        return 30 + 30;
    }else{
        return s.height + 30;
    }
}

@end
