//
//  CKMsgCenterHelpViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/15.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKMsgCenterHelpViewController.h"

@interface CKMsgCenterHelpViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation CKMsgCenterHelpViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.viewDataLoading stopAnimation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮助";
    
    [self createWebView];
    
}

-(void)createWebView{
    
    
    if (@available(iOS 11.0, *)){
        self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 65-NaviAddHeight)];
    }else{
        self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    self.wkWebView.backgroundColor = [UIColor tt_grayBgColor];
    NSURL *url = [NSURL URLWithString:self.detailUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.wkWebView loadRequest:request];
    [self.view addSubview:self.wkWebView];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始加载");
  
    self.viewNetError.position = JGProgressHUDPositionCenter;
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [self.viewDataLoading.blackBt addTarget:self action:@selector(hiddenAnim:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)hiddenAnim:(UIButton*)sender {
    [self.viewDataLoading stopAnimation];
    NSLog(@"[self.viewDataLoading stopAnimation];");
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"出错了webview");
    [self.viewDataLoading stopAnimation];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"webview提交数据");
    [self.viewDataLoading stopAnimation];
}

-(BOOL)navigationShouldPopOnBackButton {
    
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
        return NO;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
}

@end
