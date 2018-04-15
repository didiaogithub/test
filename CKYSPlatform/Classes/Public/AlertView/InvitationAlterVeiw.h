//
//  XWAlterVeiw.h
//  XWAleratView
//
//  Created by 温仲斌 on 15/12/25.
//  Copyright © 2015年 温仲斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InvitationAlterVeiwDelegate <NSObject>
-(void)copyInvitationCode;

@end

@interface InvitationAlterVeiw : UIView
@property(nonatomic,weak)id<InvitationAlterVeiwDelegate>delegate;
@property (nonatomic, strong) UIView *bigView;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UIImageView *bankImageView;
@property (nonatomic, strong)UILabel *noticeLable;
@property(nonatomic,strong)UIButton *sureBut;
@property(nonatomic,strong)UIButton *cancelBtn;

- (void)show;
@end
