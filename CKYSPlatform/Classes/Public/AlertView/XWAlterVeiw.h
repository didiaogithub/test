//
//  XWAlterVeiw.h
//  XWAleratView
//
//  Created by 庞宏侠. on 15/12/25.
//  Copyright © 2015年 庞宏侠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XWAlterVeiwDelegate <NSObject>

@optional
- (void)subuttonClicked;

@end

@interface XWAlterVeiw : UIView

@property(nonatomic,weak)id<XWAlterVeiwDelegate>delegate;
@property (nonatomic, strong) UIView *bigView;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UIImageView *bankImageView;

@property(nonatomic,strong)UIButton *sureBut;
@property(nonatomic,strong)UIButton *cancelBtn;

- (void)show;


@property (nonatomic, copy) NSString *type;

@end
