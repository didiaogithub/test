//
//  RouteView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/13.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RouteViewDelegate <NSObject>
-(void)nowToCheckRoute;
@end

@interface RouteView : UIView
@property(nonatomic,weak)id<RouteViewDelegate>delegate;
/**地址*/
@property (nonatomic, strong) UILabel *addressLable;
/**详细地址*/
@property (nonatomic, strong)UILabel *detailAddressLable;
/**导航图标*/
@property (nonatomic, strong)UIButton *routeButton;
@end
