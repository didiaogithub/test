//
//  CKMainPageCell.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/6/1.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "CKMainPageCell.h"
#import "SDCycleScrollView.h"
#import "DHomepageViewController.h"
#import "WebDetailViewController.h"
#import "BestNewsCollectionViewCell.h"
#import "MyHonourViewController.h"
#import "CKCTheHeadlinesController.h"
#import "MediaReportsController.h"
#import "CKMainTopNewsCollectionCell.h"
#import "CKMainPageModel.h"

@implementation CKMainPageCell

-(void)fillData:(id)data {
    
}

-(void)callWithParameter:(id)parameter {
    
}

+(CGFloat)computeHeight:(id)data {
    return 0;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@interface CKBannerCell()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSString *type;

@end

@implementation CKBannerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185*SCREEN_WIDTH/375.0f)];
    _myScrollView.showsVerticalScrollIndicator = NO;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_myScrollView];
    
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185*SCREEN_WIDTH/375.0f) delegate:self placeholderImage:[UIImage imageNamed:@"waitbanner"]];
    
    self.cycleScrollView.backgroundColor = [UIColor whiteColor];
    self.cycleScrollView.currentPageDotColor = [UIColor redColor];
    self.cycleScrollView.pageDotColor = [UIColor lightGrayColor];
    self.cycleScrollView.imageURLStringsGroup = _imageArray;
    [self.myScrollView addSubview:self.cycleScrollView];
    
}
- (void)fillData:(id)data {
//    if (!data) {
//        return;
//    }
    
    _imageArray = [NSMutableArray array];
    _idArray = [NSMutableArray array];
    NSArray *dataArr = data[@"data"];
    self.type = data[@"type"];
    for (Banners *bannerM in dataArr) {
        if (!IsNilOrNull(bannerM.path)) {
            [_imageArray addObject:bannerM.path];
        }
        [_idArray addObject:bannerM];
    }
    self.cycleScrollView.imageURLStringsGroup = _imageArray;
    self.myScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    self.cycleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    [self pushToActive:index];
}

#pragma mark - 首页活动轮播事件
-(void)pushToActive:(NSInteger)index {
    
    DHomepageViewController *homeVC;
    
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[DHomepageViewController class]]) {
            homeVC = (DHomepageViewController*)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    
    Banners *bannerModel = _idArray[index];
    NSString *url = [NSString stringWithFormat:@"%@",bannerModel.url];
    if(!IsNilOrNull(url)){
        NSString *detailUrl = [NSString loadImagePathWithString:url];
        WebDetailViewController *bannerDetail = [[WebDetailViewController alloc] init];
        bannerDetail.detailUrl = detailUrl;
        bannerDetail.typeString = @"banner";
        [homeVC.navigationController pushViewController:bannerDetail animated:YES];
    }
}

@end



@implementation CKFeaturesCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    
    NSArray *titleArr = @[@"创业简单化",@"购物便捷化",@"社交多元化"];
    NSArray *imageArr = @[@"fratures1",@"fratures3",@"fratures2"];
    
    for (int i=0; i<3; i++){
        float lefx = (SCREEN_WIDTH-AdaptedWidth(78/2)*3-AdaptedWidth(182/2)*2)/2;
        _featuresImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_featuresImageView];
        [_featuresImageView setImage:[UIImage imageNamed:imageArr[i]]];
        
        [_featuresImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(lefx+i*(AdaptedWidth(78/2)+AdaptedWidth(182/2)));
            make.top.mas_offset(AdaptedHeight(5));
            make.width.mas_offset(AdaptedWidth(78/2));
            make.height.mas_offset(AdaptedWidth(78/2));
        }];
        _fratureLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
        [self.contentView addSubview:_fratureLable];
        _fratureLable.text = titleArr[i];
        [_fratureLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_featuresImageView.mas_bottom).offset(AdaptedHeight(5));
            make.left.equalTo(_featuresImageView.mas_left).offset(-AdaptedWidth(20));
            make.width.mas_offset(AdaptedWidth(78/2+40));
            make.bottom.mas_offset(-AdaptedHeight(5));
        }];
    }
    
}
@end


