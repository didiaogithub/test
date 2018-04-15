//
//  KKDatePickerView.h
//  PickerView
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKDatePickerViewModel.h"
#import "AppDelegate.h"
@protocol KKDatePickerViewDelegate <NSObject>

- (void)pickView:(NSString *)yes month:(NSString *)moth;


@end
@interface KKDatePickerView : UIView
{
   UIView *bankView;

}
@property(nonatomic,weak)id<KKDatePickerViewDelegate>delegate;
@property (strong, nonatomic)UIPickerView *pickerView;
@property (nonatomic, strong)KKDatePickerViewModel *model ;
- (void)show;

-(instancetype)initWithFrame:(CGRect)frame;
@end
