//
//  XWAlterVeiw.h
//  XWAleratView
//
//  Created by 温仲斌 on 15/12/25.
//  Copyright © 2015年 温仲斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SEXAlterVeiwDelegate <NSObject>
-(void)selectedSexClickedWithTag:(UIButton *)button;

@end

@interface SEXAlterVeiw : UIView
@property(nonatomic,weak)id<SEXAlterVeiwDelegate>delegate;
@property (nonatomic, strong) UIView *bigView;
@property(nonatomic,strong)UIButton *boyButton;
@property(nonatomic,strong)UIButton *girlButton;
@property (nonatomic, strong) UIButton  *secreteButton;
- (void)show;
@end
