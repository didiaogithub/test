//
//  CKLevelLineView.h
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/7.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CKLevelLineDelegate <NSObject>

-(void)clickLevelPoint:(NSInteger)index;

@end

@interface CKLevelLineView : UIView


@property BOOL select;
@property (nonatomic, weak) id<CKLevelLineDelegate> delegate;

@end
