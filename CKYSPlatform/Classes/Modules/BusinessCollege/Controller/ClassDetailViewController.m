//
//  ClassDetailViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/24.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "ClassDetailViewController.h"
#import "TTAttibuteLabel.h"
#import "UIViewController+ZJScrollPageController.h"
#import "ClassModel.h"

@interface ClassDetailViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *classWkWebView;
@property (nonatomic, strong) TTAttibuteLabel *countLable;
@property (nonatomic, strong) UIBarButtonItem *rightItem;

@end

@implementation ClassDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"课程详情";
    [self createWebView];
    [self createNavRightViews];
}

-(void)createNavRightViews{
   
    self.rightItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:nil];
    self.rightItem.tintColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.rightBarButtonItem = self.rightItem;
    }else{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = 10;
        self.navigationItem.rightBarButtonItems = @[spaceItem, self.rightItem];
    }
    [self refreshViewsCount];
}

-(void)refreshViewsCount{
    if (!IsNilOrNull(self.classId)) {
        NSString *getReadUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetLessonReadNum];
        NSDictionary *readDict = @{@"id": self.classId};
        [HttpTool postWithUrl:getReadUrl params:readDict success:^(id json) {
            NSDictionary *dict = json;
            NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
            if ([code isEqualToString:@"200"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateReadNumber" object:nil userInfo:dict];
                NSLog(@"最新阅读量");
                self.viewsString = [NSString stringWithFormat:@"%@",dict[@"viewed"]];
                if (IsNilOrNull(self.viewsString)){
                    self.rightItem.title = @"浏览:0";
                    [_countLable setTextLeft:@"浏览:" right:@"0"];
                }else{
                    self.rightItem.title = [NSString stringWithFormat:@"浏览:%@", self.viewsString];
                }
            }
        } failure:^(NSError *error) {
            NSString *predicate = [NSString stringWithFormat:@"sortID = '%@' AND classId = '%@'", _sortID, _classId];
            RLMResults *results = [[CacheData shareInstance] search:[ClassModel class] predicate:predicate];
            ClassModel *classModel = results.firstObject;
            [_countLable setTextLeft:@"浏览:" right:classModel.viewed];
        }];
    }else{
        if (IsNilOrNull(self.viewsString)){
            self.rightItem.title = @"浏览:0";
        }else{
            self.rightItem.title = [NSString stringWithFormat:@"浏览:%@", self.viewsString];
        }
    }
}

-(void)createWebView{
    self.classWkWebView = [[WKWebView alloc] init];
    
    if (@available(iOS 11.0, *)) {
        self.classWkWebView.frame = CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 65-NaviAddHeight-BOTTOM_BAR_HEIGHT);
    }else{
        self.classWkWebView.frame = CGRectMake(0, 1, SCREEN_WIDTH, SCREEN_HEIGHT-1);
    }
    self.classWkWebView.navigationDelegate = self;
    self.classWkWebView.UIDelegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.detailUrl]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.detailUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    

    [self.classWkWebView loadRequest:request];
    [self.view addSubview:self.classWkWebView];
    [self.viewDataLoading startAnimation];
    [self.viewDataLoading.blackBt addTarget:self action:@selector(hiddenAnim:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)hiddenAnim:(UIButton*)sender {
    [self.viewDataLoading stopAnimation];
    NSLog(@"[self.viewDataLoading stopAnimation];");
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//    NSString *str = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:@"CleanWebCache"]];
//    if ([str isEqualToString:@"CleanWebCache"]) {
//        //清理缓存
//        [NSString deleteWebCache];
//    }

    NSLog(@"开始加载");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"webview提交数据");
    [self.viewDataLoading stopAnimation];
}


// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"***** 接收到服务器跳转请求之后再执行 *****");
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"*****  收到服务器响应，是否跳转 *****");
    /*
     WKNavigationResponsePolicyCancel,//不同意跳转
     WKNavigationResponsePolicyAllow,//同意跳转
     */
    decisionHandler(WKNavigationResponsePolicyAllow);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    urlString = [urlString stringByRemovingPercentEncoding];
    
    NSLog(@"Requset URL = %@",urlString);
    // 用'://'截取字符串
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    if ([urlComps count]) {
        // 获取协议头
        NSString *protocolHead = [urlComps objectAtIndex:0];
        NSLog(@"Protocol Header = %@",protocolHead);
    }
    
    /*
     WKNavigationResponsePolicyCancel,//不同意跳转
     WKNavigationResponsePolicyAllow,//同意跳转
     */
    decisionHandler(WKNavigationActionPolicyAllow);
    
}
//1.创建一个新的WebVeiw
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        _countLable.hidden = YES;
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
//2.WebVeiw关闭（9.0中的新方法）
- (void)webViewDidClose:(WKWebView *)webView{
    NSLog(@"%s",__func__);
}

-(void)backClick:(id)sender {
    if ([self.classWkWebView canGoBack]) {
        _countLable.hidden = NO;
        [self.classWkWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
