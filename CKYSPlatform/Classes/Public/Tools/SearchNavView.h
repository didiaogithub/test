//
//  SearchNavView.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/4/5.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchNavViewDelegate <NSObject>

@optional

-(void)keyboardSearchWithString:(NSString *)searchStr;

-(void)poptoLastPage;

@end

@interface SearchNavView : UIView<UITextFieldDelegate>

@property(nonatomic,weak)id<SearchNavViewDelegate>delegate;

/**搜索右侧的取消按钮*/
@property(nonatomic,strong)UIButton *cancelButton;
@property(nonatomic,strong)UILabel *searchLable;
@property(nonatomic,strong)UITextField *searchTextField;
@property(nonatomic,strong)UIButton *searchButton;

@end
