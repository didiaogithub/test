//
//  CKConfirmRegisterTableViewCell.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/14.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKConfirmRegisterCell : UITableViewCell

@end

@interface CKConfirmRegisterTableViewCell : CKConfirmRegisterCell

@property (nonatomic, strong) UITextField *registTextField;

- (void)setPlaceHolder:(NSString*)text;

- (void)setTextFieldText:(NSString*)text;

@end

@interface CKConfirmRegisterTipCell : CKConfirmRegisterCell
@property (nonatomic, strong) UITextField *registTextField;
@end

@class CKIdentifyCodeCell;
@protocol CKIdentifyCodeCellwDelegate <NSObject>

-(void)vertifyPhoneNo:(CKIdentifyCodeCell*)cell button:(STCountDownButton *)button;

@end

@interface CKIdentifyCodeCell : CKConfirmRegisterCell

@property (nonatomic, strong) STCountDownButton *countDownCode;
@property (nonatomic, strong) UITextField *registTextField;
@property (nonatomic, weak) id<CKIdentifyCodeCellwDelegate> delegate;

@end

@interface CKIdCardCell : CKConfirmRegisterCell

@property (nonatomic, strong) UILabel *updateIDLabel;

@end
