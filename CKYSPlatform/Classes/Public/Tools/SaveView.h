//
//  SaveView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/7/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaveViewDelegate <NSObject>
-(void)saveInfo;
@end

@interface SaveView : UIView
@property(nonatomic,weak)id<SaveViewDelegate>delegate;
@property(nonatomic,strong)UIImageView *saveImageView;
@property(nonatomic,strong)UIButton *saveButton;
-(instancetype)initWithFrame:(CGRect)frame andTitleStr:(NSString *)title;
@end
