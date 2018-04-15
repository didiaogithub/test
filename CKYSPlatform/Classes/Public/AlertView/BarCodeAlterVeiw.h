//
//  XWAlterVeiw.h
//  XWAleratView
//
//  Created by 庞宏侠 on 15/12/25.
//  Copyright © 2015年 庞宏侠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BarCodeAlterVeiwDelegate <NSObject>
-(void)saveToPhotobuttonClicked;

@end

@interface BarCodeAlterVeiw : UIView
@property(nonatomic,weak)id<BarCodeAlterVeiwDelegate>delegate;
@property (nonatomic, strong) UIView *bigView;
@property(nonatomic,strong)UILabel *titleLable;
@property (nonatomic, strong) UIImageView  *titleImageView;
@property(nonatomic,strong)UIButton *saveButton;
@property(nonatomic,strong)UIButton *cancelBtn;

- (void)show;
@end
