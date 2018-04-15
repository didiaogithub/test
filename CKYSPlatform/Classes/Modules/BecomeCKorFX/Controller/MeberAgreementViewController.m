//
//  MeberAgreementViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/12.
//  Copyright © 2016年 ckys. All rights reserved.

#import "MeberAgreementViewController.h"
#import "CKMainPageModel.h"

@interface MeberAgreementViewController ()<WKUIDelegate,WKNavigationDelegate>
{
    NSString *_ckcxyurl;


}
@property(nonatomic,strong)WKWebView *protocalWkWebView;

@end

@implementation MeberAgreementViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创客村注册协议";    
    RLMResults *result = [[CacheData shareInstance] search:[CKMainPageModel class]];
    if (result.count > 0) {
        CKMainPageModel *mainM = result.firstObject;
        _ckcxyurl = [NSString stringWithFormat:@"%@", mainM.ckcxyurl];
    }
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm invalidate];
    if (IsNilOrNull(_ckcxyurl)) {
        _ckcxyurl = @"";
    }
    [self createWebView];
}

-(void)createWebView{
    _protocalWkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(5, 15+64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64-15-NaviAddHeight-BOTTOM_BAR_HEIGHT)];
    self.protocalWkWebView.navigationDelegate = self;
    self.protocalWkWebView.UIDelegate = self;
    NSURL *url = [NSURL URLWithString:_ckcxyurl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.protocalWkWebView  loadRequest:request];
    [self.view addSubview:_protocalWkWebView];
}

@end