@implementation CKOpenShopCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    bankView.backgroundColor = [UIColor whiteColor];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    //openShopBg
    UIImageView *imgV = [UIImageView new];
    imgV.userInteractionEnabled = YES;
    imgV.image = [UIImage imageNamed:@"openShopBg"];
    [bankView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(bankView);
    }];

    //开店按钮
    _openShopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:_openShopButton];
    [_openShopButton setImage:[UIImage imageNamed:@"tojoin"] forState:UIControlStateNormal];
    [_openShopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(20));
        make.width.mas_equalTo(AdaptedWidth(86));
        make.right.mas_offset(-AdaptedWidth(30));
        make.height.mas_offset(AdaptedHeight(64/2));
    }];
    [_openShopButton addTarget:self action:@selector(openShop) forControlEvents:UIControlEventTouchUpInside];
    
    //开店按钮做大一点
    UIButton *bigButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:bigButton];
    [bigButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    [bigButton addTarget:self action:@selector(openShop) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UILabel *becomeLable = [UILabel configureLabelWithTextColor:CKYS_Color(85, 85, 85) textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
//    [bankView addSubview:becomeLable];
//    becomeLable.text = @"点击开店成为创客";
//    [becomeLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_openShopButton.mas_bottom).offset(AdaptedHeight(13));
//        make.left.equalTo(lineLable.mas_right);
//        make.right.mas_offset(0);
//        make.height.mas_offset(AdaptedHeight(14));
//    }];
    
}

-(void)fillData:(id)data {
    if (!data) {
        return;
    }
//    CKMainPageModel *mainM = data;
//    //最新加盟创客头像
//    for (int i = 0; i < 3; i++) {
//        Top3ckheaders *top = mainM.top3ckheaderArray[i];
//        UIImageView *imageViewU = (UIImageView *)[self.contentView viewWithTag:130+i];
//        
//        NSString *headUrl = [NSString stringWithFormat:@"%@",top.url];
//        NSString *picUrl = [NSString loadImagePathWithString:headUrl];
//        
//        [imageViewU sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"name"]];
//    }
//    _countLable.text = [NSString stringWithFormat:@"%@", mainM.cknum];
}

-(void)openShop{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickOpenShop)]) {
        [self.delegate clickOpenShop];
    }
}

@end



@interface CKNewsCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *bkHot;
@property (nonatomic, strong) UICollectionView *laterCollectionView;
@property (nonatomic, strong) NSString *type;

@end

@implementation CKNewsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _laterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _laterCollectionView.backgroundColor = [UIColor whiteColor];
    
    [_laterCollectionView registerClass:[BestNewsCollectionViewCell class] forCellWithReuseIdentifier:@"BestNewsCollectionViewCell"];
    _laterCollectionView.delegate = self;
    _laterCollectionView.dataSource = self;
    _laterCollectionView.showsHorizontalScrollIndicator = NO;
    [_laterCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerID"];
    [_laterCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID"];
    [self addSubview:_laterCollectionView];
    [_laterCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BestNewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BestNewsCollectionViewCell" forIndexPath:indexPath];
    if (self.dataArray.count == 0) {
        [cell.bestNewImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"waitbanner"]];
    }else{
        NSString *picUrl =  @"";
        if ([_type isEqualToString:@"1"]) {
            Topnews *news = self.dataArray[indexPath.row];
            picUrl = [NSString stringWithFormat:@"%@",news.url];
        }else{
            Mediareport *media = self.dataArray[indexPath.row];
            picUrl = [NSString stringWithFormat:@"%@",media.path];
        }
        
        NSString *imgUrl = [NSString loadImagePathWithString:picUrl];
        
        [cell.bestNewImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"waitbanner"]];
    }
    return cell;
}

