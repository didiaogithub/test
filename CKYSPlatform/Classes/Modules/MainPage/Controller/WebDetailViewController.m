//
//  BannerDetailViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/10/13.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "WebDetailViewController.h"

@interface WebDetailViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation WebDetailViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.viewDataLoading stopAnimation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.typeString isEqualToString:@"banner"]||[self.typeString isEqualToString:@"news"] || [self.typeString isEqualToString:@"source"] || [self.typeString isEqualToString:@"media"]){ //banner详情 新闻 素材
       
        self.navigationItem.title = @"内容详情";
        if([self.typeString isEqualToString:@"news"] || [self.typeString isEqualToString:@"source"] || [self.typeString isEqualToString:@"media"]){
            
            UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"detailshare"] style:UIBarButtonItemStylePlain target:self action:@selector(clickShareButton)];
            right.tintColor = [UIColor blackColor];
            if (@available(iOS 11.0, *)) {
                self.navigationItem.rightBarButtonItem = right;
            }else{
                UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
                spaceItem.width = 10;
                self.navigationItem.rightBarButtonItems = @[spaceItem, right];
            }
        }
    }else if ([self.typeString isEqualToString:@"help"]){
        self.navigationItem.title= @"帮助";
        [NSString deleteWebCache];

    }else if ([self.typeString isEqualToString:@"gift"]){
       self.navigationItem.title= @"礼包详情";
    }else if ([self.typeString isEqualToString:@"protocal"]){
       self.navigationItem.title= @"创客村协议";
    }else if ([self.typeString isEqualToString:@"baseTrain"]){//轻创会
        self.navigationItem.title= @"基础培训";
    }else if ([self.typeString isEqualToString:@"shopcer"]){
        self.navigationItem.title = @"资质证书";
    }else if ([self.typeString isEqualToString:@"classlive"]){
         self.navigationItem.title = @"直播间";
    }else if ([self.typeString isEqualToString:@"levelRule"]){
        self.navigationItem.title = @"等级规则";
    }else if ([self.typeString isEqualToString:@"updateSharePerson"]){
        self.navigationItem.title = @"修改分享人";
    }else if ([self.typeString isEqualToString:@"upgradeSP"]){
        self.navigationItem.title = @"应聘员工";
    }else if ([self.typeString isEqualToString:@"applySP"]){
        self.navigationItem.title = @"应聘员工";
    }
    
    [self createWebView];
    
}
#pragma mark-分享头条 标题 描述 图标
-(void)clickShareButton{
    
    NSString *title = [NSString stringWithFormat:@"%@",self.shareTitle];
    if(IsNilOrNull(title)){
        title = @"";
    }
    NSString *shareUrl = [NSString stringWithFormat:@"%@",self.detailUrl];
    if(IsNilOrNull(shareUrl)){
        shareUrl = @"";
    }
    NSString *headImageUrl = [NSString stringWithFormat:@"%@",self.imgUrl];
    NSString *headUrl = [NSString loadImagePathWithString:headImageUrl];
    if(IsNilOrNull(headUrl)){
        headUrl = @"";
    }
    NSString *info = [NSString stringWithFormat:@"%@",self.shareDescrip];
    if(IsNilOrNull(info)){
        info = @"";
    }
    [CKShareManager shareToFriendWithName:info andHeadImages:headUrl andUrl:[NSURL URLWithString:shareUrl] andTitle:title];

}

-(void)createWebView{
    

    if (@available(iOS 11.0, *)){
        if ([self.typeString isEqualToString:@"shopcer"]){
            self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(AdaptedWidth(10), 64+AdaptedHeight(10)+NaviAddHeight, SCREEN_WIDTH-AdaptedWidth(20), SCREEN_HEIGHT-64-AdaptedHeight(20)-NaviAddHeight-BOTTOM_BAR_HEIGHT)];
        }else{
            self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 65-NaviAddHeight)];
        }
    }else{
        if ([self.typeString isEqualToString:@"shopcer"]){
            self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, SCREEN_HEIGHT-10)];
        }else{
            self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        }
    }
    
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    self.wkWebView.backgroundColor = [UIColor tt_grayBgColor];
    NSURL *url = [NSURL URLWithString:self.detailUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    [self.wkWebView loadRequest:request];
    [self.view addSubview:self.wkWebView];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始加载");

//    NSString *str = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:@"CleanWebCache"]];
//    if ([str isEqualToString:@"CleanWebCache"]) {
//        //清理缓存
    [NSString deleteWebCache];
//    }
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

-(void)dealloc{
   [self.viewDataLoading stopAnimation];
}

@end
