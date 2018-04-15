//
//  CKHaveStockViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/1/6.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKHaveStockViewController.h"

@interface CKHaveStockViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)WKWebView *stockWkWebView;

@end

@implementation CKHaveStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"股权激励计划";
    [self getstockData];
    [self createWebView];
    
}
-(void)getstockData{
    NSString *ckidString = IsNilOrNull(KCKidstring) ? @"" :KCKidstring;
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"ckid":ckidString,DeviceId:uuid};
    NSString *stockUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, getCkStockMsg_Url];
    [HttpTool postWithUrl:stockUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        NSString *stockUrl = [NSString stringWithFormat:@"%@",dict[@"stockurl"]];
        if (IsNilOrNull(stockUrl)){
            [self showNoticeView:NetWorkTimeout];
            return ;
        }
        if ([stockUrl hasPrefix:@"http://"] || [stockUrl hasPrefix:@"https://"]){
            int x = arc4random() % 100000;
            _stockUrl = [NSString stringWithFormat:@"%@?%d", stockUrl, x];
//            _stockUrl = [NSString stringWithFormat:@"%@%d", stockUrl, x];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_stockUrl]];
            [self.stockWkWebView loadRequest:request];
       }
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}
-(void)createWebView{

    if (@available(iOS 11.0, *)) {
        self.stockWkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(10, 64+10+NaviAddHeight, SCREEN_WIDTH-10, SCREEN_HEIGHT-64-20-NaviAddHeight-BOTTOM_BAR_HEIGHT)];
    }else{
        self.stockWkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(10,  10, SCREEN_WIDTH-20, SCREEN_HEIGHT-20)];
    }
    
    
    [self.stockWkWebView setBackgroundColor:[UIColor tt_grayBgColor]];
    self.stockWkWebView.opaque = NO;
    self.stockWkWebView.navigationDelegate = self;
    self.stockWkWebView.UIDelegate = self;
     [self.view addSubview:self.stockWkWebView];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
//    NSString *str = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:@"CleanWebCache"]];
//    if ([str isEqualToString:@"CleanWebCache"]) {
//        //清理缓存
//        [NSString deleteWebCache];
//    }
    
    NSLog(@"开始加载");
    self.viewNetError.position = JGProgressHUDPositionCenter;
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"webview提交数据");
    [self.viewDataLoading stopAnimation];
}
-(void)dealloc{
    [self.viewDataLoading stopAnimation];
}


@end