/**设置每个item的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(AdaptedWidth(250),AdaptedHeight(125));
}
/**设置每个item的UIEdgeInsets*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
/**设置每个item水平间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DHomepageViewController *homeVC;
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[DHomepageViewController class]]) {
            homeVC = (DHomepageViewController*)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    
    if(self.dataArray.count > 0){
        WebDetailViewController *detail = [[WebDetailViewController alloc] init];
        detail.typeString = @"news";
        if ([_type isEqualToString:@"1"]) {
            Topnews *newsModel = self.dataArray[indexPath.row];
            detail.detailUrl = newsModel.detailurl;
            detail.imgUrl = newsModel.url;
            detail.shareTitle = newsModel.title;
            detail.shareDescrip = newsModel.info;
            
        }else{
            Mediareport *mediaModel = self.dataArray[indexPath.row];
            detail.typeString = @"media";
            detail.detailUrl = mediaModel.url;
            detail.imgUrl = mediaModel.path;
            detail.shareTitle = mediaModel.title;
            detail.shareDescrip = mediaModel.info;
        }
        [homeVC.navigationController pushViewController:detail animated:YES];
    }
}
#pragma mark-点击collectionView头视图跳转
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *view = nil;
    
    if (kind == UICollectionElementKindSectionFooter) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerID" forIndexPath:indexPath];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *checkMore = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AdaptedWidth(105),AdaptedHeight(125))];
        checkMore.image = [UIImage imageNamed:@"checkMore"];
        checkMore.userInteractionEnabled = YES;
        [view addSubview:checkMore];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToDetail)];
        [view addGestureRecognizer:tap];
    }else{
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID" forIndexPath:indexPath];
        view.backgroundColor = [UIColor whiteColor];
    }
    
    return view;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{

    return CGSizeMake(AdaptedWidth(105),AdaptedHeight(125));
}

-(void)jumpToDetail {
    
    DHomepageViewController *homeVC;
    UIResponder *next = self.nextResponder;
    if ([_type isEqualToString:@"1"]) {
        do {
            //判断响应者是否为视图控制器
            if ([next isKindOfClass:[DHomepageViewController class]]) {
                homeVC = (DHomepageViewController*)next;
            }
            next = next.nextResponder;
        } while (next != nil);
        
        CKCTheHeadlinesController *theHead = [[CKCTheHeadlinesController alloc]init];
        [homeVC.navigationController pushViewController:theHead animated:YES];
    }else if ([_type isEqualToString:@"2"]){
        do {
            //判断响应者是否为视图控制器
            if ([next isKindOfClass:[DHomepageViewController class]]) {
                homeVC = (DHomepageViewController*)next;
            }
            next = next.nextResponder;
        } while (next != nil);
        
        MediaReportsController *mediaReport = [[MediaReportsController alloc]init];
        [homeVC.navigationController pushViewController:mediaReport animated:YES];
    }
}

- (void)fillData:(id)data{
//    if (!data) {
//        return;
//    }
    
    [self.dataArray removeAllObjects];
    _type = [data objectForKey:@"type"];
    RLMArray *arr = [data objectForKey:@"dataArray"];
    if ([_type isEqualToString:@"1"]) {
        for (Topnews *newsM in arr) {
            [self.dataArray addObject:newsM];
        }
    }else if ([_type isEqualToString:@"2"]){
        for (Mediareport *mediaM in arr) {
            [self.dataArray addObject:mediaM];
        }
    }
    [self.laterCollectionView reloadData];
    
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end


@interface CKTopNewsCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) UIImageView *imgVL;
@property (nonatomic, strong) UIImageView *imgVR;
@property (nonatomic, strong) UICollectionView *laterCollectionView;

@end

@implementation CKTopNewsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _laterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _laterCollectionView.backgroundColor = [UIColor whiteColor];
    
    [_laterCollectionView registerClass:[CKMainTopNewsCollectionCell class] forCellWithReuseIdentifier:@"CKMainTopNewsCollectionCell"];
    _laterCollectionView.delegate = self;
    _laterCollectionView.dataSource = self;
    _laterCollectionView.showsHorizontalScrollIndicator = NO;
    [_laterCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerID"];
    [_laterCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID"];
    [self addSubview:_laterCollectionView];
    [_laterCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CKMainTopNewsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CKMainTopNewsCollectionCell" forIndexPath:indexPath];
    if (self.dataArray.count == 0) {
        [cell.bestNewImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"waitbanner"]];
    }else{
        Topnews *news = self.dataArray[indexPath.row];
        NSString *picUrl = [NSString stringWithFormat:@"%@",news.url];
        NSString *imgUrl = [NSString loadImagePathWithString:picUrl];
        
        [cell.bestNewImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"waitbanner"]];
    }
    return cell;
}

/**设置每个item的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH*0.5 - 15, AdaptedWidth(125));
}
/**设置每个item的UIEdgeInsets*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
/**设置每个item水平间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DHomepageViewController *homeVC;
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[DHomepageViewController class]]) {
            homeVC = (DHomepageViewController*)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    
    WebDetailViewController *detail = [[WebDetailViewController alloc] init];
    detail.typeString = @"news";
        Topnews *newsModel = self.dataArray[indexPath.row];
        detail.detailUrl = newsModel.detailurl;
        detail.imgUrl = newsModel.url;
        detail.shareTitle = newsModel.title;
        detail.shareDescrip = newsModel.info;
    [homeVC.navigationController pushViewController:detail animated:YES];
}
#pragma mark-点击collectionView头视图跳转
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *view = nil;
    
    if (kind == UICollectionElementKindSectionFooter) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerID" forIndexPath:indexPath];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *checkMore = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AdaptedWidth(85),AdaptedHeight(125))];
        checkMore.image = [UIImage imageNamed:@"checkMore"];
        checkMore.userInteractionEnabled = YES;
        [view addSubview:checkMore];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToDetail)];
        [view addGestureRecognizer:tap];
    }else{
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID" forIndexPath:indexPath];
        view.backgroundColor = [UIColor whiteColor];
    }
    
    return view;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(AdaptedWidth(105),AdaptedHeight(125));
}

-(void)jumpToDetail {
    
    DHomepageViewController *homeVC;
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[DHomepageViewController class]]) {
            homeVC = (DHomepageViewController*)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    
    CKCTheHeadlinesController *theHead = [[CKCTheHeadlinesController alloc]init];
    [homeVC.navigationController pushViewController:theHead animated:YES];

}

- (void)fillData:(id)data{

    [self.imageArr removeAllObjects];
    [self.dataArray removeAllObjects];
    NSString *type = [data objectForKey:@"type"];
    RLMArray *arr = [data objectForKey:@"dataArray"];
    if ([type isEqualToString:@"1"]) {
        for (Topnews *newsM in arr) {
            [self.dataArray addObject:newsM];
            [self.imageArr addObject:newsM.url];
        }
    }
    
    [self.laterCollectionView reloadData];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end



@interface CKHeaderTitleCell()

@property (nonatomic, strong) UILabel *headerLable;
@property (nonatomic, strong) UIButton *seeAllButton;
@property (nonatomic, copy)   NSString *type;


@end


@implementation CKHeaderTitleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    
    UIView *headerView = [UIView new];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:headerView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    _headerLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [headerView addSubview:_headerLable];
    [_headerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_offset(0);
        make.top.mas_offset(AdaptedHeight(10));
    }];
    
    _seeAllButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:_seeAllButton];
    [_seeAllButton setImage:[UIImage imageNamed:@"homeallbutton"] forState:UIControlStateNormal];
    [_seeAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headerLable.mas_centerY);
        make.right.mas_offset(-AdaptedWidth(15));
        make.height.mas_offset(40);
    }];
    [_seeAllButton addTarget:self action:@selector(clickSeeAllButton) forControlEvents:UIControlEventTouchUpInside];

}

-(void)fillData:(id)data {
    if (!data) {
        return;
    }
    
    _type = [data objectForKey:@"type"];
    _headerLable.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"title"]];
}

-(void)clickSeeAllButton {
    DHomepageViewController *homeVC;
    UIResponder *next = self.nextResponder;
    if ([_type isEqualToString:@"1"]) {
        do {
            //判断响应者是否为视图控制器
            if ([next isKindOfClass:[DHomepageViewController class]]) {
                homeVC = (DHomepageViewController*)next;
            }
            next = next.nextResponder;
        } while (next != nil);
        
        CKCTheHeadlinesController *theHead = [[CKCTheHeadlinesController alloc]init];
        [homeVC.navigationController pushViewController:theHead animated:YES];
    }else if ([_type isEqualToString:@"2"]){
        do {
            //判断响应者是否为视图控制器
            if ([next isKindOfClass:[DHomepageViewController class]]) {
                homeVC = (DHomepageViewController*)next;
            }
            next = next.nextResponder;
        } while (next != nil);
        
        MediaReportsController *mediaReport = [[MediaReportsController alloc]init];
        [homeVC.navigationController pushViewController:mediaReport animated:YES];
    }else if ([_type isEqualToString:@"3"]){
        do {
            //判断响应者是否为视图控制器
            if ([next isKindOfClass:[DHomepageViewController class]]) {
                homeVC = (DHomepageViewController*)next;
            }
            next = next.nextResponder;
        } while (next != nil);
        
        MyHonourViewController *honour = [[MyHonourViewController alloc] init];
        [homeVC.navigationController pushViewController:honour animated:YES];
    }
}

@end




@interface CKMPHonorCell()

@property (nonatomic, strong) UIImageView *certificateImageView;

@end

@implementation CKMPHonorCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    bankView.backgroundColor = [UIColor whiteColor];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(AdaptedHeight(10));
        make.bottom.mas_offset(10);
    }];
    
    float width = (SCREEN_WIDTH - AdaptedWidth(30))/2;
    for (int i=0;i<2;i++){
        UIView *grayView = [[UIView alloc] init];
        [bankView addSubview:grayView];
        grayView.backgroundColor = [UIColor tt_grayBgColor];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(AdaptedHeight(10));
            make.left.mas_offset(AdaptedWidth(10)+i*(width+AdaptedWidth(10)));
            make.bottom.mas_offset(-AdaptedHeight(10));
            make.width.mas_offset(width);
        }];
        
        _certificateImageView = [[UIImageView alloc] init];
        [grayView addSubview:_certificateImageView];
        [_certificateImageView setImage:[UIImage imageNamed:@"waitnews"]];
        _certificateImageView.tag = 220+i;
        [_certificateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_offset(AdaptedHeight(8));
            make.right.bottom.mas_offset(-AdaptedHeight(8));
        }];
        
        // 单击手势：
        UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapIconImageAction:)];
        tapRecognize.numberOfTapsRequired = 1;
        _certificateImageView.userInteractionEnabled = YES;
        [_certificateImageView addGestureRecognizer:tapRecognize];
        
        
    }

    
}

/**点击图片单击的响应方法*/
- (void)oneTapIconImageAction:(UITapGestureRecognizer *)sender {
    DHomepageViewController *homeVC;
    
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[DHomepageViewController class]]) {
            homeVC = (DHomepageViewController*)next;
        }
        next = next.nextResponder;
    } while (next != nil);

    MyHonourViewController *honour = [[MyHonourViewController alloc] init];
    [homeVC.navigationController pushViewController:honour animated:YES];
}


