//
//  CKSearchView.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2017/11/10.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CKSearchNavViewDelegate <NSObject>

-(void)searchKeyWords:(NSString *)keyWords;

@end
@interface CKSearchView : UIView

@property (nonatomic, weak) id<CKSearchNavViewDelegate>delegate;
@property (nonatomic, strong) UITextField *searchTextField;

@end
