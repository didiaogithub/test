//
//  WLNetworkReloaderView.m
//  WLPlaceHolder
//
//  Created by 王林 on 16/5/11.
//  Copyright © 2016年 com.ptj. All rights reserved.
//

#import "NodataLableView.h"

@interface NodataLableView ()

@end

@implementation NodataLableView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return  self;
}
- (void) setup
{
    self.backgroundColor = [UIColor tt_grayBgColor];
    [self addSubview:self.nodataLabel];

}

- (UILabel *)nodataLabel
{
    if(_nodataLabel == nil) {
        _nodataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height/2-10, self.frame.size.width, 20)];
        _nodataLabel.text = @"暂无数据";
        _nodataLabel.textAlignment = NSTextAlignmentCenter;
        _nodataLabel.textColor = SubTitleColor;
        _nodataLabel.font = MAIN_TITLE_FONT;
    }
    return  _nodataLabel;
}

@end