-(void)refreshWithCerArray:(NSMutableArray *)cerArr{
    for (int i = 0; i <cerArr.count;i++) {
        UIImageView *imageViewU = (UIImageView *)[self.contentView viewWithTag:220+i];
        
        NSString *headUrl = cerArr[i];
        NSString *picUrl = [NSString loadImagePathWithString:headUrl];
        
        [imageViewU sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"waitnews"]];
    }
}

-(void)fillData:(id)data {
    
    RLMArray *honorArr = data;

    if (honorArr.count == 0) {
        return;
    }
    for (int i = 0; i < 2; i++) {
        UIImageView *imageViewU = (UIImageView *)[self.contentView viewWithTag:220+i];
        Honor_list *honor = honorArr[i];
        NSString *honorImgUrl = [NSString loadImagePathWithString:honor.path];

        [imageViewU sd_setImageWithURL:[NSURL URLWithString:honorImgUrl] placeholderImage:[UIImage imageNamed:@"waitnews"]];
    }
}

@end



@interface CKAllJoinCell()

/**成交图片*/
@property (nonatomic, strong) UIImageView *ckImageView;
/**人数*/
@property (nonatomic, strong) UILabel *joinPeopleCountLable;
@property (nonatomic, strong) UILabel *textckLable;

@end

