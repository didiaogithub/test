//
//  PersonalAttractiveTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/4/2.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "PersonalAttractiveTableViewCell.h"

@implementation PersonalAttractiveTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTypeStr:(NSString *)typestr{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTopViewsWithStr:typestr];
    }
    return self;
}
-(void)createTopViewsWithStr:(NSString *)typestr{
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(0);
        make.bottom.mas_offset(-1);
    }];
    
    _nameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_nameLable];
    
    
    //电话
    _phoneLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_phoneLable];
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedWidth(15));
        make.left.mas_offset(AdaptedWidth(40));
    }];
    [_phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLable.mas_bottom).offset(AdaptedHeight(8));
        make.left.equalTo(_nameLable.mas_left);
        make.bottom.mas_offset(-AdaptedHeight(15));
    }];
    
    
    _rightLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_rightLable];
    
    if ([typestr isEqualToString:@"1"]) { //个人招商
        [_rightLable setTextColor:SubTitleColor];
        [_rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLable.mas_top);
            make.right.mas_offset(-AdaptedHeight(15));
        }];
        

    }else if ([typestr isEqualToString:@"2"]){ //团队招商

        [_rightLable setTextColor:TitleColor];
        [_rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_phoneLable.mas_top);
            make.bottom.equalTo(_phoneLable.mas_bottom);
            make.left.equalTo(_phoneLable.mas_right).offset(AdaptedWidth(30));
        }];
    }

}
-(void)cellfreshWithModel:(RechargeAndAttactiveModel *)personalModel{
    
    //团队招商name num mobile
    NSString *nameStr = [NSString stringWithFormat:@"%@",personalModel.name];
    if (IsNilOrNull(nameStr)) {
        nameStr = @"";
    }
    //个人招商 jointime（包含时分秒） jointype realname time（不包含时分秒）

    NSString *realNameStr = [NSString stringWithFormat:@"%@",personalModel.realname];
    if (IsNilOrNull(realNameStr)) {
        realNameStr = @"";
    }
    NSString *jointypeStr = [NSString stringWithFormat:@"%@",personalModel.jointype];
    if (IsNilOrNull(jointypeStr)) {
        jointypeStr = @"";
    }
    NSString *jointimeStr = [NSString stringWithFormat:@"%@",personalModel.jointime];
    if (IsNilOrNull(jointimeStr)) {
        jointimeStr = @"";
    }
    if ([self.typeStr isEqualToString:@"1"]){ //个人招商 右侧时间 类型
        NSString *typestr = nil;
        if([jointypeStr isEqualToString:@"SURE"]) {
            typestr = @"创客礼包";
        }else if([jointypeStr isEqualToString:@"NOTSURE"]){
            typestr = @"低风险礼包";
        }else if([jointypeStr isEqualToString:@"GROUP"]){
            typestr = @"金凤";
        }else{
            typestr = @"";
        }
        
        _nameLable.text = [NSString stringWithFormat:@"姓名:%@(%@)",realNameStr,typestr];
        //时间
        _rightLable.text = jointimeStr;
    }else if ([self.typeStr isEqualToString:@"2"]){//团队招商 右侧是招商
        _nameLable.text = [NSString stringWithFormat:@"姓名:%@",nameStr];
        //团队招商人数
        NSString *numStr = [NSString stringWithFormat:@"%@",personalModel.num];
        if (IsNilOrNull(numStr)) {
            numStr = @"";
        }
       _rightLable.text = [NSString stringWithFormat:@"创客礼包推广数:%@套",numStr];
    
    }
    //电话公用的
    NSString *mobileStr = [NSString stringWithFormat:@"%@",personalModel.mobile];
    if (IsNilOrNull(mobileStr)) {
        mobileStr = @"";
    }
    _phoneLable.text = [NSString stringWithFormat:@"电话:%@",mobileStr];

}

@end
