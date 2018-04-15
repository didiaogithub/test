//
//  SCGoodsDetailViewController.m
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/22.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "SCGoodsDetailViewController.h"
#import "XLImageViewer.h"
#import "SureMySelfOrderViewController.h"
#import "CKPickupGoodsModel.h"

@interface SCGoodsDetailViewController ()<UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, strong) UIWebView *detailWebView;
@property (nonatomic, strong) UILabel *headLab;
@property (nonatomic, strong) UIButton *nowBuyButton;
@property (nonatomic, strong) UIView *headerView;


/**名称*/
@property (nonatomic, strong) UILabel *goodNameLable;
/**价格*/
@property (nonatomic, strong) UILabel *pricceLable;
/**规格*/
@property (nonatomic, strong) TTAttibuteLabel *specLable;

@end

@implementation SCGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initComponent];
}

- (void)initComponent {
    
    
    //立即购买
    _nowBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_nowBuyButton];
    _nowBuyButton.backgroundColor = CKYS_Color(203, 24, 45);
    [_nowBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [_nowBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nowBuyButton addTarget:self action:@selector(clickBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    [_nowBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-BOTTOM_BAR_HEIGHT);
        make.height.mas_offset(50);
    }];


    _detailWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
    _detailWebView.delegate = self;
    _detailWebView.scrollView.delegate = self;
    _detailWebView.scalesPageToFit = YES;
    _detailWebView.backgroundColor = [UIColor whiteColor];

    NSString *htmlnameios = [NSString stringWithFormat:@"%@front/ckappFront/html/detail-ios.html?itemid=%@&ckid=%@", WebServiceAPI, self.goodsId, KCKidstring];

    NSURL *url = [NSURL URLWithString:htmlnameios];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_detailWebView loadRequest:request];
    [self.view addSubview:_detailWebView];
    [_detailWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
        }else{
            make.top.equalTo(self.view.mas_top).offset(0);
        }
        make.bottom.equalTo(self.nowBuyButton.mas_top);
    }];
    
    CKPickupGoodsModel *goodsM = self.tempArray.firstObject;
    NSString *goodsName = [NSString stringWithFormat:@"%@", goodsM.name];
    if (IsNilOrNull(goodsName)) {
        goodsName = @"";
    }
    CGFloat nameH = [goodsName boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size.height;
    
    _detailWebView.scrollView.contentInset =  UIEdgeInsetsMake(SCREEN_WIDTH+nameH+18+8+17+10+10, 0, 0, 0);
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -(SCREEN_WIDTH+nameH+18+8+17+10+10), SCREEN_WIDTH, SCREEN_WIDTH+nameH+18+8+17+10+10)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [_detailWebView.scrollView addSubview:_headerView];
    [self initHeaderUI];

}

-(void)initHeaderUI {
    
    CKPickupGoodsModel *goodsM = self.tempArray.firstObject;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    [self.headerView addSubview:imageV];
    imageV.userInteractionEnabled = YES;
    NSString *path = [NSString stringWithFormat:@"%@", goodsM.url];
    [imageV sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"waitbanner"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigGoodsImage)];
    [imageV addGestureRecognizer:tap];
    
    
    NSString *goodsName = [NSString stringWithFormat:@"%@", goodsM.name];
    if (IsNilOrNull(goodsName)) {
        goodsName = @"";
    }
    
    CGFloat nameH = [goodsName boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size.height;
    _goodNameLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    _goodNameLable.frame = CGRectMake(10, CGRectGetMaxY(imageV.frame)+10, SCREEN_WIDTH, nameH);
    _goodNameLable.numberOfLines = 0;
    _goodNameLable.text = goodsName;
    [self.headerView addSubview:_goodNameLable];
    
    //价格
    _pricceLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:16.0f]];
    _pricceLable.text = @"¥";
    _pricceLable.frame = CGRectMake(10, CGRectGetMaxY(_goodNameLable.frame)+10, SCREEN_WIDTH, 17);
    [self.headerView addSubview:_pricceLable];
    
    NSString *salesprice = [NSString stringWithFormat:@"%@", goodsM.price];
    if (IsNilOrNull(salesprice)) {
        salesprice = @"";
    }
    _pricceLable.text = salesprice;
    
    //规格
    _specLable = [[TTAttibuteLabel alloc] init];
    _specLable.textColor = [UIColor tt_monthGrayColor];
    _specLable.font = MAIN_TITLE_FONT;
    [self.headerView addSubview:_specLable];
    _specLable.frame = CGRectMake(10, CGRectGetMaxY(_pricceLable.frame)+8, SCREEN_WIDTH, 18);
    
    NSString *spec = [NSString stringWithFormat:@"%@", goodsM.spec];
    if (IsNilOrNull(spec)) {
        spec = @"";
    }else{
        spec = [NSString stringWithFormat:@"规格:%@", goodsM.spec];
    }
    _specLable.text = spec;
}

#pragma mark - 立即购买
-(void)clickBottomButton:(UIButton *)button{
    self.nowBuyButton.enabled = NO;
    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:2.0];//防止重复点击
    [self confirmBuyGoods];
}

-(void)changeButtonStatus {
    self.nowBuyButton.enabled = YES;
}

- (void)confirmBuyGoods {
    SureMySelfOrderViewController *confirmOrder = [[SureMySelfOrderViewController alloc] init];
    CKPickupGoodsModel *goodsM = self.tempArray.firstObject;
    goodsM.count = @"1";
    confirmOrder.dataArray = self.tempArray;
    NSString *price = [NSString stringWithFormat:@"%@", goodsM.price];
    confirmOrder.allMoneyString = [NSString stringWithFormat:@"合计：¥%.2f", [price doubleValue]];// self.allMoneyString;
    confirmOrder.showCount = NO;
    [self.navigationController pushViewController:confirmOrder animated:YES];
}

#pragma mark - 显示大的轮播图片
-(void)showBigGoodsImage {
    
    CKPickupGoodsModel *goodsM = self.tempArray.firstObject;
    NSString *path = [NSString stringWithFormat:@"%@", goodsM.url];
    [[XLImageViewer shareInstanse] showNetImages:@[path] index:0 from:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

@end