@implementation CKAllJoinCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.backgroundColor = [UIColor tt_grayBgColor];
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-AdaptedHeight(10));
        make.top.left.right.mas_offset(0);
    }];
    //人数
    _joinPeopleCountLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentLeft font:CHINESE_SYSTEM_BOLD(AdaptedWidth(51/2))];
    [bankView addSubview:_joinPeopleCountLable];
    
    [_joinPeopleCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(81/4));
        make.left.mas_offset((AdaptedWidth(10)));
        make.height.mas_offset(AdaptedHeight(51/2));
        make.bottom.mas_offset(-AdaptedHeight(81/4));
        
    }];

    _joinPeopleCountLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:AdaptedWidth(51/2)];
    //图片
    _textckLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [bankView addSubview:_textckLable];
    _textckLable.text = @"个创业店铺已开通";
    [_textckLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_joinPeopleCountLable.mas_bottom).offset(-AdaptedHeight(3));
        make.left.equalTo(_joinPeopleCountLable.mas_right);
        make.height.mas_offset(15);
    }];
    
    int buttonWidth = AdaptedWidth(85/2);
    //创客头像
    for (int i = 0; i<3; i++) {
        _ckImageView = [[UIImageView alloc] init];
        [bankView addSubview:_ckImageView];
        _ckImageView.layer.borderWidth = 1;
        _ckImageView.layer.borderColor = [UIColor tt_headBoderColor].CGColor;
        [_ckImageView setImage:[UIImage imageNamed:@"name"]];
        _ckImageView.tag = 120+i;
        _ckImageView.layer.cornerRadius = buttonWidth/2;
        _ckImageView.layer.masksToBounds = YES;
        [_ckImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedHeight(10));
            make.left.equalTo(_textckLable.mas_right).offset(AdaptedWidth(10) + i*(buttonWidth+AdaptedWidth(13)));
            make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonWidth));
        }];
    }
}

-(void)fillData:(id)data {
    if (!data) {
        return;
    }
    
    CKMainPageModel *mainM = data;
    _joinPeopleCountLable.text = [NSString stringWithFormat:@"%@", mainM.cknum];
    //最新加盟创客头像
    if (mainM.top3ckheaderArray.count == 0) {
        return;
    }
    
    for (int i = 0; i < 3; i++) {
        Top3ckheaders *top = mainM.top3ckheaderArray[i];
        UIImageView *imageViewU = (UIImageView *)[self.contentView viewWithTag:120+i];
        
        NSString *headUrl = [NSString stringWithFormat:@"%@",top.url];
        NSString *picUrl = [NSString loadImagePathWithString:headUrl];
        
        [imageViewU sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"name"]];
        
        float middlelogin = 0;
        if (iphone5){
            middlelogin = AdaptedWidth(5);
        }else if(iphone6){
            middlelogin = AdaptedWidth(8);
        }else{
            middlelogin = AdaptedWidth(10);
        }
        
        if([_joinPeopleCountLable.text length] > 5){
            [imageViewU mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_textckLable.mas_right).offset(middlelogin + i*(AdaptedWidth(42.5)+AdaptedWidth(10)));
            }];
        }else{
            [imageViewU mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_textckLable.mas_right).offset(AdaptedWidth(10) + i*(AdaptedWidth(42.5)+AdaptedWidth(13)));
            }];
        }
    }
}

@end



@interface CKMainModuleCell()

@property (nonatomic, strong) NSArray *ckTitleArr;
@property (nonatomic, strong) NSArray *tgTitleArr;
@property (nonatomic, strong) NSArray *ckImageArr;
@property (nonatomic, strong) NSArray *tgImageArr;
@property (nonatomic, strong) UIView *todaySaleView;
/**销售数值*/
@property (nonatomic, strong) UILabel *todaySaleLable;
/**我的云豆数值*/
@property (nonatomic, strong) UILabel *myCloundBeanLable;
@property (nonatomic, strong) UIButton *saleButton;
@property (nonatomic, strong) UIView *moudleView;
@property (nonatomic, strong) UIButton *mainModuleButton;
@property (nonatomic, strong) UIImageView *moduleImageView;
@property (nonatomic, strong) UILabel *moduleLable;

@end

@implementation CKMainModuleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    _ckTitleArr = @[@"荣誉资质",@"我要自提",@"媒体报道",@"素材中心"]; //创客和fx一样
    _tgTitleArr = @[@"荣誉资质",@"素材中心",@"媒体报道",@"二维码"];
    //图标
    _ckImageArr = @[@"companyhonour",@"takeself",@"homemedia",@"homesource"];
    _tgImageArr = @[@"companyhonour",@"homesource",@"homemedia",@"homeqrcode"];
    
    NSString *tgidstring = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    if (IsNilOrNull(tgidstring)) {
        tgidstring = @"0";
    }
    
    UIView *bankView = [[UIView alloc] init];
    [self.contentView addSubview:bankView];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsZero);
    }];
    float bankWidth = (SCREEN_WIDTH-50)/2;
    //今日销售和我的云豆
    for(int i= 0;i<2;i++){
        
        _todaySaleView  = [[UIView alloc] init];
        [bankView addSubview:_todaySaleView];
        [_todaySaleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedWidth(10));
            make.left.mas_offset(20+i*(bankWidth + 10));
            make.height.mas_offset(AdaptedWidth(80));
            make.width.mas_offset(bankWidth);
        }];
        
        UIFont *lableFont = nil;
        float topH = 0;
        if (iphone4){
            topH = AdaptedWidth(15);
            lableFont = CHINESE_SYSTEM_BOLD(AdaptedWidth(18));
        }else{
            topH = AdaptedWidth(20);
            lableFont = CHINESE_SYSTEM_BOLD(AdaptedWidth(20));
        }
    
        if (i==0){
            [_todaySaleView setBackgroundColor:CKYS_Color(197, 38, 48)];
            //今日销售数值
            _todaySaleLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:lableFont];
            [_todaySaleView addSubview:_todaySaleLable];
            [_todaySaleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(topH);
                make.left.right.mas_offset(0);
            }];
            UILabel *saleLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_NAMETITLE_FONT];
            [_todaySaleView addSubview:saleLable];
            saleLable.text = @"今日销售(元)";
            [saleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_todaySaleLable.mas_bottom).offset(AdaptedHeight(5));
                make.left.right.mas_offset(0);
                make.bottom.mas_offset(-AdaptedWidth(20));
            }];
        }else{
            [_todaySaleView setBackgroundColor:CKYS_Color(26, 26, 26)];
            
            _myCloundBeanLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:lableFont];
            [_todaySaleView addSubview:_myCloundBeanLable];
            [_myCloundBeanLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(topH);
                make.left.right.mas_offset(0);
            }];
            UILabel *cloundLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_NAMETITLE_FONT];
            [_todaySaleView addSubview:cloundLable];
            
            if (![tgidstring isEqualToString:@"0"]){
                cloundLable.text = @"资金管理";
            }else{
                cloundLable.text = @"我的云豆";
            }
            [cloundLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_myCloundBeanLable.mas_bottom).offset(AdaptedHeight(5));
                make.left.right.mas_offset(0);
                make.bottom.mas_offset(-AdaptedWidth(20));
            }];
            
        }
        //今日销售 我的云豆按钮
        _saleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_todaySaleView addSubview:_saleButton];
        _saleButton.tag = 1400+i;
        [_saleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_todaySaleView);
        }];
        [_saleButton addTarget:self action:@selector(clickSaleButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    //公司荣誉 软件推广 我要自提  二维码 店铺分享
    for (int i = 0; i<4; i++){
        _moudleView = [[UIView alloc] init];
        [bankView addSubview:_moudleView];
        if (i == 0) {
            [_moudleView setBackgroundColor:CKYS_Color(83, 83, 83)];
        }else if (i==1){
            [_moudleView setBackgroundColor:CKYS_Color(203, 59, 68)];
        }else if (i==2){
            [_moudleView setBackgroundColor:CKYS_Color(187, 0, 12)];
        }else{
            [_moudleView setBackgroundColor:CKYS_Color(104, 104, 104)];
        }
        
        [_moudleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_todaySaleView.mas_bottom).offset(AdaptedWidth(10)+(AdaptedWidth(80)+AdaptedWidth(10))*(i/2));
            make.left.mas_offset(20+(bankWidth+10)*(i%2));
            make.width.mas_offset(bankWidth);
            make.height.mas_offset(AdaptedWidth(80));
        }];
        
        if (i==2 || i==3){
            [_moudleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_offset(-AdaptedWidth(10));
            }];
        }
        
        //图片
        _moduleImageView = [[UIImageView alloc] init];
        [_moudleView addSubview:_moduleImageView];
        _moduleImageView.tag = 300+i;
        _moduleImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_moduleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(AdaptedWidth(34/2));
            make.left.mas_offset(AdaptedWidth(50));
            make.right.mas_offset(-AdaptedWidth(50));
            make.height.mas_offset(AdaptedWidth(23));
        }];
        
        //文字
        _moduleLable = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_NAMETITLE_FONT];
        [_moudleView addSubview:_moduleLable];
        _moduleLable.tag = 400+i;
        [_moduleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_moduleImageView.mas_bottom).offset(AdaptedWidth(25/2));
            make.left.right.mas_offset(0);
            make.bottom.mas_offset(-AdaptedWidth(34/2));
        }];
        
        if (![tgidstring isEqualToString:@"0"]){
            _moduleLable.text = _tgTitleArr[i];
            [_moduleImageView setImage:[UIImage imageNamed:_tgImageArr[i]]];
        }else{
            _moduleLable.text = _ckTitleArr[i];
            [_moduleImageView setImage:[UIImage imageNamed:_ckImageArr[i]]];
            
        }
        
        _mainModuleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moudleView addSubview:_mainModuleButton];
        _mainModuleButton.tag = 1300+i;
        [_mainModuleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_moudleView);
        }];
        [_mainModuleButton addTarget:self action:@selector(clickModuleButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
-(void)clickModuleButton:(UIButton *)button{
    NSInteger buttonTag = button.tag - 1300;
    if (self.delegate && [self.delegate respondsToSelector:@selector(dealModuleWithTag:andButton:)]){
        [self.delegate dealModuleWithTag:buttonTag andButton:button];
    }
}
-(void)clickSaleButton:(UIButton *)button{
    NSInteger buttonTag = button.tag - 1400;
    if (self.delegate && [self.delegate respondsToSelector:@selector(seeSaleDeatilWithTag:andButton:)]){
        [self.delegate seeSaleDeatilWithTag:buttonTag andButton:button];
    }
}
-(void)fillData:(id)data {
    if (!data) {
        return;
    }
    CKMainPageModel *mainModel = data;
    
    NSString * tgidstring = [NSString stringWithFormat:@"%@",[KUserdefaults objectForKey:KSales]];
    if (IsNilOrNull(tgidstring)) {
        tgidstring = @"0";
    }
    for (int i = 0; i<4; i++){
        UIImageView *imageViewU = (UIImageView *)[self.contentView viewWithTag:300+i];
        UILabel *textLable = (UILabel *)[self.contentView viewWithTag:400+i];
        //文字
        if(![tgidstring isEqualToString:@"0"]){//推广人
            textLable.text = _tgTitleArr[i];
            [imageViewU setImage:[UIImage imageNamed:_tgImageArr[i]]];
        }else{
            textLable.text = _ckTitleArr[i];
            [imageViewU setImage:[UIImage imageNamed:_ckImageArr[i]]];
        }
    }
    //今日销售 我的云豆
    NSString *moneyToday = [NSString stringWithFormat:@"%@",mainModel.moneytoday];
    NSString *moneyTotal = [NSString stringWithFormat:@"%@",mainModel.moneytotal];
    
    if (IsNilOrNull(moneyToday)) { //今日销售总收入
        moneyToday = @"0";
    }
    if (IsNilOrNull(moneyTotal)) { //我的芸豆库
        moneyTotal = @"0";
    }
    double moneyTodayFloat = [moneyToday doubleValue];
    _todaySaleLable.text = [NSString stringWithFormat:@"¥%.2f",moneyTodayFloat];
    
    double moneyTotalFloat = [moneyTotal doubleValue];
    _myCloundBeanLable.text = [NSString stringWithFormat:@"¥%.2f",moneyTotalFloat];
}

@end
